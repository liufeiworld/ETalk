//
//  MyOrderedCourse.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/5/31.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderedCourse : NSObject

@property (strong, nonatomic) NSString *courseID;
@property (strong, nonatomic) NSString *leaveNum;
@property (strong, nonatomic) NSString *lm;
@property (strong, nonatomic) NSString *orderState;
@property (strong, nonatomic) NSString *payTime;
@property (strong, nonatomic) NSString *productID;
@property (strong, nonatomic) NSString *lessionNum;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *totalMoney;
@property (strong, nonatomic) NSString *wTime;



@property (strong, nonatomic) NSString *buyTime;
@property (strong, nonatomic) NSString *dayCourse;
@property (strong, nonatomic) NSString *leavenum;
@property (strong, nonatomic) NSString *lessonCount;
@property (strong, nonatomic) NSString *materials;
@property (strong, nonatomic) NSString *name1;
@property (strong, nonatomic) NSString *name2;
@property (strong, nonatomic) NSString *name3;
@property (strong, nonatomic) NSString *orderId;
@property (strong, nonatomic) NSString *payMoney;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *valid;
@property (assign, nonatomic) int state;


- (id)initWithDictionary:(NSDictionary *)dictionary;

- (id)initWithNewDictionary:(NSDictionary *)dictionary;

@end
