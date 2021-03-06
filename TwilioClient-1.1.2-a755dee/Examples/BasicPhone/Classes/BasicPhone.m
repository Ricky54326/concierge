//
//  Copyright 2011 Twilio. All rights reserved.
//
 
#import "BasicPhone.h"
#import "BasicPhoneNotifications.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

// private methods
@interface BasicPhone ()

//TCDevice Capability Token 
-(NSString*)getCapabilityToken:(NSError**)error;
-(BOOL)capabilityTokenValid;

-(void)updateAudioRoute;

+(NSError*)errorFromHTTPResponse:(NSHTTPURLResponse*)response domain:(NSString*)domain;

@end


@implementation BasicPhone

@synthesize device = _device;
@synthesize connection = _connection;
@synthesize pendingIncomingConnection = _pendingIncomingConnection;

#pragma mark -
#pragma mark Initialization

-(id)init
{
	if ( self = [super init] )
	{
		_speakerEnabled = YES; // enable the speaker by default
	}
	return self;
}

-(void)login
{
	[[NSNotificationCenter defaultCenter] postNotificationName:BPLoginDidStart object:nil];
	
	NSError* loginError = nil;
	NSString* capabilityToken = [self getCapabilityToken:&loginError];
	
	if ( !loginError && capabilityToken )
	{
		if ( !_device )
		{
			// initialize a new device
			_device = [[TCDevice alloc] initWithCapabilityToken:capabilityToken delegate:self];
		}
		else
		{
			// update its capabilities
			[_device updateCapabilityToken:capabilityToken];
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:BPLoginDidFinish object:nil];
	}
	else if ( loginError )
	{	
		NSDictionary* userInfo = [NSDictionary dictionaryWithObject:loginError forKey:@"error"];
		[[NSNotificationCenter defaultCenter] postNotificationName:BPLoginDidFailWithError object:nil userInfo:userInfo];
	}
}

#pragma mark -
#pragma mark TCDevice Capability Token

-(NSString*)getCapabilityToken:(NSError**)error
{
	//Creates a new capability token from the auth.php file on server
	NSString *capabilityToken = nil;
	//Make the URL Connection to your server
#warning Change this URL to point to the auth.php on your public server
	NSURL *url = [NSURL URLWithString:@"http://companyfoo.com/auth.php"];
	NSURLResponse *response = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url]
										 returningResponse:&response error:error];
	if (data)
	{
		NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
		
		if (httpResponse.statusCode==200)
		{
			capabilityToken = [[[NSString alloc] initWithData:data
													   encoding:NSUTF8StringEncoding] autorelease];
		}
		else
		{
			*error = [BasicPhone errorFromHTTPResponse:httpResponse domain:@"CapabilityTokenDomain"];
		}
	}
	// else there is likely an error which got assigned to the incoming error pointer.
	
	return capabilityToken;
}

-(BOOL)capabilityTokenValid
{
	//Check TCDevice's capability token to see if it is still valid
	BOOL isValid = NO;
	NSNumber* expirationTimeObject = [_device.capabilities objectForKey:@"expiration"];
	long long expirationTimeValue = [expirationTimeObject longLongValue];
	long long currentTimeValue = (long long)[[NSDate date] timeIntervalSince1970];

	if((expirationTimeValue-currentTimeValue)>0)
		isValid = YES;
	
	return isValid;
}

#pragma mark -
#pragma mark TCConnection Implementation

-(void)connect
{
	// First check to see if the token we have is valid, and if not, refresh it.
	// Your own client may ask the user to re-authenticate to obtain a new token depending on
	// your security requirements.
	if (![self capabilityTokenValid])
	{
		//Capability token is not valid, so create a new one and update device
		[self login];
	}
	
	// Now check to see if we can make an outgoing call and attempt a connection if so
	NSNumber* hasOutgoing = [_device.capabilities objectForKey:TCDeviceCapabilityOutgoingKey];
	if ( [hasOutgoing boolValue] == YES ) 
	{
		//Disconnect if we've already got a connection in progress
		if(_connection)
			[self disconnect];
		
		_connection = [_device connect:nil delegate:self];
		[_connection retain];
		
		if ( !_connection ) // if a connection is established, connectionDidStartConnecting: gets invoked next
		{
			[[NSNotificationCenter defaultCenter] postNotificationName:BPConnectionDidFailToConnect object:nil];
		}
	}
}	

-(void)disconnect
{
	//Destroy TCConnection
	// We don't release until after the delegate callback for connectionDidConnect:
	[_connection disconnect];

	[[NSNotificationCenter defaultCenter] postNotificationName:BPConnectionIsDisconnecting object:nil];
}	


-(void)acceptConnection
{
	//Accept the pending connection
	[_pendingIncomingConnection accept];
	_connection = _pendingIncomingConnection;
	_pendingIncomingConnection = nil;
}

-(void)ignoreIncomingConnection
{
	// Ignore the pending connection
	// We don't release until after the delegate callback for connectionDidConnect:
	[_pendingIncomingConnection ignore];
}

#pragma mark -
#pragma mark TCDeviceDelegate Methods

-(void)deviceDidStartListeningForIncomingConnections:(TCDevice*)device
{
	[[NSNotificationCenter defaultCenter] postNotificationName:BPDeviceDidStartListeningForIncomingConnections object:nil];
}

-(void)device:(TCDevice*)device didStopListeningForIncomingConnections:(NSError*)error
{
	// The TCDevice is no longer listening for incoming connections, possibly due to an error.
	NSDictionary* userInfo = nil;
	if ( error )
		userInfo = [NSDictionary dictionaryWithObject:error forKey:@"error"];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:BPDeviceDidStopListeningForIncomingConnections object:nil userInfo:userInfo];
}

-(void)device:(TCDevice*)device didReceiveIncomingConnection:(TCConnection*)connection
{
	//Device received an incoming connection
	if ( _pendingIncomingConnection )
	{
		NSLog(@"A pending exception already exists");
		return;
	}
	
	// Initalize pending incoming conneciton
	_pendingIncomingConnection = [connection retain];
	[_pendingIncomingConnection setDelegate:self];
	
	// Send a notification out that we've received this.
	[[NSNotificationCenter defaultCenter] postNotificationName:BPPendingIncomingConnectionReceived object:nil];
}

#pragma mark -
#pragma mark TCConnectionDelegate

-(void)connectionDidStartConnecting:(TCConnection*)connection
{
	[[NSNotificationCenter defaultCenter] postNotificationName:BPConnectionIsConnecting object:nil];
}

-(void)connectionDidConnect:(TCConnection*)connection
{
	// Enable the proximity sensor to make sure the call doesn't errantly get hung up.
	UIDevice* device = [UIDevice currentDevice];
	device.proximityMonitoringEnabled = YES;
	
	// set up the route audio through the speaker, if enabled
	[self updateAudioRoute];

	[[NSNotificationCenter defaultCenter] postNotificationName:BPConnectionDidConnect object:nil];
}

-(void)connectionDidDisconnect:(TCConnection*)connection
{
	if ( connection == _connection )
	{
		UIDevice* device = [UIDevice currentDevice];
		device.proximityMonitoringEnabled = NO;

		[_connection release];
		_connection = nil;
		
		[[NSNotificationCenter defaultCenter] postNotificationName:BPConnectionDidDisconnect object:nil];
	}
	else if ( connection == _pendingIncomingConnection )
	{
		[_pendingIncomingConnection release];
		_pendingIncomingConnection = nil;

		[[NSNotificationCenter defaultCenter] postNotificationName:BPPendingIncomingConnectionDidDisconnect object:nil];
	}
}

-(void)connection:(TCConnection*)connection didFailWithError:(NSError*)error
{
	//Connection failed
	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:error forKey:@"error"]; // autoreleased
	[[NSNotificationCenter defaultCenter] postNotificationName:BPConnectionDidFailWithError object:nil userInfo:userInfo];
}

-(void)setSpeakerEnabled:(BOOL)enabled
{
	_speakerEnabled = enabled;
	
	[self updateAudioRoute];
}

-(void)updateAudioRoute
{
	if (_speakerEnabled)
	{
		UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker; 
		
		AudioSessionSetProperty (
								 kAudioSessionProperty_OverrideAudioRoute,                         
								 sizeof (audioRouteOverride),                                      
								 &audioRouteOverride                                               
								 );		
	}
	else
	{
		UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None; 
		
		AudioSessionSetProperty (
								 kAudioSessionProperty_OverrideAudioRoute,                         
								 sizeof (audioRouteOverride),                                      
								 &audioRouteOverride                                               
								 );	
	}
}

#pragma mark -
#pragma mark Misc

// Utility method to create a simple NSError* from an HTTP response
+(NSError*)errorFromHTTPResponse:(NSHTTPURLResponse*)response domain:(NSString*)domain
{
	NSString* localizedDescription = [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode];
	
	NSDictionary* errorUserInfo = [NSDictionary dictionaryWithObject:localizedDescription
															  forKey:NSLocalizedDescriptionKey];
	
	NSError* error = [NSError errorWithDomain:domain
										 code:response.statusCode
									 userInfo:errorUserInfo];
	return error;	
}

#pragma mark -
#pragma mark Memory management

-(void)dealloc
{
	[_connection release];
	[_pendingIncomingConnection release];
	[_device release];
	
	[super dealloc];
}

@end
