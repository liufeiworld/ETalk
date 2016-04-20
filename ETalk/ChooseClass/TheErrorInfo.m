//
//  TheErrorInfo.m
//  ETalk
//
//  Created by etalk365 on 16/1/19.
//  Copyright © 2016年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "TheErrorInfo.h"

@implementation TheErrorInfo

- (NSDictionary *)TheErrorInfo{

    NSDictionary *dic = @{@"1000":@"程序异常",                                              @"1001":@"必填字段不能为空",                                                @"1002":@"邮箱地址无效",                                                   @"1003":@"手机号码无效",                                                    @"1004":@"保存注册信息失败",                                                  @"1005":@"用户或手机号码已存在",                                              @"1006":@"用户不存在",                                                         @"1007":@"赠送课程失败",                                                       @"1008":@"匹配教材失败",                                                          @"1009":@"代金券号错误",                                                        @"1010":@"代金券已使用",                                                        @"1011":@"代金券注册失败",                                                      @"1012":@"今天已签到",                                                          @"1101":@"用户名或密码错误",                                                       @"1102":@"拒绝访问，无效的token",                                                 @"1103":@"token丢失",                                                             @"1104":@"获取Token失败，请重新登录",                                                    @"1105":@"邮箱不存在",                                                         @"1106":@"找回密码邮件发送失败",                                                    @"1107":@"获取订单信息失败",                                                    @"1108":@"获取订单信息异常",                                                    @"1109":@"删除订单失败",                                                    @"1110":@"订单不存在或已支付",                                                    @"1201":@"修改密码失败",                                                    @"1202":@"新密码与原密码相同",                                                    @"1203":@"生成新的token失败",                                                    @"1204":@"修改手机失败",                                                    @"1205":@"新手机号与原手机号相同",                                                    @"1206":@"修改QQ失败",                                                         @"1300":@"获取预约课程时间失败",                                                    @"1301":@"课程已预约满",                                                       @"1302":@"未找到可用的上课套餐",                                                    @"1303":@"此套餐课程已使用完",                                                    @"1304":@"此套餐课程已过期",                                                    @"1305":@"预约课程数超出当天限制",                                                    @"1306":@"尚未设置课程，或您已完成所有课程",                                                    @"1307":@"课程预约失败",                                                    @"1308":@"获取预约课程时间异常",                                                    @"1309":@"预约课程异常",                                                        @"1310":@"您已预约本节课程",                                                     @"1311":@"取消课程失败",                                                       @"1312":@"课程不存在",                                                         @"1313":@"非学生用户，不能预约课程",                                                    @"1314":@"没有数据",                                                           @"1315":@"没有连续课程可预约的老师",                                                    @"1316":@"没有符合要求的上课老师，建议换一个时间或套餐预约",                                                    @"1317":@"银币余额不足",                                                        @"1318":@"金币余额不足",                                                       @"1319":@"钻石余额不足",                                                       @"1501":@"提交评论失败",                                                        @"1601":@"距离上课不足一个小时或课程时间已过，不可以取消课程",                                                  @"1602":@"取消课程失败",                                                    @"1701":@"订购套餐不存在"
 };
    return dic;
}

@end