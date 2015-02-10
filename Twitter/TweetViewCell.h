//
//  TweetViewCell.h
//  Twitter
//
//  Created by Bishwajit Aich. on 2/8/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol TweetViewCellDelegate <NSObject>

- (void)didUpdateCell:(UITableViewCell *) cell withTweet:(Tweet*)tweet;

@end

@interface TweetViewCell : UITableViewCell

@property (nonatomic, assign) Tweet* tweet;
@property (weak, nonatomic) id<TweetViewCellDelegate> delegate;

@end
