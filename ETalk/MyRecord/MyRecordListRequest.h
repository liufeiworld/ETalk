//
//  MyRecordListRequest.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyRecordListRequestDelegate <NSObject>

- (void)getMyRecordListSuccess;
- (void)getMyRecordListFailure:(NSString *)errorInfo;

@end

@interface MyRecordListRequest : NSObject

@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) NSArray *myRecordList;
@property (strong, nonatomic) NSString *bespeakMonth;

- (void)getMyRecordList;
- (void)cancelGetMyRecordList;

@end