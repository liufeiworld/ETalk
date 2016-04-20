//
//  EvaluateDailyTableViewCell.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/5/7.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "EvaluateDailyTableViewCell.h"

@interface EvaluateDailyTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *courseTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseTeaLabel;

@end

@implementation EvaluateDailyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setCourseInfo:(CourseInfo *)courseInfo andDate:(NSString *)dateString
{
    self.courseTimeLabel.text = [NSString stringWithFormat:@"上课时间：%@ %@", dateString, courseInfo.coursePeriod];
    self.courseTeaLabel.text = [NSString stringWithFormat:@"上课老师：%@", courseInfo.courseTeacher];
}

- (void)setCourseInfo:(CourseInfo *)courseInfo
{
    NSString *timeFormatedString = [courseInfo.bespeakPeriod stringByReplacingOccurrencesOfString:@"~" withString:@"-"];
    self.courseTimeLabel.text = [NSString stringWithFormat:@"上课时间：%@ %@", courseInfo.bespeakDate, timeFormatedString];
    self.courseTeaLabel.text = [NSString stringWithFormat:@"上课老师：%@", courseInfo.bespeakTeaName];
}


@end
