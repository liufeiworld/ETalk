//
//  EvaluateDailyTableViewCell.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/5/7.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseInfo.h"

@interface EvaluateDailyTableViewCell : UITableViewCell

- (void)setCourseInfo:(CourseInfo *)courseInfo;

- (void)setCourseInfo:(CourseInfo *)courseInfo andDate:(NSString *)dateString;

@end
