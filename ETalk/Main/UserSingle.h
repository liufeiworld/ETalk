//
//  UserSingle.h
//  ETalk
//
//  Created by etalk365 on 16/1/21.
//  Copyright © 2016年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface UserSingle : NSObject

@property (nonatomic,assign) NSInteger count1;
@property (nonatomic,assign) NSInteger count2;
@property (nonatomic,assign) NSInteger count3;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,assign) int countMinute;
@property (nonatomic,strong) AVAudioPlayer *myPlayer;
@property (nonatomic,strong) NSString *period;
@property (nonatomic,strong) NSString *dateString;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,assign) NSInteger musicCount;
@property (nonatomic,strong) NSThread *thread1;
@property (nonatomic,strong) NSThread *thread2;
@property (nonatomic,strong) NSDictionary *teaEvaluat;
@property (nonatomic,strong) NSDictionary *teaEvaluateSecond;
@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,assign) int courseId;
@property (nonatomic,assign) NSString *EvaluateSign;
@property (nonatomic,strong) NSString *noRequestInviteData;
@property (nonatomic,strong) NSString *musicSign;

+ (instancetype)sharedInstance;

@end
