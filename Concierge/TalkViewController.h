//
//  TalkViewController.h
//  Concierge
//
//  Created by Katie Siegel on 7/27/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate>	{
	IBOutlet UITextField* messageText;
	IBOutlet UIButton* sendButton;
	IBOutlet UITableView* messageList;
	int lastId;
	
	NSMutableData *receivedData;
	
	NSMutableArray *messages;
	
	NSTimer *timer;
	
	NSXMLParser *chatParser;
	NSString *msgAdded;
	NSMutableString *msgUser;
	NSMutableString *msgText;
	int msgId;
	Boolean inText;
	Boolean inUser;
}

<<<<<<< HEAD
@property (nonatomic,retain) UITextField* messageText;
@property (nonatomic,retain) UIButton* sendButton;
@property (nonatomic,retain) UITableView* messageList;
=======

@property (nonatomic,retain) UITextField *messageText;
@property (nonatomic,retain) UIButton *sendButton;
@property (nonatomic,retain) UITableView *messageList;
>>>>>>> 511bce2031532a0b8cd2454fb5a1d7f9e3a4b3b5

- (IBAction)sendClicked:(id)sender;

@end

