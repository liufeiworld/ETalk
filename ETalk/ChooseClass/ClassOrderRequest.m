//
//  ClassOrderRequest.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "ClassOrderRequest.h"
#import "AFNetworking.h"
#import "UserSingleton.h"
#import "TheErrorInfo.h"

@interface ClassOrderRequest()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation ClassOrderRequest

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

- (void)orderWithNumber:(int)number withOrderId:(NSString *)orderId withStrDate:(NSString *)strDate
{
    NSString *tokenString = [[UserSingleton sharedInstance] tokenString];
    NSDictionary *parameters = @{kRespondKeyNewTokenString : tokenString, kRequestKeyNewStrDate : strDate, kRequestKeyNewOrderId : orderId, @"classWay" : @(number)};
    NSString *postURL = [NSString stringWithFormat:@"%@%@", kHTTPRequestURL, kRequestKeyNewBookedCourse];
    [self.manager POST:postURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@".......000000000000.......%@", operation.request);
        [self respondSuccess:(NSDictionary *)responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"－－－－－－－－－－出错了");
    }];
}

//新请求接口
//- (void)orderWithOrderId:(NSString *)orderId strDate:(NSString *)strDate
//{
//    //NSString *strD = [strDate stringByReplacingOccurrencesOfString:@" " withString:@"0"];
//    NSString *tokenString = [[UserSingleton sharedInstance] tokenString];
//    NSDictionary *parameters = @{kRespondKeyNewTokenString : tokenString, kRequestKeyNewStrDate : strDate, kRequestKeyNewOrderId : orderId};
//    NSString *postURL = [NSString stringWithFormat:@"%@%@", kHTTPRequestURL, kRequestKeyNewBookedCourse];
//   [self.manager POST:postURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//       NSLog(@".......000000000000.......%@", operation.request);
//       [self respondSuccess:(NSDictionary *)responseObject];
//   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//       NSLog(@"－－－－－－－－－－出错了");
//   }];
//}

//- (void)orderWithPlanID:(NSString *)productID time:(NSString *)timeStamp way:(int)way productType:(NSString *)productType classCount:(int)count
//{
//    NSString *userID = [[[UserSingleton sharedInstance] userInfo] identifier];
//    NSDictionary *parameters = @{kRequestKeyUserID : userID, kRequestKeyPackageID : productID, kRequestKeyTimeStamp : timeStamp, kRequestKeyCourseWay : [NSString stringWithFormat:@"%d", way], kRequestKeyProductType : productType, kRequestKeyClassCount :  [NSString stringWithFormat:@"%d", count]};
//    NSString *postURL = [NSString stringWithFormat:@"%@%@", kHTTPRequestURL, kRequestKeyUserReserveCourse];
//    [self.manager POST:postURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self respondSuccess:(NSDictionary *)responseObject];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"AFHTTPRequestOperation Error:%@", error);
//        NSString *errorInfo = @"订课失败，请检查网络";
//        [self respondFailureWithErrorInfo:errorInfo];
//    }];
//    
//    NSLog(@"URL: %@, parameters:%@", postURL, parameters);
//}

/*
 "user_id":"",
 "package_id":"课程种类id",
 "time":"课程开始时间戳",
 "way":"上课方式，0 QQ,1 电话，2 Skype",
 "lm":"套餐种类id",
 "count":"课程节数"
 }
 */
- (void)respondSuccess:(NSDictionary *)dictionary
{
    NSLog(@"requestSuccess;%@", dictionary);
    int state = [[dictionary objectForKey:kRespondKeyStatus] intValue];
    
    TheErrorInfo *errorInfo = [[TheErrorInfo alloc] init];
    NSDictionary *dicc = [errorInfo TheErrorInfo];
    
    switch (state) {
        case 0:
        {
            int error_code = [[dictionary objectForKey:kRespondKeyErrorCode] intValue];
                NSString *errorInfo = [dicc objectForKey:[NSString stringWithFormat:@"%d",error_code]];
            NSLog(@"errorInfo = %@",errorInfo);
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
            NSString *errorInfo = @"订课失败，服务器错误!";
            [self respondFailureWithErrorInfo:errorInfo];
        }
            break;
    }
}

- (void)respondSuccess
{
    if (_delegate && [_delegate respondsToSelector:@selector(classOrderSuccess)]) {
        [_delegate performSelectorOnMainThread:@selector(classOrderSuccess) withObject:nil waitUntilDone:NO];
    }
    
}

- (void)respondFailureWithErrorInfo:(NSString *)errorInfo
{
    if (_delegate && [_delegate respondsToSelector:@selector(classOrderFailure:)]) {
        [_delegate performSelectorOnMainThread:@selector(classOrderFailure:) withObject:errorInfo waitUntilDone:NO];
    }
    
}

- (void)cancelClassOrder
{
    self.delegate = nil;
    
    if (_manager && [_manager operationQueue]) {
        [[_manager operationQueue] cancelAllOperations];
    }
}

@end
