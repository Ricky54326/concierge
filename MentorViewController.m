//
//  MentorViewController.m
//  Concierge
//
//  Created by Katie Siegel on 7/27/13.
//  Copyright (c) 2013 Katie Siegel. All rights reserved.
//

#import "MentorViewController.h"
#import <Parse/Parse.h>

@interface MentorViewController ()

@end

@implementation MentorViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.titles = @[@"blah1",@"blah2"];
    //self.titles = [[NSMutableArray alloc] initWithObjects:@"blah1",@"blah2", nil];
    self.titles = [[NSMutableArray alloc] init];
    
    [self.titles addObject:@"Event Organizers"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"sponsors"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", [object objectForKey:@"name"]);
                [self.titles addObject:[object objectForKey:@"name"]];
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"fdjsafghaf");
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return 0;
    //will end up dividing more
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    }
    
    cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Contact %@?",[tableView cellForRowAtIndexPath:indexPath].textLabel.text]
                                                    message: @"\n\n"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Send Message",nil];
    UITextField* phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 15.0, 245.0, 25.0)];
    phoneNumberTextField.delegate=self;
    [phoneNumberTextField setBackgroundColor:[UIColor whiteColor]];
    [phoneNumberTextField setKeyboardType:UIKeyboardTypeDefault];
    phoneNumberTextField.placeholder=@"Phone Number";
    phoneNumberTextField.secureTextEntry=NO;
    [alert addSubview:phoneNumberTextField];
    
    UITextField* messageField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
    messageField.delegate=self;
    [messageField setBackgroundColor:[UIColor whiteColor]];
    [messageField setKeyboardType:UIKeyboardTypeDefault];
    messageField.placeholder=@"Message";
    [alert addSubview:messageField];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        //NSString* phoneNumber = [alertView textFieldAtIndex:0];
        //NSString* message = [alertView textFieldAtIndex:1];
        NSLog(@"I should be running hello world");
        
        [PFCloud callFunctionInBackground:@"hello"
                           withParameters:@{}
                                    block:^(NSString *result, NSError *error) {
                                        if (!error) {
                                            // result is @"Hello world!"
                                            NSLog(@"done fucked up");
                                        }
                                    }];
    }
    NSLog(@"wahhhh");
}


@end
