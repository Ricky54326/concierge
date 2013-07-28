//
//  ParseUtil.m
//  Concierge
//
//  Created by Alex Chen on 7/28/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import <Parse/Parse.h>
#import "ParseUtil.h"

@implementation ParseUtil

- (NSMutableArray *)getSponsors
{
    __block NSArray *result = [[NSArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"sponsors"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            result = objects;
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    NSMutableArray *answer = [[NSMutableArray alloc] init];
    for (int i = 0; i < result.count; i++) {
        PFObject *obj = [result objectAtIndex:i];
        NSString *sponsor = [obj objectForKey:@"name"];
        [answer addObject:sponsor];
    }
    
    return answer;
}

@end
