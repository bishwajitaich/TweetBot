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

@property (strong, nonatomic) User* user;
@property (strong, nonatomic) NSString* tweet;
@property (strong, nonatomic) NSString* created_at;

-(id) initWithDictionary:(NSDictionary*) dictionary;

+(NSArray*) tweetsWithDictionary:(NSArray*) dictionaries;

@end
