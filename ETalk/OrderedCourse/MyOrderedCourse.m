//
//  MyOrderedCourse.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/5/31.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "MyOrderedCourse.h"

@implementation MyOrderedCourse

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _courseID = [dictionary objectForKey:@"id"];
        _leaveNum = [dictionary objectForKey:@"lession_leaveNum"];
        _lm = [dictionary objectForKey:@"lm"];
        _orderState = [dictionary objectForKey:@"order_state"];
        _payTime = [dictionary objectForKey:@"pay_time"];
        _productID = [dictionary objectForKey:@"product_id"];
        _lessionNum = [dictionary objectForKey:@"product_lessionNum"];
        _title = [dictionary objectForKey:@"product_title"];
        _type = [dictionary objectForKey:@"product_type"];
        _totalMoney = [dictionary objectForKey:@"total_money"];
        _wTime = [dictionary objectForKey:@"wtime"];

    }

    return self;
}

- (id)initWithNewDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _buyTime = [dictionary objectForKey:@"buyTime"];
        _dayCourse = [dictionary objectForKey:@"dayCourse"];
        _leavenum = [dictionary objectForKey:@"leaveNum"];
        _lessonCount = [dictionary objectForKey:@"lessonCount"];
        _materials = [dictionary objectForKey:@"materials"];
        _name1 = [dictionary objectForKey:@"name1"];
        _name2 = [dictionary objectForKey:@"name2"];
        _name3 = [dictionary objectForKey:@"name3"];
        _orderId = [dictionary objectForKey:@"orderId"];
        _payMoney = [dictionary objectForKey:@"payMoney"];
        _price = [dictionary objectForKey:@"price"];
        _valid = [dictionary objectForKey:@"valid"];
        _state = [[dictionary objectForKey:@"state"] intValue];
    }
    return self;
}

@end
