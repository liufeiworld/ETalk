//
//  MyRecordDailyTableViewCell.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/5/7.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "MyRecordDailyTableViewCell.h"
#import "MyRecordMothInfo.h"
#import "JsonObjectDic.h"

@interface MyRecordDailyTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *courseTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseTeaLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseTitle;
@property (weak, nonatomic) IBOutlet UIButton *myEvaluateButton;
@property (weak, nonatomic) IBOutlet UIButton *teacherEvaluateButton;
@property (nonatomic,strong)NSDictionary *dic;
@property (nonatomic,strong)NSString *myString;
@property (nonatomic,strong)TeacherEvaluat *teacherEvaluat;

@end

@implementation MyRecordDailyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCourseInfo:(MyRecordMothInfo *)myRecordMothInfo andDateString:(NSString *)dateString
{
    
    UserSingle *single = [UserSingle sharedInstance];
    single.courseId = myRecordMothInfo.courseId;
    
    self.courseTimeLabel.text = [NSString stringWithFormat:@"上课时间：%@ %@", dateString, myRecordMothInfo.coursePeriod];
    
//    UserSingle *single = [UserSingle sharedInstance];
    single.period = myRecordMothInfo.coursePeriod;
    single.dateString = dateString;
    
    self.courseTeaLabel.text = [NSString stringWithFormat:@"上课老师：%@", myRecordMothInfo.courseTeacher];
    self.courseTitle.text = [NSString stringWithFormat:@"学习课程：%@", myRecordMothInfo.coursePackageName];
    BOOL isEvaluated = (myRecordMothInfo.courseStuScore > 0 && myRecordMothInfo.courseStuScore < 6);
    [self setMyEvaluateButtonStyle:isEvaluated];
//    [self setTeacherEvaluateButtonStyle:NO];
    
    
    single.dict = myRecordMothInfo.teaEvaluat;
    
    
    if ([myRecordMothInfo.teaEvaluat isEqual:[NSString stringWithFormat:@""]]) {
        
        [self setTeacherEvaluateButtonStyle:NO];
    }else{
        
        BOOL isTeacherEvaluated = YES;
        [self setTeacherEvaluateButtonStyle:isTeacherEvaluated];
    }
    
}

- (void)setCourseInfo:(CourseInfo *)courseInfo
{
    //NSString *timeFormatedString = [courseInfo.bespeakPeriod stringByReplacingOccurrencesOfString:@"~" withString:@"-"];
    self.courseTimeLabel.text = [NSString stringWithFormat:@"上课时间：%@", courseInfo.bespeakTime];
    self.courseTeaLabel.text = [NSString stringWithFormat:@"上课老师：%@", courseInfo.bespeakTeaName];
    self.courseTitle.text = [NSString stringWithFormat:@"学习课程：%@", courseInfo.title];
    
    BOOL isEvaluated = (([courseInfo.stuCommentRank intValue] > 0) && ([courseInfo.stuCommentRank intValue] < 6));
    [self setMyEvaluateButtonStyle:isEvaluated];
    BOOL isTeacherEvaluated = (([courseInfo.teaCommentRank intValue] > 0) && ([courseInfo.teaCommentRank intValue] < 6));
    
    [self setTeacherEvaluateButtonStyle:isTeacherEvaluated];
    
}

- (void)setMyEvaluateButtonStyle:(BOOL)isEvaluated
{
    if (isEvaluated) {
        self.myEvaluateButton.backgroundColor = UIColorFromRGB(0x1DC96F);
        self.myEvaluateButton.tag = 6045324;
        [self.myEvaluateButton setTitle:@"我的评价" forState:UIControlStateNormal];
    }
    else {
        self.myEvaluateButton.backgroundColor = UIColorFromRGB(0xFC4D26);
        self.myEvaluateButton.tag = 6045384;
        [self.myEvaluateButton setTitle:@"我要评价" forState:UIControlStateNormal];
    }
}

- (void)setTeacherEvaluateButtonStyle:(BOOL)isEvaluated
{
    if (isEvaluated) {
        self.teacherEvaluateButton.backgroundColor = UIColorFromRGB(0xFC860A);
        self.teacherEvaluateButton.tag = 2045324;
        [self.teacherEvaluateButton setTitle:@"查看老师评价" forState:UIControlStateNormal];
    }
    else {
        self.teacherEvaluateButton.backgroundColor = UIColorFromRGB(0xCCCCCC);
        self.teacherEvaluateButton.tag = 2045384;
        [self.teacherEvaluateButton setTitle:@"暂无老师评价" forState:UIControlStateNormal];
    }
}

@end
