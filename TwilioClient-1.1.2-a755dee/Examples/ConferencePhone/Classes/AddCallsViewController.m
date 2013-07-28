//
//  Copyright 2011 Twilio. All rights reserved.
//
 
#import "AddCallsViewController.h"
#import <AddressBook/AddressBook.h>
#import "ConferencePhoneAppDelegate.h"
#import "ConferencePhone.h"
#import "Participant.h"


@interface AddCallsViewController () // private methods

// utility methods
-(void)addParticipantFromString:(NSString*)participantString;
-(BOOL)stringIsPhoneNumber:(NSString*)string;
-(NSString*)formatString:(NSString*)string;

@end


@implementation AddCallsViewController

@synthesize callButton = _callButton;
@synthesize addedParticipantsTableView = _addedParticipantsTableView;
@synthesize participantTextField = _participantTextField;
@synthesize participants = _participants;

static NSCharacterSet* sPhoneNumberCharSet = nil;
static NSCharacterSet* sNonPhoneNumberCharsToRemove = nil;


#pragma mark -
#pragma mark Application behavior

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Limit to portrait for simplicity
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewDidLoad
{
	if ( !self.participants )
	{
		//Initalize phone numbers array
		self.participants = [NSMutableArray array]; // autoreleased, retained by property definition
	}
	
	if ( !sPhoneNumberCharSet )
		sPhoneNumberCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789-() "] retain];
	if ( !sNonPhoneNumberCharsToRemove )
		sNonPhoneNumberCharsToRemove = [[[NSCharacterSet alphanumericCharacterSet] invertedSet] retain];
		
	self.addedParticipantsTableView.dataSource = self;
	[self.addedParticipantsTableView reloadData];
}

- (void)viewDidUnload 
{
	self.addedParticipantsTableView = nil;
	self.participantTextField = nil;
	
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated
{
	//Make keyboard visible
	[self.participantTextField becomeFirstResponder];
	
	// Enable the call button if there are users in the list
	[_callButton setEnabled:[_participants count] > 0];
	
	[super viewDidAppear:animated];
}

#pragma mark -
#pragma mark UITableView delegate

- (NSInteger)tableView:(UITableView* )tableView numberOfRowsInSection:(NSInteger)section 
{
	//Number of rows in the table should be the amount of participants in array
	return [_participants count];
}

//RootViewController.m
- (UITableViewCell* )tableView:(UITableView* )tableView cellForRowAtIndexPath:(NSIndexPath* )indexPath 
{
	//Set up the UITableViewCell
	
	static NSString* CellIdentifier = @"Cell";
	
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	// Set up the cell
	Participant* participant = [_participants objectAtIndex:indexPath.row];
	cell.textLabel.text = participant.contactString;
	
	//Assign each cell with either "Phone Number" or "Client Name" as detail text
	//as appropriate
	NSString* cellDetailText;
	if (participant.type == eParticipantType_PhoneNumber)
		cellDetailText = @"Phone Number";
	else
		cellDetailText = @"Client Name";
	
	cell.detailTextLabel.text = cellDetailText;
	
	return cell;
}

-(void)tableView:(UITableView*)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath*)indexPath
{
	//UITableView is being edited, remove object at indexPath row
	[_participants removeObjectAtIndex:indexPath.row];
	[_addedParticipantsTableView reloadData];
}

#pragma mark -
#pragma mark People Picker delegate

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController* )peoplePicker
{
	//Dismiss the People Picker from the View
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController* )peoplePicker 
	  shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
	//A contact was selected, get information of that contact
		
	//Get the phone number of the selected contact
	ABMultiValueRef multiRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
	NSString* phoneNumber = (NSString*)ABMultiValueCopyValueAtIndex(multiRef, 0);
	
	[self addParticipantFromString:phoneNumber];
	
	//Enable call button if not already enabled
	[_callButton setEnabled:YES];
	
	//Reload table view
	[_addedParticipantsTableView reloadData];
	
	//Dismiss view
	[self dismissModalViewControllerAnimated:YES];
	
	return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController* )peoplePicker 
	  shouldContinueAfterSelectingPerson:(ABRecordRef)person 
								property:(ABPropertyID)property 
							  identifier:(ABMultiValueIdentifier)identifier
{
	return NO;
}

#pragma mark -
#pragma mark Button Actions 

-(IBAction)contactsButtonPressed:(id)sender
{
	// Create and show the People Picker view
	ABPeoplePickerNavigationController* picker = [[ABPeoplePickerNavigationController alloc] init];

	picker.peoplePickerDelegate = self;
	
	[self presentModalViewController:picker animated:YES];
	
	[picker release];
}

-(IBAction)cancelButtonPressed:(id)sender
{
	//Cancel bar button item pressed
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)callButtonPressed:(id)sender
{
	//Call button pressed
	ConferencePhoneAppDelegate* delegate = (ConferencePhoneAppDelegate*)[UIApplication sharedApplication].delegate;
	ConferencePhone* conferencePhone = delegate.phone;
	
	//Call selected participants
	[conferencePhone performCalls:_participants];
	
	[self dismissModalViewControllerAnimated:YES];
	
}

#pragma mark -
#pragma mark Utility Methods

-(void)addParticipantFromString:(NSString *)participantString
{
	// Figure out if the participant is a phone number or a client string,
	// and create a Participant object of the appropriate type.
	Participant* participant = [[Participant alloc] init];
	if ( [self stringIsPhoneNumber:participantString] )
	{
		participant.contactString = [self formatString:participantString];
		participant.type = eParticipantType_PhoneNumber;
	}
	else
	{
		participant.contactString = participantString;
		participant.type = eParticipantType_Client;
	}
	[_participants addObject:participant];
	[participant release];
}

-(BOOL)stringIsPhoneNumber:(NSString*)string
{
	//Returns YES if the trimmed string is empty, meaning all characters inside string were numbers, dashes or parentheses
	return [[string stringByTrimmingCharactersInSet:sPhoneNumberCharSet] isEqualToString:@""];
}

-(NSString*)formatString:(NSString*)string
{
	NSString* formattedString;
	
	if (![self stringIsPhoneNumber:string])
	{
		//If string is not a phone number, return original string
		return string;
	}
	
	formattedString =
		[[string componentsSeparatedByCharactersInSet:sNonPhoneNumberCharsToRemove]
			componentsJoinedByString:@""];
	
	return formattedString;
}


#pragma mark -
#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField* )textField
{
	if ([textField.text isEqualToString:@""])
	{
		//The text field is empty, alert user
		UIAlertView* stringEmptyAlert = [[[UIAlertView alloc] initWithTitle:@"Text Field Is Empty" message:nil 
																  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil] 
										 autorelease];
		
		[stringEmptyAlert show];
		return NO;
	}
	else 
	{
		//The text field is not empty
		
		//Add string from textField to participant array
		NSString* participantString = textField.text;
		[self addParticipantFromString:participantString];
		
		//Enable call button if not already enabled
		[_callButton setEnabled:YES];
		
		//Reload table view
		[_addedParticipantsTableView reloadData];
		
		//Clear text field
		textField.text = @"";
		return YES;
	}
}

#pragma mark -
#pragma mark Memory management


- (void)dealloc 
{
	[_callButton release];
	[_addedParticipantsTableView release];
	[_participantTextField release];
	
	[_participants release];
	
    [super dealloc];
}


@end
