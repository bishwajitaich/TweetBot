//
//  TweetDetailViewController.m
//  Twitter
//
//  Created by Bishwajit Aich. on 2/9/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "ComposeViewController.h"

@interface TweetDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *tweetThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *tweetName;
@property (weak, nonatomic) IBOutlet UILabel *tweetUserName;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
- (IBAction)onReply:(id)sender;
- (IBAction)onRetweet:(id)sender;
- (IBAction)onFavorite:(id)sender;

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[TwitterClient sharedInstance]getTweetWithId:self.tweet.id_str completion:^(Tweet *tweet, NSError *error) {
        if (error == nil) {
            self.tweet = tweet;
            [self renderTweet];
        }
    }];
    self.tweetThumbnail.layer.cornerRadius = 3;
    self.tweetThumbnail.clipsToBounds = YES;
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

- (void)renderTweet {
    Tweet* tweet = self.tweet;
    NSString* profileImage = tweet.user.profileImageUrl;
    [self.tweetThumbnail setImageWithURL:[NSURL URLWithString:profileImage]];
    self.tweetName.text = tweet.user.name;
    self.tweetUserName.text = [NSString stringWithFormat:@"@%@",tweet.user.username];
    self.tweetText.text = tweet.tweet;
    
    self.favoriteCount.hidden = YES;
    self.retweetCount.hidden = YES;
    
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
    
    [self presentViewController:nvc animated:YES completion:nil];
}

- (IBAction)onRetweet:(id)sender {
    [[TwitterClient sharedInstance]retweetWithParams:self.tweet.id_str completion:^(Tweet *tweet, NSError *error) {
        if (error == nil) {
            self.tweet = tweet;
            [self renderTweet];
            [self.delegate didUpdateTweet:tweet atIndexPath:self.tweetIndex];
            
            NSLog(@"Retweet %@", tweet);
        }
    }];
}

- (IBAction)onFavorite:(id)sender {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.tweet.id_str, @"id", nil];
    if (self.tweet.favorited) {
        [[TwitterClient sharedInstance]unfavoriteWithParams:params completion:^(Tweet *tweet, NSError *error) {
            if (error == nil) {
                self.tweet = tweet;
                [self renderTweet];
                [self.delegate didUpdateTweet:tweet atIndexPath:self.tweetIndex];
            }
        }];
    } else {
        [[TwitterClient sharedInstance]favoriteWithParams:params completion:^(Tweet *tweet, NSError *error) {
            if (error == nil) {
                self.tweet = tweet;
                [self renderTweet];
                [self.delegate didUpdateTweet:tweet atIndexPath:self.tweetIndex];
            }
        }];
    }
}
@end
