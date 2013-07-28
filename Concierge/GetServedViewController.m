//
//  GetServedViewController.m
//  Concierge
//
//  Created by Katie Siegel on 7/28/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import "GetServedViewController.h"
#import "GetFoodViewController.h"
#import "GetTechViewController.h"

@interface GetServedViewController ()

@end

@implementation GetServedViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)foodButtonPressed:(id)sender {
    UIViewController *vc = [[MentorViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
