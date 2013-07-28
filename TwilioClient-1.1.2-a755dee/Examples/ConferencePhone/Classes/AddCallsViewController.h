//
//  Copyright 2011 Twilio. All rights reserved.
//
 
#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface AddCallsViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,ABPeoplePickerNavigationControllerDelegate> 
{
	UIBarButtonItem *_callButton;
	UITableView *_addedParticipantsTableView;
	UITextField *_participantTextField;
@private
	NSMutableArray *_participants; // NSArray of Participants
}

@property (nonatomic,retain) IBOutlet UIBarButtonItem *callButton;
@property (nonatomic,retain) IBOutlet UITableView *addedParticipantsTableView;
@property (nonatomic,retain) IBOutlet UITextField *participantTextField;
@property (nonatomic,retain) NSMutableArray *participants;

//Button Actions
-(IBAction)contactsButtonPressed:(id)sender;
-(IBAction)cancelButtonPressed:(id)sender;
-(IBAction)callButtonPressed:(id)sender;

@end
