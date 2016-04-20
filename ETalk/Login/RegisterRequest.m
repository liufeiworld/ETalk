//
//  RegisterRequest.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "RegisterRequest.h"
#import "AFNetworking.h"
#import "UserSingleton.h"

@interface RegisterRequest()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation RegisterRequest

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

- (void)registerWithUserName:(NSString *)userName password:(NSString *)password  email:(NSString *)email phoneNumber:(NSString *)phoneNumber refereeCode:(NSString *)refereeCode
{
    NSDictionary *parameters = nil;
    if (refereeCode) {
        if (email) {
            parameters = @{kRequestKeyUserName : userName , kRequestKeyPassword : password , kRequestKeyMobile : phoneNumber , kRequestKeyNewQrcode : refereeCode};
        }
        else{
            parameters = @{kRequestKeyUserName : userName , kRequestKeyPassword : password , kRequestKeyMobile : phoneNumber , kRequestKeyNewQrcode : refereeCode};
        }
    }
    else{
        parameters = @{kRequestKeyUserName : userName , kRequestKeyPassword : password , kRequestKeyMobile : phoneNumber};
    }
  
    NSString *postURL = [NSString stringWithFormat:@"%@%@", kHTTPRequestURL, kRequestKeyUserRegister];
    [self.manager POST:postURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self respondSuccess:(NSDictionary *)responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorInfo = @"注册失败，请检查网络";
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
            if ([self userInfoWithDictionary:dictionary]) {
                [self respondSuccess];
            }
            else {
                NSString *errorInfo = @"注册失败，服务器错误";
                [self respondFailureWithErrorInfo:errorInfo];
            }
        }
            break;
            
        default:
        {
            NSString *errorInfo = @"注册失败，服务器错误!";
            [self respondFailureWithErrorInfo:errorInfo];
        }
            break;
    }
}

- (Userinfo *)userInfoWithDictionary:(NSDictionary *)dic
{
    Userinfo *userInfo = nil;
    if (dic) {
        NSDictionary *data = [dic objectForKey:kRespondKeyData];
        if (data) {
            userInfo = [[Userinfo alloc] init];

            if (![[data objectForKey:kRespondKeyNewCnName] isKindOfClass:[NSNull class]]) {
                userInfo.cnName = [data objectForKey:kRespondKeyNewCnName];
            }
            else{
                userInfo.cnName = [data objectForKey:kRespondKeyNewUserName];
            }
            userInfo.username = [data objectForKey:kRespondKeyNewUserName];
            userInfo.pictures = [data objectForKey:kRespondKeyNewPictures];
            //userInfo.qrcode = [data objectForKey:kRespondKeyNewQrcode];
            
            UserSingleton *user = [UserSingleton sharedInstance];
            user.state = kUserStateLogin;
            user.tokenString = [data objectForKey:kRespondKeyNewTokenString];
            user.userInfo = userInfo;
        }
    }
    
    return userInfo;
}

- (void)respondSuccess
{
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(registerSuccess)]) {
        [_delegate performSelectorOnMainThread:@selector(registerSuccess) withObject:nil waitUntilDone:NO];
    }
    
}

- (void)respondFailureWithErrorInfo:(NSString *)errorInfo
{
    if (_delegate && [_delegate respondsToSelector:@selector(registerFailure:)]) {
        [_delegate performSelectorOnMainThread:@selector(registerFailure:) withObject:errorInfo waitUntilDone:NO];
    }
    
}

- (void)cancelRegister
{
    self.delegate = nil;
    
    if (_manager && [_manager operationQueue]) {
        [[_manager operationQueue] cancelAllOperations];
    }
}

@end
