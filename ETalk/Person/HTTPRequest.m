//
//  HTTPRequest.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "HTTPRequest.h"
#import "AFNetworking.h"
#import "UserSingleton.h"

@interface HTTPRequest()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation HTTPRequest


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

- (void)startRequest
{
    if ((self.requestType == kHTTPRequestType_UnKown) || (self.respondType == kHTTPRespondType_UnKown) ) {
        NSLog(@"*******************************************请配置请求类型*******************************************");
        return;
    }
    
    NSString *postURL = [NSString stringWithFormat:@"%@%@", kHTTPRequestURL, self.title];
    switch (self.requestType) {
        case kHTTPRequestType_Post:
        {
            [self.manager POST:postURL parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //NSLog(@"--------------%@",(NSDictionary *)responseObject);
                [self respondFinished:(NSDictionary *)responseObject];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@", error);
                [self respondFailureWithErrorInfo:@"请求失败，请检查网络"];
            }];
        }
            break;
            
        case kHTTPRequestType_Put:
        {
            [self.manager PUT:postURL parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self respondFinished:(NSDictionary *)responseObject];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@", error);
                [self respondFailureWithErrorInfo:@"请求失败，请检查网络"];
            }];
        }
            break;
            
        case kHTTPRequestType_Get:
        {
            [self.manager GET:postURL parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self respondFinished:(NSDictionary *)responseObject];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@", error);
                [self respondFailureWithErrorInfo:@"请求失败，请检查网络"];
            }];
        }
            break;
            
        default:
            break;
    }
    
    NSLog(@"URL:%@, parameters:%@", postURL, self.parameters);
}

- (void)respondFinished:(NSDictionary *)dictionary
{
    //NSLog(@"requestSuccess;%@", dictionary);
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
            switch (self.respondType) {
                case kHTTPRespondType_Data:
                {
                    id respondData = [dictionary objectForKey:kRespondKeyData];
                    
                    if (respondData) {
                        
                        [self respondSuccess:respondData];
                    }
                    else {
                        NSString *errorInfo = @"请求失败，服务器错误";
                        [self respondFailureWithErrorInfo:errorInfo];
                    }
                    
                }
                    break;
                    
                case kHTTPRespondType_None:
                {
                    [self respondSuccess:nil];
                }
                    break;
                default:
                    break;
            }
            
        }
            break;
            
        default:
        {
            NSString *errorInfo = @"请求失败，服务器错误!";
            [self respondFailureWithErrorInfo:errorInfo];
        }
            break;
    }
}

- (void)respondSuccess:(NSDictionary *)dictionary
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:)]) {
        [_delegate performSelectorOnMainThread:@selector(requestSuccess:) withObject:dictionary waitUntilDone:NO];
    }
    
}

- (void)respondFailureWithErrorInfo:(NSString *)errorInfo
{
    if (_delegate && [_delegate respondsToSelector:@selector(requestFailure:)]) {
        [_delegate performSelectorOnMainThread:@selector(requestFailure:) withObject:errorInfo waitUntilDone:NO];
    }
    
}

- (void)cancelRequest
{
    self.delegate = nil;
    
    if (_manager && [_manager operationQueue]) {
        [[_manager operationQueue] cancelAllOperations];
    }
}

@end
