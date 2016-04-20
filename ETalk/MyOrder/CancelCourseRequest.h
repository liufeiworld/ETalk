//
//  CancelCourseRequest.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CancelCourseRequestDelegate <NSObject>

- (void)cancelCourseSuccess;
- (void)cancelCourseFailure:(NSString *)errorInfo;

@end

@interface CancelCourseRequest : NSObject

@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) NSArray *orderList;

- (void)cancelCourseWithIdentifier:(NSString *)identifier;
- (void)cancel;

@end