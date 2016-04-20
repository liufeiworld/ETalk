//
//  LoginRequest.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/10.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "LoginRequest.h"
#import "AFNetworking.h"
#import "UserSingleton.h"

@interface LoginRequest()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@property (strong, nonatomic) NSString *loginUserName;
@property (strong, nonatomic) NSString *loginPassword;

@end

@implementation LoginRequest

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

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password
{
    self.loginUserName = userName;
    self.loginPassword = password;
    
    NSDictionary *parameters = @{kRequestKeyUserName : userName , kRequestKeyPassword : password};
    NSString *postURL = [NSString stringWithFormat:@"%@%@", kHTTPRequestURL, kRequestKeyUserLogin];
    [self.manager POST:postURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self respondSuccess:(NSDictionary *)responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorInfo = @"登录失败，请检查网络";
        [self respondFailureWithErrorInfo:errorInfo];
    }];
    
}

- (void)respondSuccess:(NSDictionary *)dictionary
{
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
                
                [Common setUserName:self.loginUserName];
                [Common setPassword:self.loginPassword forUserName:self.loginUserName];
            }
            else {
                NSString *errorInfo = @"登录失败，服务器错误";
                [self respondFailureWithErrorInfo:errorInfo];
            }
        }
            break;
            
        default:
        {
            NSString *errorInfo = @"登录失败，服务器错误!";
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
            if (![[data objectForKey:kRespondKeyNewPictures] isKindOfClass:[NSNull class]]) {
                userInfo.pictures = [data objectForKey:kRespondKeyNewPictures];
            }
           // userInfo.qrcode = [data objectForKey:kRespondKeyNewQrcode];
            userInfo.username = [data objectForKey:kRespondKeyNewUserName];

            UserSingleton* user = [UserSingleton sharedInstance];
            user.state = kUserStateLogin;
            user.tokenString = [data objectForKey:kRespondKeyNewTokenString];
            user.userInfo = userInfo;
        }
    }
    
    return userInfo;
}

- (void)respondSuccess
{
    if (_delegate && [_delegate respondsToSelector:@selector(loginSuccess)]) {
        [_delegate performSelectorOnMainThread:@selector(loginSuccess) withObject:nil waitUntilDone:NO];
    }
    
}

- (void)respondFailureWithErrorInfo:(NSString *)errorInfo
{
    if (_delegate && [_delegate respondsToSelector:@selector(loginFailure:)]) {
        [_delegate performSelectorOnMainThread:@selector(loginFailure:) withObject:errorInfo waitUntilDone:NO];
    }

}

- (void)cancelLogin
{
    self.delegate = nil;

    if (_manager && [_manager operationQueue]) {
        [[_manager operationQueue] cancelAllOperations];
    }
}

@end
