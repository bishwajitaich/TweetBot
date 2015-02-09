//
//  User.m
//  Twitter
//
//  Created by Bishwajit Aich. on 2/8/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString* const userDidLoginNotification = @"userDidLoginNotification";
NSString* const userDidLogoutNotification = @"userDidLogoutNotification";

@interface User()

@property (strong, nonatomic) NSDictionary* dictionary;

@end

@implementation User


- (id)initWithDictionary:(NSDictionary*) dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.name = ([dictionary[@"name"] isEqualToString:@"undefined"]) ? dictionary[@"screen_name"]: dictionary[@"name"];
        self.tagLine = dictionary[@"description"];
        self.profileImageUrl = dictionary[@"profile_image_url"];
        self.username = dictionary[@"screen_name"];
        self.tweetCount = [dictionary[@"statuses_count"] integerValue];
        self.followerCount = [dictionary[@"followers_count"] integerValue];
        self.followingCount = [dictionary[@"friends_count"] integerValue];
    }
    return self;
}

static User* _currentUser;
NSString* const userKey = @"kCurrentUserKey";

+ (User*)currentUser {
    if(_currentUser == nil) {
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:userKey];
        if (data != nil) {
            NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}

+ (void)setCurrentUser:(User *)user {
    _currentUser = user;
    if (_currentUser != nil) {
        NSData* data = [NSJSONSerialization dataWithJSONObject:user.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults]setObject:data forKey:userKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:userKey];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (void)logout {
    [User setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    [[NSNotificationCenter defaultCenter]postNotificationName:userDidLogoutNotification object:nil];
}

@end
