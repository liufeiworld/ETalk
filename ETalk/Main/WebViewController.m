//
//  WebViewController.m
//  ETalk
//
//  Created by etalk365 on 16/2/26.
//  Copyright © 2016年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "WebViewController.h"
#import "WebViewJavascriptBridge.h"
#import <JavaScriptCore/JavaScriptCore.h>

//获取屏幕 宽度、高度
#define SCREEN_FRAME ([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//引导页的URL
#define GUIDEPAGEFIRST_URL @"http://www.etalk365.com/mobile/app/guide/1.png"
#define GUIDEPAGESECONDE_URL @"http://www.etalk365.com/mobile/app/guide/2.png"
#define GUIDEPAGETHIRD_URL @"http://www.etalk365.com/mobile/app/guide/3.png"

#define kTotalFileSize  @"totalSize"

#define kDownloadUrlStr @"http://www.etalk365.com/mobile/app/guide/1.png"


@interface WebViewController ()<UIWebViewDelegate,UITextViewDelegate,NSURLConnectionDataDelegate>
{
    
    NSString *_tokenString;
    NSString *_is_sign;
    UIPageControl *pageControl; //指示当前处于第几个引导页
    
    UIImageView *_showImageView;//展示图片
    //起始点
    CGPoint _beginPoint;
    //结束点
    CGPoint _endPoint;
    //计数
    NSInteger _count1;
    
    UIImage *image1;
    UIImage *image2;
    UIImage *image3;
    NSURL *photourl1;
    NSURL *photourl2;
    NSURL *photourl3;
    NSTimer *_timer;
}
@property (nonatomic ,strong) UIWebView *webView;
@property (strong, nonatomic) LoginRequest *loginRequest;
@property (assign, getter=isAutoLogin, nonatomic) BOOL autoLogin;
@property (strong,nonatomic) UIButton *isSign;
@property (nonatomic,strong) AVAudioPlayer *myPlayer;
@property (nonatomic,assign) NSInteger musicCount;
@property (nonatomic ,strong )WebViewJavascriptBridge *bridge;
/**
 ETWeb平台所使用的URL
 */
@property (nonatomic,strong)NSString *ETWebURL;
/**
 教师发起请求的URL
 */
@property (nonatomic,strong) NSString *SearchURL;
/**
 学生登录成功的URL
 */
@property (nonatomic,strong)NSString *ResponseURL;

@property (nonatomic,assign)long long totalSize;
@property (nonatomic,assign)long long currentSize;

@property (nonatomic,strong)NSURLConnection *downLoadConnection;
//用它来做文件写入操作
@property (nonatomic,strong)NSFileHandle  *fileHandle;

@end

@implementation WebViewController


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    _ETWebURL = @"http://etalk365.com/app/index.html";
//    _ETWebURL = @"http://192.168.31.133/app/index.html";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //状态栏视图
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//    statusBarView.backgroundColor  =  UIColorFromRGB(0x93d140);
    statusBarView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:statusBarView];
    
    [self initDownload];
    
    [self CRCChecking];
    
    
    photourl1 = [NSURL URLWithString:GUIDEPAGEFIRST_URL];
    image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:photourl1]];
    
    photourl2 = [NSURL URLWithString:GUIDEPAGESECONDE_URL];
    image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:photourl2]];
    
    photourl3 = [NSURL URLWithString:GUIDEPAGETHIRD_URL];
    image3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:photourl3]];
    
    _count1 = 1;
    
    _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height)];
    _showImageView.userInteractionEnabled = YES;
    
    
}

- (void)showTimeInfo{

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *timeInfo = [user objectForKey:kRespondKeyTimeInfo];
    
    NSLog(@"timeInfo:%@",timeInfo);
    
    if (timeInfo) {
        static int count = 0;
        count++;
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, self.webView.frame.size.width, 60);
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:11];
        label.backgroundColor = [UIColor blackColor];
        label.text = timeInfo;
        
        label.tag = 121201;
        [self.webView addSubview:label];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(removeLabelTimeInfo) userInfo:nil repeats:NO];
    }
}

- (void)removeLabelTimeInfo{

    UILabel *label = (UILabel *)[self.webView viewWithTag:121201];
    [label removeFromSuperview];
    NSLog(@"5秒后显示的推送消息自动消失");
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRespondKeyTimeInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_timer invalidate];
}

#pragma mark- UITouch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //获得起始点的坐标
    _beginPoint = [[touches anyObject] locationInView:self.view];
    
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    //获得结束点的坐标
    _endPoint = [[touches anyObject] locationInView:self.view];
    
    [self loadingGuidePageOrNot];
}

/**
 判断是否需要加载引导页
 */
- (void)loadingGuidePageOrNot{
    
    //比较横坐标大小
    if (_endPoint.x > _beginPoint.x) {
        //右滑（上一张）
        _count1--;
        if (_count1 == 0) {
            //            _count = 4;
            _count1 = 1;
        }
        
        
    }else if (_endPoint.x < _beginPoint.x){
        //左滑（下一张）
        _count1++;
        if (_count1 == 4) {
            //            _count = 1;
            _count1 = 3;
            
           [self guidePageFinished];
            
        }
        
    }
    
    if (_count1 == 1) {
        
        _showImageView.image = image1;
        pageControl.currentPage = 0;
        
    }else if (_count1 == 2) {
        
        _showImageView.image = image2;
        pageControl.currentPage = 1;
        
    }else if (_count1 == 3) {
        
        _showImageView.image = image3;
        pageControl.currentPage = 2;
    }
    
}


/**
 初始化下载
 */
-(void)initDownload{
    /**
     要判断本地是否已经存在该文件，
     如果存在，则获取到文件的大小
     */
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self getImagedownLoadPath]]) {
        //如果存在该文件,则读取本地文件的属性，并且获取到该文件的大小，赋值给_currentSize
        _currentSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:[self getImagedownLoadPath] error:nil] fileSize];
        
       
        //如果本地文件存在，则说明已经下载过，所以可以从NSUserDefaults获取到文件的总大小
        NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:kTotalFileSize];
        _totalSize  = [number longLongValue];
    }else{
        //如果不存在该文件
        _currentSize =0;
        _totalSize   =0;
    }
}
/**
 获取到qq下载的本地路径
 */
-(NSString *)getImagedownLoadPath{
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"沙盒路径为:%@",path);
    path = [path stringByAppendingPathComponent:@"1.png"];
    return path;
}

- (void)CRCChecking{

    NSURL *url = [NSURL URLWithString:kDownloadUrlStr];
    //创建一个可变的request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    /**
     1.注意！！！！！！！！！服务器接收的值格式为 bytes=%lld-
     2.这条消息的作用是，告诉服务器我要从哪里下载
     3.请求头的key为：Range
     */
    NSString *currentSizeStr = [NSString stringWithFormat:@"bytes=%lld-",_currentSize];
    //把currentsize赋值到请求头里
    [request setValue:currentSizeStr forHTTPHeaderField:@"Range"];
    _downLoadConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    NSLog(@"currentSize:%lld",_currentSize);
    
}


#pragma mark -  NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"接收到服务器响应");
    //文件总大小，等于，需要下载的文件大小＋已经下载了的文件大小
    _totalSize = [(NSHTTPURLResponse *)response expectedContentLength] ;
    if (_currentSize == _totalSize) {
        
//        _signStr = @"YES";
        [self guidePageFinished];
        
        return;
        
    }else{
        
        _showImageView.image = image1;
        [self.view addSubview:_showImageView];
        [self guidePage];
        
    //把获取到的文件大小，存到NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:@(_totalSize) forKey:kTotalFileSize];
    //把数据同步到NSUserDefaults
    [[NSUserDefaults standardUserDefaults] synchronize];
    //判断一下handle是否为空，为空则创建
    if (_fileHandle == nil) {
        //判断文件路径是否存在，不存在，则创建
        if (![[NSFileManager defaultManager] fileExistsAtPath:[self getImagedownLoadPath]]) {
            [[NSFileManager defaultManager] createFileAtPath:[self getImagedownLoadPath] contents:nil attributes:nil];
        }
        _fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:[self getImagedownLoadPath]];
        //把句炳移动到文件尾部
//        [_fileHandle seekToEndOfFile];
    }
        
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    _currentSize = data.length;
    [_fileHandle writeData:data];
}

- (void)sendAction
{
    //    iOS给html发送消息，
    /*
     send:消息的内容
     responseCallback:提供给html回调的方法
     */
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *token = [user objectForKey:kRespondKeyDeviceToken];
    
    NSLog(@"推送所需上传到服务器的DeviceToken信息:%@",token);
    
    [self.bridge send:token responseCallback:^(id responseData) {
        //        responseData:html调用回调方法时，传入的参数
        NSLog(@"response %@", responseData);
    }];
    
    /**
     显示推送信息
     */
//    [self showTimeInfo];
}


/**
 引导页
 */
- (void)guidePage{

    
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 10)];
    pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xbae580);
    pageControl.pageIndicatorTintColor = UIColorFromRGB(0xfafafa);
    [self.view addSubview:pageControl];
    pageControl.numberOfPages=3;
    
}

/**
 引导页加载完毕调用的方法
 */
- (void)guidePageFinished{
    
    [self initWebViewPage];
    [self EstablishingBridgingImplementationAndWebDataExchange];
    [self sendAction];
    [self createBtn];
    
}

/**
 引导页加载完成后建立桥接，并实现与web数据交互（接收web数据与web调用iOS方法）
 */
- (void)EstablishingBridgingImplementationAndWebDataExchange{

    //    在加载请求之前就需要跟bridge建立联系
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView handler:^(id data, WVJBResponseCallback responseCallback) {
        //        data:js传入的消息
        //        responseCallback:js提供的回调方法
        NSLog(@"message: %@", data);
        //        执行回调方法
        //        responseCallback(@[@"1", @"2"]);
        
    }];
    [self.bridge registerHandler:@"classInvitation" handler:^(id data, WVJBResponseCallback responseCallback) {
        //        data：js调用iOS方法“iosMethod”传入的参数
        //        responseCallback：js提供的回调方法
        
        [self classInvitation];
        NSLog(@"data %@", data);
        
        NSString *address = data[@"address"];
        NSString *classId = data[@"classId"];
        NSString *currentPage = data[@"currentPage"];
        NSString *ip = data[@"ip"];
        NSString *loginName = data[@"loginName"];
        NSString *maxPage = data[@"maxPage"];
        NSString *msgport = data[@"msgport"];
        NSString *sendLoginName = data[@"sendLoginName"];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:address forKey:kWebRespondKeyAddress];
        [user setObject:classId forKey:kWebRespondKeyClassId];
        [user setObject:currentPage forKey:kWebRespondKeyCurrentPage];
        [user setObject:ip forKey:kWebRespondKeyIp];
        [user setObject:loginName forKey:kWebRespondKeyLoginName];
        [user setObject:maxPage forKey:kWebRespondKeyMaxPage];
        [user setObject:msgport forKey:kWebRespondKeyMsgport];
        [user setObject:sendLoginName forKey:kWebRespondKeySendLoginName];
        
        responseCallback(@{@"one":@"1", @"two":@"2"});
        
    }];
    
}

/**
 上课邀请
 */
- (void)createBtn{

    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(100, 100, 60, 30);
    [btn1 setTitle:@"Invite" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(classInvitation) forControlEvents:UIControlEventTouchUpInside];
    btn1.backgroundColor = [UIColor blackColor];
    btn1.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.webView addSubview:btn1];
    
//    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn2.frame = CGRectMake(100, 200, 60, 30);
//    [btn2 setTitle:@"Evalute" forState:UIControlStateNormal];
//    [btn2 addTarget:self action:@selector(evaluteAction) forControlEvents:UIControlEventTouchUpInside];
//    btn2.backgroundColor = [UIColor blackColor];
//    btn2.titleLabel.font = [UIFont systemFontOfSize:11];
//    [self.webView addSubview:btn2];
}

///**
// 上课评价
// */
//- (void)evaluteAction{
//    
//    [self performSegueWithIdentifier:@"kkk" sender:nil];
//    
//}

/**
 老师发起网络请求，实现邀请学生上课的功能
 */
- (void)classInvitation{
    
    NSLog(@"上课邀请成功");
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"WebMain" bundle:nil];
    ClassInvitationViewController *ctl = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ClassInvitationViewController"];
    [self presentViewController:ctl animated:YES completion:nil];
    
//    [self performSegueWithIdentifier:@"sss" sender:nil];
    
}


/**
 接收web发过来的消息
 */
-(void)reseveWebViewMessage{
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView handler:^(id data, WVJBResponseCallback responseCallback) {
        //        data:js传入的消息
        //        responseCallback:js提供的回调方法
        NSLog(@"message: %@", data);
        //        执行回调方法
        responseCallback(@[@"1", @"2"]);
    }];
}

/**
 web网页初始化
 */
- (void)initWebViewPage{
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height)];
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    
    [self.view addSubview:self.webView];
    
    NSURL *url = [NSURL URLWithString:_ETWebURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    
    //     加载本地页面
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"indexs" ofType:@"html"];
    //    NSURL *url = [NSURL fileURLWithPath:path];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //
    //    [self.webView loadRequest:request];
}

/**
 以后需要增加的交互功能
 */
//    [self.bridge registerHandler:@"evaluteAction" handler:^(id data, WVJBResponseCallback responseCallback) {
//        //        data：js调用iOS方法“iosMethod”传入的参数
//        //        responseCallback：js提供的回调方法
//        [self evaluteAction];
//        NSLog(@"data %@", data);
//        //        NSLog(@"js调用了iOS中的方法");
//
//        responseCallback(@{@"one":@"1", @"two":@"2"});
//
//    }];


///**
// html给iOS发送消息
// */
//- (void)reseveUserInfo{
//
//    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView handler:^(id data, WVJBResponseCallback responseCallback) {
//        //        data:js传入的消息
//        //        responseCallback:js提供的回调方法
//        NSLog(@"html给iOS发送的消息: %@", data);
//        //        执行回调方法
//        responseCallback(@[@"1", @"2"]);
//    }];
//}
//
//
//
///**
// iOS给html发送消息
// */
//- (void)sendUserInfo{
//
//    [self.bridge send:@[@"字符串1", @"字符串2"] responseCallback:^(id responseData) {
//        //        responseData:html调用回调方法时，传入的参数
//        NSLog(@"iOS给html发送的消息: %@", responseData);
//    }];
//}


@end
