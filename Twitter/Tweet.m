//
//  Tweet.m
//  Twitter
//
//  Created by Bishwajit Aich. on 2/8/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import "Tweet.h"
#import "YLMoment.h"

@implementation Tweet

-(id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        if (dictionary[@"retweeted_status"]) {
            self.user = [[User alloc]initWithDictionary:dictionary[@"retweeted_status"][@"user"]];
            self.retweetUser = [[User alloc]initWithDictionary:dictionary[@"user"]];
        } else {
            self.user = [[User alloc]initWithDictionary:dictionary[@"user"]];
        }
        self.tweet = dictionary[@"text"];
        
        YLMoment *moment = [YLMoment momentWithDateAsString:dictionary[@"created_at"]];
        self.created_at = [moment fromNow];
        self.favorited = [dictionary[@"favorited"] integerValue];
        self.retweeted = [dictionary[@"retweeted"] integerValue];
        self.id_str = dictionary[@"id_str"];
        self.retweet_count = [dictionary[@"retweet_count"] integerValue];
        self.favorited_count = [dictionary[@"favorite_count"] integerValue];
        self.user_mentions = dictionary[@"entities"][@"user_mentions"];
    }
    NSLog(@"Tweet %@", dictionary);
    return self;
}

+(NSArray*) tweetsWithDictionary:(NSArray*) dictionaries {
    NSMutableArray * array = [NSMutableArray array];
    for (NSDictionary* dictionary in dictionaries) {
        [array addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    return array;
}

@end
