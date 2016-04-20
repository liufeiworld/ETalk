//
//  CancelCourseRequest.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "CancelCourseRequest.h"
#import "AFNetworking.h"
#import "UserSingleton.h"

@interface CancelCourseRequest()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation CancelCourseRequest

- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
        
        _manager.requestSerializer.timeoutInterval = kTimeoutSeconds;
        _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        //NSString *token = [[UserSingleton sharedInstance] token];
        //[_manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"charset=UTF-8", nil];
        _manager.responseSerializer = responseSerializer;
    }
    
    return  _manager;
}

- (void)cancelCourseWithIdentifier:(NSString *)identifier
{
    //NSString *userID = [[[UserSingleton sharedInstance] userInfo] identifier];
    NSString *tokenString = [[UserSingleton sharedInstance] tokenString];
    //NSDictionary *parameters = @{kRequestKeyUserID : userID, kRequestKeyCourseID : identifier};
    NSDictionary *parameters = @{kRespondKeyNewTokenString : tokenString , kRequestKeyNewStrDate : identifier};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", kHTTPRequestURL, kRequestKeyUserCancelCourse];
    [self.manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self respondSuccess:(NSDictionary *)responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorInfo = @"获取我的预约失败，请检查网络";
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
            NSString *errorInfo = @"获取我的预约失败，服务器错误!";
            [self respondFailureWithErrorInfo:errorInfo];
        }
            break;
    }
}

- (void)respondSuccess
{
    if (_delegate && [_delegate respondsToSelector:@selector(cancelCourseSuccess)]) {
        [_delegate performSelectorOnMainThread:@selector(cancelCourseSuccess) withObject:nil waitUntilDone:NO];
    }
}

- (void)respondFailureWithErrorInfo:(NSString *)errorInfo
{
    if (_delegate && [_delegate respondsToSelector:@selector(cancelCourseFailure:)]) {
        [_delegate performSelectorOnMainThread:@selector(cancelCourseFailure:) withObject:errorInfo waitUntilDone:NO];
    }
    
}

- (void)cancel
{
    self.delegate = nil;
    
    if (_manager && [_manager operationQueue]) {
        [[_manager operationQueue] cancelAllOperations];
    }
}

@end
