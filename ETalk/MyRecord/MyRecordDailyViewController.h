//
//  MyRecordDailyViewController.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/5/7.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRecordMothInfo.h"
#import "CourseInfo.h"

@interface MyRecordDailyViewController : UIViewController
@property(nonatomic, strong) NSString *bespeakDay;
@property(nonatomic, strong) MyRecordInfoList *getMyRecordInfoList;
@property (assign, nonatomic) NSInteger score;
@property (nonatomic,strong) CourseInfo *courseInfo;

@end
