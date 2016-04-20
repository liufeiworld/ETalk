//
//  Userinfo.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/11.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Userinfo : NSObject

//@property (strong, nonatomic) NSString *identifier;
//@property (assign, nonatomic) int level;
//@property (strong, nonatomic) NSString *name;
//@property (assign, nonatomic) long long number;
//@property (strong, nonatomic) NSString *scrore;
//
//@property (strong, nonatomic) NSString *cnName;
//@property (strong, nonatomic) NSString *pictures;
//@property (strong, nonatomic) NSString *qrcode;
//@property (strong, nonatomic) NSString *username;
//@property (strong, nonatomic) NSString *is_sign;
@property (strong, nonatomic) NSString *username;
@property (nonatomic,strong) NSString *password;
@property (strong, nonatomic) NSString *cnName;
@property (strong, nonatomic) NSString *pictures;
@property (strong, nonatomic) NSString *tokenString;
//@property (strong, nonatomic) NSString *is_first_time;
@property (strong, nonatomic) NSString *integral;//积分
@property (strong, nonatomic) NSString *first_members;//班级成员
@property (strong, nonatomic) NSString *second_members;//年级成员
@property (strong, nonatomic) NSString *is_sign;//签到


@end
