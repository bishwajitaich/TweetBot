//
//  UserTimelineViewController.h
//  Twitter
//
//  Created by Bishwajit Aich. on 2/16/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "User.h"

@interface UserTimelineViewController : UIViewController

@property (nonatomic, assign) Tweet* tweet;
@property (nonatomic, assign) User* user;

@end
