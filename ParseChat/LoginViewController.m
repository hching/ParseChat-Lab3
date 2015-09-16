//
//  LoginViewController.m
//  ParseChat
//
//  Created by Henry Ching on 9/16/15.
//  Copyright © 2015 Henry Ching. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *signinButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UILabel *loginFailedMessage;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)onSignIn:(id)sender {
    [PFUser logInWithUsernameInBackground:self.usernameText.text password:self.passwordText.text block:^(PFUser *user, NSError *error) {
        if (user) {
            // Do stuff after successful login.
            NSLog(@"Login Successful");
            self.loginFailedMessage.hidden = true;
            [self performSegueWithIdentifier:@"chatSegway" sender:self];
        } else {
            // The login failed. Check error to see why.
            NSLog(@"Login Failed");
            self.loginFailedMessage.hidden = false;
        }
    }];
}

- (IBAction)onSignUp:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.usernameText.text;
    user.password = self.passwordText.text;
    user.email = self.usernameText.text;
    
    // other fields can be set just like with PFObject
    user[@"phone"] = @"408-123-1234";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            NSLog(@"Sign Up Successful");
            self.loginFailedMessage.hidden = true;
            [self performSegueWithIdentifier:@"chatSegway" sender:self];
        } else {   NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
            NSLog(@"Sign Up Failed:");
            self.loginFailedMessage.text = @"Sign up failed!";
            self.loginFailedMessage.hidden = false;
        }
    }];
}


@end
