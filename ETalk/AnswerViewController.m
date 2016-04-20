//
//  AnswerViewController.m
//  ETalk
//
//  Created by etalk365 on 15/12/24.
//  Copyright © 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "AnswerViewController.h"
#import "ClassroomViewController.h"
#import "JsonObjectDic.h"
#include "control.h"

#define BEGIN_FLAG @"[/"
#define END_FLAG @"]"

@interface AnswerViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    NSString *_msgCount;
}
//进入教室
- (IBAction)ClassroomAction:(UIButton *)sender;
//发送圆角按钮
@property (weak, nonatomic) IBOutlet UIButton *SendOutBtn;
//教室圆角按钮
@property (weak, nonatomic) IBOutlet UIButton *ClassroomBtn;
//聊天消息数组
//键盘遮挡问题
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewConstraint;

//教师端视频窗口
@property (weak, nonatomic) IBOutlet UIView *teacherVedio;
//学生端视频窗口
@property (weak, nonatomic) IBOutlet UIView *studentVedio;
@property (nonatomic,strong) NSString *student;
@property (nonatomic,strong) NSString *teacher;

@end

@implementation AnswerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
    [self creatCustomUI];
    [self SendOutBtnUI];
    
    // 监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbFrmWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jieShouXiaoXi:) name:@"jieshoudaodexiaoxi" object:nil];
    
}

-(void)jieShouXiaoXi:(NSNotification *)center{
    //    jsonDic[@"data"][@"ShortMessageContent"]
    self.receiveString = center.object;
    //    [self bubbleView:self.receiveString from:NO];
    [self recevWithString:center.object];
    NSLog(@"--self.receiveString---%@",self.receiveString);
    [self.chatTableView reloadData];
}

-(void)recevWithString:(NSString *)info1{
    
    NSMutableString *mString = [NSMutableString stringWithString:_receiveString];
    NSString *str1 = [mString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSDictionary *jsonDic = [JsonObjectDic dictionaryWithJsonString:str2];
    NSLog(@"jsonDic----%@",jsonDic);
    //    NSLog(@"host---->%@",host);
    [self.udpSocket receiveWithTimeout:-1 tag:0];
   	//接收到数据回调，用泡泡VIEW显示出来
    //    NSString *info=[[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    NSString *info = info1;
    
    NSLog(@"info = %@",info);
    
    NSLog(@"_receiveString = %@",jsonDic[@"data"][@"ShortMessageContent"]);
    
    /**
     老师teacher
     */
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    _teacher = [user objectForKey:kRespondKeyTeacherId];
    
    UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@",info] from:NO];
    
    [self.chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:info, @"text", @"teacherSpeak", @"speaker", chatView, @"view", nil]];
    
    UserSingleton *singleton = [UserSingleton sharedInstance];
    int msgCount = [self.chatArray count]/2;
    NSString *msgStrCount = [NSString stringWithFormat:@"%d",msgCount];
    singleton.messageCount = msgStrCount;
    _msgCount = singleton.messageCount;
    
    [user setObject:msgStrCount forKey:kRespondKeyMessageCount];
    
    [self.chatTableView reloadData];
    [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0] atScrollPosition: UITableViewScrollPositionBottom animated:YES];
    
}


#pragma mark - 创建自定义UI
- (void)creatCustomUI{
    
   	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.chatArray = tempArray;
    
    NSMutableString *tempStr = [[NSMutableString alloc] initWithFormat:@""];
    self.messageString = tempStr;
    
    NSDate   *tempDate = [[NSDate alloc] init];
    self.lastTime = tempDate;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.chatTableView setSeparatorColor:[UIColor clearColor]];
    [self openUDPServer];
    
    [self.messageTextField setText:self.messageString];
    [self.chatTableView reloadData];
}

//建立基于UDP的Socket连接
-(void)openUDPServer{
    //初始化udp
    AsyncUdpSocket *tempSocket=[[AsyncUdpSocket alloc] initWithDelegate:self];
    self.udpSocket=tempSocket;
    //绑定端口
    NSError *error = nil;
    [self.udpSocket bindToPort:4333 error:&error];
    [self.udpSocket joinMulticastGroup:@"224.0.0.1" error:&error];
    
   	//启动接收线程
    [self.udpSocket receiveWithTimeout:-1 tag:0];
    
}

#pragma mark - 设置键盘动态高度
-(void)kbFrmWillChange:(NSNotification *)noti{
    
    // 获取窗口的高度
    CGFloat windowH = [UIScreen mainScreen].bounds.size.height;
    // 键盘结束的Frm
    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 获取键盘结束的y值
    CGFloat kbEndY = kbEndFrm.origin.y;
    
    self.inputViewConstraint.constant = windowH - kbEndY;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
    
}

#pragma mark - 设置按钮为圆角
- (void)SendOutBtnUI{

    [_SendOutBtn.layer setMasksToBounds:YES];
    [_SendOutBtn.layer setCornerRadius:7.0];
    
    [_ClassroomBtn.layer setMasksToBounds:YES];
    [_ClassroomBtn.layer setCornerRadius:20.0];
}

#pragma mark - 进入教室点击事件
- (IBAction)ClassroomAction:(UIButton *)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"WebMain" bundle:nil];
    ClassroomViewController *ctl = [story instantiateViewControllerWithIdentifier:@"ClassroomViewController"];
    [self presentViewController:ctl animated:YES completion:nil];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

//发送消息
- (IBAction)sendMessage_Click:(UIButton *)sender {
    
    NSString *messageStr = self.messageTextField.text;
    self.messageString = self.messageTextField.text;
    
    /**********************************发送端的数据打包**********************************/
    //将客户端发送的消息组成JSON包发送到服务器
    _sendString = self.messageTextField.text;
    NSMutableString *sendStr = [NSMutableString stringWithString:_sendString];
    [sendStr appendString:@"\r\n"];
    NSDictionary *dic1 = @{@"ShortMessageContent":sendStr};
    NSDictionary *dic2 = @{@"data":dic1,@"type":@1};
    NSString *jsonString = [JsonObjectDic dictionaryToJson:dic2];
    NSLog(@"发送端的消息组成JSON包:%@",jsonString);
    const  char *acontent = [jsonString UTF8String];
    int lenth = (int)  strlen(acontent);
    WriteContent(acontent, lenth);
    
    if (messageStr == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发送失败！" message:@"发送的内容不能为空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else
    {
        [self sendMassage:messageStr];
    }
    self.messageTextField.text = @"";
    self.messageString = self.messageTextField.text;
    [_messageTextField resignFirstResponder];
    
    
}
//通过UDP,发送消息
-(void)sendMassage:(NSString *)message
{
    
    NSDate *nowTime = [NSDate date];
    
    NSMutableString *sendString=[NSMutableString stringWithCapacity:100];
    [sendString appendString:message];
    //开始发送
    BOOL res = [self.udpSocket sendData:[sendString dataUsingEncoding:NSUTF8StringEncoding] toHost:@"224.0.0.1" port:4333 withTimeout:-1 tag:0];
   	if (!res) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([self.chatArray lastObject] == nil) {
        self.lastTime = nowTime;
        [self.chatArray addObject:nowTime];
    }
    NSTimeInterval timeInterval = [nowTime timeIntervalSinceDate:self.lastTime];
    if (timeInterval >5) {
        self.lastTime = nowTime;
        [self.chatArray addObject:nowTime];
    }
    
    /**
     学生student
     */
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    _student = [user objectForKey:kRespondKeyStudentId];
    
    UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@", message] from:YES];
    [self.chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:message, @"text", @"self", @"speaker", chatView, @"view", nil]];
    
    [self.chatTableView reloadData];
    //随着聊天信息的增多，cell的行数不断上升
    [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0] atScrollPosition: UITableViewScrollPositionBottom animated:YES];
}

#pragma mark Table view methods
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf {
    // build single chat bubble cell with given text
    UIView *returnView =  [self assembleMessageAtIndex:text from:fromSelf];
    returnView.backgroundColor = [UIColor clearColor];
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectZero];
    cellView.backgroundColor = [UIColor clearColor];
    
    UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"bubbleSelf":@"bubble" ofType:@"png"]];
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:20 topCapHeight:14]];
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    
    UILabel *studentLabel = [[UILabel alloc] init];
    UILabel *teacherLabel = [[UILabel alloc] init];
    
    if(fromSelf){
        [headImageView setImage:[UIImage imageNamed:@"1_7_1.png"]];
        returnView.frame= CGRectMake(9.0f, 15.0f, returnView.frame.size.width, returnView.frame.size.height);
        bubbleImageView.frame = CGRectMake(0.0f, 14.0f, returnView.frame.size.width+24.0f, returnView.frame.size.height+24.0f );
        cellView.frame = CGRectMake(self.myView.frame.size.width - 50 -bubbleImageView.frame.size.width, 0.0f,bubbleImageView.frame.size.width+50.0f, bubbleImageView.frame.size.height+30.0f);
        headImageView.frame = CGRectMake(bubbleImageView.frame.size.width, cellView.frame.size.height-50.0f, 40.0f, 40.0f);
        studentLabel.frame = CGRectMake(bubbleImageView.frame.size.width - 10, cellView.frame.size.height-10.0f, 60.0f, 20.0f);
        /**
         获取学生登录名称
         */
        studentLabel.text = _student;
        studentLabel.textAlignment = NSTextAlignmentCenter;
        studentLabel.font = [UIFont systemFontOfSize:9];
        studentLabel.textColor = [UIColor greenColor];
    }else{
        [headImageView setImage:[UIImage imageNamed:@"1_1_2.png"]];
        returnView.frame= CGRectMake(65.0f, 15.0f, returnView.frame.size.width, returnView.frame.size.height);
        bubbleImageView.frame = CGRectMake(50.0f, 14.0f, returnView.frame.size.width+24.0f, returnView.frame.size.height+24.0f);
        cellView.frame = CGRectMake(0.0f, 0.0f, bubbleImageView.frame.size.width+30.0f,bubbleImageView.frame.size.height+30.0f);
        headImageView.frame = CGRectMake(10.0f, cellView.frame.size.height-50.0f, 40.0f, 40.0f);
        teacherLabel.frame = CGRectMake(0.0f, cellView.frame.size.height-10.0f, 60.0f, 20.0f);
        /**
         获取教师登录名称
         */
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *teacherName = [user objectForKey:kRespondKeyUserName];
        teacherLabel.text = teacherName;
        teacherLabel.text = _teacher;
        teacherLabel.textAlignment = NSTextAlignmentCenter;
        teacherLabel.font = [UIFont systemFontOfSize:9];
        teacherLabel.textColor = [UIColor blueColor];
    }
    
    [cellView addSubview:bubbleImageView];
    [cellView addSubview:headImageView];
    [cellView addSubview:returnView];
    [cellView addSubview:studentLabel];
    [cellView addSubview:teacherLabel];
    return cellView;
}

#pragma mark - 将服务器接收到的信息显示到界面上
#pragma mark UDP Delegate Methods
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    
    /*******************************接收端的数据显示*************************************/
    
    //将服务器端接收到的数据解析生成聊天信息在客户端显示
    _receiveString = @"{\"data\":{\"ShortMessageContent\":\"asdf525445454\r\n\"},\"type\":1}";
    
    if ([_receiveString isEqualToString:@"{\"data\":{\"ShortMessageContent\":\"\r\n\"},\"type\":1}"]) {
        
        return nil;
    }
    
    NSMutableString *mString = [NSMutableString stringWithString:_receiveString];
    NSString *str1 = [mString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSDictionary *jsonDic = [JsonObjectDic dictionaryWithJsonString:str2];
    
    NSLog(@"host---->%@",host);
    [self.udpSocket receiveWithTimeout:-1 tag:0];
   	//接收到数据回调，用泡泡VIEW显示出来
    NSString *info=[[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    NSLog(@"info = %@",info);
    
    NSLog(@"_receiveString = %@",jsonDic[@"data"][@"ShortMessageContent"]);
    
    /**
     老师teacher
     */
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    _teacher = [user objectForKey:kRespondKeyTeacherId];
    
    UIView *chatView = [self bubbleView:[NSString stringWithFormat:@"%@",info] from:NO];
    
    [self.chatArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:info, @"text", @"teacherSpeak", @"speaker", chatView, @"view", nil]];
    
    UserSingleton *singleton = [UserSingleton sharedInstance];
    int msgCount = [self.chatArray count]/2;
    NSString *msgStrCount = [NSString stringWithFormat:@"%d",msgCount];
    singleton.messageCount = msgStrCount;
    _msgCount = singleton.messageCount;
    
    [user setObject:msgStrCount forKey:kRespondKeyMessageCount];
    
    [self.chatTableView reloadData];
    [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0] atScrollPosition: UITableViewScrollPositionBottom animated:YES];
    //已经处理完毕
    return YES;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    //无法发送时,返回的异常提示信息
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[error description] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alert show];
    
}
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    //无法接收时，返回异常提示信息
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[error description] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alert show];
}

#pragma mark -
#pragma mark Table View DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chatArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[self.chatArray objectAtIndex:[indexPath row]] isKindOfClass:[NSDate class]]) {
        return 30;
    }else {
        UIView *chatView = [[self.chatArray objectAtIndex:[indexPath row]] objectForKey:@"view"];
        return chatView.frame.size.height+10;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CommentCellIdentifier = @"CommentCell";
    ChatCustomCell *cell = (ChatCustomCell*)[tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier];
    [tableView setSeparatorColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatCustomCell" owner:self options:nil] lastObject];
    }
    
    if ([[self.chatArray objectAtIndex:[indexPath row]] isKindOfClass:[NSDate class]]) {
        // Set up the cell...
        NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss"];
        NSMutableString *timeString = [NSMutableString stringWithFormat:@"%@",[formatter stringFromDate:[self.chatArray objectAtIndex:[indexPath row]]]];
        cell.dateLabel.font = [UIFont systemFontOfSize:13];
        cell.dateLabel.textAlignment = NSTextAlignmentCenter;
        [cell.dateLabel setText:timeString];
        
        
    }else {
        // Set up the cell...
        NSDictionary *chatInfo = [self.chatArray objectAtIndex:[indexPath row]];
        UIView *chatView = [chatInfo objectForKey:@"view"];
        [cell.contentView addSubview:chatView];
    }
    return cell;
}
#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.messageTextField resignFirstResponder];
}

#pragma mark TextField Delegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.messageTextField)
    {
        //		[self moveViewUp];
    }
}

//图文混排
-(void)getImageRange:(NSString*)message : (NSMutableArray*)array {
    NSRange range=[message rangeOfString: BEGIN_FLAG];
    NSRange range1=[message rangeOfString: END_FLAG];
    if (range.length>0 && range1.length>0) {
        if (range.location > 0) {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            if (![nextstr isEqualToString:@""]) {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str :array];
            }else {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
}

#define KFacialSizeWidth  18
#define KFacialSizeHeight 18
#define MAX_WIDTH self.myView.frame.size.width - 180
-(UIView *)assembleMessageAtIndex:(NSString *)message from:(BOOL)fromself
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getImageRange:message :array];
    UIView *returnView = [[UIView alloc] initWithFrame:self.myView.bounds];
    NSArray *data = array;
    UIFont *fon = [UIFont systemFontOfSize:13.0f];
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat X = 0;
    CGFloat Y = 0;
    if (data) {
        for (int i=0;i < [data count];i++) {
            NSString *str=[data objectAtIndex:i];
            NSLog(@"str--->%@",str);
            if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG])
            {
                if (upX >= MAX_WIDTH)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X = MAX_WIDTH;
                    Y = upY;
                }
                NSLog(@"str(image)---->%@",str);
                NSString *imageName=[str substringWithRange:NSMakeRange(2, str.length - 3)];
                UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
                img.frame = CGRectMake(upX, upY, KFacialSizeWidth, KFacialSizeHeight);
                [returnView addSubview:img];
                upX=KFacialSizeWidth+upX;
                if (X<MAX_WIDTH) X = upX;
                
                
            } else {
                for (int j = 0; j < [str length]; j++) {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if (upX >= MAX_WIDTH)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                        X = MAX_WIDTH;
                        Y =upY;
                    }
                    CGSize size=[temp sizeWithFont:fon constrainedToSize:CGSizeMake(MAX_WIDTH, 40)];
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,size.height)];
                    la.font = fon;
                    la.text = temp;
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    upX=upX+size.width;
                    if (X<MAX_WIDTH) {
                        X = upX;
                    }
                }
            }
        }
    }
    returnView.frame = CGRectMake(15.0f,1.0f, X, Y);
    NSLog(@"X = %.1f Y = %.1f", X, Y);
    return returnView;
}

#pragma mark - 横屏的相关实现方法
- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

@end
