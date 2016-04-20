//
//  ClassOrderInfo.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/8.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "ClassOrderInfo.h"

@implementation ClassOrderInfo

- (id)initWithNewDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _buyTime = [dic objectForKey:kRespondKeyNewBuyTime];
        _dayCourse = [dic objectForKey:kRespondKeyNewDayCourse];
        _leaveNum = [dic objectForKey:kRespondKeyNewLeaveNum];
        _lessonCount = [dic objectForKey:kRespondKeyNewLessonCount];
        _materials = [dic objectForKey:KRespondKeyNewMaterial];
        _name1 = [dic objectForKey:kRespondKeyNewName1];
        _name2 = [dic objectForKey:kRespondKeyNewName2];
        _name3 = [dic objectForKey:kRespondKeyNewName3];
        _orderId = [dic objectForKey:kRespondKeyNewOrderId];
        _payMoney = [dic objectForKey:kRespondKeyNewPayMoney];
        _price = [dic objectForKey:kRespondKeyNewPrice];
        _valid = [dic objectForKey:kRespondKeyNewValid];
        _state = [dic objectForKey:kRespondKeyNewState];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _productID = [dic  objectForKey:kRespondKeyPlanID];
        _lessionLeaveNum = [dic  objectForKey:kRespondKeyLessionLeaveNum];
        _orderState = [dic objectForKey:kRespondKeyOrderState];
        _payTime = [dic objectForKey:kRespondKeyPayTime];
        _lm = [dic objectForKey:kRespondKeyProductLM];
        _productLessionNum = [dic objectForKey:kRespondKeyProductLessionNum];
        _productTitle = [dic  objectForKey:kRespondKeyProductTitle];
        _productType = [dic  objectForKey:kRespondKeyProductType];
        _totalMoney = [dic objectForKey:kRespondKeyTotalMoney];
        _wtime = [dic objectForKey:kRespondKeyWTime];
    }
    
    return self;
}

@end
