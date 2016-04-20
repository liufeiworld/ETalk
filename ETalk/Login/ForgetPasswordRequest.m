//
//  ForgetPasswordRequest.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "ForgetPasswordRequest.h"

#import "AFNetworking.h"
#import "UserSingleton.h"

@interface ForgetPasswordRequest()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation ForgetPasswordRequest

- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
        
        _manager.requestSerializer.timeoutInterval = kTimeoutSeconds;
        _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        
        
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"charset=UTF-8", nil];
        _manager.responseSerializer = responseSerializer;
    }
    
    return  _manager;
}

- (void)forgetPasswordWithEmail:(NSString *)email
{
    NSDictionary *parameters = @{kRequestKeyEmail : email};
    
    NSString *postURL = [NSString stringWithFormat:@"%@%@", kHTTPRequestURL, kRequestKeyUserForgetPassword];
    [self.manager POST:postURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self respondSuccess:(NSDictionary *)responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorInfo = @"找回密码失败，请检查网络";
        [self respondFailureWithErrorInfo:errorInfo];
    }];
    
}

- (void)respondSuccess:(NSDictionary *)dictionary
{
    NSLog(@"requestSuccess;%@", dictionary);
    int state = [[dictionary objectForKey:kRespondKeyStatus] intValue];
    switch (state) {
        case 0:
        {
            NSString *errorInfo = [dictionary objectForKey:kRespondKeyErrorInfo];
            [self respondFailureWithErrorInfo:errorInfo];
        }
            break;
            
        case 1:
        {
            [self respondSuccess];
        }
            break;
            
        default:
        {
            NSString *errorInfo = @"找回密码失败，服务器错误!";
            [self respondFailureWithErrorInfo:errorInfo];
        }
            break;
    }
}

- (void)respondSuccess
{
    if (_delegate && [_delegate respondsToSelector:@selector(forgetPasswordSuccess)]) {
        [_delegate performSelectorOnMainThread:@selector(forgetPasswordSuccess) withObject:nil waitUntilDone:NO];
    }
}

- (void)respondFailureWithErrorInfo:(NSString *)errorInfo
{
    if (_delegate && [_delegate respondsToSelector:@selector(forgetPasswordFailure:)]) {
        [_delegate performSelectorOnMainThread:@selector(forgetPasswordFailure:) withObject:errorInfo waitUntilDone:NO];
    }
    
}

- (void)cancelForgetPassword
{
    self.delegate = nil;
    
    if (_manager && [_manager operationQueue]) {
        [[_manager operationQueue] cancelAllOperations];
    }
}

@end
