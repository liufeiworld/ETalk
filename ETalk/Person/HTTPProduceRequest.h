//
//  HTTPProduceRequest.h
//  ETalk
//
//  Created by etalk365 on 15/9/9.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HTTPProduceRespondType) {
    kHTTPProduceRespondType_UnKown     = 0,
    kHTTPProduceRespondType_None       = 1,
    kHTTPProduceRespondType_Data       = 2
};

typedef NS_ENUM(NSUInteger, HTTPProduceRequestType){
    kHTTPProduceRequestType_UnKown     = 0,
    kHTTPProduceRequestType_Post       = 1,
    kHTTPProduceRequestType_Put        = 2,
    kHTTPProduceRequestType_Get        = 3
};

@protocol HTTPProducDelegate <NSObject>

- (void)requestProduceSuccess:(id)respondProduceData;
- (void)requestProduceFailure:(NSString *)errorInfo;

@end

@interface HTTPProduceRequest : NSObject

@property (weak, nonatomic) id produceDelegate;

@property (assign, nonatomic) HTTPProduceRequestType requestType;
@property (assign, nonatomic) HTTPProduceRespondType respondType;

@property (strong, nonatomic) NSString *produceSubUrl;
@property (strong, nonatomic) NSDictionary *producePara;

- (void)startProduceRequest;
- (void)cancelProduceRequest;

@end
