//
//  ViewController.m
//  Concierge
//
//  Created by Katie Siegel on 7/27/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import "ViewController.h"
#import "ComeHitherVC.h"
#import "TalkViewController.h"
#import "MentorViewController.h"
#import "ScheduleViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:176.0/255.0 green:226.0/255.0 blue:255.0/255.0 alpha:1.0];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)talkButtonPressed:(id)sender {
    UIViewController *vc = [[TalkViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)comeHitherButtonPressed:(id)sender {
    UIViewController *vc = [[ComeHitherVC alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)mentorButtonPressed:(id)sender {
    UIViewController *vc = [[MentorViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)scheduleButtonPressed:(id)sender {
    UIViewController *vc = [[ScheduleViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)timerTick:(NSTimer *)timer {
    NSDate *now = [NSDate date];
    
    NSDateFormatter *hackDateFormatter;
    [hackDateFormatter setDateFormat:@"LLL dd hh mm"];
    NSDate *hackDate = [hackDateFormatter dateFromString:@"Oct 06 07 00"];
    
    NSTimeInterval *difference = [hackDate timeIntervalSinceDate:now];
    
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"h:mm:ss a"; 
    }
    
    
    timerLabel.text = [NSString stringWithFormat:@"%f", difference];
}

@end
