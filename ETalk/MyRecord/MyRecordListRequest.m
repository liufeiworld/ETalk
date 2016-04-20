//
//  MyRecordListRequest.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "MyRecordListRequest.h"
#import "AFNetworking.h"
#import "UserSingleton.h"
#import "CourseInfo.h"
#import "CourseListModel.h"

@interface MyRecordListRequest()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation MyRecordListRequest

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

- (void)getMyRecordList
{
    NSString *tokenString = [[UserSingleton sharedInstance] tokenString];
    NSDictionary *parameters = @{kRespondKeyNewTokenString : tokenString, kRequestKeyNewStrDate : self.bespeakMonth, @"page" : @(1), @"size" : @(100)};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", kHTTPRequestURL, @"app_getClassRecordList.action"];
    
    NSString *EvaluateOfTeacherURL = [NSString stringWithFormat:@"http://www.etalk365.cn/interface/app_getClassRecordList.action?tokenString=%@&strDate=%@&page=%@&size=%@",tokenString,self.bespeakMonth,@(1),@(100)];
    
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:EvaluateOfTeacherURL forKey:kRespondKeyEvaluateOfTeacherURL];
    
    [self.manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"---------------%lu", (unsigned long)operation.responseData.length);
        if (operation.responseData.length < 32) {
            [self respondSuccess:@{kRespondKeyStatus : @(0), kRespondKeyErrorInfo : @"本月无上课记录"}];
        }
        else {
            [self respondSuccess:(NSDictionary *)responseObject];
            for (NSDictionary *dict in responseObject[@"data"]) {
                
                 NSDictionary *teaEvaluat = [dict objectForKey:@"courseList"][0][@"teaEvaluat"];
                
                UserSingle *single = [UserSingle sharedInstance];
                single.teaEvaluat = teaEvaluat;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorInfo = @"获取我的记录失败，请检查网络";
        [self respondFailureWithErrorInfo:errorInfo];
        self.myRecordList = nil;
    }];
}

- (void)respondSuccess:(NSDictionary *)dictionary
{
    //NSLog(@"requestSuccess;%@", dictionary);
    int state = [[dictionary objectForKey:kRespondKeyStatus] intValue];
    switch (state) {
        case 0:
        {
            NSString *errorInfo = [dictionary objectForKey:kRespondKeyErrorInfo];
            [self respondFailureWithErrorInfo:errorInfo];
            self.myRecordList = nil;
        }
            break;
            
        case 1:
        {
            self.myRecordList = [dictionary objectForKey:kRespondKeyData];
            [self respondSuccess];
        }
            break;
            
        default:
        {
            NSString *errorInfo = @"获取待评价课程失败，服务器错误!";
            [self respondFailureWithErrorInfo:errorInfo];
            self.myRecordList = nil;
        }
            break;
    }
}

- (void)respondSuccess
{
    if (_delegate && [_delegate respondsToSelector:@selector(getMyRecordListSuccess)]) {
        [_delegate performSelectorOnMainThread:@selector(getMyRecordListSuccess) withObject:nil waitUntilDone:NO];
    }
}

- (void)respondFailureWithErrorInfo:(NSString *)errorInfo
{
    if (_delegate && [_delegate respondsToSelector:@selector(getMyRecordListFailure:)]) {
        [_delegate performSelectorOnMainThread:@selector(getMyRecordListFailure:) withObject:errorInfo waitUntilDone:NO];
    }
}

- (void)cancelGetMyRecordList
{
    self.delegate = nil;
    
    if (_manager && [_manager operationQueue]) {
        [[_manager operationQueue] cancelAllOperations];
    }
}

@end
