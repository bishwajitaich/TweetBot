//
//  Tweet.h
//  Twitter
//
//  Created by Bishwajit Aich. on 2/8/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (strong, nonatomic) User* retweetUser;
@property (strong, nonatomic) User* user;
@property (strong, nonatomic) NSString* tweet;
@property (strong, nonatomic) NSString* created_at;
@property (assign, nonatomic) NSInteger favorited;
@property (assign, nonatomic) NSInteger retweeted;
@property (strong, nonatomic) NSString* id_str;
@property (assign, nonatomic) NSInteger retweet_count;
@property (assign, nonatomic) NSInteger favorited_count;
@property (strong, nonatomic) NSArray* user_mentions;

-(id) initWithDictionary:(NSDictionary*) dictionary;

+(NSArray*) tweetsWithDictionary:(NSArray*) dictionaries;

@end
