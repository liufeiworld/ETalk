//
//  CourseTimeListRequest.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CourseTimeListRequestDelegate <NSObject>

- (void)getCourseTimeListSuccess;
- (void)getCourseTimeListFailure:(NSString *)errorInfo;

@end

@interface CourseTimeListRequest : NSObject

@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) NSArray *courseTimeList;

- (void)getCourseTimeListWithPlanID:(NSString *)productID date:(NSString *)date;
- (void)cancelGetCourseTimeList;

@end