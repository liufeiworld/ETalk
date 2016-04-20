//
//  RegisterRequest.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RegisterRequestDelegate <NSObject>

- (void)registerSuccess;
- (void)registerFailure:(NSString *)errorInfo;

@end

@interface RegisterRequest : NSObject

@property (weak, nonatomic) id delegate;

- (void)registerWithUserName:(NSString *)userName password:(NSString *)password  email:(NSString *)email phoneNumber:(NSString *)phoneNumber refereeCode:(NSString *)refereeCode;
- (void)cancelRegister;

@end