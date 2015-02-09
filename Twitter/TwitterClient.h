//
//  TwitterClient.h
//  Twitter
//
//  Created by Bishwajit Aich. on 2/8/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient*)sharedInstance;

- (void)loginWithCompletion:(void (^)(User* user, NSError* error))completion;
- (void)openURL:(NSURL*) url;
- (void)homeTimelineWithParams:(NSDictionary *) params completion:(void (^)(NSArray *tweets, NSError *error))completion;
- (void)postTweetWithParams:(NSDictionary* ) params completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)retweetWithParams:(NSString* ) tweet_id completion:(void (^)(Tweet *tweet, NSError *error))completion;
- (void)favoriteWithParams:(NSDictionary* ) params completion:(void (^)(Tweet *tweet, NSError *error))completion;

@end
