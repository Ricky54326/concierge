//
//  Copyright 2011 Twilio. All rights reserved.
//
 
#import <UIKit/UIKit.h>

@class ConferencePhoneViewController;
@class ConferencePhone;
@interface ConferencePhoneAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *_window;
    ConferencePhoneViewController *_viewController;
	
	ConferencePhone *_phone;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ConferencePhoneViewController *viewController;
@property (nonatomic, retain) ConferencePhone *phone;
@end

