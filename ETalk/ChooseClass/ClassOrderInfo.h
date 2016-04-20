//
//  ClassOrderInfo.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/8.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassOrderInfo : NSObject

@property (strong, nonatomic) NSString *productID;
@property (strong, nonatomic) NSString *lessionLeaveNum;
@property (strong, nonatomic) NSString *orderState;
@property (strong, nonatomic) NSString *payTime;
@property (strong, nonatomic) NSString *lm;
@property (strong, nonatomic) NSString *productLessionNum;
@property (strong, nonatomic) NSString *productTitle;
@property (strong, nonatomic) NSString *productType;
@property (strong, nonatomic) NSString *totalMoney;
@property (strong, nonatomic) NSString *wtime;

@property (strong, nonatomic) NSString *buyTime;
@property (strong, nonatomic) NSString *dayCourse;
@property (strong, nonatomic) NSString *leaveNum;
@property (strong, nonatomic) NSString *lessonCount;
@property (strong, nonatomic) NSString *materials;
@property (strong, nonatomic) NSString *name1;
@property (strong, nonatomic) NSString *name2;
@property (strong, nonatomic) NSString *name3;
@property (strong, nonatomic) NSString *orderId;
@property (strong, nonatomic) NSString *payMoney;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *valid;
@property (strong, nonatomic) NSString *state;

- (id)initWithNewDictionary:(NSDictionary *)dic;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
