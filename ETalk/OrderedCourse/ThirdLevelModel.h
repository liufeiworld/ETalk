//
//  ThirdLevelModel.h
//  ETalk
//
//  Created by etalk365 on 15/9/9.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThirdLevelModel : NSObject

@property (assign, nonatomic) int everydayClass;
@property (assign, nonatomic) int packageId;
@property (assign, nonatomic) int packageLessonCount;
@property (strong, nonatomic) NSString *packageName;
@property (assign, nonatomic) int packagePrice;
@property (assign, nonatomic) int packageValid;

- (id)initThirdLevelModelWithDictionary:(NSDictionary *)dictionary;

@end
