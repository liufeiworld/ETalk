//
//  CourseInfo.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/23.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseInfo : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *bespeakTime;
@property (strong, nonatomic) NSString *bespeakCount;
@property (strong, nonatomic) NSString *lessionID;
@property (strong, nonatomic) NSString *bespeakTeaName;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *teaCommentRank;
@property (strong, nonatomic) NSString *teaCommentText;
@property (strong, nonatomic) NSString *stuCommentRank;
@property (strong, nonatomic) NSString *stuCommentText;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *imgSL;
@property (strong, nonatomic) NSString *bespeakDate;
@property (strong, nonatomic) NSString *bespeakPeriod;


@property (strong, nonatomic) NSString *courseMaterials;
@property (strong, nonatomic) NSString *coursePackageName;
@property (strong, nonatomic) NSString *coursePeriod;
@property (strong, nonatomic) NSString *courseTeacher;
@property (strong, nonatomic) NSString *courseClassTime;
@property (nonatomic,strong) NSString *teaEvaluat;
@property (assign, nonatomic) NSInteger courseId;

- (id)initWithDictionary:(NSDictionary *)dic;
- (id)initWithNewDictionary:(NSDictionary *)dic;
- (id)initWithEvaluateDictionary:(NSDictionary *)dic;


@end


@interface CourseInfoList : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSMutableArray *infoList;

@end
