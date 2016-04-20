//
//  MyWebViewController.m
//  ETalk
//
//  Created by etalk365 on 16/2/26.
//  Copyright © 2016年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "MyWebViewController.h"
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
#import "UserViewController.h"

@interface MyWebViewController () <LoginRequestDelegate,UITextViewDelegate>
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

@implementation MyWebViewController

{
    NSTimer *_timer;//减速定时器
    CGFloat _numOfSubView;//子视图数量
    UIImageView *_circleView;//圆形图
    NSMutableArray *_subViewArray;//子视图数组
    CGPoint beginPoint;//第一触碰点
    CGPoint movePoint;//第二触碰点
    BOOL _isPlaying;//正在跑
    NSDate * date;//滑动时间
    
    NSDate *startTouchDate;
    NSInteger _decelerTime;//减速计数
    CGSize _subViewSize;//子视图大小
    UIPanGestureRecognizer *_pgr;
    
    double mStartAngle;   //转动的角度
    int mFlingableValue;   //转动临界速度，超过此速度便是快速滑动，手指离开仍会转动
    int mRadius;  //半径
    NSMutableArray *btnArray;
    float mTmpAngle;   //检测按下到抬起时旋转的角度
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //状态栏视图
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusBarView.backgroundColor  =  UIColorFromRGB(0x9BCB2D);
    [self.view addSubview:statusBarView];
    
    [self initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width) andImage:[UIImage imageNamed:@"back_"]];
    [self addSubViewWithSubView:nil andTitle:@[@"我要订课",@"我的记录",@"e课学堂",@"我的套餐",@"我要评价",@"我的预约",@"登录",@"设置"] andSize:CGSizeMake(60, 60) andcenterImage:nil];
    
}

- (void)btnAction{
    
    NSLog(@"clicked the btn");
}

-(void)dealloc
{
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
}
-(id)initWithFrame:(CGRect)frame andImage:(UIImage *)image
{
    _decelerTime=0;
    _subViewArray=[[NSMutableArray alloc] init];
    _circleView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height)];
    if(image==nil){
        _circleView.backgroundColor=[UIColor yellowColor];
        //        _circleView.layer.cornerRadius=frame.size.height/2;
        
    }else{
        _circleView.image=image;
        _circleView.backgroundColor=[UIColor clearColor];
    }
    mRadius =frame.size.width;
    mStartAngle = 0;
    mFlingableValue = 200;
    _isPlaying = false;
    _circleView.userInteractionEnabled=YES;
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(10, 150, self.view.frame.size.width/2-25, 60)];
    myView.userInteractionEnabled = YES;
    myView.backgroundColor = [UIColor lightGrayColor];
    [myView.layer setMasksToBounds:YES];
    [myView.layer setCornerRadius:30];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnAction)];
    [myView addGestureRecognizer:tap];
    
    [_circleView addSubview:myView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(myView.frame.size.width-60, 0, 60, 60);
    [btn setTitle:@"cilck" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:30.0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, myView.frame.size.width-60, myView.frame.size.height)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"我的套餐";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [myView addSubview:titleLabel];
    
    [myView addSubview:btn];
    
    [self.view addSubview:_circleView];
    
    return self;
}
#pragma mark -  加子视图
-(void)addSubViewWithSubView:(NSArray *)imageArray andTitle:(NSArray *)titleArray andSize:(CGSize)size andcenterImage:(UIImage *)centerImage
{
    _subViewSize=size;
    if(titleArray.count==0){
        _numOfSubView=(CGFloat)imageArray.count;
    }
    if(imageArray.count==0){
        _numOfSubView=(CGFloat)titleArray.count;
    }
    btnArray = [[NSMutableArray alloc]init];
    for(NSInteger i=0; i<_numOfSubView ;i++){
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(20, 20, size.width, size.height)];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        
        if(imageArray==nil){
            button.backgroundColor=[UIColor clearColor];
            button.layer.cornerRadius=size.width/2;
        }else{
            [button setImage:imageArray[i] forState:UIControlStateNormal];
        }
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.tag=100+i;
        
        if (button.tag == 100) {
            
            //我要订课
            [button setBackgroundImage:[UIImage imageNamed:@"1_1_4"] forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(80, -button.titleLabel.bounds.size.width-70, 0, -button.titleLabel.bounds.size.width-70);//设置title在button上的位置（上top，左left，下bottom，右right）
        }else if (button.tag == 101){
            
            //我的记录
            [button setBackgroundImage:[UIImage imageNamed:@"1_1_7"] forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(80, -button.titleLabel.bounds.size.width-70, 0, -button.titleLabel.bounds.size.width-70);//设置title在button上的位置（上top，左left，下bottom，右right）
        }else if (button.tag == 102){
            
            //e课学堂
            [button setBackgroundImage:[UIImage imageNamed:@"1_1_9"] forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(80, -button.titleLabel.bounds.size.width-70, 0, -button.titleLabel.bounds.size.width-70);//设置title在button上的位置（上top，左left，下bottom，右right）
        }else if (button.tag == 103){
            
            //我的套餐
            [button setBackgroundImage:[UIImage imageNamed:@"1_1_8"] forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(80, -button.titleLabel.bounds.size.width-70, 0, -button.titleLabel.bounds.size.width-70);//设置title在button上的位置（上top，左left，下bottom，右right）
        }else if (button.tag == 104){
            
            //我要评价
            [button setBackgroundImage:[UIImage imageNamed:@"1_1_6"] forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(80, -button.titleLabel.bounds.size.width-70, 0, -button.titleLabel.bounds.size.width-70);//设置title在button上的位置（上top，左left，下bottom，右right）
        }else if (button.tag == 105){
            
            //我的预约
            [button setBackgroundImage:[UIImage imageNamed:@"1_1_5"] forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(80, -button.titleLabel.bounds.size.width-70, 0, -button.titleLabel.bounds.size.width-70);//设置title在button上的位置（上top，左left，下bottom，右right）
        }else if (button.tag == 106){
            
            //登录
            [button setBackgroundImage:[UIImage imageNamed:@"logo_1_"] forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(80, -button.titleLabel.bounds.size.width-70, 0, -button.titleLabel.bounds.size.width-70);//设置title在button上的位置（上top，左left，下bottom，右right）
            
        }else if (button.tag == 107){
            
            //设置
            [button setBackgroundImage:[UIImage imageNamed:@"1_1_3"] forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(80, -button.titleLabel.bounds.size.width-70, 0, -button.titleLabel.bounds.size.width-70);//设置title在button上的位置（上top，左left，下bottom，右right）
            
        }
        
        [btnArray addObject:button];
        [_subViewArray addObject:button];
        [self.view addSubview:button];
    }
    [self layoutBtn];
    
    //中间视图
    UIButton *buttonCenter=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height/1.6, self.view.frame.size.height/1.6)];
    buttonCenter.tag=100+_numOfSubView+1;
    if(centerImage==nil){
        buttonCenter.layer.cornerRadius=self.view.frame.size.height;
        [buttonCenter setBackgroundImage:[UIImage imageNamed:@"1_1_2"] forState:UIControlStateNormal];
        buttonCenter.userInteractionEnabled = NO;
        [buttonCenter setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    }else{
        buttonCenter.layer.cornerRadius=self.view.frame.size.height;
        buttonCenter.backgroundColor=[UIColor redColor];
        [buttonCenter setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        buttonCenter.userInteractionEnabled = NO;
        [buttonCenter setImage:centerImage forState:UIControlStateNormal];
    }
    buttonCenter.center=CGPointMake(self.view.frame.size.width, self.view.frame.size.width-80);
    [_subViewArray addObject:buttonCenter];
    [_circleView addSubview:buttonCenter];
    //加转动手势
    _pgr=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(zhuanPgr:)];
    [_circleView addGestureRecognizer:_pgr];
    //加点击效果
    for (NSInteger i=0; i<_subViewArray.count; i++) {
        UIButton *button=_subViewArray[i];
        [button addTarget:self action:@selector(subViewOut:) forControlEvents:UIControlEventTouchUpOutside];
    }
}


//按钮布局
-(void)layoutBtn{
    
    for (NSInteger i=0; i<_numOfSubView ;i++) {// 178,245
        CGFloat yy=self.view.frame.size.width-75+sin((i/_numOfSubView)*M_PI*2+mStartAngle)*(self.view.frame.size.width/1.5);
        CGFloat xx=self.view.frame.size.width+cos((i/_numOfSubView)*M_PI*2+mStartAngle)*(self.view.frame.size.width/1.5);
        UIButton *button=[btnArray objectAtIndex:i];
        button.center=CGPointMake(xx, yy);
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

NSTimer *flowtime;
float anglePerSecond;
float speed;  //转动速度

#pragma mark - 转动手势
-(void)zhuanPgr:(UIPanGestureRecognizer *)pgr
{
    //    UIView *view=pgr.view;
    if(pgr.state==UIGestureRecognizerStateBegan){
        mTmpAngle = 0;
        beginPoint=[pgr locationInView:self.view];
        startTouchDate=[NSDate date];
    }else if (pgr.state==UIGestureRecognizerStateChanged){
        float StartAngleLast = mStartAngle;
        movePoint= [pgr locationInView:self.view];
        float start = [self getAngle:beginPoint];   //获得起始弧度
        float end = [self getAngle:movePoint];     //结束弧度
        if ([self getQuadrant:movePoint] == 1 || [self getQuadrant:movePoint] == 4) {
            //            mStartAngle += start - end;
            //            mTmpAngle += start - end;
            mStartAngle += end - start;
            mTmpAngle += end - start;
            //            NSLog(@"第一、四象限____%f",mStartAngle);
        } else
            // 二、三象限，色角度值是负值
        {
            //            mStartAngle += end - start;
            //            mTmpAngle += end - start;
            mStartAngle += start - end;
            mTmpAngle += start - end;
            //            NSLog(@"第二、三象限____%f",mStartAngle);
            //             NSLog(@"mTmpAngle is %f",mTmpAngle);
        }
        [self layoutBtn];
        beginPoint=movePoint;
        speed = mStartAngle - StartAngleLast;
        //        NSLog(@"speed is %f",speed);
    }else if (pgr.state==UIGestureRecognizerStateEnded){
        // 计算，每秒移动的角度
        
        NSTimeInterval time=[[NSDate date] timeIntervalSinceDate:startTouchDate];
        anglePerSecond = mTmpAngle*50/ time;
        //        NSLog(@"anglePerSecond is %f",anglePerSecond);
        // 如果达到该值认为是快速移动
        if (fabsf(anglePerSecond) > mFlingableValue && !_isPlaying) {
            // post一个任务，去自动滚动
            _isPlaying = true;
            flowtime = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                        target:self
                                                      selector:@selector(flowAction)
                                                      userInfo:nil
                                                       repeats:YES];
        }
    }
}

//获取当前点弧度

-(float)getAngle:(CGPoint)point {
    double x = point.x - mRadius;
    double y = point.y - mRadius;
    return (float) (asin(y / hypot(x, y)));
}

/**
 * 根据当前位置计算象限
 *
 * @param x
 * @param y
 * @return
 */
-(int) getQuadrant:(CGPoint) point {
    int tmpX = (int) (point.x - mRadius);
    int tmpY = (int) (point.y - mRadius);
    if (tmpX >= 0) {
        return tmpY >= 0 ? 1 : 4;
    } else {
        return tmpY >= 0 ? 2 : 3;
    }
}

-(void)flowAction{
    if (speed < 0.1) {
        _isPlaying = false;
        [flowtime invalidate];
        flowtime = nil;
        return;
    }
    // 不断改变mStartAngle，让其滚动，/30为了避免滚动太快
    mStartAngle += speed ;
    speed = speed/1.1;
    // 逐渐减小这个值
    //    anglePerSecond /= 1.1;
    [self layoutBtn];
}

- (void)btnAction:(UIButton *)sender{
    
    
    //我要订课
    if (sender.tag == 100) {
        
        NSLog(@"我要订课:%ld",(long)sender.tag);
        [self performSegueWithIdentifier:@"IWantToBookClassViewController" sender:nil];
        
    }else if (sender.tag == 101){
        
        //我的记录
        NSLog(@"我的记录:%ld",(long)sender.tag);
        [self performSegueWithIdentifier:@"MyRecordViewController" sender:nil];
        
    }else if (sender.tag == 102){
        
        //e课学堂
        NSLog(@"e课学堂:%ld",(long)sender.tag);
        [self performSegueWithIdentifier:@"ETalkWebViewController" sender:nil];
        
    }else if (sender.tag == 103){
        
        //我的套餐
        NSLog(@"我的套餐:%ld",(long)sender.tag);
        [self performSegueWithIdentifier:@"MyPackgersViewController" sender:nil];
        
    }else if (sender.tag == 104){
        
        //我要评价
        NSLog(@"我要评价:%ld",(long)sender.tag);
        [self performSegueWithIdentifier:@"IWantToEvaluateViewController" sender:nil];
        
    }else if (sender.tag == 105){
        
        //我的预约
        NSLog(@"我的预约:%ld",(long)sender.tag);
        [self performSegueWithIdentifier:@"MyReservationViewController" sender:nil];
        
    }else if (sender.tag == 106){
        
        //登录
        NSLog(@"登录:%ld",(long)sender.tag);
        [self performSegueWithIdentifier:@"MainToLogin" sender:sender];
        
    }else if (sender.tag == 107){
        
        //设置
        NSLog(@"设置:%ld",(long)sender.tag);
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"MyWebMain" bundle:nil];
        UserViewController *ctl = [story instantiateViewControllerWithIdentifier:@"UserViewController"];
        [self presentViewController:ctl animated:YES completion:nil];
        
    }
    
    
}

#pragma mark - viewWillAppear:(BOOL)animated
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[UserSingleton sharedInstance] state] == kUserStateLogin) {
        [self showUserInterface];
        
    }
}

- (void)evaluteAction{
    
    [self performSegueWithIdentifier:@"kkk" sender:nil];
    
}

#pragma mark - 显示用户界面
- (void)showUserInterface
{
    [self requestData];
    
    _thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(thread_start1) object:nil];
    [_thread1 start];
    
    _thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(thread_start2) object:nil];
    [_thread2 start];
    
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
