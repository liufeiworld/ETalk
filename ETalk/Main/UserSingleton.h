//
//  UserSingleton.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Userinfo.h"

typedef NS_ENUM(NSUInteger, UserState) {
    kUserStateUnkown = 0,
    kUserStateLogin  = 1,
    kUserStateLogout = 2
};

@interface UserSingleton : NSObject

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) Userinfo *userInfo;
@property (assign, nonatomic) UserState state;
@property (strong, nonatomic) NSString *tokenString;
@property (strong, nonatomic) NSString *messageCount;
@property (nonatomic, assign) NSInteger count1;
@property (nonatomic, assign) NSInteger count2;

+ (instancetype)sharedInstance;

@end