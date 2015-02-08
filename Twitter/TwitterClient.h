//
//  TwitterClient.h
//  Twitter
//
//  Created by Bishwajit Aich. on 2/8/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient*)sharedInstance;

- (void)loginWithCompletion:(void (^)(User* user, NSError* error))completion;
- (void)openURL:(NSURL*) url;

@end
