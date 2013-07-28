//
//  Message.m
//  HelpMeHack
//
//  Created by Kiran Vodrahalli on 7/27/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize hacker_id = _hacker_id;
@synthesize leader_id = _leader_id;
@synthesize type = _type;
@synthesize request_type = _request_type;
@synthesize text = _text;

- (id)initWithType:(NSString *)hacker_id andLeader:(NSString *)leader_id andType:(NSString *)type andRequestType: (NSString *)request_type andText: (NSString*)test {
    
    if ((self = [super init]))
	{
        self.hacker_id = hacker_id;
        self.leader_id = leader_id;
		self.type = type;
		self.request_type = request_type;
        self.text = text; 
	}
    
	return self;
    
}

- (void)send: (Message) message {
    PFObject *tosend = [PFObject objectWithClassName:@"message"];
    [tosend setObject: message.hacker_id forKey:@"hacker_id"];
    [tosend setObject: message.leader_id forKey:@"leader_id"];
    [tosend setObject: message.type forKey:@"type"];
    [tosend setObject: message.request_type forKey:@"request_type"];
    [tosend setObject: message.text forKey:@"text"];
    [tosend saveInBackground];
   
}

- (void)isMessageThere:(Message)message {
    
}

- (void)removeMessage: (Message) message {
    
}


@end
