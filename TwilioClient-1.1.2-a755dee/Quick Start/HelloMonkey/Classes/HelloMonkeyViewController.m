//
//  Copyright 2011 Twilio. All rights reserved.
//
 
#import "HelloMonkeyViewController.h"

@implementation HelloMonkeyViewController

@synthesize dialButton = _dialButton;
@synthesize hangupButton = _hangupButton;
@synthesize numberField = _numberField;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Limit to portrait for simplicity.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)viewDidUnload
{
	self.dialButton = nil;
	self.hangupButton = nil;
	self.numberField = nil;

	[super viewDidUnload];
}


-(IBAction)dialButtonPressed:(id)sender
{
}


-(IBAction)hangupButtonPressed:(id)sender
{
}


@end
