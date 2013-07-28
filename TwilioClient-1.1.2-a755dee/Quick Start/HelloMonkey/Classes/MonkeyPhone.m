//
//  Copyright 2011 Twilio. All rights reserved.
//
 
#import "MonkeyPhone.h"

@implementation MonkeyPhone


-(id)init
{
	if ( self = [super init] )
	{
// Replace the URL with your Capabilities Token URL
		NSURL* url = [NSURL URLWithString:@"http://companyfoo.com/auth.php"];
		NSURLResponse*  response = nil;
		NSError*  	error = nil;
		NSData* data = [NSURLConnection sendSynchronousRequest:
						[NSURLRequest requestWithURL:url] 
											 returningResponse:&response 
														 error:&error];
		if (data)
		{
			NSHTTPURLResponse*  httpResponse = (NSHTTPURLResponse*)response;
			
			if (httpResponse.statusCode == 200)
			{
				NSString* capabilityToken = [[[NSString alloc] initWithData:data
																	 encoding:NSUTF8StringEncoding] 
											   autorelease];
				
				_device = [[TCDevice alloc] initWithCapabilityToken:capabilityToken
															 delegate:nil];
			}
			else
			{
				NSString*  errorString = [NSString stringWithFormat:
											@"HTTP status code %d",                          
											httpResponse.statusCode];
				NSLog(@"Error logging in: %@", errorString);
			}
		}
		else
		{
			NSLog(@"Error logging in: %@", [error localizedDescription]);
		}
	}
	return self;
}


-(void)dealloc
{
	[_device release];
	[super dealloc];
}


@end
