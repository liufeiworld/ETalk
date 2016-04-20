//
//  HTTPProduceRequest.m
//  ETalk
//
//  Created by etalk365 on 15/9/9.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "HTTPProduceRequest.h"
#import "AFNetworking.h"
#import "UserSingleton.h"
#import "FirstLevelModel.h"
#import "SecondLevelModel.h"
#import "ThirdLevelModel.h"

@interface HTTPProduceRequest()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation HTTPProduceRequest

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
    return _manager;
}

- (void)startProduceRequest
{
    if ((self.requestType == kHTTPProduceRequestType_UnKown) || (self.respondType == kHTTPProduceRespondType_UnKown)) {
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", kHTTPRequestURL, self.produceSubUrl];
    switch (self.requestType) {
        case kHTTPProduceRequestType_Post:
        {
            [self.manager POST:url parameters:self.producePara success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self respondProduceFinished:(NSDictionary *)responseObject];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
            break;
            
        case kHTTPProduceRequestType_Get:
        {
        
        }
            break;
        default:
            break;
    }
}

- (void)respondProduceFinished:(NSDictionary *)dictionary
{
    //NSLog(@"---------101---------%@", dictionary);
    int state = [[dictionary objectForKey:kRespondKeyStatus] intValue];
    switch (state) {
        case 0:
        {
            NSString *errorInfo = [dictionary objectForKey:kRespondKeyErrorCode];
            [self respondProduceFailure:errorInfo];
        }
            break;
            
        case 1:
        {
            switch (self.respondType) {
                case kHTTPProduceRespondType_Data:
                {
                    id respondProduceData = [dictionary objectForKey:kRespondKeyData];
                    
                    if (respondProduceData)
                    {
                        //[self respondProduceSuccess:respondProduceData];
                        if (((NSArray *) respondProduceData).count > 0)
                        {
                            NSMutableArray *respondProduceArray = [[NSMutableArray alloc] init];
                            NSArray *produceArray = (NSArray *)respondProduceData;
                            for (NSDictionary *firstLevelDictionary in produceArray)
                            {
                                
                                FirstLevelModel *firstLevelProduceModel = [[FirstLevelModel alloc] init];
                                
                                firstLevelProduceModel.firstId = [[firstLevelDictionary objectForKey:@"firstId"] intValue];
                                firstLevelProduceModel.firstIntroduce = [firstLevelDictionary objectForKey:@"firstIntroduce"];
                                firstLevelProduceModel.firstName = [firstLevelDictionary objectForKey:@"firstName"];
                                
                                NSArray *secondListArray = [firstLevelDictionary objectForKey:@"secondList"];
                                NSMutableArray *secondLevelArray = [[NSMutableArray alloc] init];
                                for (NSDictionary *secondLevelDictionary in secondListArray)
                                {
                                    
                                    SecondLevelModel *secondLevelProduceModel = [[SecondLevelModel alloc] init];
                                    
                                    secondLevelProduceModel.secondId = [[secondLevelDictionary objectForKey:@"secondId"] intValue];
                                    secondLevelProduceModel.secondIntroduce = [secondLevelDictionary objectForKey:@"secondIntroduce"];
                                    secondLevelProduceModel.secondName = [secondLevelDictionary objectForKey:@"secondName"];
                                    
                                    NSArray *thirdListArray = [secondLevelDictionary objectForKey:@"packageList"];
                                    NSMutableArray *thirdLevelArray = [[NSMutableArray alloc] init];
                                    
                                    for (NSDictionary *thirdLevelDictionary in thirdListArray)
                                    {
                                        ThirdLevelModel *thirdLevelProduceModel = [[ThirdLevelModel alloc] init];
                                        
                                        thirdLevelProduceModel.everydayClass = [[thirdLevelDictionary objectForKey:@"everydayClass"] intValue];
                                        thirdLevelProduceModel.packageId = [[thirdLevelDictionary objectForKey:@"packageId"] intValue];
                                        thirdLevelProduceModel.packageLessonCount = [[thirdLevelDictionary objectForKey:@"packageLessonCount"] intValue];
                                        thirdLevelProduceModel.packageName = [thirdLevelDictionary objectForKey:@"packageName"];
                                        
                                        thirdLevelProduceModel.packagePrice = [[thirdLevelDictionary objectForKey:@"packagePrice"] intValue];
                                        thirdLevelProduceModel.packageValid = [[thirdLevelDictionary objectForKey:@"packageValid"] intValue];
                                        
                                        [thirdLevelArray addObject:thirdLevelProduceModel];
                                    }
                                    
                                    secondLevelProduceModel.packageListArray = thirdLevelArray;
                                    [secondLevelArray addObject:secondLevelProduceModel];
                                }
                                firstLevelProduceModel.secondListArray = secondLevelArray;
                                [respondProduceArray addObject:firstLevelProduceModel];
                            }
                            
                            if (respondProduceArray.count > 0) {
                                [self respondProduceSuccess:respondProduceArray];
                            }
                        }
                    }
                    else{
                        NSString *errorInfo = @"请求失败,服务器错误";
                        [self respondProduceFailure:errorInfo];
                    }
                }
                    break;
                    
                case kHTTPProduceRespondType_None:
                {
                    [self respondProduceSuccess:nil];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
        {
            NSString *errorInfo = @"请求失败,服务器错误!";
            [self respondProduceFailure:errorInfo];
        }
            break;
    }
}

- (void)respondProduceSuccess:(NSArray *)array
{
    if (_produceDelegate && [_produceDelegate respondsToSelector:@selector(requestProduceSuccess:)]) {
        [_produceDelegate performSelectorOnMainThread:@selector(requestProduceSuccess:) withObject:array waitUntilDone:NO];
    }
}

- (void)respondProduceFailure:(NSString *)errorInfo
{
    if (_produceDelegate && [_produceDelegate respondsToSelector:@selector(requestProduceFailure:)]) {
        [self performSelectorOnMainThread:@selector(requestProduceFailure:) withObject:errorInfo waitUntilDone:NO];
    }
}

- (void)cancelProduceRequest
{
    self.produceDelegate = nil;
    
    if (_manager && [_manager operationQueue]) {
        [[_manager operationQueue] cancelAllOperations];
    }
}

@end
