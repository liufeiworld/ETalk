//
//  ClassOrderRequest.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ClassOrderRequestDelegate <NSObject>

- (void)classOrderSuccess;
- (void)classOrderFailure:(NSString *)errorInfo;

@end

@interface ClassOrderRequest : NSObject

@property (weak, nonatomic) id delegate;

//- (void)orderWithPlanID:(NSString *)productID time:(NSString *)timeStamp way:(int)way productType:(NSString *)productType classCount:(int)count;

//- (void)orderWithOrderId:(NSString *)orderId strDate:(NSString *)strDate;

- (void)orderWithNumber:(int)number withOrderId:(NSString *)orderId withStrDate:(NSString *)strDate;

- (void)cancelClassOrder;

@end