//
//  CourseTimeInfo.h
//  ETalk
//
//  Created by Neil on 4/17/15.
//  Copyright (c) 2015 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseTimeInfo : NSObject

@property (strong, nonatomic) NSString *begin;
@property (assign, nonatomic) int status;


@property (strong, nonatomic) NSString *period;
@property (strong, nonatomic) NSString *classTime;
@property (assign, nonatomic) int state;


//- (id)initWithDictionary:(NSDictionary *)dic;
- (id)initWithNewDictionary:(NSDictionary *)dic;

@end
