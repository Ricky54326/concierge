//
//  Twitter.h
//  Concierge
//
//  Created by Kiran Vodrahalli on 7/28/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface Twitter : NSObject
@property (nonatomic) ACAccountStore *accountStore;

- (id)init;
- (BOOL)userHasAccessToTwitter;
- (void)postTweet: (NSString *)status andPhoto: ( UIImage*)image;


@end
