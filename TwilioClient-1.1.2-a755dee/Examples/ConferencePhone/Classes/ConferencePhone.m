//
//  Copyright 2011 Twilio. All rights reserved.
//
 
#import "ConferencePhone.h"
#import "ConferencePhoneNotifications.h"
#import "Participant.h"

// private methods
@interface ConferencePhone ()

//TCDevice Capability Token 
-(NSString*)getCapabilityToken:(NSError**)error;
-(BOOL)capabilityTokenValid;

//REST call
-(NSURL*)getRESTURL:(NSArray*)participants;

+(NSError*)errorFromHTTPResponse:(NSHTTPURLResponse*)response domain:(NSString*)domain;

@end

@implementation ConferencePhone

@synthesize device = _device;
@synthesize connection = _connection;

#pragma mark -
#pragma mark Initialization

-(void)login
{
	[[NSNotificationCenter defaultCenter] postNotificationName:CPLoginDidStart object:nil];

	NSError* loginError = nil;
	NSString* capabilityToken = [self getCapabilityToken:&loginError];
	
	if ( !loginError && capabilityToken )
	{
		if ( !_device )
		{
			// initialize a new device
			_device = [[TCDevice alloc] initWithCapabilityToken:capabilityToken delegate:nil];
		}
		else
		{
			// update its capabilities
			[_device updateCapabilityToken:capabilityToken];
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:CPLoginDidFinish object:nil];
	}
	else if ( loginError )
	{	
		NSDictionary* userInfo = [NSDictionary dictionaryWithObject:loginError forKey:@"error"];
		[[NSNotificationCenter defaultCenter] postNotificationName:CPLoginDidFailWithError object:nil userInfo:userInfo];
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
			*error = [ConferencePhone errorFromHTTPResponse:httpResponse domain:@"CapabilityTokenDomain"];
		}
	}
	// else there is likely an error which got assigned to the incoming error pointer.
	
	return capabilityToken;
}

-(BOOL)capabilityTokenValid
{
	//Check TCDevice's capability token to see if it is still valid
	BOOL isValid = NO;
	NSNumber *expirationTimeObject = [_device.capabilities objectForKey:@"expiration"];
	long long expirationTimeValue = [expirationTimeObject longLongValue];
	long long currentTimeValue = (long long)[[NSDate date] timeIntervalSince1970];
	
	if ((expirationTimeValue-currentTimeValue)>0)
		isValid = YES;
	
	return isValid;
}

#pragma mark -
#pragma mark Connections

-(void)connect:(NSString*)conferenceName
{
	// first check to see if the token we have is valid, and if not, refresh it.
	// Your own client may ask the user to re-authenticate to obtain a new token depending on
	// your security requirements.
	if (![self capabilityTokenValid])
	{
		//Capability token is not valid, so create a new one and update device
		[self login];
	}
	
	// now check to see if we can make an outgoing call and attempt a connection if so
	NSNumber* hasOutgoing = [_device.capabilities objectForKey:TCDeviceCapabilityOutgoingKey];
	if ( [hasOutgoing boolValue] == YES ) 
	{
		//Disconnect if we've already got a connection in progress
		if (_connection)
			[self disconnect];
		
		// save off our conference name for later use when dialing conference participants
		if ( _conferenceName != conferenceName )
		{
			[_conferenceName release];
			_conferenceName = [conferenceName retain];
		}
		
		NSDictionary *parameters = nil;
		if ([conferenceName length]>0)
		{
			parameters = [NSDictionary dictionaryWithObject:conferenceName forKey:@"ConferenceName"];
		}
		
		_connection = [_device connect:parameters delegate:self];
		[_connection retain];
		
		if ( !_connection ) // if a connection could be established, connectionDidStartConnecting: will follow
		{
			[[NSNotificationCenter defaultCenter] postNotificationName:CPConferenceConnectionDidFailToConnect object:nil];
		}
	}
}

-(void)disconnect
{
	//Destroy TCConnection
	// We don't release until after the delegate callback for connectionDidDisconnect:
	[_connection disconnect];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:CPConferenceConnectionIsDisconnecting object:nil];
}	

#pragma mark -
#pragma mark REST call


-(void)performCalls:(NSArray*)participants
{
	[[NSNotificationCenter defaultCenter] postNotificationName:CPDialingParticipants object:nil];

	NSURL* requestURL = [self getRESTURL:participants];
	NSLog(@"Making a request to: %@", [requestURL absoluteString]);
	
	NSURLResponse *response = nil;
	NSError *error = nil;
	
	NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:requestURL]
										 returningResponse:&response error:&error];
	
	if (data)
	{
		NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
		
		if (httpResponse.statusCode != 200)
		{
			NSError* restError = [ConferencePhone errorFromHTTPResponse:httpResponse domain:@"ConferencePhoneRESTDomain"];
			NSDictionary* userInfo = [NSDictionary dictionaryWithObject:restError forKey:@"error"];
											
			[[NSNotificationCenter defaultCenter] postNotificationName:CPDialingParticipantsFailedWithError object:nil userInfo:userInfo];
		}
	}
	else if (error)
	{
		NSDictionary* userInfo = [NSDictionary dictionaryWithObject:error forKey:@"error"];
		[[NSNotificationCenter defaultCenter] postNotificationName:CPDialingParticipantsFailedWithError object:nil userInfo:userInfo];
	}
}

-(NSURL*)getRESTURL:(NSArray*)participants;
{
	// Creates a URL to the PHP file that will make REST calls to add the participants to the conference.
	// If participant answers call, they are added to the current conference
	
	NSURL* url = nil;
#warning Change this URL to point to the make-call.php on your public server
	NSMutableString* urlString = [[NSMutableString alloc] initWithString:
									[NSString stringWithFormat:@"http://companyfoo.com/make-call.php?conferenceName=%@",
																			_conferenceName]];
	for (Participant* participant in participants)
	{
		// If the participant is a client, prepend @"client:" onto the 
		// contact string, otherwise assume it's a phone number and pass along as-is.
		// This is done to properly pass arguments via the REST API to make the outbound
		// calls to the participants.  (This string could be appended server-side,
		// but is done here since we already use the client/phone number enum type for display
		// purposes elsewhere in the app.)
		NSString* contactString = participant.type == eParticipantType_Client ?
										[NSString stringWithFormat:@"client:%@", participant.contactString] :
										participant.contactString;
		
		NSString* participantArgToAppend = [NSString stringWithFormat:@"&participants[]=%@",contactString];
		[urlString appendString:participantArgToAppend];
	}
	
	url = [NSURL URLWithString:urlString]; // autoreleased
	
	[urlString release];
	
	return url;
}


#pragma mark -
#pragma mark TCConnectionDelegate

-(void)connectionDidStartConnecting:(TCConnection*)connection
{
	[[NSNotificationCenter defaultCenter] postNotificationName:CPConferenceConnectionIsConnecting object:nil];
}

-(void)connectionDidConnect:(TCConnection*)connection
{
	//Enable the proximity censor
	UIDevice *device = [UIDevice currentDevice];
	device.proximityMonitoringEnabled = YES;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:CPConferenceConnectionDidConnect object:nil];
}

-(void)connectionDidDisconnect:(TCConnection*)connection
{
	if ( connection == _connection ) // only send out notifications if it's a connection we care about
	{
		//Disable proximity censor
		UIDevice *device = [UIDevice currentDevice];
		device.proximityMonitoringEnabled = NO;
		
		[_connection release];
		_connection = nil;
		
		[[NSNotificationCenter defaultCenter] postNotificationName:CPConferenceConnectionDidDisconnect object:nil];
	}	
}

-(void)connection:(TCConnection*)connection didFailWithError:(NSError*)error
{
	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:error forKey:@"error"]; // autoreleased
	[[NSNotificationCenter defaultCenter] postNotificationName:CPConferenceConnectionDidFailWithError object:nil userInfo:userInfo];
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
	[_device release];
	
	[_conferenceName release];
	
	[super dealloc];
}

@end
