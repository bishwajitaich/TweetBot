//
//  TweetDetailViewController.h
//  Twitter
//
//  Created by Bishwajit Aich. on 2/9/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol TweetDetailViewControllerDelegate <NSObject>

- (void)didUpdateTweet:(Tweet*)tweet atIndexPath:(NSInteger)row;

@end

@interface TweetDetailViewController : UIViewController

@property (nonatomic, strong) Tweet* tweet;
@property (nonatomic, assign) NSInteger tweetIndex;
@property (weak, nonatomic) id<TweetDetailViewControllerDelegate> delegate;

@end
