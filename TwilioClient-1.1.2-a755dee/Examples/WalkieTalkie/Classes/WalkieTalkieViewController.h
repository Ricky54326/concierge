//
//  Copyright 2011 Twilio. All rights reserved.
//
 
#import <UIKit/UIKit.h>

@class WalkieTalkie;

@interface WalkieTalkieViewController : UIViewController<UIAlertViewDelegate>
{
	WalkieTalkie* _walkieTalkie;
	
	UIButton* _talkButton;
	UIButton* _hangupButton;
	UIButton* _dialButton;
	UITextField* _toTextField;
	UILabel* _statusLabel;
	UIAlertView* _alertView;
}
@property (nonatomic, retain) IBOutlet UIButton* talkButton;
@property (nonatomic, retain) IBOutlet UIButton* hangupButton;
@property (nonatomic, retain) IBOutlet UITextField* toTextField;
@property (nonatomic, retain) IBOutlet UILabel* statusLabel;
@property (nonatomic, retain) IBOutlet UIButton* dialButton;
@property (nonatomic, retain) WalkieTalkie* walkieTalkie;

//Button Actions
-(IBAction)talkButtonDown:(id)sender;
-(IBAction)talkButtonUp:(id)sender;
-(IBAction)hangupButtonPressed:(id)sender;
-(IBAction)dialButtonPressed:(id)sender;

// UI State
-(void)syncConnectionState;

//UITextFieldDelegate 
-(void)textFieldShouldReturn:(UITextField*)textField;

//UIAlertView
-(void)constructAlert;
-(void)cancelAlert;

@end

