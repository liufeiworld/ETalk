//
//  SecondLevelModel.h
//  ETalk
//
//  Created by etalk365 on 15/9/9.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecondLevelModel : NSObject

@property (assign, nonatomic) int secondId;
@property (strong, nonatomic) NSString *secondIntroduce;
@property (strong, nonatomic) NSString *secondName;
@property (strong, nonatomic) NSArray *packageListArray;


@end
