//
//  User.m
//  Twitter
//
//  Created by Bishwajit Aich. on 2/8/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import "User.h"

@implementation User


- (id)initWithDictionary:(NSDictionary*) dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.tagLine = dictionary[@"description"];
        self.profileImageUrl = dictionary[@"profile_image_url"];
        self.username = dictionary[@"screen_name"];
    }
    return self;
}

@end
