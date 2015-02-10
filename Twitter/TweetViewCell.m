//
//  TweetViewCell.m
//  Twitter
//
//  Created by Bishwajit Aich. on 2/8/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import "TweetViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "ComposeViewController.h"
#import "TweetViewController.h"

@interface TweetViewCell()
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tweetThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *tweetName;
@property (weak, nonatomic) IBOutlet UILabel *tweetUsername;
@property (weak, nonatomic) IBOutlet UILabel *tweetCreatedOn;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
- (IBAction)onReply:(id)sender;
- (IBAction)onRetweet:(id)sender;
- (IBAction)onFavorite:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;

@end

@implementation TweetViewCell

- (void)awakeFromNib {
    // Initialization code
    self.retweetLabel.hidden = YES;
    self.tweetThumbnail.layer.cornerRadius = 3;
    self.tweetThumbnail.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    NSString* profileImage = tweet.user.profileImageUrl;
    [self.tweetThumbnail setImageWithURL:[NSURL URLWithString:profileImage]];
    self.tweetName.text = tweet.user.name;
    self.tweetUsername.text = [NSString stringWithFormat:@"@%@",tweet.user.username];
    self.tweetCreatedOn.text = tweet.created_at;
    self.tweetText.text = tweet.tweet;
    
    self.retweetLabel.hidden = YES;
    self.favoriteCount.hidden = YES;
    self.retweetCount.hidden = YES;
    
    if (tweet.retweetUser.name) {
        self.retweetLabel.text = [NSString stringWithFormat:@"%@ retweeted", tweet.retweetUser.name];
        self.retweetLabel.hidden = NO;
    }
    
    if (tweet.retweet_count > 0) {
        self.retweetCount.text = [NSString stringWithFormat:@"%ld", tweet.retweet_count];
        self.retweetCount.hidden = NO;
    }
    
    if (tweet.favorited_count > 0) {
        self.favoriteCount.text = [NSString stringWithFormat:@"%ld", tweet.favorited_count];
        self.favoriteCount.hidden = NO;
    }
    
    if (self.tweet.retweeted) {
        [self.retweetButton setBackgroundImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
    } else {
        [self.retweetButton setBackgroundImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
    }
    
    if (self.tweet.favorited) {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
    }
}

- (IBAction)onReply:(id)sender {
    NSArray* user_mentions = self.tweet.user_mentions;
    NSMutableArray *screenNames = [NSMutableArray array];
    /*
     if retweet_user 
     append retweetuser.username
     else 
     append user.username
     
     */
    if (self.tweet.retweetUser.name) {
        [screenNames addObject:[NSString stringWithFormat:@"@%@", self.tweet.retweetUser.username]];
    } else {
        [screenNames addObject:[NSString stringWithFormat:@"@%@", self.tweet.user.username]];
    }
    
    for(NSDictionary *mention in user_mentions) {
        [screenNames addObject:[NSString stringWithFormat:@"@%@", mention[@"screen_name"]]];
    }
    
    ComposeViewController *vc = [[ComposeViewController alloc]init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    vc.in_reply_to_status_id = self.tweet.id_str;
    vc.prependMentions = [screenNames componentsJoinedByString:@" "];
    
    UITableView *tv = (UITableView *) self.superview.superview;
    TweetViewController *tvc = (TweetViewController *) tv.dataSource;
    
    [tvc presentViewController:nvc animated:YES completion:nil];
}

- (IBAction)onRetweet:(id)sender {
    [[TwitterClient sharedInstance]retweetWithParams:self.tweet.id_str completion:^(Tweet *tweet, NSError *error) {
        if (error == nil) {
            self.tweet = tweet;
        }
    }];
}

- (IBAction)onFavorite:(id)sender {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.tweet.id_str, @"id", nil];
    [[TwitterClient sharedInstance]favoriteWithParams:params completion:^(Tweet *tweet, NSError *error) {
        if (error == nil) {
            self.tweet = tweet;
        }
    }];
}
@end
