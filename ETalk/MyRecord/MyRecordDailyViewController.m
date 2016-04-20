//
//  MyRecordDailyViewController.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/5/7.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "MyRecordDailyViewController.h"
#import "UIViewController+BackButton.h"
#import "MyRecordDailyTableViewCell.h"
#import "UIPlaceHolderTextView.h"
#import "LBorderView.h"
#import "AppDelegate.h"
#import "RKDropdownAlert.h"
#import "MBProgressHUD.h"
#import "EvaluateRequest.h"
#import "HTTPRequest.h"
#import "UserSingleton.h"
#import "MyEvaluateViewController.h"
#import "TeacherEvaluateViewController.h"

@interface MyRecordDailyViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, EvaluateRequestDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *evaluateAlertView;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet LBorderView *borderView;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *placeHolderTextView;
@property (weak, nonatomic) IBOutlet UIButton *score1Button;
@property (weak, nonatomic) IBOutlet UIButton *score2Button;
@property (weak, nonatomic) IBOutlet UIButton *score3Button;
@property (weak, nonatomic) IBOutlet UIButton *score4Button;
@property (weak, nonatomic) IBOutlet UIButton *score5Button;

- (IBAction)commit:(id)sender;
- (IBAction)setScore1:(id)sender;
- (IBAction)setScore2:(id)sender;
- (IBAction)setScore3:(id)sender;
- (IBAction)setScore4:(id)sender;
- (IBAction)setScore5:(id)sender;

@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) EvaluateRequest *evaluateRequest;
@property (assign, nonatomic) NSInteger evaluateRow;
@property (strong, nonatomic) HTTPRequest *request;
@property (strong, nonatomic) NSMutableArray *dailyCourseList;



//11111
@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSArray *dataArray;


@end

@implementation MyRecordDailyViewController

#pragma mark - EvaluateListRequest

- (EvaluateRequest *)evaluateRequest
{
    if (!_evaluateRequest) {
        _evaluateRequest = [[EvaluateRequest alloc] init];
        _evaluateRequest.delegate = self;
    }
    
    return _evaluateRequest;
}

- (void)cancelEvaluateRequest
{
    [self hideHUD:NO];
    
    if (_evaluateRequest) {
        [_evaluateRequest cancelEvaluate];
        _evaluateRequest.delegate = nil;
        _evaluateRequest = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //11111
    
    
    
    _dateString = _getMyRecordInfoList.recordMoth;
    _dataArray = [NSArray arrayWithArray:_getMyRecordInfoList.myRecordMothInfoList];
    
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _borderView.borderType = BorderTypeSolid;
    _borderView.borderWidth = 2;
    _borderView.cornerRadius = 4;
    _borderView.borderColor = UIColorFromRGB(0xCCCCCC);
    self.placeHolderTextView.placeholder = @"请输入你对老师的评价";
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideEvaluateAlertView)];
    [self.evaluateAlertView addGestureRecognizer:tapRecognizer];
    
    UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doNothing)];
    [self.inputView addGestureRecognizer:tapRecognizer2];
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        statusBarView.backgroundColor  =  UIColorFromRGB(0x9BCB2D);
        [self.view addSubview:statusBarView];
    }
    
    _dailyCourseList = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNavigaionBarBackButtonWithBackStylePop];
    [self setupNavigaionBarHomeButton];
    
    [self addEvaluateAlertView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[self setupHTTPRequest];
    //[self.request startRequest];
//    [self showHUDWithMessage:@""];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self cancelEvaluateRequest];
    [self removeEvaluateAlertView];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doNothing
{
//    NSLog(@"doNothing");
}

#pragma mark - EvaluateAlertView

- (void)addEvaluateAlertView
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];
    
    if ([self.evaluateAlertView superview] != window) {
        [self.evaluateAlertView setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.5]];
        [window addSubview:self.evaluateAlertView];
        
        self.evaluateAlertView.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_evaluateAlertView);
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_evaluateAlertView]-0-|"
                                                                       options:0 metrics:nil views:viewsDictionary];
        [window addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_evaluateAlertView]-0-|"
                                                              options:0 metrics:nil views:viewsDictionary];
        [window addConstraints:constraints];
    }
    
    self.evaluateAlertView.hidden = YES;
}

- (void)removeEvaluateAlertView
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];
    
    if ([self.evaluateAlertView superview] == window) {
        [self.evaluateAlertView removeFromSuperview];
    }
}

- (void)hideEvaluateAlertView
{
    self.evaluateAlertView.hidden = YES;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 192.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [self.dailyCourseList count];
    //11111
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyRecordDailyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRecordDailyTableViewCellIdentifier"];
    //[cell setCourseInfo:[self.dailyCourseList objectAtIndex:indexPath.row]];
    //11111
    [cell setCourseInfo:[self.dataArray objectAtIndex:indexPath.row] andDateString:self.dateString];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *EvaluateOfTeacherURL = [user objectForKey:kRespondKeyEvaluateOfTeacherURL];
    NSLog(@"EvaluateOfTeacherURL = %@",EvaluateOfTeacherURL);
    [[AFHTTPRequestOperationManager manager] GET:EvaluateOfTeacherURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        for (NSDictionary *dict in responseObject[@"data"]) {
            
            NSDictionary *teaEvaluat = [dict objectForKey:@"courseList"][0][@"teaEvaluat"];
            
            UserSingle *single = [UserSingle sharedInstance];
            single.teaEvaluateSecond = teaEvaluat;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    
    //  我的评价按钮
    if ([cell viewWithTag:6045324]) {
        UIButton *button = (UIButton *)[cell viewWithTag:6045324];
        [button addTarget:self action:@selector(showMyEvaluate:) forControlEvents:UIControlEventTouchUpInside];
    } else if ([cell viewWithTag:6045384]) {
        UIButton *button = (UIButton *)[cell viewWithTag:6045384];
        [button addTarget:self action:@selector(evaluate:) forControlEvents:UIControlEventTouchUpInside];
    }

    //  查看老师评价按钮
    if ([cell viewWithTag:2045324]) {
        UIButton *button = (UIButton *)[cell viewWithTag:2045324];
        [button addTarget:self action:@selector(showTeacherEvaluate:) forControlEvents:UIControlEventTouchUpInside];
    }

    return cell;
}

- (void)showMyEvaluate:(id)sender
{
    DLog();
    
    [self performSegueWithIdentifier:@"CourseDailyInfoToMyEvaluate" sender:sender];
}

- (void)evaluate:(id)sender
{
    DLog();
    
    UITableViewCell *cell = [self getSuperTableViewCell:(UIView *)sender];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if (indexPath) {
        
        self.evaluateRow = indexPath.row;
        self.evaluateAlertView.hidden = NO;
    }
}

- (void)showTeacherEvaluate:(id)sender
{
    DLog();

    [self performSegueWithIdentifier:@"MyRecordDailyToTeacherEvaluate" sender:sender];
}

- (UITableViewCell *)getSuperTableViewCell:(UIView *)view
{
    BOOL isSuperTableViewCellExist = NO;
    while (view) {
        if ([view isKindOfClass:[UITableViewCell class]]) {
            isSuperTableViewCellExist = YES;
            break;
        }
        
        view = [view superview];
    }
    
    return isSuperTableViewCellExist ? (UITableViewCell *)view : nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UITableViewCell *cell = [self getSuperTableViewCell:(UIView *)sender];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        //CourseInfo *courseInfo = [self.dailyCourseList objectAtIndex:indexPath.row];
        MyRecordMothInfo *info = [self.dataArray objectAtIndex:indexPath.row];
        
        if ([segue.identifier isEqualToString:@"CourseDailyInfoToMyEvaluate"]) {
            DLog();

            MyEvaluateViewController *viewController = [segue destinationViewController];
            //viewController.courseInfo = courseInfo;
            viewController.stuRecordMothInfo = info;
        }
        else if ([segue.identifier isEqualToString:@"MyRecordDailyToTeacherEvaluate"]) {
            TeacherEvaluateViewController *viewController = [segue destinationViewController];
            //viewController.courseInfo = courseInfo;
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (IBAction)commit:(id)sender
{
    if (self.placeHolderTextView.text.length == 0) {
        [RKDropdownAlert title:@"请请输入你对老师的评价" time:1.0];
        return;
    }
    
    if (self.score == 0) {
        [RKDropdownAlert title:@"请给老师评分" time:1.0];
        return;
    }
    
    CourseInfo *courseInfo = [self.dataArray objectAtIndex:self.evaluateRow];
    
    [self.evaluateRequest evaluateWithText:self.placeHolderTextView.text score:self.score courseID:courseInfo.courseId];
    
    [self showHUDWithMessage:nil];
}

- (void)evaluateSuccess
{
    
//    [self hideHUD:NO];
//    [self hideEvaluateAlertView];
//
//    CourseInfo *courseInfo = [self.dataArray objectAtIndex:self.evaluateRow];
//    courseInfo.stuCommentRank = [NSString stringWithFormat:@"%d", (int)self.score];
//    courseInfo.stuCommentText = self.placeHolderTextView.text;
//
//    [self.tableView reloadData];
    
    [self.progressHUD hide:NO];
    [RKDropdownAlert title:@"评价成功，谢谢！" time:1.5];
    
    /**再次刷新数据标志suc*/
    UserSingle *single = [UserSingle sharedInstance];
    single.EvaluateSign = @"suc";
    
    [self hideEvaluateAlertView];
    
    [self clearEvaluate];
    [self.tableView reloadData];
    
    [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.5];
    
}

- (void)clearEvaluate
{
    [self clearScore];
    self.placeHolderTextView.text = nil;
}

- (void)clearScore
{
    UIImage *image = [UIImage imageNamed:@"1_3_2"];
    [self.score1Button setImage:image forState:UIControlStateNormal];
    [self.score2Button setImage:image forState:UIControlStateNormal];
    [self.score3Button setImage:image forState:UIControlStateNormal];
    [self.score4Button setImage:image forState:UIControlStateNormal];
    [self.score5Button setImage:image forState:UIControlStateNormal];
}

- (void)popViewController
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)evaluateFailure:(NSString *)errorInfo
{
    [self hideHUD:NO];
    [self hideEvaluateAlertView];
    
    [RKDropdownAlert title:errorInfo time:1.0];
}

- (IBAction)setScore1:(id)sender
{
    if (sender) {
        self.score = 1;
        [self clearScore];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_3_1"];
    [self.score1Button setImage:image forState:UIControlStateNormal];
}

- (IBAction)setScore2:(id)sender
{
    if (sender) {
        self.score = 2;
        [self clearScore];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_3_1"];
    [self.score2Button setImage:image forState:UIControlStateNormal];
    [self setScore1:nil];
}

- (IBAction)setScore3:(id)sender
{
    if (sender) {
        self.score = 3;
        [self clearScore];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_3_1"];
    [self.score3Button setImage:image forState:UIControlStateNormal];
    [self setScore2:nil];
}

- (IBAction)setScore4:(id)sender
{
    if (sender) {
        self.score = 4;
        [self clearScore];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_3_1"];
    [self.score4Button setImage:image forState:UIControlStateNormal];
    [self setScore3:nil];
}

- (IBAction)setScore5:(id)sender
{
    if (sender) {
        self.score = 5;
        [self clearScore];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_3_1"];
    [self.score5Button setImage:image forState:UIControlStateNormal];
    [self setScore4:nil];
}

#pragma mark -


- (MBProgressHUD *)progressHUD
{
    if(!_progressHUD)
    {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.evaluateAlertView];
        _progressHUD.minShowTime = 0.25;
        _progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
        [self.evaluateAlertView addSubview:_progressHUD];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doNothing)];
        [_progressHUD addGestureRecognizer:tapRecognizer];
    }
    
    return _progressHUD;
}

- (void)showHUDWithMessage:(NSString *)message
{
    self.progressHUD.labelText = message;
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    [self.progressHUD show:YES];
}

- (void)hideHUD:(BOOL)animated
{
    [self.progressHUD hide:animated];
}

- (void)showHUDWithCompleteMessage:(NSString *)message
{
    [self.progressHUD show:YES];
    self.progressHUD.labelText = message;
    self.progressHUD.mode = MBProgressHUDModeCustomView;
    [self.progressHUD hide:YES afterDelay:1.0];
}

- (void)showHUDWithFailureMessage:(NSString *)message
{
    [self.progressHUD show:YES];
    self.progressHUD.labelText = message;
    self.progressHUD.mode = MBProgressHUDModeText;
    [self.progressHUD hide:YES afterDelay:2.0];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - HTTPRequestDelegate

- (void)requestSuccess:(id)respondData
{
    [self showHUDWithCompleteMessage:@"修改成功"];
    
    NSArray *courseList = (NSArray *)respondData;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < courseList.count; i++) {
        CourseInfo *courseInfo = [[CourseInfo alloc] initWithDictionary:courseList[i]];
        [array addObject:courseInfo];
    }

    self.dailyCourseList = array;
    [self.tableView reloadData];
}

- (void)requestFailure:(NSString *)errorInfo
{
    [self hideHUD:NO];
    [RKDropdownAlert title:errorInfo time:1.0];
}

#pragma mark - HTTPRequest

- (HTTPRequest *)request
{
    if (!_request) {
        _request = [[HTTPRequest alloc] init];
        _request.delegate = self;
    }
    
    return _request;
}

- (void)cancelRequest
{
    [self hideHUD:NO];
    
    if (_request) {
        [_request cancelRequest];
        _request.delegate = nil;
        _request = nil;
    }
}

- (void)setupHTTPRequest
{
    self.request.title = @"user_get_recordview_list";
    
    NSString *userName = [[[UserSingleton sharedInstance] userInfo] username];
    NSDictionary *parameters = @{kRequestKeyUserName : userName, @"bespeak_date" : self.bespeakDay};
    self.request.parameters = parameters ;
    
    self.request.requestType = kHTTPRequestType_Post;
    self.request.respondType = kHTTPRespondType_Data;
}


@end
