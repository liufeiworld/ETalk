//
//  UserSingle.m
//  ETalk
//
//  Created by etalk365 on 16/1/21.
//  Copyright © 2016年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "UserSingle.h"

@implementation UserSingle

+ (instancetype)sharedInstance
{
    static UserSingle *userSingle = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        userSingle = [[UserSingle alloc] init];
    });
    return userSingle;
}

@end
