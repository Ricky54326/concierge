//
//  AppDelegate.m
//  Concierge
//
//  Created by Katie Siegel on 7/27/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import "AppDelegate.h"
#import "OpeningViewController.h"
#import "ViewController.h"
#import <Parse/Parse.h>

#import "Person.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"inSNvmINeKuPwKQ9k9XyS9YCAQ2TKSAqZ6b3BSgu"
                  clientKey:@"HJzdZLrVznQ16DBHWHucqo6zLSdzEvLStXqFcQFp"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.viewController = [[OpeningViewController alloc] initWithNibName:@"OpeningViewController" bundle:nil];
    self.viewController = [[UINavigationController alloc] initWithRootViewController:self.viewController];

    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    // TODO testing code here
    Person *person = [[Person alloc] initWithType:@"hacker" andName:@"Kiran" andTeam:@"asdf"];
    [person addJob:@"eat"];
    [person setName:@"notKiran"];
    [person setType:@"leader"];
    // TODO end testing code here
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
