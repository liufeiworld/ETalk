//
//  CourseTimeListRequest.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "CourseTimeListRequest.h"
#import "AFNetworking.h"
#import "UserSingleton.h"
#import "CourseTimeInfo.h"

@interface CourseTimeListRequest()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation CourseTimeListRequest

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

- (void)getCourseTimeListWithPlanID:(NSString *)productID date:(NSString *)date
{
    //NSString *userID = [[[UserSingleton sharedInstance] userInfo] identifier];
    //NSDictionary *parameters = @{kRequestKeyUserID : userID, kRequestKeyProductID : productID, kRequestKeyDate : date};
    NSString *tokenString = [[UserSingleton sharedInstance] tokenString];
    NSDictionary *parameters = @{kRespondKeyNewTokenString : tokenString, kRequestKeyNewStrDate : date};
    NSString *postURL = [NSString stringWithFormat:@"%@%@", kHTTPRequestURL, kRequestKeyGetCourseTimeList];
    [self.manager POST:postURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self respondSuccess:(NSDictionary *)responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorInfo = @"获取课程失败，请检查网络";
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
            NSMutableArray *courses = [[NSMutableArray alloc] init];
            NSArray *list = [dictionary objectForKey:kRespondKeyData];
            for (NSInteger i = 0; i < list.count; i++) {
                NSDictionary *dic = [list objectAtIndex:i];
                //CourseTimeInfo *courseTimeInfo = [[CourseTimeInfo alloc] initWithDictionary:dic];
                CourseTimeInfo *courseTimeInfo = [[CourseTimeInfo alloc] initWithNewDictionary:dic];
                [courses addObject:courseTimeInfo];
            }
            
            
            if (courses.count > 0) {
                self.courseTimeList = courses;
                [self respondSuccess];
            }
            else {
                NSString *errorInfo = @"获取课程失败，服务器错误";
                [self respondFailureWithErrorInfo:errorInfo];
            }
        }
            break;
            
        default:
        {
            NSString *errorInfo = @"获取课程失败，服务器错误!";
            [self respondFailureWithErrorInfo:errorInfo];
        }
            break;
    }
}

- (void)respondSuccess
{
    if (_delegate && [_delegate respondsToSelector:@selector(getCourseTimeListSuccess)]) {
        [_delegate performSelectorOnMainThread:@selector(getCourseTimeListSuccess) withObject:nil waitUntilDone:NO];
    }
    
}

- (void)respondFailureWithErrorInfo:(NSString *)errorInfo
{
    if (_delegate && [_delegate respondsToSelector:@selector(getCourseTimeListFailure:)]) {
        [_delegate performSelectorOnMainThread:@selector(getCourseTimeListFailure:) withObject:errorInfo waitUntilDone:NO];
    }
    
}

- (void)cancelGetCourseTimeList
{
    self.delegate = nil;
    
    if (_manager && [_manager operationQueue]) {
        [[_manager operationQueue] cancelAllOperations];
    }
}

@end
