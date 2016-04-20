//
//  MyOrderRequest.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyOrderRequestDelegate <NSObject>

- (void)getMyOrderSuccess;
- (void)getMyOrderFailure:(NSString *)errorInfo;

@end

@interface MyOrderRequest : NSObject

@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) NSArray *orderList;

- (void)getMyOrderList;
- (void)cancelGetMyOrder;

@end