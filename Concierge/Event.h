//
//  Event.h
//  Concierge
//
//  Created by Kiran Vodrahalli on 7/28/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

@interface Event : NSObject
@property (nonatomic, strong) NSDate *start_time; // event start time
@property (nonatomic, strong) NSDate *end_time; // in charge of hackathon
@property (nonatomic, strong) PFFile *image; // image representation of the event
@property (nonatomic, strong) NSString *name; // name of the event

- (id)initWithType: (NSDate *)start_time andEndTime:(NSDate *)end_time andImage:(PFFile *)image andName: (NSString *)name;
- (void)addEvent: (Event *)event;

@end
