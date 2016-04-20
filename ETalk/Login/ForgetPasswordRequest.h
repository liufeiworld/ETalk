//
//  ForgetPasswordRequest.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ForgetPasswordRequestDelegate <NSObject>

- (void)forgetPasswordSuccess;
- (void)forgetPasswordFailure:(NSString *)errorInfo;

@end

@interface ForgetPasswordRequest : NSObject

@property (weak, nonatomic) id delegate;

- (void)forgetPasswordWithEmail:(NSString *)email;
- (void)cancelForgetPassword;

@end
