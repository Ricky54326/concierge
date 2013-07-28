//
//  ViewController.h
//  Concierge
//
//  Created by Katie Siegel on 7/27/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    IBOutlet UILabel *timerLabel;
    NSDate *hackDate;
    IBOutlet UIButton *chatButton;
    IBOutlet UIButton *comeHitherButton;
    IBOutlet UIButton *mentorButton;
    IBOutlet UIButton *scheduleButton;
}

-(IBAction)talkButtonPressed:(id)sender;
-(IBAction)comeHitherButtonPressed:(id)sender;
-(IBAction)mentorButtonPressed:(id)sender;
-(IBAction)scheduleButtonPressed:(id)sender;

@end
