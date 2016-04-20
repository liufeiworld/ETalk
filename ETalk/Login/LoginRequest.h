//
//  LoginRequest.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/10.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginRequestDelegate <NSObject>

- (void)loginSuccess;
- (void)loginFailure:(NSString *)errorInfo;

@end

@interface LoginRequest : NSObject

@property (weak, nonatomic) id delegate;

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password;
- (void)cancelLogin;

@end
