//
//  EvaluateListRequest.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "EvaluateListRequest.h"
#import "AFNetworking.h"
#import "UserSingleton.h"
#import "CourseInfo.h"

@interface EvaluateListRequest()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation EvaluateListRequest

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

- (void)getEvaluateList
{
    //NSString *userID = [[[UserSingleton sharedInstance] userInfo] identifier];
    NSString *tokenString = [[UserSingleton sharedInstance] tokenString];
    NSDictionary *parameters = @{kRespondKeyNewTokenString : tokenString, kRequestKeyPage : @(1), kRequestKeyNewSize : @(200)};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", kHTTPRequestURL, kRequestKeyUserGetReviewCourseList];
    [self.manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"--------%@", operation.request);
//        NSLog(@"========%@", (NSDictionary *)responseObject);
        [self respondSuccess:(NSDictionary *)responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorInfo = @"获取待评价课程失败，请检查网络";
        [self respondFailureWithErrorInfo:errorInfo];
    }];
}

- (void)respondSuccess:(NSDictionary *)dictionary
{
    int state = [[dictionary objectForKey:kRespondKeyStatus] intValue];
    switch (state) {
        case 0:
        {
            int errorCode = [[dictionary objectForKey:@"error_code"] intValue];
            if (errorCode == 1314) {
                self.evaluateList = nil;
                [self respondSuccess];
            }
            else {
                NSString *errorInfo = @"获取待评价课程失败!";
                [self respondFailureWithErrorInfo:errorInfo];
            }
        }
            break;
        case 1:
        {
            NSArray *array = [dictionary objectForKey:kRespondKeyData];
            NSMutableArray *courseListArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in array) {
                CourseInfoList *infoList = [[CourseInfoList alloc] init];
                infoList.title = [dic objectForKey:kRespondKeyNewCourseDate];
                NSArray *infoArray = [dic objectForKey:kRespondKeyNewCourseList];
                for (NSDictionary *infoDic in infoArray) {
                    CourseInfo *courseInfoModel = [[CourseInfo alloc] initWithEvaluateDictionary:infoDic];
                    //CourseInfo *courseInfoModel = [[CourseInfo alloc] initWithNewDictionary:infoDic];
                    [infoList.infoList addObject:courseInfoModel];
                }
                [courseListArray addObject:infoList];
            }
            if (courseListArray.count > 0) {
                self.evaluateList = [NSArray arrayWithArray:courseListArray];
            }
            [self respondSuccess];
        }
            break;
        default:
        {
            NSString *errorInfo = @"获取待评价课程失败，服务器错误!";
            [self respondFailureWithErrorInfo:errorInfo];
        }
            break;
    }
}

//- (void)respondSuccess:(NSDictionary *)dictionary
//{
//    NSLog(@"requestSuccess;%@", dictionary);
//    int state = [[dictionary objectForKey:kRespondKeyStatus] intValue];
//    switch (state) {
//        case 0:
//        {
//            NSString *errorInfo = [dictionary objectForKey:kRespondKeyErrorInfo];
//            [self respondFailureWithErrorInfo:errorInfo];
//        }
//            break;
//            
//        case 1:
//        {
//            NSArray *array = [dictionary objectForKey:kRespondKeyData];
//            NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
//            for (NSInteger i = 0; i < array.count; i++) {
//                NSDictionary *dic = [array objectAtIndex:i];
//                CourseInfo *info = [[CourseInfo alloc] initWithDictionary:dic];
//                [mutableArray addObject:info];
//            }
//            if (mutableArray.count > 0) {
//                self.evaluateList = [NSArray arrayWithArray:mutableArray];
//            }
//            
//            [self respondSuccess];
//        }
//            break;
//            
//        default:
//        {
//            NSString *errorInfo = @"获取待评价课程失败，服务器错误!";
//            [self respondFailureWithErrorInfo:errorInfo];
//        }
//            break;
//    }
//}

- (void)respondSuccess
{
    if (_delegate && [_delegate respondsToSelector:@selector(getEvaluateListSuccess)]) {
        [_delegate performSelectorOnMainThread:@selector(getEvaluateListSuccess) withObject:nil waitUntilDone:NO];
    }
}

- (void)respondFailureWithErrorInfo:(NSString *)errorInfo
{
    if (_delegate && [_delegate respondsToSelector:@selector(getEvaluateListFailure:)]) {
        [_delegate performSelectorOnMainThread:@selector(getEvaluateListFailure:) withObject:errorInfo waitUntilDone:NO];
    }
    
}

- (void)cancelGetEvaluateList
{
    self.delegate = nil;
    
    if (_manager && [_manager operationQueue]) {
        [[_manager operationQueue] cancelAllOperations];
    }
}

@end
