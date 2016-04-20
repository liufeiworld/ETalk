//
//  EvaluateRequest.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EvaluateRequestDelegate <NSObject>

- (void)evaluateSuccess;
- (void)evaluateFailure:(NSString *)errorInfo;

@end

@interface EvaluateRequest : NSObject

@property (weak, nonatomic) id delegate;

- (void)evaluateWithText:(NSString *)text score:(NSInteger)score courseID:(NSInteger)courseID;
- (void)cancelEvaluate;

@end