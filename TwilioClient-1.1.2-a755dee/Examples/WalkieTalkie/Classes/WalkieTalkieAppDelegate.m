//
//  Copyright 2011 Twilio. All rights reserved.
//
 
#import "WalkieTalkieAppDelegate.h"
#import "WalkieTalkieViewController.h"
#import "WalkieTalkie.h"

@implementation WalkieTalkieAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize phone = _phone;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Set the view controller as the window's root view controller and display.
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
	
	self.phone = [[[WalkieTalkie alloc] init] autorelease];
	
	_viewController.walkieTalkie = self.phone;

    return YES;
}


#pragma mark -
#pragma mark UIApplication 

-(BOOL)isMultitaskingOS
{
	//Check to see if device's OS supports multitasking
	BOOL backgroundSupported = NO;
	UIDevice *currentDevice = [UIDevice currentDevice];
	if ([currentDevice respondsToSelector:@selector(isMultitaskingSupported)])
	{
		backgroundSupported = currentDevice.multitaskingSupported;
	}
	
	return backgroundSupported;
}

-(BOOL)isForeground
{
	//Check to see if app is currently in foreground
	if (![self isMultitaskingOS])
	{
		return YES;
	}
	
	UIApplicationState state = [UIApplication sharedApplication].applicationState;
	return (state==UIApplicationStateActive);
}

#pragma mark -
#pragma mark Memory management


- (void)dealloc {
    [_viewController release];
	[_window release];
	
	[_phone release];

    [super dealloc];
}



@end
