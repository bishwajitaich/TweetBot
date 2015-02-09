//
//  ComposeViewController.h
//  Twitter
//
//  Created by Bishwajit Aich. on 2/8/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol ComposeViewControllerDelegate <NSObject>

- (void)didPostTweet:(Tweet *) tweet;

@end

@interface ComposeViewController : UIViewController

@property (weak, nonatomic) id<ComposeViewControllerDelegate> delegate;

@end
