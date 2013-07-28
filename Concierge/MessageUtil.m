//
//  MessageUtil.m
//  HelpMeHack
//
//  Created by Kiran Vodrahalli on 7/27/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import "MessageUtil.h"

@implementation MessageUtil

- (NSArray *)downloadRelevantMessages: (Person) person {
    
    PFQuery *query = [PFQuery queryWithClassName:@"message"];
    if ([person.type isEqualToString: @"hacker"]) {
        // relevant messages are all of type response
        [query whereKey:@"type" equalTo:@"response"];
        [query whereKey:@"hacker_id" equalTo: person.phone_id];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                //NSLog(@"Successfully retrieved %d scores.", objects.count);
                // Do something with the found objects
                /*for (PFObject *object in objects) {
                    NSLog(@"%@", object.objectId);
                }*/
                return objects;
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    else if ([person.type isEqualToString: @"leader"] && [person.available != NO]){
        // relevant messages are all of type request
        [query whereKey:@"type" equalTo:@"request"];
        
        // of all the leaders, pick a leader who is capable of solving request_type who is available
        [query whereKey:@"request_type" containedIn: person.jobs];
        //[query whereKey:@"leader_id" equalTo: person.phone_id];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                //NSLog(@"Successfully retrieved %d scores.", objects.count);
                // Do something with the found objects
                /*for (PFObject *object in objects) {
                 NSLog(@"%@", object.objectId);
                 }*/
                return objects;
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    else {
        // cry moar
    }
}

@end
