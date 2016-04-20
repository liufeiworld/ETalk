//
//  Common.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/11.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

+ (NSString *)userName;
+ (void)setUserName:(NSString *)name;
+ (NSString *)passwordForUserName:(NSString *)userName;
+ (void)setPassword:(NSString *)psw forUserName:(NSString *)userName;
+ (void)clearPasswordForUserName:(NSString *)userName;

@end
