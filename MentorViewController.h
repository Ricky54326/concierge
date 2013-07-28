//
//  MentorViewController.h
//  Concierge
//
//  Created by Katie Siegel on 7/27/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MentorViewController : UITableViewController {
    UITextField* phoneNumberTextField;
    UITextField* messageField;
}

@property (nonatomic, strong) NSMutableArray *titles;

@end
