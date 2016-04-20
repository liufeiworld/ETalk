//
//  Common.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/11.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "Common.h"
#import "SSKeychain.h"

@implementation Common

#define kServerIndentifierForKeychain @"cn.com.etalk365.ETalk"

#pragma mark - Accout Info

+ (NSString *)userName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:kRequestKeyUserName];
}

+ (void)setUserName:(NSString *)name
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:name forKey:kRequestKeyUserName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)passwordForUserName:(NSString *)userName
{

    if (!userName) return nil;
    
    NSError *error = nil;
    NSString *password = [SSKeychain passwordForService:kServerIndentifierForKeychain account:userName error:&error];
    if ([error code] == SSKeychainErrorNotFound) {
        NSLog(@"SSKeychain Password not found");
    }
    
    return password;
}

+ (void)setPassword:(NSString *)psw forUserName:(NSString *)userName
{
    if (!userName) return;
    
    NSError *error = nil;
    if (![SSKeychain setPassword:psw forService:kServerIndentifierForKeychain account:userName error:&error]) {
        NSLog(@"SSKeychain setPassword error, %@", error);
    }
}

+ (void)clearPasswordForUserName:(NSString *)userName
{
    if (!userName) return;
    
    NSError *error = nil;
    if (![SSKeychain deletePasswordForService:kServerIndentifierForKeychain account:userName error:&error]) {
        NSLog(@"SSKeychain deletePasswordForService error, %@", error);
    }
}

@end
