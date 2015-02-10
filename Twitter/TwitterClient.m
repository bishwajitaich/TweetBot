//
//  TwitterClient.m
//  Twitter
//
//  Created by Bishwajit Aich. on 2/8/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"
#import "User.h"

NSString* const twitterConsumerKey = @"wZJSfb7AUsz90BKnXa87EqsXB";
NSString* const twitterSecretKey = @"zp8fOM586W0umd5VVaIad9XeWkqK46dBxZZZqNBcRFwwGNCSkc";
NSString* const baseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (strong, nonatomic) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient*) sharedInstance {
    static TwitterClient* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]
                                                  consumerKey:twitterConsumerKey
                                               consumerSecret:twitterSecretKey];
        }
    });
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"tweetdemooauth://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        self.loginCompletion(nil, error);
    }];
}

- (void)openURL:(NSURL*) url {
    if ([url.scheme isEqualToString:@"tweetdemooauth"]) {
        if ([url.host isEqualToString:@"oauth"]) {
            [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
                NSLog(@"got access token");
                [self.requestSerializer saveAccessToken:accessToken];
                
                [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    User* user = [[User alloc] initWithDictionary:responseObject];
                    [User setCurrentUser:user];
                    self.loginCompletion(user, nil);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"failed to get user");
                    self.loginCompletion(nil, error);
                }];
            } failure:^(NSError *error) {
                NSLog(@"failed to get access token");
            }];
        }
    }
}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json?count=20" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweets = [Tweet tweetsWithDictionary:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
    
}

- (void)postTweetWithParams:(NSDictionary *)params completion:(void (^)(Tweet *, NSError *))completion {
    [self POST:@"1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)retweetWithParams:(NSString *)tweet_id completion:(void (^)(Tweet *, NSError *))completion {
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweet_id];
    [self POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)favoriteWithParams:(NSDictionary *)params completion:(void (^)(Tweet *, NSError *))completion {
    [self POST:@"1.1/favorites/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)unfavoriteWithParams:(NSDictionary* ) params completion:(void (^)(Tweet *tweet, NSError *error))completion {
    [self POST:@"1.1/favorites/destroy.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

- (void)getTweetWithId:(NSString *)tweet_id completion:(void (^)(Tweet *tweet, NSError *error))completion {
    NSDictionary *params = @{@"id" : tweet_id};
    
    [self GET:@"1.1/statuses/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
    }];
}

@end
