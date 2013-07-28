//
//  Copyright 2011 Twilio. All rights reserved.
//
 
#import <UIKit/UIKit.h>
#import "ConferencePhone.h"
#import "AddCallsViewController.h"

@interface ConferencePhoneViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate> 
{
	ConferencePhone *_conferencePhone;
	AddCallsViewController *_addCallsViewController;
	
	UIBarButtonItem *_addCallsButton;
	UIButton *_dialButton;
	UIButton *_hangupButton;
	UITextView *_textView;
	UITextField *_conferenceNameTextField;
}

@property (nonatomic,retain) IBOutlet UIBarButtonItem *addCallsButton;
@property (nonatomic,retain) IBOutlet UIButton *dialButton;
@property (nonatomic,retain) IBOutlet UIButton *hangupButton;
@property (nonatomic,retain) IBOutlet UITextView *textView;
@property (nonatomic,retain) IBOutlet UITextField *conferenceNameTextField;
@property (nonatomic,retain) ConferencePhone *conferencePhone;
@property (nonatomic,retain) AddCallsViewController *addCallsViewController;

//Button Actions
-(IBAction)dialButtonPressed:(id)sender;
-(IBAction)hangupButtonPressed:(id)sender;
-(IBAction)addCallPressed:(id)sender;

@end

