//
//  UserSingleton.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "UserSingleton.h"

@implementation UserSingleton

+ (instancetype)sharedInstance
{
    static UserSingleton *userSingleton = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        userSingleton = [[UserSingleton alloc] init];
    });
    return userSingleton;
}

@end
