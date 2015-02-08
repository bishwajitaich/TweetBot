//
//  LoginViewController.m
//  Twitter
//
//  Created by Bishwajit Aich. on 2/8/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"

@interface LoginViewController ()
- (IBAction)onLogin:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
    [[TwitterClient sharedInstance]loginWithCompletion:^(User *user, NSError *error) {
        if (user != nil) {
            NSLog(@"username: %@", user.username);
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}
@end
