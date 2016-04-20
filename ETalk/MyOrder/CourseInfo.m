//
//  CourseInfo.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/23.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "CourseInfo.h"

@implementation CourseInfo

//@property (strong, nonatomic) NSString *courseMaterials;
//@property (strong, nonatomic) NSString *coursePackageName;
//@property (strong, nonatomic) NSString *coursePeriod;
//@property (strong, nonatomic) NSString *courseTeacher;
//@property (assign, nonatomic) int courseId;

- (id)initWithEvaluateDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _courseMaterials = [dic objectForKey:kRespondKeyNewCourseMaterials];
        _coursePackageName = [dic objectForKey:kRespondKeyNewCoursePackageName];
        _coursePeriod = [dic objectForKey:kRespondKeyNewCoursePeriod];
        _courseTeacher = [dic objectForKey:kRespondKeyNewCourseTeacher];
        _courseId = [[dic objectForKey:kRespondKeyID] intValue];
    }
    return self;
}

- (id)initWithNewDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _courseMaterials = [dic objectForKey:kRespondKeyNewCourseMaterials];
        _coursePackageName = [dic objectForKey:kRespondKeyNewCoursePackageName];
        _coursePeriod = [dic objectForKey:kRespondKeyNewCoursePeriod];
        _courseTeacher = [dic objectForKey:kRespondKeyNewCourseTeacher];
        _courseId = [[dic objectForKey:kRespondKeyID] intValue];
        _courseClassTime = [dic objectForKey:kRespondKeyNewClassTime];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _identifier = [dic objectForKey:kRespondKeyID];
        _bespeakTime = [dic objectForKey:kRespondKeyBespeakTime];
        _bespeakCount = [dic objectForKey:kRespondKeyBespeakCount];
        _lessionID = [dic objectForKey:kRespondKeyLessionID];
        _bespeakTeaName = [dic objectForKey:kRespondKeyBespeakTeaName];
        _state = [dic objectForKey:kRespondKeyState];
        _teaCommentRank = [dic objectForKey:kRespondKeyTeaCommentRank];
        _teaCommentText = [dic objectForKey:kRespondKeyTeaCommentText];
        _stuCommentRank = [dic objectForKey:kRespondKeyStuCommentRank];
        _stuCommentText = [dic objectForKey:kRespondKeyStuCommentText];
        _title = [dic objectForKey:kRespondKeyTitle];
        _imgSL = [dic objectForKey:kRespondKeyImgSL];
        _bespeakDate = [dic objectForKey:kRespondKeyBespeakDate];
        _bespeakPeriod = [dic objectForKey:kRespondKeyBespeakPeriod];
        _teaEvaluat = [dic objectForKey:kRespondKeyTeaEvaluat];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"CourseInfoList:{\r                identifier = %@\r                bespeakTime = %@\r                bespeakCount = %@\r                lessionID = %@\r                bespeakTeaName = %@\r                state = %@\r                teaCommentRank = %@\r                teaCommentText = %@\r                stuCommentRank = %@\r                title = %@\r                imgSL = %@\r                bespeakDate = %@\r      teaEvaluat = %@          bespeakPeriod = %@"  , _identifier, _bespeakTime, _bespeakCount, _lessionID, _bespeakTeaName, _state, _teaCommentRank, _teaCommentText, _stuCommentRank, _title, _imgSL, _bespeakDate, _teaEvaluat, _bespeakPeriod];
}

@end


@implementation CourseInfoList

- (id)init
{
    self = [super init];
    if (self) {
        _infoList = [[NSMutableArray alloc] init];
    }
    
    return self;
}


@end

