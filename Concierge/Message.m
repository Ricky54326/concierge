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

- (id)initWithType:(NSString *)hacker_id andLeader:(NSString *)leader_id andType:(NSString *)type andRequestType: (NSString *)request_type andText: (NSString*)text {
    
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

- (void)send {
    PFObject *tosend = [PFObject objectWithClassName:@"message"];
    [tosend setObject: self.hacker_id forKey:@"hacker_id"];
    [tosend setObject: self.leader_id forKey:@"leader_id"];
    [tosend setObject: self.type forKey:@"type"];
    [tosend setObject: self.request_type forKey:@"request_type"];
    [tosend setObject: self.text forKey:@"text"];
    [tosend saveInBackground];
   
}

- (BOOL)isMessageThere {
    __block BOOL isThere = NO;
    PFQuery *tosend = [PFQuery queryWithClassName:@"message"];
    [tosend whereKey:@"hacker_id" equalTo:self.hacker_id];
    [tosend whereKey:@"leader_id" equalTo:self.leader_id];
    [tosend whereKey:@"type" equalTo: self.type];
    [tosend whereKey:@"request_type" equalTo:self.request_type];
    [tosend whereKey:@"text" equalTo:self.text];
    [tosend findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                isThere = YES;
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    return isThere;
}

- (void)removeMessage {
    PFObject *tosend = [PFObject objectWithClassName:@"message"];
    [tosend setObject: self.hacker_id forKey:@"hacker_id"];
    [tosend setObject: self.leader_id forKey:@"leader_id"];
    [tosend setObject: self.type forKey:@"type"];
    [tosend setObject: self.request_type forKey:@"request_type"];
    [tosend setObject: self.text forKey:@"text"];
    [tosend deleteInBackground];
}


@end
