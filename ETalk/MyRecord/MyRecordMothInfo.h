//
//  MyRecordMothInfo.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/6/6.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyRecordMothInfo : NSObject

@property (strong, nonatomic) NSString *bespeakTime;
@property (strong, nonatomic) NSString *identifier;

@property (assign, nonatomic) int courseId;
@property (strong, nonatomic) NSString *courseMaterials;
@property (strong, nonatomic) NSString *coursePackageName;
@property (strong, nonatomic) NSString *coursePeriod;
@property (strong, nonatomic) NSString *courseStuComment;
@property (strong, nonatomic) NSString *courseTeacher;
@property (assign, nonatomic) int courseStuScore;
@property (nonatomic,strong) NSDictionary *teaEvaluat;


- (id)initWithNewDictionary:(NSDictionary *)dic;
- (id)initWithDictionary:(NSDictionary *)dic;

@end

@interface MyRecordInfoList : NSObject

@property (strong, nonatomic) NSString *recordMoth;
@property (strong, nonatomic) NSArray *myRecordMothInfoList;

@end

@interface TeacherEvaluat : NSObject

@property (assign, nonatomic) int accuracyLevel;
@property (strong, nonatomic) NSString *comments;
@property (assign, nonatomic) int fluencyLevel;
@property (assign, nonatomic) int grammarLevel;
@property (strong, nonatomic) NSString *grammarRank;
@property (assign, nonatomic) int listenLevel;
@property (strong, nonatomic) NSString *materialsInfo;
@property (assign, nonatomic) int performanceLevel;
@property (assign, nonatomic) int pronunLevel;
@property (strong, nonatomic) NSString *pronuncRank;
@property (assign, nonatomic) int vocabularyLevel;
@property (assign, nonatomic) int vocabularyRank;

- (id)initWithTeaEvaluatDictionary:(NSDictionary *)dictionary;

@end
