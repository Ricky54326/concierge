//
//  Person.h
//  HelpMeHack
//
//  Created by Alex Chen on 7/27/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, strong) NSString *phone_id; // id specific to phone of person -- used as id of person
@property (nonatomic, strong) NSString *type; // hacker or leader
@property (nonatomic, strong) NSString *name; // the person's name
@property (nonatomic, strong) NSString *team; // the team name of the person for the hackathon
@property (nonatomic, assign) BOOL available = YES; // is the leader available (if leader). if hacker, always YES and not used.
@property (nonatomic, retain) NSMutableArray *jobs; // if hacker, only job is "hack". if leader, can be stuff like "tech", "food", etc. any size greater than or equal to 1

- (id)initWithType:(NSString *)type andName:(NSString *)name andTeam:(NSString *)team;
- (NSString*)getID;
- (void)updateType:(NSString *)type;
- (void)updateName:(NSString *)name;
- (void)updateTeam:(NSString *)team;
- (void)updateAvailability: (BOOL)new_available;
- (void)addJob:(NSString *)job;
- (void)removeJob:(NSString *)job;
- (void)store;

@end
