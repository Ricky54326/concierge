//
//  Message.h
//  HelpMeHack
//
//  Created by Kiran Vodrahalli on 7/27/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Message : NSObject


@property (nonatomic, strong) NSString *hacker_id; // a hacker at the hackathon
@property (nonatomic, strong) NSString *leader_id; // in charge of hackathon
@property (nonatomic, strong) NSString *type; // response and request; leaders get requests and hackers get responses
@property (nonatomic, strong) NSString *request_type; // tech, food, etc
@property (nonatomic, retain) NSString *text; // text of message

- (id)initWithType:(NSString *)hacker_id andLeader:(NSString *)leader_id andType:(NSString *)type andRequestType: (NSString *)request_type andText: (NSString*)text;
- (void)send;
- (void)isMessageThere;
- (void)removeMessage;

@end

