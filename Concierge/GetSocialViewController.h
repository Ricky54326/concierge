//
//  GetSocialViewController.h
//  Concierge
//
//  Created by Kathryn Siegel on 8/22/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetSocialViewController : UIViewController {
    IBOutlet UIButton *piazzaButton;
    IBOutlet UIButton *fbButton;
    IBOutlet UIButton *twitterButton;
    IBOutlet UITableView *announceTable;
}

@property (nonatomic, strong) NSMutableArray *announcements;

- (IBAction) piazzaButtonClicked: (id)sender;
- (IBAction) fbButtonClicked: (id)sender;
- (IBAction) twitterButtonClicked: (id)sender;

@end
