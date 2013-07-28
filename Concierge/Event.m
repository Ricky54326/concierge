//
//  Event.m
//  Concierge
//
//  Created by Kiran Vodrahalli on 7/28/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize start_time = _start_time;
@synthesize end_time = _end_time;
@synthesize image = _image;
@synthesize name = _name;

- (id)initWithType: (NSDate *)start_time andEndTime:(NSDate *)end_time andImage:(PFFile *)image andName: (NSString *)name {
    if ((self = [super init]))
	{
        self.start_time = start_time;
        self.end_time = end_time;
		self.image = image;
		self.name = name;
	}
    
	return self;
}

- (void)addEvent: (Event *)event {
    PFObject *toAdd = [PFObject objectWithClassName:@"message"];
    [toAdd setObject: self.start_time forKey:@"start_time"];
    [toAdd setObject: self.end_time forKey:@"end_time"];
    [toAdd setObject: self.image forKey:@"image"];
    [toAdd setObject: self.name forKey:@"name"];
    [toAdd saveInBackground];
}

@end
