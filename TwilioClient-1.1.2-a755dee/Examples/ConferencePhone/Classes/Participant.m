//
//  Copyright 2011 Twilio. All rights reserved.
//
 
#import "Participant.h"


@implementation Participant

@synthesize contactString = _contactString;
@synthesize type = _type;

-(void)dealloc
{
	[_contactString release];
	[super dealloc];
}

@end
