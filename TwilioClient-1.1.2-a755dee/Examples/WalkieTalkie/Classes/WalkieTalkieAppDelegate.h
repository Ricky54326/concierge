//
//  Copyright 2011 Twilio. All rights reserved.
//
 
#import <UIKit/UIKit.h>

@class WalkieTalkieViewController;
@class WalkieTalkie;

@interface WalkieTalkieAppDelegate : NSObject <UIApplicationDelegate> 
{
@private
    UIWindow* _window;
    WalkieTalkieViewController* _viewController;
	WalkieTalkie* _phone;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) IBOutlet WalkieTalkieViewController* viewController;
@property (nonatomic, retain) WalkieTalkie* phone;

// Returns NO if the app isn't in the foreground in a multitasking OS environment.
-(BOOL)isForeground;

@end

