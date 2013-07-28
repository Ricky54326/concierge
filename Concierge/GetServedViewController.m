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
    
    [[foodButton imageView] setContentMode: UIViewContentModeScaleAspectFill];
    [[techButton imageView] setContentMode: UIViewContentModeScaleAspectFill];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)foodButtonPressed:(id)sender {
    UIViewController *vc = [[GetFoodViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)techButtonPressed:(id)sender {
    UIViewController *vc = [[GetTechViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
