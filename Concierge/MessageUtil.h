//
//  MessageUtil.h
//  HelpMeHack
//
//  Created by Kiran Vodrahalli on 7/27/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Person.h" 
#import "Message.h"

@interface MessageUtil : NSObject

- (NSMutableArray *)downloadRelevantMessages:(Person *)person;

@end
