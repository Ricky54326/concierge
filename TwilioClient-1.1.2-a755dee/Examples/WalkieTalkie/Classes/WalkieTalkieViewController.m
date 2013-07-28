//
//  Copyright 2011 Twilio. All rights reserved.
//
 
#import "WalkieTalkieViewController.h"
#import "WalkieTalkieAppDelegate.h"
#import "WalkieTalkie.h"
#import "WalkieTalkieNotifications.h"

// key for NSUserDefaults to retain the last used client name to popuplate
// the "Enter client name" text field on each launch.
#define kWalkieTalkieLastOutgoingClientName @"WalkieTalkieLastOutgoingClientName"


@interface WalkieTalkieViewController () // Internal methods that don't get exposed.

-(void)syncMutedState;

// notifications
-(void)connectionDidConnect:(NSNotification*)notification;
-(void)connectionDidDisconnect:(NSNotification*)notification;
-(void)connectionDidFailWithError:(NSNotification*)notification;
-(void)pendingIncomingConnectionDidDisconnect:(NSNotification*)notification;
-(void)pendingIncomingConnectionReceived:(NSNotification*)notification;

@end


@implementation WalkieTalkieViewController

@synthesize talkButton = _talkButton;
@synthesize hangupButton = _hangupButton;
@synthesize toTextField = _toTextField;
@synthesize statusLabel = _statusLabel;
@synthesize dialButton = _dialButton;
@synthesize walkieTalkie = _walkieTalkie;

#pragma mark -
#pragma mark Application behavior


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Limit to portrait for simplicity.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewDidLoad
{
	[super viewDidLoad];
	
	[self syncMutedState];
	[self syncConnectionState];
	
	NSString* lastClient = [[NSUserDefaults standardUserDefaults] objectForKey:kWalkieTalkieLastOutgoingClientName];
	if ( lastClient )
		self.toTextField.text = lastClient;
	
	// Register to receive notifications from the WalkieTalkie model controller
	// that something's occurred.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(connectionDidConnect:)
												 name:WTConnectionDidConnect
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(connectionDidDisconnect:)
												 name:WTConnectionDidDisconnect
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(connectionDidFailWithError:)
												 name:WTConnectionDidFailWithError
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(pendingIncomingConnectionDidDisconnect:)
												 name:WTPendingIncomingConnectionDidDisconnect
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(pendingIncomingConnectionReceived:)
												 name:WTPendingIncomingConnectionReceived
											   object:nil];
}

- (void)viewDidUnload 
{
	// Unregister this class from all notifications
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	self.talkButton = nil;
	self.hangupButton = nil;
	self.toTextField = nil;
	self.statusLabel = nil;
	self.dialButton = nil;
	
	[super viewDidUnload];
}


#pragma mark -
#pragma mark Button Actions

-(IBAction)talkButtonDown:(id)sender
{
	if (_walkieTalkie.connection.state != TCConnectionStateDisconnected)
	{
		// A connection exists and it is connected, so turn off mute
		// (Once the mute has been turned off, it will update the UI in audioPropertyChanged)
		_walkieTalkie.muted = NO;
	}
}

-(IBAction)talkButtonUp:(id)sender
{
	//Talk button released
	if (_walkieTalkie.connection.state != TCConnectionStateDisconnected)
	{
		//A connection exists and it is not disconnected, so turn on mute
		// (Once the mute has been turned on, it will update the UI in audioPropertyChanged)
		_walkieTalkie.muted = YES;
	}
}

-(IBAction)hangupButtonPressed:(id)sender
{
	[_walkieTalkie disconnect];
}

-(IBAction)dialButtonPressed:(id)sender
{
	//Dial button pressed

	// dismiss the keyboard which may be showing.
	[self.toTextField resignFirstResponder];
	
	// If a connection doesn't exist (or one exists but isn't connected),
	// dial out.  Don't do anything if an active connection already exists.
	if (_walkieTalkie.connection)
	{
		if (_walkieTalkie.connection.state == TCConnectionStateDisconnected)
		{
			//Connection state is closed, connect phone
			[_walkieTalkie connect:self.toTextField.text];
		}
	}	
	else
	{
		//A connection was not already established, so make one
		[_walkieTalkie connect:self.toTextField.text];
	}
	
	// save off the dialed client name to be pre-populated on launch
	[[NSUserDefaults standardUserDefaults] setObject:self.toTextField.text forKey:kWalkieTalkieLastOutgoingClientName];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark Notifications

-(BOOL)isForeground
{
	WalkieTalkieAppDelegate* appDelegate = (WalkieTalkieAppDelegate*)[UIApplication sharedApplication].delegate;
	return [appDelegate isForeground];
}

-(void)connectionDidConnect:(NSNotification*)notification
{
	[self performSelectorOnMainThread:@selector(syncConnectionState) withObject:nil waitUntilDone:NO];	
}

-(void)connectionDidDisconnect:(NSNotification*)notification
{
	[self performSelectorOnMainThread:@selector(syncConnectionState) withObject:nil waitUntilDone:NO];
}

-(void)connectionDidFailWithError:(NSNotification*)notification
{
	[self performSelectorOnMainThread:@selector(syncConnectionState) withObject:nil waitUntilDone:NO];
}

-(void)pendingIncomingConnectionReceived:(NSNotification*)notification
{
	//Show alert view asking if user wants to accept or ignore call
	[self performSelectorOnMainThread:@selector(constructAlert) withObject:nil waitUntilDone:NO];
	
	//Check for background support
	if ( ![self isForeground] )
	{
		//App is not in the foreground, so send LocalNotification
		UIApplication* app = [UIApplication sharedApplication];
		UILocalNotification* notification = [[UILocalNotification alloc] init];
		NSArray* oldNots = [app scheduledLocalNotifications];
		
		if ([oldNots count]>0)
		{
			[app cancelAllLocalNotifications];
		}
		
		notification.alertBody = @"Incoming Call";
		
		[app presentLocalNotificationNow:notification];
		[notification release];
	}
	
	//If text field is showing, resign to first responder
	[self.toTextField performSelectorOnMainThread:@selector(resignFirstResponder) withObject:nil waitUntilDone:NO];
}

-(void)pendingIncomingConnectionDidDisconnect:(NSNotification*)notification
{
	// Make sure to cancel any pending notifications/alerts
	[self performSelectorOnMainThread:@selector(cancelAlert) withObject:nil waitUntilDone:NO];
	if ( ![self isForeground] )
	{
		//App is not in the foreground, so kill the notification we posted.
		UIApplication* app = [UIApplication sharedApplication];
		[app cancelAllLocalNotifications];
	}
	
	[self performSelectorOnMainThread:@selector(syncConnectionState) withObject:nil waitUntilDone:NO];
}

#pragma mark -
#pragma mark Update UI

-(void)syncMutedState
{
	if (self.walkieTalkie.muted)
		[self.statusLabel setText:@"Press and Hold to Talk"];
	else
		[self.statusLabel setText:@"Talking..."];
}

-(void)syncConnectionState
{
	if ( self.walkieTalkie.connection.state == TCConnectionStateConnected )
	{
		// Enable talk and hangup buttons, disable dial button
		[self.talkButton setEnabled:YES];
		[self.hangupButton setEnabled:YES];
		[self.dialButton setEnabled:NO];
				
		// Update status label text
		[self.statusLabel setText:@"Press and hold to talk"];
	}
	else
	{
		// Disable talk and hangup button, enable dial button
		[self.talkButton setEnabled:NO];
		[self.hangupButton setEnabled:NO];
		[self.dialButton setEnabled:YES];
		
		//Update status label text
		[self.statusLabel setText:@"Not connected"];
	}
}

#pragma mark -
#pragma mark UITextField implementation

-(void)textFieldShouldReturn:(UITextField*)textField
{
	[textField resignFirstResponder];
	return;
}


#pragma mark -
#pragma mark UIAlertView

-(void)constructAlert
{
	_alertView = [[[UIAlertView alloc] initWithTitle:@"Incoming Call" 
														message:@"Accept or Ignore?"
													   delegate:self 
											  cancelButtonTitle:nil 
											  otherButtonTitles:@"Accept",@"Ignore",nil] autorelease];
	[_alertView show];
}

-(void)cancelAlert
{
	if ( _alertView )
	{
		[_alertView dismissWithClickedButtonIndex:1 animated:YES];
		_alertView = nil; // autoreleased
	}
}

#pragma mark -
#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex==0)
	{
		//Accept button pressed
		if (_walkieTalkie.connection)
		{
			//A connection already existed, so disconnect old connection and connect to current pending connection
			[_walkieTalkie disconnect];
			
			//Give the client time to reset itself, then accept connection
			[_walkieTalkie performSelector:@selector(acceptIncomingConnection) withObject:nil afterDelay:0.2];
		}
		else
		{
			//A connection did not already exist
			[_walkieTalkie acceptIncomingConnection];
		}
	}
	else
	{
		//Ignore button pressed
		[_walkieTalkie ignoreIncomingConnection];
	}
}

#pragma mark -
#pragma mark  Memory management

- (void)dealloc
{
	[_walkieTalkie release];
	[_talkButton release];
	[_hangupButton release];
	[_dialButton release];
	[_toTextField release];
	[_statusLabel release];
	[_alertView release];
	
    [super dealloc];
}

@end


