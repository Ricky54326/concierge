//
//  EventUtil.m
//  Concierge
//
//  Created by Kiran Vodrahalli on 7/28/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import <Parse/Parse.h>
#import "EventUtil.h"

@implementation EventUtil

- (NSMutableArray *)getEvents {
    __block NSArray *array = [[NSArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"event"];
    [query orderByAscending: @"start_time"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            array = objects;
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    NSMutableArray * answer = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i++) {
        PFObject * current = [array objectAtIndex:i];
        NSDate * current_start_time = [current objectForKey:@"start_time"];
        NSDate * current_end_time = [current objectForKey:@"end_time"];
        PFFile * current_image = [current objectForKey:@"image"];
        NSString * current_name = [current objectForKey:@"name"];
        Event * current_event = [[Event alloc] initWithType: current_start_time andEndTime: current_end_time andImage: current_image andName: current_name];
        [answer addObject: current_event];
    }
    return answer;
}

@end
