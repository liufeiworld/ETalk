//
//  ThirdLevelModel.m
//  ETalk
//
//  Created by etalk365 on 15/9/9.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "ThirdLevelModel.h"

@implementation ThirdLevelModel

- (id)initThirdLevelModelWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _everydayClass = [[dictionary objectForKey:@"everydayClass"] intValue];
        _packageId = [[dictionary objectForKey:@"packageId"] intValue];
        _packageLessonCount = [[dictionary objectForKey:@"packageLessonCount"] intValue];
        _packageName = [dictionary objectForKey:@"packageName"];
        _packagePrice = [[dictionary objectForKey:@"packagePrice"] intValue];
        _packageValid = [[dictionary objectForKey:@"packageValid"] intValue];
    }
    return self;
}

@end
