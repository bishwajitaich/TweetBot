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
        self.user = [[User alloc]initWithDictionary:dictionary[@"user"]];
        self.tweet = dictionary[@"text"];
        
        YLMoment *moment = [YLMoment momentWithDateAsString:dictionary[@"created_at"]];
        self.created_at = [moment fromNow];
    }
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
