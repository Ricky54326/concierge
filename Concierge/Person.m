//
//  Person.m
//  HelpMeHack
//
//  Created by Alex Chen on 7/27/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize phone_id = _phone_id;
@synthesize type = _type;
@synthesize name = _name;
@synthesize team = _team;
@synthesize available = _available;
@synthesize jobs = _jobs;

- (id)initWithType:(NSString *)type andName:(NSString *)name andTeam:(NSString *)team
{
	if ((self = [super init]))
	{
        self.phone_id = [self getID];
		self.type = type;
		self.name = name;
        self.team = team;
        self.jobs = [NSMutableArray array];
        self.available = YES;
	}
    [self store];
    
	return self;
}

- (NSString *)getID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

- (void)updateType:(NSString *)type
{
    self.type = type;
    //[self store];
}

- (void)updateName:(NSString *)name
{
    self.name = name;
    //[self store];
}

- (void)updateTeam:(NSString *)team
{
    self.team = team;
    //[self store];
}

- (void)updateAvailability: (BOOL)new_available {
    self.available = new_available;
}

- (void)addJob:(NSString *)job
{
    [self.jobs addObject:job];
    //[self store];
}

- (void)removeJob:(NSString *)job
{
    [self.jobs removeObject:job];
    //[self store];
}

- (void)store
{
    // figure out if it's in the database already
    PFQuery *query = [PFQuery queryWithClassName:@"person"];
    [query whereKey:@"id" equalTo:self.phone_id];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                // update
                PFObject *person = [PFObject objectWithClassName:@"person"];
                [person setObject:self.phone_id forKey:@"id"];
                [person saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [person setObject:self.type forKey:@"type"];
                    [person setObject:self.name forKey:@"name"];
                    [person setObject:self.team forKey:@"team"];
                    [person setObject:self.jobs forKey:@"jobs"];
                    [person saveInBackground];
                }];
            } else {
                // add
                PFObject *person = [PFObject objectWithClassName:@"person"];
                [person setObject:self.phone_id forKey:@"id"];
                [person setObject:self.type forKey:@"type"];
                [person setObject:self.name forKey:@"name"];
                [person setObject:self.team forKey:@"team"];
                [person setObject:self.jobs forKey:@"jobs"];
                [person saveInBackground];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
