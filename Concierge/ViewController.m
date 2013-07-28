//
//  ViewController.m
//  Concierge
//
//  Created by Katie Siegel on 7/27/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import "ViewController.h"
#import "ComeHitherVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)comeHitherButtonPressed:(id)sender {
    UIViewController *vc = [[ComeHitherVC alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"fdgdgsd %@",self.navigationController);
}

@end
