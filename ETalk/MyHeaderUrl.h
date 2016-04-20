
//
//  MyHeaderUrl.h
//  ETalk
//
//  Created by etalk365 on 15/12/21.
//  Copyright © 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#ifndef MyHeaderUrl_h
#define MyHeaderUrl_h

//官网接口URL
#define HttpRequestURL @"http://www.etalk365.cn/interface"

//注册URL
#define app_registerSign_URL  @"http://www.etalk365.com/interface/app_registerSign.action"

//登录URL
#define app_login_URL @"http://www.etalk365.cn/interface/app_login.action"

//教师发起邀请URL
//http://www.etalk365.cn/interface/lessonsList.action?lessons.studentLogin=apple&tokenString=68FCFE159F966D142FFC8A9ED886EF53&lessons.storesId=1
#define TeacherInvitation_URL @"http://www.etalk365.cn/interface/lessonsList.action"

//学生接收邀请URL
//http://www.etalk365.cn/interface/GetClassRoom.action?tokenString=68FCFE159F966D142FFC8A9ED886EF53&classroom.teacherId=teaapple&classroom.studentId=apple&classroom.classtime=2015-10-23T16:00:00&classroom.lessonId=70669&classroom.storesId=1
#define StudentAcceptTheInvitation_URL @"http://www.etalk365.cn/interface/GetClassRoom.action"

//删除教室信息URL
//http://www.192.168.31.134:8080/etalk/interface/CloseClassRoom.action
#define DeleteClassroomInformation_URL @"http://www.etalk365.com/interface/CloseClassRoom.action"

//下载教材信息URL
//http://www.etalk365.com/interface/GetNextPage.action
#define Download_URL @"http://www.etalk365.com/interface/GetNextPage.action"

/**
 老师的评价URL
 */
//http://www.etalk365.cn/interface/app_getClassRecordList.action
#define TeacherEvaluation_URL @"http://www.etalk365.cn/interface/app_getClassRecordList.action"

/**
 快速投诉与评分（强制性）
 */
//http://www.etalk365.com/interface/app_getNotEvaluatedByLastLesson.action?tokenString=68FCFE159F966D142FFC8A9ED886EF53
#define EvaluateView_URL @"http://www.etalk365.com/interface/app_getNotEvaluatedByLastLesson.action"

/**
 快速投诉与评分（非强制性）
 */
//http://www.etalk365.com/interface/app_setStuComplain.action
#define ProposalView_URL @"http://www.etalk365.com/interface/app_setStuComplain.action"


#endif /* MyHeaderUrl_h */
