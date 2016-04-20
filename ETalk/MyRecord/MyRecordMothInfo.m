//
//  MyRecordMothInfo.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/6/6.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "MyRecordMothInfo.h"


/*
 data =     (
 {
 "bespeak_time" = "2015-06-02";
 id = 45620;
 }
 );
 status = 1;
 }
 */

@implementation MyRecordMothInfo

- (id)initWithNewDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _courseId = [[dic objectForKey:@"id"] intValue];
        _courseMaterials = [dic objectForKey:@"materials"];
        _coursePackageName = [dic objectForKey:@"packageName"];
        _coursePeriod = [dic objectForKey:@"period"];
        _courseStuComment = [dic objectForKey:@"stuComment"];
        _courseTeacher = [dic objectForKey:@"teacher"];
        _courseStuScore = [[dic objectForKey:@"stuScore"] intValue];
        _teaEvaluat = [dic objectForKey:@"teaEvaluat"];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        _bespeakTime = dic[@"bespeak_time"];
        _identifier = dic[@"id"];
    }
    
    return self;
}


@end

@implementation MyRecordInfoList
@end

@implementation TeacherEvaluat

- (id)initWithTeaEvaluatDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _accuracyLevel = [[dictionary objectForKey:@"accuracyLevel"] intValue];
        _comments = [dictionary objectForKey:@"comments"];
        _fluencyLevel = [[dictionary objectForKey:@"fluencyLevel"] intValue];
        _grammarLevel = [[dictionary objectForKey:@"grammarLevel"] intValue];
        _grammarRank = [dictionary objectForKey:@"grammarRank"];
        _listenLevel = [[dictionary objectForKey:@"listenLevel"] intValue];
        _materialsInfo = [dictionary objectForKey:@"materialsInfo"];
        _performanceLevel = [[dictionary objectForKey:@"performanceLevel"] intValue];
        _pronunLevel = [[dictionary objectForKey:@"pronunLevel"] intValue];
        _pronuncRank = [dictionary objectForKey:@"pronuncRank"];
        _vocabularyLevel = [[dictionary objectForKey:@"vocabularyLevel"] intValue];
        _vocabularyRank = [[dictionary objectForKey:@"vocabularyRank"] intValue];
    }
    return self;
}

@end


















