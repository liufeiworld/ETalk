//
//  ProductDetailInfo.h
//  ETalk
//
//  Created by Neil on 4/17/15.
//  Copyright (c) 2015 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyCourseInfo : NSObject

@property (strong, nonatomic) NSString *indentifier;
@property (strong, nonatomic) NSString *buyCoursesNumber;
@property (strong, nonatomic) NSString *validDate;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *pricePerMonth;
@property (strong, nonatomic) NSString *gift;

- (id)initWithDictionary:(NSDictionary *)dic;

@end

@interface ProductDetailInfo : NSObject

@property (strong, nonatomic) NSString *productID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *courseList;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
