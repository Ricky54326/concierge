//
//  Copyright 2011 Twilio. All rights reserved.
//
 
#import <Foundation/Foundation.h>

typedef enum ParticipantType
{
	eParticipantType_PhoneNumber,
	eParticipantType_Client
} ParticipantType;

// A participant in a phone call
@interface Participant : NSObject 
{
@private
	NSString* _contactString;
	ParticipantType _type;
}

@property (nonatomic,retain) NSString*	contactString;
@property (nonatomic) ParticipantType	type;

@end
