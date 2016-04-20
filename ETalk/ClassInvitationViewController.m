//
//  ClassInvitationViewController.m
//  ETalk
//
//  Created by etalk365 on 15/12/24.
//  Copyright © 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "ClassInvitationViewController.h"
#import "AnswerViewController.h"
#import "JsonObjectDic.h"
#import <AVFoundation/AVFoundation.h>
#import "UserSingle.h"
#import "ClassroomViewController.h"
#import <Foundation/Foundation.h>

#include "mq.h"
#import "cr.h"
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <stdlib.h>
#include "control.h"

#define ZhuShi @"/*"
#define ZHU @"*/"

#include "pcm.h"
#include "cr_mgr.h"
#include "control.h"
#include "material.h"
#include "MaterialDrawStream.h"
#include "public.h"

//#include "codec.h"
//#include "../inc/media/jni_main.h"
//#include "../inc/media/camera.h"
//#include "../inc/media/codec.h"
//#include "../inc/media/av.h"
//#include "../inc/media/draw.h"
//#include "../inc/libavcodec/avcodec.h"
//#include "../inc/public_log.h"


long main_conn_addr = 0;
int main_conn_port = 0;
int preview_width = 0;
int preview_height = 0;
char materialParsePath[255];

struct app_desc pad;
struct control_session_param psp;
int Material_Manage_Handle = 0;
int Material_Handle = 0;
int Material_Play_Status = 0;
struct pcm_recoder_param *record_read_pprp = NULL;
void *g_usr = NULL;
//preview_frame_callback g_pfc;

char sdcardPath[255];

struct CreateRoom_Param {
    uint32_t cr_local_handle;
    uint32_t cr_id;
    uint32_t cr_addr;
    uint32_t cr_port;
};

struct Audio_Param {
    //    struct pcm_recoder_param prp;
    //    struct pcm_player_param ppp;
    //    struct aac_encode_param aep;
    //    struct stream_session_param ssp;
    //    struct sockaddr_in addr;
};

struct Video_Param {
    //    struct camera_recoder_param crp;
    //    struct draw_param dp;
    //    struct x264_encode_param xep;
    //    struct stream_session_param ssp;
    //    struct sockaddr_in addr;
    //    int camerahandle;
    //    int drawhandle;
};

struct Create_Stream_Session_Param {
    uint32_t session_handle;
    uint32_t relayed_addr;
    uint32_t relayed_port;
    int Operator;
    int send_stream_msg_handle;
};

struct MaterialDrawStream_Session_Param_desc {
    uint32_t MaterialDrawStreamHandle;
    uint32_t MaterialDrawStream_relayed_addr;
    uint32_t MaterialDrawStream_relayed_port;
    struct sockaddr_in addr;
    int send_mgs_MaterialDrawStream_handle;
    struct MaterialDrawStream_Session_Param mdssp;
    //int heartbeat_time;
    //int heartbeat_state;
    //vector<student_state_param> student_state;
};

struct app_desc {
    struct Audio_Param ap;
    struct Video_Param vp;
    struct CreateRoom_Param cd;
    struct Create_Stream_Session_Param video_cssp;
    struct Create_Stream_Session_Param audio_cssp;
    struct MaterialDrawStream_Session_Param_desc mdsspd;
};

/*test variables start*/
static int h264_enc_handle = -1;
static int h264_dec_handle = -1;

/*test variables end*/



@interface ClassInvitationViewController ()

@property (nonatomic,copy)NSString *filePath;//保存的文件路径
@property (nonatomic,strong)NSFileHandle *fileHandle;//文件操作对象
@property (nonatomic,strong)NSURLConnection *connection;//连接对象
@property (nonatomic,strong)NSThread *thread;
@property (nonatomic,strong)NSString *suffixName;//后缀名
//@property (nonatomic,assign)NSInteger *myMusic;
@property (nonatomic,strong)NSThread *classMusicThread;

//会话回调所需要参数
@property(nonatomic,strong)NSMutableDictionary *mDic;
@property(nonatomic,strong)NSMutableDictionary *data;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,assign)int len;

@property(nonatomic,strong)NSString *marketData;
@property(nonatomic,strong)NSDictionary *marketDic;
//教材存放沙盒路径
@property(nonatomic,strong)NSString *pathDocuments;
// 网络请求体
@property (nonatomic,strong)NSURLConnection *downLoadConnection;

//页数
@property(nonatomic,strong)NSString *pages;
@property(nonatomic,strong)NSString *JCURL;

/**
 负责，把下载接收到的数据，写到沙盒中(会追加数据到同一个文件的尾部)
 */
//用来展示下载进度
@property (weak, nonatomic)  UIProgressView *progressView;
/**
 totalSize   用来存储文件的总大小
 currentSize 用来存储已经下载了的文件大小
 */
@property (nonatomic,assign)long long totalSize;
@property (nonatomic,assign)long long currentSize;
@end

@implementation ClassInvitationViewController

- (NSString *)suffixName{

    if (!_suffixName) {
        
        _suffixName = [[NSString alloc] init];
    }
    return _suffixName;
}

-(NSString *)filePath{
    if (!_filePath) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *page = [user objectForKey:kRespondKeyPage];
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSString *pathDocuments=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *createPath=[NSString stringWithFormat:@"%@/P%@",pathDocuments,page];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:createPath])
        {
            [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        else
        {
            NSLog(@"Have");
        }
        
        NSLog(@"下载教材资料路径:%@",createPath);
        
        _filePath = [createPath stringByAppendingString:[NSString stringWithFormat:@"/P%@%@",page,@".et3"]];
        NSLog(@"下载教材资料:%@",_filePath);
    }
    return _filePath;
}

-(NSFileHandle *)fileHandle{
    if (!_fileHandle) {
        //以读写权限打开文件
        _fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:self.filePath];
    }
    return _fileHandle;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView{

    [super loadView];
    
    UserSingle *single = [UserSingle sharedInstance];
    [single.thread1 cancel];
    [single.thread2 cancel];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    NSString *musicSign = [[UserSingle sharedInstance] musicSign];
    musicSign = @"no";
    
    /**
     邀请时的音乐提醒
     */
    NSURL *fileUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"attend_class" ofType:@"mp3"]];
    _myPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
    
    
    //    _answerImage.image = [UIImage imageNamed:@"1_1_2"];
    
    UserSingle *single = [UserSingle sharedInstance];
    [single.thread1 cancel];
    [single.thread2 cancel];
    
    self.navigationController.navigationBarHidden = YES;
    
    _classMusicThread = [[NSThread alloc] initWithTarget:self selector:@selector(classInvitateMusic) object:nil];
    [_classMusicThread start];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //圆角按钮事件
    [self roundButtonAction];
    
    self.thread = [[NSThread alloc]initWithTarget:self selector:@selector(downLoadBook) object:nil];
    [self.thread start];
    
}

- (void)classInvitateMusic{

    while (1) {
        
        if ([_classMusicThread isCancelled]) {
            
            /**
             把他写到哪个线程里，哪个线程就会退出
             相当于咱们经常用的return
             */
            [NSThread exit];
        }
        
        [self playTheMusic];
        
        if ([[[UserSingle sharedInstance] musicSign] isEqualToString:@"yes"]) {
            
            break;
        
        }
    }
}

//下载教材信息
- (void)downLoadBook{

    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *tokenSring = [user objectForKey:kRespondKeyNewTokenString];
    NSString *page = [user objectForKey:kRespondKeyPage];
    NSString *orderBooksId = [user objectForKey:kRespondKeyorderBooksId];
    NSString *viewModel1 = @"0";
    NSString *storesId = @"1";
    NSString *pageModel = @"2";
    
    NSLog(@"orderBooksId = %@",orderBooksId);
    NSLog(@"page = %@",page);
    if (page == nil) {
        
        return;
    }
    
    NSDictionary *param = @{@"tokenString":tokenSring,@"viewModel":viewModel1,@"orderBooks.id":orderBooksId,@"page":page,@"orderBooks.storesId":storesId,@"pageMode":pageModel};
    [[AFHTTPRequestOperationManager manager] GET:Download_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"responseObject = %@",responseObject);
        NSString *filePath = responseObject[@"data"][@"filePath"];
        [user setObject:filePath forKey:kRespondKeyfilePath];
        NSLog(@"filePath = %@",filePath);
        
        NSString *myFileHttp = [NSString stringWithFormat:@"%@/%@",HttpRequestURL,filePath];
        [user setObject:myFileHttp forKey:kRespondKeymyFileHttp];
        
        //可变请求类对象
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:myFileHttp]];
        NSFileManager *manager = [NSFileManager defaultManager];
        //判断本地是否有残余的文件存在
        if (![manager fileExistsAtPath:self.filePath]) {
            [manager createFileAtPath:self.filePath contents:nil attributes:0];
            self.connection =  [NSURLConnection connectionWithRequest:request delegate:self];
        }else{
            [self.fileHandle seekToEndOfFile];
            //偏移量的大小，就是已经下载的文件的字节数大小
            long long totalLength = self.fileHandle.offsetInFile;
            //请求头当中设置Range字段
            [request addValue:[NSString stringWithFormat:@"bytes=%lld-",totalLength] forHTTPHeaderField:@"Range"];
            //发起请求
            self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error = %@",error);
    }];
    
}

//设置圆角按钮
- (void)roundButtonAction{

    [_refuseBtn.layer setMasksToBounds:YES];
    [_refuseBtn.layer setCornerRadius:7.0];
    
    [_answerBtn.layer setMasksToBounds:YES];
    [_answerBtn.layer setCornerRadius:7.0];
    
}

- (void)playTheMusic{

    [_myPlayer play];
    
    [NSThread sleepForTimeInterval:1.5];
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

//拒绝
- (IBAction)refuseActionrefuseAction:(UIButton *)sender {
    
    NSString *musicSign = [[UserSingle sharedInstance] musicSign];
    musicSign = @"yes";
    //学生点击事件
    [self StudentClickEvent];
    
    [_myPlayer pause];
    [_classMusicThread cancel];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//创建教室管理事件

-(void)creatManager{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:self.filePath]) {
        [manager createFileAtPath:self.filePath contents:nil attributes:0];
    }
    const char *path = [_pathDocuments UTF8String];
    NSLog(@"--__--%s",path);
    _createMaterialManager(path);
}


//接听
- (IBAction)answerAction:(UIButton *)sender {
    
    //    用户信息储存
    //    [user setObject:address forKey:kWebRespondKeyAddress];
    //    [user setObject:classId forKey:kWebRespondKeyClassId];
    //    [user setObject:currentPage forKey:kWebRespondKeyCurrentPage];
    //    [user setObject:ip forKey:kWebRespondKeyIp];
    //    [user setObject:loginName forKey:kWebRespondKeyLoginName];
    //    [user setObject:maxPage forKey:kWebRespondKeyMaxPage];
    //    [user setObject:msgport forKey:kWebRespondKeyMsgport];
    //    [user setObject:sendLoginName forKey:kWebRespondKeySendLoginName];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSInteger ip = [[user objectForKey:kWebRespondKeyIp] integerValue];
    int msgport = [[user objectForKey:kWebRespondKeyMsgport] intValue];
    
    _mDic = [NSMutableDictionary dictionary];
    _data = [NSMutableDictionary dictionary];
    
    NSString *loginName = [user objectForKey:kWebRespondKeyLoginName];
    [_data setObject:loginName forKey:@"UserName"];
    [_data setObject:@(1) forKey:@"EnterClassroomType"];
    [_data setObject:@(CRCMD_ENTER_CLASSROOM) forKey:@"type"];
    
    [_mDic setObject:_data forKey:@"data"];
    [_mDic setObject:@(CRCMD_ENTER_CLASSROOM) forKey:@"type"];
    _content = [self dictionaryToJson:_mDic];
    _len = (int)[_content length];
    //存储有效信息
    [user setObject:_content forKey:@"content"];
    [user setObject:@(_len) forKey:@"len"];
    
    [self createClassRoomWithAddress:ip andPort:msgport];
    [self creatManager];
    
    
    NSString *musicSign = [[UserSingle sharedInstance] musicSign];
    musicSign = @"yes";
    //学生点击事件
    [self StudentClickEvent];
    
    [_myPlayer pause];
    [_classMusicThread cancel];
    
    
    [self performSelectorOnMainThread:@selector(jumpToClassRoom) withObject:nil waitUntilDone:NO];
}
//字典转换成字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


/**刷新UI,进入上课界面*/
- (void)jumpToClassRoom{

    UIStoryboard *story = [UIStoryboard storyboardWithName:@"WebMain" bundle:nil];
    AnswerViewController *ctl = [story instantiateViewControllerWithIdentifier:@"AnswerViewController"];
    [self presentViewController:ctl animated:YES completion:nil];
    
}

#pragma mark - 学生点击事件
- (void)StudentClickEvent{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *teacherId = [user objectForKey:kRespondKeyTeacherId];
    NSString *studentId = [user objectForKey:kRespondKeyStudentId];
    NSString *classtime = [user objectForKey:kRespondKeyClasstime];
    NSString *lessonId = [user objectForKey:kRespondKeyLessonId];
    NSString *storesId = [user objectForKey:kRespondKeyStoresId];
    NSString *tokenString = [user objectForKey:kRespondKeyNewTokenString];
    
    if (teacherId == nil ) {
    }else{
    
        NSDictionary *param = @{@"tokenString":tokenString,@"classroom.teacherId":teacherId,@"classroom.studentId":studentId,@"classroom.classtime":classtime,@"classroom.lessonId":lessonId,@"classroom.storesId":storesId};
        [[AFHTTPRequestOperationManager manager] POST:DeleteClassroomInformation_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

#pragma mark- NSURLConnectionDataDelegate

//接收到服务器传递的数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    //写入到本地
    [self.fileHandle writeData:data];
}
//已经完成下载
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSDictionary *dic1 = @{@"state":@1,@"type":@1};
    NSDictionary *dic2 = @{@"data":dic1,@"type":@2};
    NSString *downloadJSON = [JsonObjectDic dictionaryToJson:dic2];
    NSLog(@"教材下载结束后的JSON组包:%@",downloadJSON);
    
}

//#pragma mark - 保持竖屏VS默认竖屏
//-(NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}


-(void)createClassRoomWithAddress:(NSInteger)address andPort:(int)port{
    struct sockaddr_in addr_in;
    
    memset(&psp, 0, sizeof(struct control_content_param));
    memset(&pad, 0, sizeof(struct app_desc));
    
    //    g_object = (*env)->NewGlobalRef(env, thiz);
    
    main_conn_addr = address;
    main_conn_port = port;
    
    memset(&addr_in, 0, sizeof(struct sockaddr_in));
    
    if (pad.cd.cr_local_handle == 0 || pad.cd.cr_local_handle == 0xffffffff) {
        printf("---------%d" ,create_classroom(&addr_in, callbackCreateClassroom, &pad, ROLE_TYPE_STUDENT));
    } else {
        
    }
}


void callbackCreateClassroom(void *usr, struct event_desc *ped) {
    struct to_app_cr_handle *ptach = (struct to_app_cr_handle *) ped->data;
    
    
    switch (ped->evt_id) {
        case TO_APP_CR_HANDLE:
            if (ptach->cr_local_handle == -1) {
                // 通知上层classroom创建失败
                printf("%s,TO_APP_CR_HANDLE,create classroom fail\n", __FUNCTION__);
            } else {
                printf("%s,TO_APP_CR_HANDLE,create classroom success\n", __FUNCTION__);
                psp.ec = callbackCtrlSession;
                psp.protocol = IPPROTO_TCP;
                psp.srv_cr_addr.sin_family = AF_INET;
                psp.srv_cr_addr.sin_addr.s_addr = htonl(main_conn_addr);
                psp.srv_cr_addr.sin_port = htons(main_conn_port);
                psp.role = ROLE_TYPE_STUDENT;
                psp.usr = &psp;
                Send_BusinessMsg(ptach->cr_local_handle, FROM_UI_CREATE_CTLSESSION, &psp, NULL, NULL);
            }
            break;
        default:
            break;
    }
}

-(void)WriteContentWithChar:(char *)content len:(int)len{
    
}


void callbackCtrlSession(void *usr, struct event_desc *ped) {
    struct to_app_session_handle *ptash = NULL;
    struct to_app_session_recv_data *ptasrd = NULL;
    struct to_app_session_writable *ptasw = NULL;
    
    switch (ped->evt_id) {
        case TO_APP_SESSION_HANDLE:
            ptash = (struct to_app_session_handle *) (ped->data);
            if ((ptash->session_handle != 0xFFFFFFFF) && (ptash->session_handle != 0)) {
                // ctrl session create success
                //                jni_main(CONFIRM_ENTER_CLASSROOM, NULL, 0);
                printf("%s,TO_APP_SESSION_HANDLE,success\n", __FUNCTION__);
                //               取出用户信息
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSString *content =  [user objectForKey:@"content"];
                NSNumber *len = [user objectForKey:@"len"];
                //                NSLog(@"content%@  ----  len%@ ",content,len);
                
                const  char *acontent = [content UTF8String];
                int lenth = (int)  strlen(acontent);
                printf("=====> length=%d, acontent:%s", lenth, acontent);
                WriteContent(acontent, lenth);
            } else {
                //                jni_main(SESSION_CHECK_REMOVE, NULL, 0);
                printf("%s,TO_APP_SESSION_HANDLE,fail\n", __FUNCTION__);
                
            }
            break;
        case TO_APP_SESSION_RECV_DATA: {
            printf("%s,TO_APP_SESSION_RECV_DATA\n", __FUNCTION__);
            ptasrd = (struct to_app_session_recv_data *) (ped->data);
            printf("recv data: length = %d, data: %s", ptasrd->data_len, ptasrd->data);
            
            int lens = ptasrd->data_len;
            char a[1024];
            memset(a, 0, sizeof(a)/sizeof(a[0]));
            const char *data = (const char *)ptasrd -> data;
            strncpy(a, data, lens);
            
            
            NSString *marketData = [NSString stringWithCString:a encoding:NSASCIIStringEncoding];
            NSLog(@"%@",marketData);
            ClassInvitationViewController *view = [[ClassInvitationViewController alloc]init];
            //            [view reload];
            
            NSData *Data = [marketData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *marketDic = [NSJSONSerialization JSONObjectWithData:Data options:NSJSONReadingMutableLeaves error:nil];
            
            
            
            //             NSDictionary *marketDic = [view dictionaryWithString:marketData];
            NSInteger type  = [[marketDic objectForKey:@"type"]integerValue];
            NSLog(@"------type-------%zd",type);
            
            /**         CRCMD_SHORT_MESSAGE = 1,
             CRCMD_MATERIAL = 2,
             CRCMD_AUDIO = 3,
             CRCMD_VIDEO = 4,
             CRCMD_CLASS_OVER = 5,
             CRCMD_ENTER_CLASSROOM = 6,
             CRCMD_HEARTBEAT_PACKAGE = 7,
             CRCMD_DISMISS_CLASSROOM = 8,
             CRCMD_NOTALLOWED_ENTER = 9,
             CRCMD_FILESTREAM = 10,
             CRCMD_VIDEO_MINIMIZE = 11,
             CRCMD_MATERIAL_DRAW_STREAM = 12,
             */
            if (type == 1) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"jieshoudaodexiaoxi" object:marketDic[@"data"][@"ShortMessageContent"]];
            }else if (type == 2) {
                [view crcmdMaterialWithDictionary:marketDic];
            }else if (type == 3) {
                NSLog(@"------type---3-------");
            }else if (type == 4) {
                NSLog(@"-------type--4-------");
            }else if (type == 5) {
                NSLog(@"------type---5-------");
            }else if (type == 6) {
                NSLog(@"-------type--6-------");
            }else if (type == 7) {
                NSLog(@"------type---7-------");
            }else if (type == 8) {
                NSLog(@"------type---8-------");
            }else if (type == 9) {
                NSLog(@"-------type--9-------");
            }else if (type == 10) {
                NSLog(@"------type---10-------");
            }else if (type == 11) {
                NSLog(@"-------type--11-------");
            }else if (type == 12) {
                NSLog(@"-------type--12-------");
            }
            
            
            //            recv data: length = 73, data: {"data":{"MaterialOperation":"18","PageIdentifier":6,"type":1},"type":2}
            //            ,"type":12}
            
            //            jni_main(SESSION_RECV_DATA, ptasrd->data, ptasrd->data_len);
        }
            break;
            
        case TO_APP_SESSION_WRITABLE:
            ptasw = (struct to_app_session_writable *) (ped->data);
            break;
        default:
            break;
    }
}


//创建教材
-(void)crcmdMaterialWithDictionary:(NSDictionary *)marketDic{
    NSString *eTalkStr = @"http://www.etalk365.com";
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *address = [user objectForKey:@"address"];
    NSString *page = [marketDic[@"data"]objectForKey:@"MaterialOperation"];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@/p%d.et3",eTalkStr,address,page.intValue];
    NSLog(@"%@",urlStr);
    
    
    NSString * urlstr = [urlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSLog(@"---urlstr %@",urlstr);
    _JCURL = urlstr;
    [self downLoadBook];
    
    
    //    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    //网络请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlstr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"-----教材文件的内容 -%@",responseObject);
        NSString *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *str = [NSString stringWithFormat:@"p%d",page.intValue];
        paths = [paths stringByAppendingPathComponent:str];
        NSLog(@"------教材管理的沙盒路径----paths %@",paths);
        
        if (![[NSFileManager defaultManager]fileExistsAtPath:paths]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:paths withIntermediateDirectories:YES attributes:nil error:nil];
            
        }
        NSString *str1 = [NSString stringWithFormat:@"p%d.et3",page.intValue];
        paths = [paths stringByAppendingPathComponent:str1];
        if (![[NSFileManager defaultManager]fileExistsAtPath:paths]){
            BOOL bol = [responseObject writeToFile:paths atomically:YES];
            NSLog(@"教材文件下载成功！,%d",bol);
            NSString *str3 = [NSString stringWithFormat:@"/p%d/p%d.et3",page.intValue,page.intValue];
            const char *abc = [str3 UTF8String];
            [self Media_natifyMaterialWithHandle:Material_Manage_Handle materialParsePath:abc];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"教材下载网络请求失败！%@",error);
    }];
    
    
}

-(NSString *)getdownloadPath{
    
    
    //1.获取沙盒路径
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"沙盒路径为:%@",path);
    //2.拼接qq下载文件路径
    
    NSString *str = [NSString stringWithFormat:@"p%d",_pages.intValue];
    path = [path stringByAppendingPathComponent:str];
    
    return path;
}

//-(void)reload{
//    NSString *marketData = [[NSUserDefaults standardUserDefaults]objectForKey:@"marketData"];
//    _marketDic = [self dictionaryWithString:marketData];
//    NSLog(@"---------------_marketDic%@--------",_marketDic);
//
//}

//  字符串转换成字典
-(NSDictionary *)dictionaryWithString:(NSString *)string{
    
    // NSString *marketPacket = [NSString stringWithCString:data encoding:NSASCIIStringEncoding];
    
    NSData *Data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:Data options:NSJSONReadingMutableLeaves error:nil];
    return response;
}


// 教材管理器
void _createMaterialManager(char *pathDocuments) {
    //    jboolean jbIsCopy = JNI_TRUE;
    //    const char *material_path = NULL;
    struct pcm_player_param ppp;
    
    //    material_path = (*env)->GetStringUTFChars(env, path, &jbIsCopy);
    ppp.buffer_size = 4096;
    ppp.nChannels = 2;
    ppp.nSamplesPerSec = 44100;
    ppp.wBitsPerSample = 16;
    
    //eg. /storage/emulated/0/etalk_textbooks/
    material_mgr_create(NULL, callbackCreateMaterialManager, pathDocuments, &ppp);
    //    (*env)->ReleaseStringUTFChars(env, path, material_path);
    
    //    return 0;
}



//教材管理器回调
void callbackCreateMaterialManager(void *usr, struct event_desc *ped) {
    switch (ped->evt_id) {
        case TO_UI_MATERIAL_MGR_HANDLE: {
            struct to_ui_material_mgr_handle *ptummh = (struct to_ui_material_mgr_handle *) ped->data;
            Material_Manage_Handle = ptummh->material_mgr_handle;
            
            if (ptummh->material_mgr_handle != 0) {
                printf("%s,TO_UI_MATERIAL_MGR_HANDLE,create material manager success\n", __FUNCTION__);
                //                jni_main(GET_MATERIAL_URL, NULL, 0);
                
            } else {
                printf("%s,TO_UI_MATERIAL_MGR_HANDLE,create material manager fail\n", __FUNCTION__);
            }
        }
            break;
        case TO_UI_MATERIAL_HANDLE: {
            struct to_ui_material_handle *ptumh = (struct to_ui_material_handle *) ped->data;
            Material_Handle = ptumh->material_handle;
            if (ptumh->material_handle != -1) {
                //                jni_main(SET_MATERIAL_JPG_VOICE, ptumh->jpg_name, ptumh->voice_count);
                NSLog(@"ptumh->jpg_name  -- %s  ptumh->voice_count -- %d",ptumh->jpg_name,ptumh->voice_count);
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                NSString *str = [NSString stringWithCString:ptumh->jpg_name encoding:NSASCIIStringEncoding];
                NSArray *arr = [str componentsSeparatedByString:@"/"];//p37/p37.jpg
                NSString *str2 = arr.lastObject;//p37.jpg
                NSString *str4 = arr[1];//p37
                NSString *str1  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];//路径
                NSString *str3 = [NSString stringWithFormat:@"%@%@",str1,str];//全路径
                NSLog(@"准备传给消息中心的字符串%@,%@",str,str3);
                
                str1 = [str1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",str4,str2]];
                
                
                UIImage *image4 = [[UIImage alloc ]initWithContentsOfFile:str3];
                NSLog(@"-------全路径的照片-----能不打出照片 %@",image4);
                
                //                NSString *nameStr = [NSString stringWithFormat:@"%@.et3",str4];
                
                NSData *data = [NSData dataWithContentsOfFile:str3];
                NSLog(@"照片的数据data %@",data);
                
                UIImage *image = [[UIImage alloc ]initWithData:data];
                NSLog(@"-----数据转换-------能不打出照片 %@",image);
                
                NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@/%@.jpg",NSHomeDirectory(),str4,str4];
                NSLog(@"-----apath3%@",aPath3);
                UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
                UIImageView* imageView3=[[UIImageView alloc]initWithImage:imgFromUrl3];
                NSLog(@"-----第一次-------能不打出照片imgFromUrl3 %@",imgFromUrl3);
                
                [[NSUserDefaults standardUserDefaults]setObject:aPath3 forKey:@"xiazaidejiaocai"];
                
                [center postNotificationName:@"xianShiTuPian" object:image];
            } else {
                
            }
        }
            break;
        case TO_UI_VOICE_START:
            printf("%s,TO_UI_VOICE_START\n", __FUNCTION__);
            //            jni_main(MATERIAL_AUDIO_TRACK_OPEN, NULL, 0);
            //            jni_main(MATERIAL_AUDIO_TRACK_PLAY, NULL, 0);
            break;
        case TO_UI_VOICE_STOPED:
            printf("%s,TO_UI_VOICE_STOPED\n", __FUNCTION__);
            //            jni_main(MATERIAL_AUDIO_TRACK_STOP, NULL, 0);
            break;
        case TO_UI_VOICE_END:
            printf("%s,TO_UI_VOICE_END\n", __FUNCTION__);
            //            jni_main(MATERIAL_AUDIO_TRACK_WRITE, NULL, 0);
        default:
            break;
    }
}
//教材解析函数
-(void)Media_natifyMaterialWithHandle:(void * )handle materialParsePath:(char *)materialParsePath{
    int ret = -1;
    
    if (handle != 0) {
        ret = material_open_material(handle, materialParsePath);
        NSLog(@"教材解析结果ret222 %d ",ret);
        ClassroomViewController *class = [[ClassroomViewController alloc]init];
        if (class.block) {
            class.block();
            
            NSLog(@"block 起作用啦");
            
        }
        
        
        
    }
}


@end
