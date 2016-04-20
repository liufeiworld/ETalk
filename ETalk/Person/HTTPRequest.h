//
//  HTTPRequest.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HTTPRespondType) {
    kHTTPRespondType_UnKown      = 0,
    kHTTPRespondType_None          = 1,
    kHTTPRespondType_Data           = 2
};

typedef NS_ENUM(NSUInteger, HTTPRequestType) {
    kHTTPRequestType_UnKown      = 0,
    kHTTPRequestType_Post            = 1,
    kHTTPRequestType_Put             = 2,
    kHTTPRequestType_Get             = 3
};

@protocol HTTPRequestDelegate <NSObject>

- (void)requestSuccess:(id)respondData;
- (void)requestFailure:(NSString *)errorInfo;

@end

@interface HTTPRequest : NSObject

@property (weak, nonatomic) id delegate;

@property (assign, nonatomic) HTTPRequestType requestType;
@property (assign, nonatomic) HTTPRespondType respondType;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSDictionary *parameters;


- (void)startRequest;
- (void)cancelRequest;

@end