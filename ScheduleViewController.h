//
//  ScheduleViewController.h
//  Concierge
//
//  Created by Katie Siegel on 7/27/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *startTimes;
@property (nonatomic, strong) NSMutableArray *endTimes;

@end
