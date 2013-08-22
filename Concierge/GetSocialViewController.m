//
//  GetSocialViewController.m
//  Concierge
//
//  Created by Kathryn Siegel on 8/22/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import "GetSocialViewController.h"
#import <Parse/Parse.h>

@interface GetSocialViewController ()

@end

@implementation GetSocialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.announcements = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName: @"Announcements"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {// The find succeeded.
            NSLog(@"Successfully retrieved %d announcements.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", [object objectForKey:@"Announcement"]);
                [self.announcements addObject:[object objectForKey:@"Announcement"]];
            }
            [announceTable reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    [announceTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) piazzaButtonClicked: (id)sender {
    
}

- (IBAction) fbButtonClicked: (id)sender {
    
}

- (IBAction) twitterButtonClicked: (id)sender {
    
}

@end
