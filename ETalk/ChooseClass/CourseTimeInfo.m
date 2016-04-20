//
//  CourseTimeInfo.m
//  ETalk
//
//  Created by Neil on 4/17/15.
//  Copyright (c) 2015 深圳市易课文化科技有限公司. All rights reserved.
//

#import "CourseTimeInfo.h"

@implementation CourseTimeInfo

//- (id)initWithDictionary:(NSDictionary *)dic
//{
//    self = [super init];
//    if (self) {
//        _begin = [dic objectForKey:kRespondKeyBegin];
//        _period = [dic objectForKey:kRespondKeyPeriod];
//        _status = [[dic objectForKey:kRespondKeyStatus] intValue];
//    }
//    
//    return self;
//}

- (id)initWithNewDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _classTime = [dic objectForKey:kRespondKeyNewClassTime];
        _period = [dic objectForKey:kRespondKeyNewPeriod];
        _state = [[dic objectForKey:kRespondKeyNewState] intValue];
    }
    return self;
}


@end
