//
//  ChatViewController.m
//  ParseChat
//
//  Created by Henry Ching on 9/16/15.
//  Copyright © 2015 Henry Ching. All rights reserved.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "MessageTableViewCell.h"

@interface ChatViewController ()
@property (weak, nonatomic) IBOutlet UITextField *messageText;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (strong, atomic) NSArray *messageList;
- (void) onTimer;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self onTimer];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector: @selector(onTimer) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onSend:(id)sender {
    PFObject *message = [PFObject objectWithClassName:@"Message"];
    message[@"text"] = self.messageText.text;
    message[@"user"] = [PFUser currentUser];
    [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            NSLog(@"Message Sent!");
        } else {
            // There was a problem, check error.description
            NSLog(@"Message Error");
        }
    }];
}

- (void) onTimer {
    // Add code to be run periodically
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    //[query whereKey:@"playerName" equalTo:@"Dan Stemkoski"];
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            //for (PFObject *object in objects) {
            //NSLog(@"%@", object.objectId);
            //}
            dispatch_async(dispatch_get_main_queue(), ^{
                self.messageList = objects;
                [self.chatTableView reloadData];
            });
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageList.count;
}

- (MessageTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"com.yahoo.messagecell"];
    PFObject *messageObj = self.messageList[indexPath.row];
    PFUser *user = messageObj[@"user"];
    if(user.username.length > 0) {
        cell.messageLabel.text = [NSString stringWithFormat:@"<%@>: %@", user.username, messageObj[@"text"]];
    } else {
        cell.messageLabel.text = [NSString stringWithFormat:@"<unknown>: %@", messageObj[@"text"]];
    }
    return cell;
}



@end
