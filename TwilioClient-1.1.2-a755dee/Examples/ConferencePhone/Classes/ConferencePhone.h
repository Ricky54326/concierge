//
//  Copyright 2011 Twilio. All rights reserved.
//
 
#import <Foundation/Foundation.h>

#import "TwilioClient.h"

@interface ConferencePhone : NSObject<TCConnectionDelegate, UIAlertViewDelegate>
{
@private
	TCDevice* _device;
	TCConnection* _connection;
	NSString* _conferenceName;
}
@property (nonatomic,retain) TCDevice* device;
@property (nonatomic,retain) TCConnection* connection;

// Log-in to the Twilio Account and Application, creating and initializing
// the TCDevice.
-(void)login;

// Connect to a named conference.
-(void)connect:(NSString*)conferenceName;
// Disconnect from the named conference.
-(void)disconnect;

// Make outbound calls via the Twilio API to invite the participants to join the conference.
-(void)performCalls:(NSArray*)participants;

@end
