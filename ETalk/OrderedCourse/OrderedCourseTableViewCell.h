//
//  OrderedCourseTableViewCell.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/5/30.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderedCourse.h"

@interface OrderedCourseTableViewCell : UITableViewCell

@property(nonatomic,assign) BOOL top,down;

- (void)setCourseInfo:(MyOrderedCourse *)courseInfo;

@end
