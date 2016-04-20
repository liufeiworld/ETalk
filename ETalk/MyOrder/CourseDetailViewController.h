//
//  CourseDetailViewController.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/27.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CourseInfo;

@interface CourseDetailViewController : UIViewController

@property (strong, nonatomic) CourseInfo *courseInfo;
@property (strong, nonatomic) NSDictionary *getDictionary;

@end
