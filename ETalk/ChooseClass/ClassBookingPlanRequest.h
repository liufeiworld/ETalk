//
//  ClassBookingPlanRequest.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ClassBookingPlanRequestDelegate <NSObject>

- (void)getClassBookingPlanSuccess;
- (void)getClassBookingPlanFailure:(NSString *)errorInfo;

@end

@interface ClassBookingPlanRequest : NSObject

@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) NSArray *userPlanList;


- (void)getClassBookingPlan;
- (void)cancelClassBookingPlan;

@end
