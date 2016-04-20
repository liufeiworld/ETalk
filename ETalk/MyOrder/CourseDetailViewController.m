//
//  CourseDetailViewController.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/27.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "CourseInfo.h"
#import "CancelCourseRequest.h"
#import "UIViewController+MBProgressHUD.h"
#import "RKDropdownAlert.h"
#import "AppDelegate.h"
#import "UIViewController+BackButton.h"

@interface CourseDetailViewController () <CancelCourseRequestDelegate>

@property (weak, nonatomic) IBOutlet UILabel *courseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseTeaLabel;

- (IBAction)cancelCourse:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *timeOutAlertView;
- (IBAction)close:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *cancelCouseAlertView;
- (IBAction)yes:(id)sender;
- (IBAction)no:(id)sender;

@property (strong, nonatomic) CancelCourseRequest *cancelCourseRequest;

@end

@implementation CourseDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *dateStr = [self.getDictionary objectForKey:@"dateString"];
    CourseInfo *couInfo = [self.getDictionary objectForKey:@"courseIfo"];
//    self.courseTitleLabel.text = [NSString stringWithFormat:@"学习课程：%@", self.courseInfo.title];
//    NSString *timeFormatedString = [self.courseInfo.bespeakPeriod stringByReplacingOccurrencesOfString:@"~" withString:@"-"];
//    self.courseTimeLabel.text = [NSString stringWithFormat:@"上课时间：%@ %@", self.courseInfo.bespeakDate, timeFormatedString];
//    self.courseTeaLabel.text = [NSString stringWithFormat:@"上课老师：%@", self.courseInfo.bespeakTeaName];
    self.courseTitleLabel.text = [NSString stringWithFormat:@"学习课程：%@", couInfo.coursePackageName];
    self.courseTimeLabel.text = [NSString stringWithFormat:@"上课时间：%@ %@", dateStr, couInfo.coursePeriod];
    self.courseTeaLabel.text = [NSString stringWithFormat:@"上课老师：%@", couInfo.courseTeacher];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNavigaionBarBackButtonWithBackStylePop];
    [self setupNavigaionBarHomeButton];

    [self addTimeOutAlertView];
    [self addCancelCouseAlertView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self cancelRequest];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self removeTimeOutAlertView];
    [self removeCancelCouseAlertView];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelCourse:(id)sender
{
    time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
    
    CourseInfo *couInfo = [self.getDictionary objectForKey:@"courseIfo"];
    if ([couInfo.courseClassTime longLongValue] > unixTime + 1800 ) {
        self.cancelCouseAlertView.hidden = NO;
    }
    else {
        self.timeOutAlertView.hidden = NO;
    }
//    if ([self.courseInfo.bespeakTime longLongValue] - unixTime > 3600 ) {
//        self.cancelCouseAlertView.hidden = NO;
//    }
//    else {
//        self.timeOutAlertView.hidden = NO;
//    }
}

#pragma mark - CancelCourseRequest

- (CancelCourseRequest *)cancelCourseRequest
{
    if (!_cancelCourseRequest) {
        _cancelCourseRequest = [[CancelCourseRequest alloc] init];
        _cancelCourseRequest.delegate = self;
    }
    return _cancelCourseRequest;
}

- (void)cancelRequest
{
    [self hideHUD:NO];
    
    if (_cancelCourseRequest) {
        [_cancelCourseRequest cancel];
        _cancelCourseRequest.delegate = nil;
        _cancelCourseRequest = nil;
    }
}

#pragma mark - CancelCourseRequestDelegate

- (void)cancelCourseSuccess
{
    [self showHUDWithCompleteMessage:@"取消课程成功"];
    
    [self performSelector:@selector(back:) withObject:nil afterDelay:2.0];
}

- (void)cancelCourseFailure:(NSString *)errorInfo
{
    [self hideHUD:NO];
    [RKDropdownAlert title:errorInfo time:1.0];
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TimeOutAlertView

- (void)addTimeOutAlertView
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];
    
    if ([self.timeOutAlertView superview] != window) {
        [self.timeOutAlertView setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.5]];
        [window addSubview:self.timeOutAlertView];
        
        self.timeOutAlertView.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_timeOutAlertView);
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_timeOutAlertView]-0-|"
                                                                       options:0 metrics:nil views:viewsDictionary];
        [window addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_timeOutAlertView]-0-|"
                                                              options:0 metrics:nil views:viewsDictionary];
        [window addConstraints:constraints];
    }
    
    self.timeOutAlertView.hidden = YES;
}

- (void)removeTimeOutAlertView
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];
    
    if ([self.timeOutAlertView superview] == window) {
        [self.timeOutAlertView removeFromSuperview];
    }
}

- (IBAction)close:(id)sender
{
    self.timeOutAlertView.hidden = YES;
}


#pragma mark - View Above All

- (void)addCancelCouseAlertView
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];
    
    if ([self.cancelCouseAlertView superview] != window) {
        [self.cancelCouseAlertView setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.5]];
        [window addSubview:self.cancelCouseAlertView];
        
        self.cancelCouseAlertView.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_cancelCouseAlertView);
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_cancelCouseAlertView]-0-|"
                                                                       options:0 metrics:nil views:viewsDictionary];
        [window addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_cancelCouseAlertView]-0-|"
                                                              options:0 metrics:nil views:viewsDictionary];
        [window addConstraints:constraints];
    }
    
    self.cancelCouseAlertView.hidden = YES;
}

- (void)removeCancelCouseAlertView
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];
    
    if ([self.cancelCouseAlertView superview] == window) {
        [self.cancelCouseAlertView removeFromSuperview];
    }
}

- (IBAction)yes:(id)sender
{
    self.cancelCouseAlertView.hidden = YES;

    [self cancelRequest];
    NSString *dateStr = [self.getDictionary objectForKey:@"dateString"];
    CourseInfo *couInfo = [self.getDictionary objectForKey:@"courseIfo"];
    NSString *dateString = [couInfo.coursePeriod substringToIndex:5];
    NSString *date = [NSString stringWithFormat:@"%@ %@:00", dateStr, dateString];
    
    NSString *classStamp = couInfo.courseClassTime;
    NSLog(@"-----0000000000----%@",classStamp);
    [self.cancelCourseRequest  cancelCourseWithIdentifier:classStamp];
    [self showHUDWithMessage:nil];
}

- (IBAction)no:(id)sender
{
    self.cancelCouseAlertView.hidden = YES;
}

@end
