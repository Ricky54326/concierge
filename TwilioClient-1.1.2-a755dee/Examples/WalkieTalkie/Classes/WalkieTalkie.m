//
//  Copyright 2011 Twilio. All rights reserved.
//
 
#import "WalkieTalkie.h"
#import "WalkieTalkieNotifications.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface WalkieTalkie ()

//TCDevice Capability Token
-(NSString*)getCapabilityToken;
-(BOOL)capabilityTokenValid;

@end


@implementation WalkieTalkie

@synthesize connection = _connection;
@synthesize pendingIncomingConnection = _pendingIncomingConnection;

#pragma mark -
#pragma mark Initalization

-(id)init
{
	if (self = [super init])
	{
		//Initalize the TCDevice
		_device = [[TCDevice alloc] initWithCapabilityToken:[self getCapabilityToken] delegate:self];
	}
	
	// Check the capabilities and warn if features aren't available.
	// You might handle this in other ways such as disabling buttons, or having
	// LED-style images in a red or green state.
	NSNumber* hasOutgoing = [_device.capabilities objectForKey:TCDeviceCapabilityOutgoingKey];
	NSNumber* hasIncoming = [_device.capabilities objectForKey:TCDeviceCapabilityIncomingKey];
	
	if ( [hasOutgoing boolValue] == NO )
	{
		NSLog(@"Unable to make outgoing calls with current capability token");
	}
	if ( [hasIncoming boolValue] == NO )
	{
		NSLog(@"Unable to receive incoming calls with current capability token");
	}
	
	return self;
}

#pragma mark -
#pragma mark TCDevice Capability Token

-(NSString*)getCapabilityToken
{
	//Creates a new capability token from the auth.php file on server
	
	NSString* capabilityToken = nil;
	//Make the URL Connection to your server
#if TARGET_IPHONE_SIMULATOR
	NSURL* url = [NSURL URLWithString:@"http://companyfoo.com/auth.php?ClientName=jenny"];
#else
	NSURL* url = [NSURL URLWithString:@"http://companyfoo.com/auth.php?ClientName=tommy"];
#endif
	
	NSURLResponse* response = nil;
	NSError* error = nil;
	NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url]
										 returningResponse:&response error:&error];
	if (data)
	{
		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
		
		if (httpResponse.statusCode==200)
		{
			capabilityToken = [[[NSString alloc] initWithData:data
													   encoding:NSUTF8StringEncoding]autorelease];
		}
		else
		{
			NSLog(@"Capability Token error: HTTP status code %d",httpResponse.statusCode);
		}
	}
	else
	{
		NSLog(@"Error logging in: %@", [error localizedDescription]);
	}
	
	return capabilityToken;
}


-(BOOL)capabilityTokenValid
{
	//Check TCDevice's capability token to see if it is still valid
	BOOL isValid = NO;
	NSNumber* expirationTimeObject = [_device.capabilities objectForKey:@"expiration"];
	long long expirationTimeValue = [expirationTimeObject longLongValue];
	long long currentTimeValue = (long long)[[NSDate date]timeIntervalSince1970];
	
	if ((expirationTimeValue-currentTimeValue)>0)
		isValid = YES;
	
	return isValid;
}

-(void)connect:(NSString*)clientName;
{
	// first check to see if the token we have is valid, and if not, refresh it.
	// Your own client may ask the user to re-authenticate to obtain a new token depending on
	// your security requirements.
	if (![self capabilityTokenValid])
	{
		//Capability token is not valid, so create a new one and update device
		
		//Set the capability token of the device to be the newly created capability token
		[_device updateCapabilityToken:[self getCapabilityToken]];
	}
	
	//now check to see if we can make an outgoing call and attempt a connection if so
	NSNumber* hasOutgoing = [_device.capabilities objectForKey:TCDeviceCapabilityOutgoingKey];
	if ([hasOutgoing boolValue]==YES)
	{
		//Disconnect if we've already got a connection in progress
		if (_connection)
			[self disconnect];
		
		NSDictionary* parameters = nil;
		if ([clientName length]>0)
		{
			parameters = [NSDictionary dictionaryWithObject:clientName forKey:@"ClientName"];
		}
		_connection = [_device connect:parameters delegate:self];
		[_connection retain];
		
		if (!_connection)
			NSLog(@"Couldn't establish outgoing call");
	}
	else
	{
		NSLog(@"Unable to make outgoing calls with current capabilities");
	}
}

-(void)disconnect
{
	// Destroy TCConnection.
	// We don't release until after the delegate callback for connectionDidConnect:
	[_connection disconnect];
}

-(void)acceptIncomingConnection
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
	NSLog(@"Device is now listening for incoming connections");
}

-(void)device:(TCDevice*)device didStopListeningForIncomingConnections:(NSError*)error
{
	if ( !error )
		NSLog(@"Device went offline");
	else
		NSLog(@"Device went offline due to error: %@", [error localizedDescription]);
}

-(void)device:(TCDevice*)device didReceiveIncomingConnection:(TCConnection*)connection
{
	//Device received an incoming connection
	
	if (_pendingIncomingConnection != nil)
	{
		// For simplicity, we only allow a single pending connection at once.
		// Your app may choose to do something more complicated.
		NSLog(@"A pending connection already exists");
		return;
	}
	
	self.pendingIncomingConnection = connection; // retains
	self.pendingIncomingConnection.delegate = self;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:WTPendingIncomingConnectionReceived object:nil];
}

#pragma mark -
#pragma mark TCConnectionDelegate

-(void)connectionDidStartConnecting:(TCConnection*)connection
{
	NSLog(@"Connection attempting to connect");
}

-(void)connectionDidConnect:(TCConnection*)connection
{
	NSLog(@"Connection Did Connect");

	// make sure we're using the speaker as an audio route
	UInt32 route = kAudioSessionOverrideAudioRoute_Speaker;
	AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
	
	// Start out muted when the connection is established.
	// The user presses the button on-screen to un-mute.
	self.muted = YES;

	[[NSNotificationCenter defaultCenter] postNotificationName:WTConnectionDidConnect object:nil];
}

-(void)connectionDidDisconnect:(TCConnection*)connection
{
	NSLog(@"Connection did disconnect");
	//If a connection still exists that we're tracking, release it.
	if (connection == _connection)
	{
		[_connection release];
		_connection = nil;
		
		[[NSNotificationCenter defaultCenter] postNotificationName:WTConnectionDidDisconnect object:nil];
	} 
	else if (connection == _pendingIncomingConnection)
	{
		// This might happen if the caller calling us has hung up before we could ignore it or answer/disconnect explicitly.
		[_pendingIncomingConnection release];
		_pendingIncomingConnection = nil;

		[[NSNotificationCenter defaultCenter] postNotificationName:WTPendingIncomingConnectionDidDisconnect object:nil];
	}
}

-(void)connection:(TCConnection*)connection didFailWithError:(NSError*)error
{
	NSLog(@"Connection failed with error: %@",error);
	if ( connection == _pendingIncomingConnection || connection == _connection )
		[[NSNotificationCenter defaultCenter] postNotificationName:WTConnectionDidFailWithError object:nil];
}




#pragma mark -
#pragma mark Mute

-(void)setMuted:(BOOL)muted
{
	// Since we only have a single connection, there's a global
	// "muted" property on the WalkieTalkie that just affects that
	// connection.  In a more complicated app you might independently mute
	// individual connections or all of them at once.
	_connection.muted = muted;
}

-(BOOL)muted
{
	return _connection.muted;
}

#pragma mark -
#pragma mark Memory management

-(void)dealloc
{
	[_device release];
	[_connection release];
	[_pendingIncomingConnection release];
	
	[super dealloc];
}

@end

