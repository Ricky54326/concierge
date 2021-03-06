//
//  ViewController.m
//  Concierge
//
//  Created by Katie Siegel on 7/27/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import "ViewController.h"
#import "TalkViewController.h"
#import "MentorViewController.h"
#import "ScheduleViewController.h"
#import "GetSocialViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController () {}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    hackDate = [NSDate dateWithTimeIntervalSinceNow:5728];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)talkButtonPressed:(id)sender {
    UIViewController *vc = [[MentorViewController alloc] initWithStyle: UITableViewStylePlain];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)comeHitherButtonPressed:(id)sender {
    UIViewController *vc = [[GetSocialViewController alloc] initWithNibName:nil bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)socialButtonPressed:(id)sender {
    UIViewController *vc = [[TalkViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)scheduleButtonPressed:(id)sender {
    UIViewController *vc = [[ScheduleViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)timerTick:(NSTimer *)timer {
    NSDate *now = [NSDate date];
    
    NSTimeInterval difference = [hackDate timeIntervalSinceDate:now];
    
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"h:mm:ss a"; 
    }
    NSString* s = [NSString stringWithFormat:@"%i",(int)difference % 60];
    NSString* m = [NSString stringWithFormat:@"%i",(int)difference/60%60];
    NSString* h = [NSString stringWithFormat:@"%i",(int)difference/3600];
    if (s.length == 1) {
        s = [NSString stringWithFormat:@"0%@",s];
    }
    if (m.length == 1) {
        m = [NSString stringWithFormat:@"0%@",m];
    }
    if (h.length == 1) {
        h = [NSString stringWithFormat:@"0%@",h];
    }
    
    timerLabel.text = [NSString stringWithFormat:@"%@:%@:%@", h, m, s];
}

@end
