//
//  Copyright 2011 Twilio. All rights reserved.
//
 
#import "ConferencePhoneViewController.h"
#import "ConferencePhoneNotifications.h"

@interface ConferencePhoneViewController ()

-(void)syncButtons;
-(void)addStatusMessage:(NSString *)statusMessage;

-(void)loginDidStart:(NSNotification*)notification;
-(void)loginDidFinish:(NSNotification*)notification;
-(void)loginDidFailWithError:(NSNotification*)notification;
-(void)conferenceConnectionIsConnecting:(NSNotification*)notification;
-(void)conferenceConnectionDidConnect:(NSNotification*)notification;
-(void)conferenceConnectionDidFailToConnect:(NSNotification*)notification;
-(void)conferenceConnectionIsDisconnecting:(NSNotification*)notification;
-(void)conferenceConnectionDidDisconnect:(NSNotification*)notification;
-(void)conferenceConnectionDidFailWithError:(NSNotification*)notification;
-(void)dialingPartipants:(NSNotification*)notification;
-(void)dialingPartipantsFailedWithError:(NSNotification*)notification;

@end

@implementation ConferencePhoneViewController

@synthesize addCallsButton = _addCallsButton;
@synthesize dialButton = _dialButton;
@synthesize hangupButton = _hangupButton;
@synthesize textView = _textView;
@synthesize conferenceNameTextField = _conferenceNameTextField;
@synthesize conferencePhone = _conferencePhone;
@synthesize addCallsViewController = _addCallsViewController;

#pragma mark -
#pragma mark Application behavior

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Limit to portrait for simplicity
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(loginDidStart:)
												 name:CPLoginDidStart
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(loginDidFinish:)
												 name:CPLoginDidFinish
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(loginDidFailWithError:)
												 name:CPLoginDidFailWithError
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(conferenceConnectionIsConnecting:)
												 name:CPConferenceConnectionIsConnecting
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(conferenceConnectionDidConnect:)
												 name:CPConferenceConnectionDidConnect
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(conferenceConnectionDidFailToConnect:)
												 name:CPConferenceConnectionDidFailToConnect
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(conferenceConnectionIsDisconnecting:)
												 name:CPConferenceConnectionIsDisconnecting
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(conferenceConnectionDidDisconnect:)
												 name:CPConferenceConnectionDidDisconnect
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(conferenceConnectionDidFailWithError:)
												 name:CPConferenceConnectionDidFailWithError
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(dialingPartipants:)
												 name:CPDialingParticipants
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(dialingPartipantsFailedWithError:)
												 name:CPDialingParticipantsFailedWithError
											   object:nil];
}

- (void)viewDidUnload
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	self.addCallsButton = nil;
	self.conferenceNameTextField = nil;
	self.dialButton = nil;
	self.hangupButton = nil;
	self.textView = nil;
	
	[super viewDidUnload];
}

#pragma mark -
#pragma mark Button Actions 

-(IBAction)dialButtonPressed:(id)sender
{
	if (!_conferencePhone.connection || 
		_conferencePhone.connection.state == TCConnectionStateDisconnected)
	{
		//Connection state is closed or there's no connection,
		//so create a conference
		NSString* message = [NSString stringWithFormat:@"-Connecting to conference \"%@\"", 
														self.conferenceNameTextField.text];
		[self addStatusMessage:message];
		
		[_conferencePhone connect:self.conferenceNameTextField.text];
	}
}

-(IBAction)hangupButtonPressed:(id)sender
{
	if (_conferencePhone.connection)
	{
		//A connection existed, so disconnect phone
		[_conferencePhone disconnect];
	}
}

-(IBAction)addCallPressed:(id)sender
{
	//Action for "+" bar button
	if (_addCallsViewController==nil)
	{
		AddCallsViewController *acv = [[AddCallsViewController alloc] initWithNibName:@"AddCalls" bundle:[NSBundle mainBundle]];
		self.addCallsViewController = acv;
		[acv release];
	}
	[self presentModalViewController:self.addCallsViewController animated:YES];
	
}

#pragma mark -
#pragma mark Update UI

-(void)loginDidStart:(NSNotification*)notification
{
	[self addStatusMessage:@"-Logging in..."];		
	[self syncButtons];
}

-(void)loginDidFinish:(NSNotification*)notification
{
	NSNumber* hasOutgoing = [self.conferencePhone.device.capabilities objectForKey:TCDeviceCapabilityOutgoingKey];
	if ( [hasOutgoing boolValue] == YES )
	{
		[self addStatusMessage:@"-Phone ready to dial"];		
	}
	else
	{
		[self addStatusMessage:@"-Unable to make outgoing calls with current capabilities"];
	}
	[self syncButtons];
}

-(void)loginDidFailWithError:(NSNotification*)notification
{
	NSError* error = [[notification userInfo] objectForKey:@"error"];
	if ( error )
	{
		NSString* message = [NSString stringWithFormat:@"-Error logging in: %@ (%d)",
							 [error localizedDescription],
							 [error code]];
		[self addStatusMessage:message];		
	}
	else
	{
		[self addStatusMessage:@"-Unknown error logging in"];		
	}
	[self syncButtons];
}

-(void)conferenceConnectionIsConnecting:(NSNotification*)notification
{
	//Connection attempting to connect. Update the textview
	[self addStatusMessage:@"-Attempting to connect"];
	[self syncButtons];
}

-(void)conferenceConnectionDidConnect:(NSNotification*)notification
{
	//If text field keyboard is showing, resign first responder
	[self.conferenceNameTextField performSelectorOnMainThread:@selector(resignFirstResponder) withObject:nil waitUntilDone:NO];
	
	//Update the text view and the state of the button
	[self addStatusMessage:@"-Connection did connect"];
	[self syncButtons];
}

-(void)conferenceConnectionIsDisconnecting:(NSNotification*)notification
{
	[self addStatusMessage:@"-Attempting to disconnect"];
}

-(void)conferenceConnectionDidDisconnect:(NSNotification*)notification
{
	//Update the text view and the state of the button
	[self addStatusMessage:@"-Connection did disconnect"];
	[self syncButtons];
}

-(void)conferenceConnectionDidFailToConnect:(NSNotification*)notification
{
	[self addStatusMessage:@"-Couldn't establish outgoing call to conference"];
	[self syncButtons];
}

-(void)conferenceConnectionDidFailWithError:(NSNotification*)notification
{
	NSError* error = [[notification userInfo] objectForKey:@"error"];
	[self addStatusMessage:[NSString stringWithFormat:@"Conference connection did fail with error: %@", [error localizedDescription]]];
	[self syncButtons];
}

-(void)dialingPartipants:(NSNotification*)notification
{
	[self addStatusMessage:@"-Dialing conference participants..."];
}

-(void)dialingPartipantsFailedWithError:(NSNotification*)notification
{
	NSError* error = [[notification userInfo] objectForKey:@"error"];
	if ( error )
	{
		NSString* message = [NSString stringWithFormat:@"-Error dialing participants: %@ (%d)",
											 [error localizedDescription],
											 [error code]];
		[self addStatusMessage:message];		
	}
	else
	{
		[self addStatusMessage:@"-Unknown error dialing participants"];		
	}
	[self syncButtons];
}

-(void)syncButtons
{
	if ( ![NSThread isMainThread] )
	{
		[self performSelectorOnMainThread:@selector(syncButtons) withObject:nil waitUntilDone:NO];
		return;
	}
	
	//Update main button image according to current connection
	if (_conferencePhone.connection)
	{
		if (_conferencePhone.connection.state == TCConnectionStateDisconnected)
		{
			//Connection is disconnected
			
			//Diable add calls button
			[self.addCallsButton setEnabled:NO];
			
			//Enable dial button, disable hangup button
			[self.dialButton setEnabled:YES];
			[self.hangupButton setEnabled:NO];
			
		}
		else
		{
			//Connection is not disconnected
			
			//Enable add calls button
			[self.addCallsButton setEnabled:YES];
			
			//Enable hangup button, disable dial button
			[self.dialButton setEnabled:NO];
			[self.hangupButton setEnabled:YES];
		}
	}
	else
	{
		//A connection did not exist
		
		//Disable add calls button
		[self.addCallsButton setEnabled:NO];
		
		//Enable dial button, disable hangup button
		[self.dialButton setEnabled:YES];
		[self.hangupButton setEnabled:NO];
	}
}

-(void)addStatusMessage:(NSString*)statusMessage
{
	if ( ![NSThread isMainThread] )
	{
		[self performSelectorOnMainThread:@selector(addStatusMessage:) withObject:statusMessage waitUntilDone:NO];
		return;
	}
	
	//Update the text view to tell the user what the phone is doing
	self.textView.text = [self.textView.text stringByAppendingFormat:@"\n%@",statusMessage];
	
	//Scroll textview automatically for readability
	[self.textView scrollRangeToVisible:NSMakeRange([self.textView.text length], 0)];
}

#pragma mark -
#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc 
{
	[_addCallsViewController release];
	
	[_conferencePhone release];
	
	[_addCallsButton release];
	[_dialButton release];
	[_hangupButton release];
	[_textView release];
	[_conferenceNameTextField release];
	
    [super dealloc];
}

@end
