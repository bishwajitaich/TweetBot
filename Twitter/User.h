//
//  User.h
//  Twitter
//
//  Created by Bishwajit Aich. on 2/8/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const userDidLoginNotification;
extern NSString* const userDidLogoutNotification;

@interface User : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* profileImageUrl;
@property (nonatomic, strong) NSString* tagLine;
@property (nonatomic, assign) NSInteger tweetCount;
@property (nonatomic, assign) NSInteger followerCount;
@property (nonatomic, assign) NSInteger followingCount;

-(id) initWithDictionary:(NSDictionary*) dictionary;
+ (User*) currentUser;
+ (void) setCurrentUser:(User*) user;
+ (void) logout;

@end
