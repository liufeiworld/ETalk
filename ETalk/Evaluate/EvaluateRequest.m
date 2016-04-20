//
//  EvaluateRequest.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "EvaluateRequest.h"
#import "AFNetworking.h"
#import "UserSingleton.h"
#import "CourseInfo.h"

@interface EvaluateRequest()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation EvaluateRequest

- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
        
        _manager.requestSerializer.timeoutInterval = kTimeoutSeconds;
        _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        NSString *token = [[UserSingleton sharedInstance] token];
        [_manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"charset=UTF-8", nil];
        _manager.responseSerializer = responseSerializer;
    }
    
    return  _manager;
}

- (void)evaluateWithText:(NSString *)text score:(NSInteger)score courseID:(NSInteger)courseID
{
    //NSString *userID = [[[UserSingleton sharedInstance] userInfo] identifier];
    NSString *tokenString = [[UserSingleton sharedInstance] tokenString];
    //NSDictionary *parameters = @{kRequestKeyUserID : userID, kRequestKeyCourseID : courseID, kRequestKeyComment: text, kRequestKeyScore : @(score)};
    NSDictionary *parameters = @{kRespondKeyNewTokenString : tokenString, kRequestKeyNewCourseId : @(courseID), kRequestKeyComment : text, kRequestKeyScore : @(score)};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", kHTTPRequestURL, kRequestKeySubmitReview];
    [self.manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self respondSuccess:(NSDictionary *)responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorInfo = @"评价课程失败，请检查网络";
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
            NSArray *array = [dictionary objectForKey:kRespondKeyData];
            NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < array.count; i++) {
                NSDictionary *dic = [array objectAtIndex:i];
                CourseInfo *info = [[CourseInfo alloc] initWithDictionary:dic];
                [mutableArray addObject:info];
            }
            if (mutableArray.count > 0) {
            }
            
            [self respondSuccess];
        }
            break;
            
        default:
        {
            NSString *errorInfo = @"评价课程失败，服务器错误!";
            [self respondFailureWithErrorInfo:errorInfo];
        }
            break;
    }
}

- (void)respondSuccess
{
    if (_delegate && [_delegate respondsToSelector:@selector(evaluateSuccess)]) {
        [_delegate performSelectorOnMainThread:@selector(evaluateSuccess) withObject:nil waitUntilDone:NO];
    }
}

- (void)respondFailureWithErrorInfo:(NSString *)errorInfo
{
    if (_delegate && [_delegate respondsToSelector:@selector(evaluateFailure:)]) {
        [_delegate performSelectorOnMainThread:@selector(evaluateFailure:) withObject:errorInfo waitUntilDone:NO];
    }
    
}

- (void)cancelEvaluate
{
    self.delegate = nil;
    
    if (_manager && [_manager operationQueue]) {
        [[_manager operationQueue] cancelAllOperations];
    }
}

@end
