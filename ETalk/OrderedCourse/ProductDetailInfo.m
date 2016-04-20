//
//  ProductDetailInfo.m
//  ETalk
//
//  Created by Neil on 4/17/15.
//  Copyright (c) 2015 深圳市易课文化科技有限公司. All rights reserved.
//

#import "ProductDetailInfo.h"

#define kRespondKeyProductID         @"id"
#define kRespondKeyCourseList     @"course_list"

#define kRespondKeyCourseID         @"id"

@implementation BuyCourseInfo

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        _indentifier = dic[@"id"];
        _buyCoursesNumber = dic[@"pro_can1"];
        _validDate = dic[@"pro_can2"];
        _price = dic[@"pro_can3"];
        _pricePerMonth = dic[@"pro_can4"];
        _gift = dic[@"f_body"];
    }
    
    return self;
}

@end

@implementation ProductDetailInfo

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        _productID = dic[@"id"];
        _title = dic[@"title"];
        
        NSArray *array = dic[@"course_list"];
        NSMutableArray *courseMutableList = [[NSMutableArray alloc] init];
        for (int i = 0; i < array.count; i++) {
            BuyCourseInfo *courseInfo = [[BuyCourseInfo alloc] initWithDictionary:array[i]];
            [courseMutableList addObject:courseInfo];
        }
        _courseList = [[NSArray alloc] initWithArray:courseMutableList];
    }
    
    return self;
}

@end
