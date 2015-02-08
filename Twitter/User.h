//
//  User.h
//  Twitter
//
//  Created by Bishwajit Aich. on 2/8/15.
//  Copyright (c) 2015 Bishwajit Aich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* profileImageUrl;
@property (nonatomic, strong) NSString* tagLine;

-(id) initWithDictionary:(NSDictionary*) dictionary;

@end
