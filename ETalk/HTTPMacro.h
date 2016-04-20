//
//  HTTPMacro.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/11.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#ifndef ETalk_HTTPMacro_h
#define ETalk_HTTPMacro_h

#define kHTTPRequestURL            @"http://www.etalk365.cn/interface/"    //@"http://www.etalk365.mobi:8080/api/v1/"  //@"http:192.168.31.206/interface/"
#define kTimeoutSeconds     12

#pragma mark - Failure

#define kRespondKeyErrorCode        @"error_code"
#define kRespondKeyErrorInfo          @"error_info"

#pragma mark - Login

#define kRequestKeyUserLogin         @"app_login.action"    //@"user_login"
#define kRequestKeyUserName         @"username"
#define kRequestKeyPassword          @"password"

#define kRequestKeyOldPassword      @"oldPassword"

#define kRespondKeyData                @"data"
#define kRespondUserID                  @"user_id"
#define kRespondKeyUserLevel         @"user_level"
#define kRespondKeyUserName        @"user_name"
#define kRespondKeyUserNo            @"user_no"
#define kRespondKeyUserScore         @"user_score"
#define kRespondKeyStatus              @"status"
#define kRespondKeyToken              @"token"

#define kRespondKeyNewCnName        @"cnName"
#define kRespondKeyNewPictures      @"pictures"
#define kRespondKeyNewQrcode        @"qrcode"
#define kRespondKeyNewTokenString   @"tokenString"
#define kRespondKeyNewUserName      @"username"

#define kRequestKeyNewPackageId     @"packageId"


#pragma mark - Register

#define kRequestKeyUserRegister     @"app_register.action"      //@"user_register"
#define kRequestKeyEmail               @"email"
#define kRequestKeyMobile             @"mobile"
#define kRequestKeyInviteCode        @"invite_code"
#define kRequestKeyNewQrcode        @"qrcode"

#pragma mark - Forget Password

#define kRequestKeyUserForgetPassword   @"user_find_password"

#pragma mark - Plan List

#define kRequestKeyUserGetOrderList           @"app_getMyOrderList.action"     //@"user_get_order_list"
#define kRespondKeyPlanID                          @"id"
#define kRespondKeyLessionLeaveNum          @"lession_leaveNum"
#define kRespondKeyOrderState                    @"order_state"
#define kRespondKeyPayTime                       @"pay_time"
#define kRespondKeyProductLM                    @"lm"
#define kRespondKeyProductLessionNum       @"product_lessionNum"
#define kRespondKeyProductTitle                  @"product_title"
#define kRespondKeyProductType                 @"product_type"
#define kRespondKeyTotalMoney                  @"total_money"
#define kRespondKeyWTime                          @"wtime"

//新定义plan list 宏
#define kRespondKeyNewBuyTime               @"buyTime"
#define kRespondKeyNewDayCourse             @"dayCourse"
#define kRespondKeyNewLeaveNum              @"leaveNum"
#define kRespondKeyNewLessonCount           @"lessonCount"
#define KRespondKeyNewMaterial              @"materials"
#define kRespondKeyNewName1                 @"name1"
#define kRespondKeyNewName2                 @"name2"
#define kRespondKeyNewName3                 @"name3"
#define kRespondKeyNewOrderId               @"orderId"
#define kRespondKeyNewPayMoney              @"payMoney"
#define kRespondKeyNewPrice                 @"price"
#define kRespondKeyNewValid                 @"valid"
#define kRespondKeyNewState                 @"state"

#pragma mark - Course Time List

#define kRequestKeyGetCourseTimeList        @"app_getBookedTime.action"             //@"get_course_time_list"
#define kRequestKeyUserID                       @"user_id"
#define kRequestKeyProductID                   @"product_id"
#define kRequestKeyDate                          @"date"
#define kRespondKeyBegin                        @"begin"
#define kRespondKeyPeriod                       @"period"
#define kRespondKeyStatus                       @"status"

#define kRespondKeyNewClassTime             @"classTime"
#define kRespondKeyNewPeriod                @"period"



#define kRequestKeyNewStrDate                @"strDate"
#define kRequestKeyNewOrderId                @"orderId"

#pragma mark -

#define kRequestKeyNewBookedCourse      @"app_setBookedCourse.action"
#define kRequestKeyUserReserveCourse    @"user_reserve_course"
#define kRequestKeyTimeStamp                @"time"
#define kRequestKeyProductType              @"lm"
#define kRequestKeyTimeStamp                @"time"
#define kRequestKeyClassCount               @"count"
#define kRequestKeyCourseWay                @"way"
#define kRequestKeyPackageID                @"package_id"

#pragma mark - Get Course List

#define kRequestKeyUserGetCourseList    @"app_getBookedCourseList.action"  //@"user_get_course_list"


#define kRespondKeyBespeakTime           @"bespeak_time"
#define kRespondKeyBespeakCount          @"bespeak_count"
#define kRespondKeyLessionID                 @"lession_id"
#define kRespondKeyBespeakTeaName      @"bespeak_tea_name"
#define kRespondKeyState                        @"state"
#define kRespondKeyTeaCommentRank     @"tea_comment_rank"
#define kRespondKeyTeaCommentText      @"tea_comment_text"
#define kRespondKeyStuCommentRank      @"stu_comment_rank"
#define kRespondKeyStuCommentText      @"stu_comment_text"
#define kRespondKeyTitle                         @"title"
#define kRespondKeyImgSL                       @"img_sl"
#define kRespondKeyBespeakDate             @"bespeak_date"
#define kRespondKeyBespeakPeriod          @"bespeak_period"
#define kRespondKeyID                           @"id"


#define kRespondKeyNewCourseDate        @"courseDate"
#define kRespondKeyNewCourseList        @"courseList"
#define kRespondKeyNewCourseMaterials   @"materials"
#define kRespondKeyNewCoursePackageName @"packageName"
#define kRespondKeyNewCoursePeriod      @"period"
#define kRespondKeyNewCourseTeacher     @"teacher"
#define kRespondKeyNewCourseClassTime   @"classTime"

#pragma mark - Cancel Course

#define kRequestKeyUserCancelCourse    @"app_cancelCourseByStu.action"      //@"user_cancel_course"
#define kRequestKeyCourseID                 @"course_id"
#define kRequestKeyNewCourseId          @"courseId"

#pragma mark - Get Review Course List

#define kRequestKeyUserGetReviewCourseList    @"app_getEvaluatCourseList.action"           //@"user_get_review_course_list"
#define kRequestKeyPage                                 @"page"
#define kRequestKeyPageSize                           @"page_size"
#define kRequestKeyNewSize                      @"size"


#pragma mark - Review Course

#define kRequestKeySubmitReview           @"app_setStuEvaluate.action"          //@"submit_review"
#define kRequestKeyComment                 @"comment"
#define kRequestKeyScore                       @"score"

#pragma mark - Record List
#define kRequestKeyUserGetRecordList        @"user_get_record_list"
#define kRequestKeyState                            @"state"

#pragma mark - Reset Password
#define kRequestKeyUserResetPassword        @"user_reset_password"
#define kRequestKeyNewPassword                @"password"

#pragma mark - Reset Mobile
#define kRequestKeyUserResetMobile         @"user_reset_mobile"
#define kRequestKeyMobile                       @"mobile"
#define kRequestKeyNewMobile                 @"newMobile"

#define kRequestKeyOldMobile                @"oldMobile"
#define kRequestKeyNewNewMobile             @"mobile"


#pragma mark - Reset QQ
#define kRequestKeyUserResetQQ        @"user_reset_qq"
#define kRequestKeyQQ                       @"qq"

#pragma mark - User Logout
#define kRequestKeyUserLogout        @"user_logout"
#define kRequestKeyUserName          @"username"
#define kRequestKeyBespeakMonth      @"bespeak_month"

#pragma mark - Order

#define kRequestKeyUserBuy           @"save_order_info"

#pragma mark - isSign
#define kRequestKeyIsSign            @"isSign"
#define kRespondKeyIsSign            @"isSign"
#define kRespondKeyThreadFlag            @"ThreadFlag"
#define kRespondKeyTeacherInivte            @"TeacherInivte"
#define kRespondKeyStudentAcceptTheInvitate            @"StudentAcceptTheInvitate"
#define kRespondKeyTeacherId            @"teacherId"
#define kRespondKeyStudentId            @"studentId"
#define kRespondKeyClasstime            @"classtime"
#define kRespondKeyLessonId            @"lessonId"
#define kRespondKeyStoresId            @"storesId"
#define kRespondKeyAddress            @"address"
#define kRespondKeyClassid            @"classid"
#define kRespondKeyMsgport            @"msgport"
#define kRespondKeyMessageCount            @"messageCount"
#define kRespondKeyPage            @"page"
#define kRespondKeyorderBooksId            @"orderBooksId"
#define kRespondKeyfilePath            @"filePath"
#define kRespondKeymyFileHttp            @"myFileHttp"
#define kRespondKeyMyUserName            @"myUserName"
#define kRespondKeyMyPassWord            @"myPassWord"
#define kRespondKeyMyTokenString            @"myTokenString"
#define kRespondKeyEvaluateOfTeacherURL       @"EvaluateOfTeacherURL"
#define kRespondKeyTextView             @"textView"
#define kRespondKeyCourseId             @"courseId"
#define kRespondKeyTeaEvaluat           @"teaEvaluat"
#define kRespondKeyNoSignOfTheBell      @"NoSignOfTheBell"
#define kRespondKeyReminderFlag         @"ReminderFlag"
#define kRespondKeyNoRequestInviteData  @"noRequestInviteData"

#define kRespondKeyDeviceToken          @"deviceToken"
#define kRespondKeyImageOfCRCChecking   @"crcChecking"
#define kRespondKeyTimeInfo             @"timeInfo"

/**web端口参数*/
#define kWebRespondKeyAddress                  @"address"
#define kWebRespondKeyClassId                  @"classId"
#define kWebRespondKeyCurrentPage              @"currentPage"
#define kWebRespondKeyIp                       @"ip"
#define kWebRespondKeyLoginName                @"loginName"
#define kWebRespondKeyMaxPage                  @"maxPage"
#define kWebRespondKeyMsgport                  @"msgport"
#define kWebRespondKeySendLoginName            @"sendLoginName"


#endif
