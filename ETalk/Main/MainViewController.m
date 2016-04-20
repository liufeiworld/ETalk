//
//  MainViewController.m
//  ETalk
//
//  Created by Neil on 15/3/23.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "UserSingleton.h"
#import "LoginRequest.h"
#import "UIViewController+MBProgressHUD.h"
#import "RKDropdownAlert.h"
#import "AFNetworking.h"
#import "ClassInvitationViewController.h"
#import "UserSingle.h"
#import "EvaluateView.h"
#import "ProposalView.h"
#import <AVFoundation/AVFoundation.h>

@interface MainViewController () <LoginRequestDelegate,UITextViewDelegate>
{

    NSString *_tokenString;
    NSString *_is_sign;
}
@property (strong, nonatomic) LoginRequest *loginRequest;
@property (assign, getter=isAutoLogin, nonatomic) BOOL autoLogin;
@property (strong,nonatomic) UIButton *isSign;
@property (nonatomic,strong) AVAudioPlayer *myPlayer;
@property (nonatomic,assign) NSInteger musicCount;
/**
 教师发起请求的URL
 */
@property (nonatomic,strong) NSString *SearchURL;
/**
 学生登录成功的URL
 */
@property (nonatomic,strong)NSString *ResponseURL;

/**
 老师上课邀请线程NSThread *thread1
 */
@property (nonatomic,strong)NSThread *thread1;
@property (nonatomic,strong)UserSingle *singleton;
@property (nonatomic,strong)NSThread *thread2;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //状态栏视图
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//    statusBarView.backgroundColor  =  UIColorFromRGB(0x9BCB2D);
    statusBarView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusBarView];
    
    [self setupUserHeaderViewConstraints];
    [self setupCostomerHeaderViewConstraints];
    
    self.autoLogin = YES;
    
}

- (void)evaluteAction{

    [self performSegueWithIdentifier:@"kkk" sender:nil];
    
}

#pragma mark - 适配用户头部视图
- (void)setupUserHeaderViewConstraints
{
    if (IS_SMALL_SCREEN_IPHONE) {
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:88.0];
        constraint1.priority = UILayoutPriorityRequired;
        [self.headerView addConstraint:constraint1];
        
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:self.nickNameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.userHeaderView attribute:NSLayoutAttributeTop multiplier:1.0 constant:8.0];
        constraint2.priority = UILayoutPriorityRequired;
        [self.userHeaderView addConstraint:constraint2];
        
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.headImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.userHeaderView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:16.0];
        constraint3.priority = UILayoutPriorityRequired;
        [self.userHeaderView addConstraint:constraint3];
        
        NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.headImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.userHeaderView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        constraint4.priority = UILayoutPriorityRequired;
        [self.userHeaderView addConstraint:constraint4];
    }
    
    if (IS_BIG_SCREEN_IPHONE) {
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:178.0];
        constraint1.priority = UILayoutPriorityRequired;
        [self.headerView addConstraint:constraint1];
        
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:self.nickNameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.userHeaderView attribute:NSLayoutAttributeTop multiplier:1.0 constant:92.0];
        constraint2.priority = UILayoutPriorityRequired;
        [self.userHeaderView addConstraint:constraint2];
        
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.headImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.userHeaderView attribute:NSLayoutAttributeTop multiplier:1.0 constant:16.0];
        constraint3.priority = UILayoutPriorityRequired;
        [self.userHeaderView addConstraint:constraint3];
    }
}

#pragma mark - 适配自定义头部视图
- (void)setupCostomerHeaderViewConstraints
{
    if (IS_SMALL_SCREEN_IPHONE) {
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:88.0];
        constraint1.priority = UILayoutPriorityRequired;
        [self.headerView addConstraint:constraint1];
        
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:self.etalkImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80.0];
        constraint2.priority = UILayoutPriorityRequired;
        [self.etalkImageView addConstraint:constraint2];
        
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.etalkImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:43.5];
        constraint3.priority = UILayoutPriorityRequired;
        [self.etalkImageView addConstraint:constraint3];
        
        NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.etalkImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.customerHeaderView attribute:NSLayoutAttributeTop multiplier:1.0 constant:4.0];
        constraint4.priority = UILayoutPriorityRequired;
        [self.customerHeaderView addConstraint:constraint4];
    }
    
    if (IS_BIG_SCREEN_IPHONE) {
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:178.0];
        constraint1.priority = UILayoutPriorityRequired;
        [self.headerView addConstraint:constraint1];
        
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:self.etalkTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.etalkImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8.0];
        constraint2.priority = UILayoutPriorityRequired;
        [self.customerHeaderView addConstraint:constraint2];
        
        CGFloat length = SCREEN_SHORT / 2 - 155;
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.etalkPhoneLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.customerHeaderView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:length];
        constraint3.priority = UILayoutPriorityRequired;
        [self.customerHeaderView addConstraint:constraint3];
        
        NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.etalkPhoneLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.customerHeaderView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10.0];
        constraint4.priority = UILayoutPriorityRequired;
        [self.customerHeaderView addConstraint:constraint4];
        
        NSLayoutConstraint *constraint5 = [NSLayoutConstraint constraintWithItem:self.etalkNameLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.customerHeaderView attribute:NSLayoutAttributeRight multiplier:1.0 constant:(0 - length)];
        constraint5.priority = UILayoutPriorityRequired;
        [self.customerHeaderView addConstraint:constraint5];
        
        NSLayoutConstraint *constraint6 = [NSLayoutConstraint constraintWithItem:self.etalkNameLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.customerHeaderView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10.0];
        constraint6.priority = UILayoutPriorityRequired;
        [self.customerHeaderView addConstraint:constraint6];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - viewWillAppear:(BOOL)animated
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[UserSingleton sharedInstance] state] == kUserStateLogin) {
        [self showUserInterface];
        
    }
    else {
        [self showCustomerInterface];
    }
}

#pragma mark - 显示用户界面
- (void)showUserInterface
{
    self.customerHeaderView.hidden = YES;
    self.customerFooterView.hidden = YES;
    self.userFooterView.hidden = NO;
    self.userHeaderView.hidden = NO;
    self.loginTagImageView.image = [UIImage imageNamed:@"logo_1_"];

    Userinfo *userInfo = [[UserSingleton sharedInstance] userInfo];
    self.nickNameLabel.text = userInfo.cnName;
    self.studentIDLabel.text = [NSString stringWithFormat:@"用户名: %@", userInfo.username];
    //self.gradeLabel.text = [NSString stringWithFormat:@"推荐码: %@",userInfo.qrcode];
    self.integrationLabel.text = @"";
    
    
    [self requestData];
    [self isSignData];
    
    _thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(thread_start1) object:nil];
    [_thread1 start];
    
    _thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(thread_start2) object:nil];
    [_thread2 start];
    
}

#pragma mark - 显示自定义界面
- (void)showCustomerInterface
{
    self.customerHeaderView.hidden = NO;
    self.customerFooterView.hidden = NO;
    self.userFooterView.hidden = YES;
    self.userHeaderView.hidden = YES;
    self.loginTagImageView.image = [UIImage imageNamed:@"logo_"];
}

#pragma mark - viewDidAppear:(BOOL)animated
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *userName = [Common userName];
    NSString *password = [Common passwordForUserName:userName];
    BOOL isNotLogout  = ([[UserSingleton sharedInstance] state] != kUserStateLogout);
    if (self.isAutoLogin && userName && password && isNotLogout) {
        self.loginRequest = [[LoginRequest alloc] init];
        self.loginRequest.delegate = self;
        [self.loginRequest loginWithUserName:userName password:password];
        [self showHUDWithMessage:nil];
    }
    self.autoLogin = NO;
}

#pragma mark - 登录成功
- (void)loginSuccess
{
    [self hideHUD:NO];
    [self showUserInterface];
}

#pragma mark - 登录失败
- (void)loginFailure:(NSString *)errorInfo
{
    [self hideHUD:NO];
    [RKDropdownAlert title:errorInfo time:1.0];
}

#pragma mark - 我要订课
- (IBAction)orderCourse:(id)sender
{
    if ([[UserSingleton sharedInstance] state] == kUserStateLogin) {
        [self performSegueWithIdentifier:@"MainToClassBookingPlan" sender:sender];
    } else {
        [self login:sender];
    }
}

#pragma mark - 我的预约
- (IBAction)myOrderList:(id)sender
{
    if ([[UserSingleton sharedInstance] state] == kUserStateLogin) {
        [self performSegueWithIdentifier:@"MainToMyOrder" sender:sender];
    } else {
        [self login:sender];
    }
}

#pragma mark - 我要评价
- (IBAction)evaluate:(id)sender
{
    if ([[UserSingleton sharedInstance] state] == kUserStateLogin) {
        [self performSegueWithIdentifier:@"MainToEvaluateList" sender:sender];
    } else {
        [self login:sender];
    }
}

#pragma mark - 我的套餐
- (IBAction)myCoursePlan:(id)sender
{
    if ([[UserSingleton sharedInstance] state] == kUserStateLogin) {
        [self performSegueWithIdentifier:@"MainToOrderedCourse" sender:sender];
    } else {
        [self login:sender];
    }
}

#pragma mark - 我的记录
- (IBAction)myList:(id)sender
{
    if ([[UserSingleton sharedInstance] state] == kUserStateLogin) {
        [self performSegueWithIdentifier:@"MainToCourseList" sender:sender];
    } else {
        [self login:sender];
    }
}

#pragma mark - 登录
- (IBAction)login:(id)sender
{
    [self performSegueWithIdentifier:@"MainToLogin" sender:sender];
    
}

- (void)thread_start1 {
    while(1) {
        
        [self requestInviteData];
        
        [NSThread sleepForTimeInterval:5];
        
        if ([[[UserSingle sharedInstance] noRequestInviteData] isEqualToString:@"noRequestInviteData"]) {
        }
        break;
    }
}

/**实现快速投诉调用线程*/
- (void)thread_start2{

    while (1) {
        
        [self evaluateRequestData];
        
        [NSThread sleepForTimeInterval:5];
    }
}

#pragma mark - 签到实现功能
- (void)isSignData{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *is_sign = [user objectForKey:kRequestKeyIsSign];
    if ([is_sign integerValue] == 0) {
        [_signBtn setTitle:@"未签到" forState:UIControlStateNormal];
        _signBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _signBtn.backgroundColor = [UIColor orangeColor];
    }else if ([is_sign integerValue] == 1){
        [_signBtn setTitle:@"已签到" forState:UIControlStateNormal];
        _signBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _signBtn.backgroundColor = [UIColor orangeColor];
    }
}

#pragma mark - 签到网络请求相关
- (IBAction)signBtnAction:(UIButton *)sender {
    
    [self requestDataSign];
    
}

#pragma mark - 网络请求实现对tokenString信息的缓存
- (void)requestData{
    
    NSUserDefaults *_user  = [NSUserDefaults standardUserDefaults];
    NSString *username = [_user objectForKey:kRespondKeyUserName];
    NSString *password = [_user objectForKey:kRequestKeyPassword];
    
    NSDictionary *parameters = @{@"username":username,@"password":password};
    
    [[AFHTTPRequestOperationManager manager] POST:app_login_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *tokenString = responseObject[@"data"][@"tokenString"];
        [_user setValue:tokenString forKey:kRespondKeyNewTokenString];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 发起网络请求，将sign标志置1，用以作为签到成功标记
- (void)requestDataSign{
    
    NSUserDefaults *user  = [NSUserDefaults standardUserDefaults];
    NSString *username = [user objectForKey:kRespondKeyUserName];
    NSString *password = [user objectForKey:kRequestKeyPassword];
    NSDictionary *parameters = @{@"username":username,@"password":password};
    
    [[AFHTTPRequestOperationManager manager] POST:app_login_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *is_sign = responseObject[@"data"][@"isSign"];
        [user setValue:is_sign forKey:kRequestKeyIsSign];
        
        NSString *tokenString = [user objectForKey:kRespondKeyNewTokenString];
        
        [[AFHTTPRequestOperationManager manager]GET:app_registerSign_URL parameters:@{@"tokenString":tokenString} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [_signBtn setTitle:@"已签到" forState:UIControlStateNormal];
            _signBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            _signBtn.backgroundColor = [UIColor orangeColor];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"error = %@",error);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 发起网络请求,在循环开启的线程中调用接收和拒绝的学生端上课视频
- (void)requestInviteData{
    
    NSString *flag = [NSString stringWithFormat:@"1"];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *tokenString = [user objectForKey:kRespondKeyNewTokenString];
    NSString *username = [user objectForKey:kRespondKeyUserName];
    
    UserSingleton *singleton = [UserSingleton sharedInstance];
    NSString *token = singleton.tokenString;
    
        NSDictionary *TecherParam = @{@"lessons.studentLogin":username,@"tokenString":token,@"lessons.storesId":flag};
    
        [[AFHTTPRequestOperationManager manager]GET:TeacherInvitation_URL parameters:TecherParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *TeacherInivte_URL = [NSString stringWithFormat:@"http://www.etalk365.cn/interface/lessonsList.action?lessons.studentLogin=%@&tokenString=%@&lessons.storesId=%@",username,tokenString,flag];
            
            NSLog(@"TeacherInivte_URL = %@",TeacherInivte_URL);
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:TeacherInivte_URL forKey:kRespondKeyTeacherInivte];
            
            NSString *teacherId = responseObject[@"data"][0][@"teacherLogin"];
            NSString *studentId = responseObject[@"data"][0][@"studentLogin"];
            NSString *classtime = responseObject[@"data"][0][@"releaseTime"];
            NSString *lessonId = responseObject[@"data"][0][@"id"];
            NSString *storesId = @"1";
            NSString *page = responseObject[@"data"][0][@"textbooksPath"][@"page"];
            NSString *orderBooksId = responseObject[@"data"][0][@"orderBooksId"];
            //将网络请求到的数据使用NSUserDefaults进行保存，方便下次调用
            [user setObject:teacherId forKey:kRespondKeyTeacherId];
            [user setObject:studentId forKey:kRespondKeyStudentId];
            [user setObject:classtime forKey:kRespondKeyClasstime];
            [user setObject:lessonId forKey:kRespondKeyLessonId];
            [user setObject:storesId forKey:kRespondKeyStoresId];
            [user setObject:page forKey:kRespondKeyPage];
            [user setObject:orderBooksId forKey:kRespondKeyorderBooksId];
            
            
            NSString *StudentAcceptInvitate_URL = [NSString stringWithFormat:@"http://www.etalk365.cn/interface/GetClassRoom.action?tokenString=%@&classroom.teacherId=%@&classroom.studentId=%@&classroom.classtime=%@&classroom.lessonId=%@&classroom.storesId=%@",tokenString,teacherId,studentId,classtime,lessonId,storesId];
            
            [user setObject:StudentAcceptInvitate_URL forKey:kRespondKeyStudentAcceptTheInvitate];
            
            [[AFHTTPRequestOperationManager manager] GET:StudentAcceptInvitate_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *myDic = responseObject;
                
                NSString *myString = [myDic objectForKey:@"data"];
                
                if ([myString isKindOfClass:[NSString class]]) {
                    
                    
                }else if([myString isKindOfClass:[NSDictionary class]]){
                    
                    /**
                     在该方法中，打上noRequestInviteData标志，标示接收到了老师的邀请后，终止再次发送邀请的网络请求
                     */
                    NSString *noRequestInviteData = @"noRequestInviteData";
                    [user setObject:noRequestInviteData forKey:kRespondKeyNoRequestInviteData];
                    UserSingle *single = [UserSingle sharedInstance];
                    single.noRequestInviteData = noRequestInviteData;
                    
                    NSString *address = responseObject[@"data"][@"address"];
                    NSString *classid = responseObject[@"data"][@"classid"];
                    NSString *msgport = responseObject[@"data"][@"msgport"];
                    
                    [user setObject:address forKey:kRespondKeyAddress];
                    [user setObject:classid forKey:kRespondKeyClassid];
                    [user setObject:msgport forKey:kRespondKeyMsgport];
                    
                    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ClassInvitationViewController *ctl = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ClassInvitationViewController"];
                    
                    single.thread1 = _thread1;
                    single.thread2 = _thread2;
                    
                    [self presentViewController:ctl animated:YES completion:nil];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
}

/**
 快速投诉与评分
 */
- (void)evaluateRequestData{
    
    NSString *token = [[UserSingleton sharedInstance] tokenString];

    [[AFHTTPRequestOperationManager manager] POST:EvaluateView_URL parameters:@{@"tokenString":token} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *status = responseObject[@"status"];
        UserSingle *single = [UserSingle sharedInstance];
        single.status = status;
        if ([status intValue] == 0) {
            
            NSLog(@"已经评价!");
        }else{
        
            NSString *courseId = responseObject[@"data"][@"courseId"];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:courseId forKey:kRespondKeyCourseId];
            [self evaluteAction];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}


@end
