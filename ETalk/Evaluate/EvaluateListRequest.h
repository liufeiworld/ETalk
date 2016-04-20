//
//  EvaluateListRequest.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EvaluateListRequestDelegate <NSObject>

- (void)getEvaluateListSuccess;
- (void)getEvaluateListFailure:(NSString *)errorInfo;

@end

@interface EvaluateListRequest : NSObject

@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) NSArray *evaluateList;

- (void)getEvaluateList;
- (void)cancelGetEvaluateList;

@end