//
//  HederViewController.m
//  Twitter
//
//  Created by Bishwajit Aich. on 2/16/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

/*
 
 @property (weak, nonatomic) IBOutlet UILabel *name;
 @property (weak, nonatomic) IBOutlet UILabel *twitterHandle;
 @property (weak, nonatomic) IBOutlet UILabel *numberTweets;
 @property (weak, nonatomic) IBOutlet UILabel *numberFollowing;
 @property (weak, nonatomic) IBOutlet UILabel *numberFollower;
 */

#import "HederViewController.h"
#import "UIImageView+AFNetworking.h"

@interface HederViewController ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *twitterHandle;
@property (weak, nonatomic) IBOutlet UILabel *numberTweets;
@property (weak, nonatomic) IBOutlet UILabel *numberFollower;
@property (weak, nonatomic) IBOutlet UILabel *numberFollowing;

@end

@implementation HederViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    User* user = self.user;
    self.name.text = user.name;
    self.twitterHandle.text = [NSString stringWithFormat:@"@%@", user.username];
    self.numberTweets.text = [NSString stringWithFormat:@"%ld", (long)user.tweetCount];
    self.numberFollower.text = [NSString stringWithFormat:@"%ld", (long)user.followerCount];
    self.numberFollowing.text = [NSString stringWithFormat:@"%ld", (long)user.followingCount];
    NSString *hqImageUrl = [user.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    [self.profileImage setImageWithURL:[NSURL URLWithString:hqImageUrl]];
    self.profileImage.layer.cornerRadius = 5;
    self.profileImage.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
