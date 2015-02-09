//
//  TweetViewCell.m
//  Twitter
//
//  Created by Bishwajit Aich. on 2/8/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import "TweetViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface TweetViewCell()
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tweetThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *tweetName;
@property (weak, nonatomic) IBOutlet UILabel *tweetUsername;
@property (weak, nonatomic) IBOutlet UILabel *tweetCreatedOn;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;

@end

@implementation TweetViewCell

- (void)awakeFromNib {
    // Initialization code
    self.retweetLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    NSString* profileImage = tweet.user.profileImageUrl;
    [self.tweetThumbnail setImageWithURL:[NSURL URLWithString:profileImage]];
    self.tweetName.text = tweet.user.name;
    self.tweetUsername.text = [NSString stringWithFormat:@"@%@",tweet.user.username];
    self.tweetCreatedOn.text = tweet.created_at;
    self.tweetText.text = tweet.tweet;
    
    if (tweet.retweetUser.name) {
        self.retweetLabel.text = [NSString stringWithFormat:@"%@ retweeted", tweet.retweetUser.name];
        self.retweetLabel.hidden = NO;
    } else {
        self.retweetLabel.hidden = YES;
    }
    
    [self.tweetText sizeToFit];
}

@end
