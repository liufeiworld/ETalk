//
//  ClassBookingPlanRequest.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "ClassBookingPlanRequest.h"

#import "AFNetworking.h"
#import "UserSingleton.h"
#import "UserSingleton.h"
#import "ClassOrderInfo.h"

@interface ClassBookingPlanRequest()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation ClassBookingPlanRequest

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

- (void)getClassBookingPlan
{
    //NSString *userID = [[[UserSingleton sharedInstance] userInfo] identifier];
    NSString *tokenString = [[UserSingleton sharedInstance] tokenString];
    NSDictionary *para = @{kRespondKeyNewTokenString : tokenString};
    NSLog(@"---------%@",tokenString);
    NSString *postURL = [NSString stringWithFormat:@"%@%@", kHTTPRequestURL, kRequestKeyUserGetOrderList];
    [self.manager GET:postURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"0000000%@",operation.request);
        [self respondSuccess:(NSDictionary *)responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorInfo = @"获取课程列表失败，请检查网络";
        [self respondFailureWithErrorInfo:errorInfo];
    }];
    
}

- (void)respondSuccess:(NSDictionary *)dictionary
{
    NSLog(@"requestSuccess;%@", dictionary);
    
    
    if ([[dictionary objectForKey:kRespondKeyStatus] intValue] == 1) {
        NSArray *array = [dictionary objectForKey:kRespondKeyData];
        NSMutableArray *userOrderInfoList = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < array.count; i++) {
            NSDictionary *dic = [array objectAtIndex:i];

            //ClassOrderInfo *orderInfo  = [[ClassOrderInfo alloc] initWithDictionary:dic];
            ClassOrderInfo *orderInfo = [[ClassOrderInfo alloc] initWithNewDictionary:dic];
            [userOrderInfoList addObject:orderInfo];
        }
        
        if (userOrderInfoList.count > 0) {
            self.userPlanList = userOrderInfoList;
        }
    }
    
    if (self.userPlanList) {
        [self respondSuccess];
    }
    else {
        [self respondFailureWithErrorInfo:@"没有购买套餐"];
    }
    
}

- (void)respondSuccess
{
    if (_delegate && [_delegate respondsToSelector:@selector(getClassBookingPlanSuccess)]) {
        [_delegate performSelectorOnMainThread:@selector(getClassBookingPlanSuccess) withObject:nil waitUntilDone:NO];
    }
    
}

- (void)respondFailureWithErrorInfo:(NSString *)errorInfo
{
    if (_delegate && [_delegate respondsToSelector:@selector(getClassBookingPlanFailure:)]) {
        [_delegate performSelectorOnMainThread:@selector(getClassBookingPlanFailure:) withObject:errorInfo waitUntilDone:NO];
    }
    
}

- (void)cancelClassBookingPlan
{
    self.delegate = nil;
    
    if (_manager && [_manager operationQueue]) {
        [[_manager operationQueue] cancelAllOperations];
    }
}

@end
