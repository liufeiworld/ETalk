//
//  CalendarHomeViewController.m
//  Calendar
//
//  Created by Neil on 14-6-23.
//  Copyright (c) 2014年 Neil. All rights reserved.
//
#import "ClassBookingViewController.h"
#import "OrderCollectionViewCell.h"
#import "OrderCollectionHeaderView.h"
#import "NSDate+WQCalendarLogic.h"
#import "CourseTimeListRequest.h"
#import "UIViewController+MBProgressHUD.h"
#import "UserSingleton.h"
#import "ChooseDateViewController.h"
#import "CustomCollectionFlowLayout.h"
#import "CourseTimeInfo.h"
#import "RKDropdownAlert.h"
#import "ClassOrderRequest.h"
#import "AppDelegate.h"
#import "UIViewController+BackButton.h"

@interface ClassBookingViewController () <UICollectionViewDelegate, UICollectionViewDataSource, OrderCollectionHeaderViewDelegate, CourseTimeListRequestDelegate, ClassOrderRequestDelegate>

@property (strong, nonatomic) NSArray *courseList;
@property (strong, nonatomic) OrderCollectionHeaderView *headerView;
@property (strong, nonatomic) NSDate *currentDate;
@property (strong, nonatomic) NSDate *standardDate;
@property (strong, nonatomic) CourseTimeListRequest *courseTimeListRequest;
@property (strong, nonatomic) ClassOrderRequest *classOrderRequest;
@property (strong, nonatomic) CourseTimeInfo *selectedCourseTimeInfo;

@end

@implementation ClassBookingViewController

- (void)viewDidLoad
{
    self.currentDate = [NSDate date];
    self.standardDate = self.currentDate;
    [self setupCollectionViewLayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseDateFinished:)
                                                 name:kChooseDateFinishedNofitication object:nil];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideOrderAlertView:)];
    [self.orderAlertView addGestureRecognizer:tapRecognizer];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    DLog();
}

- (void)setupCollectionViewLayout
{
    CustomCollectionFlowLayout *flowLayout = [[CustomCollectionFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(88, 44);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, [self interItemSpacing], 10, [self interItemSpacing]);
    flowLayout.minimumInteritemSpacing = [self interItemSpacing];
    flowLayout.minimumLineSpacing = 10.0;
    flowLayout.headerReferenceSize = CGSizeMake(self.collectionView.frame.size.width, 96.0);
    self.collectionView.collectionViewLayout = flowLayout;
}

- (CGFloat)interItemSpacing
{
    CGFloat width = self.view.bounds.size.width;
    return (int)((width - [self cellCountForLine] * 88) / ([self cellCountForLine] + 1) - 2.0);
}

- (NSInteger)cellCountForLine
{
    NSInteger count = 1;
    CGFloat width = self.view.bounds.size.width;
    while (width >= (96 * count + 8)) count++;
    
    return count - 1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNavigaionBarBackButtonWithBackStylePop];
    [self setupNavigaionBarHomeButton];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [self addOrderAlertView];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getCourseTimeList];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self hideHUD:NO];
    [self cancelGetCourseTimeList];
    [self cancelClassOrder];
    [self removeOrderAlertView];

    [super viewWillDisappear:animated];
}

#pragma mark - OrderCollectionHeaderViewDelegate

- (void)showCalendar
{
    NSLog(@"showCalendar");
}

- (void)previousDay
{
    NSDate *previousDay = [self.currentDate dateByAddingTimeInterval:-3600 * 24];
    if ([previousDay timeIntervalSinceDate:self.standardDate] >= 0) {
        self.currentDate = previousDay;
        [self.headerView setTitleLabelText:[self.currentDate orderHeaderString]];
        
        [self getCourseTimeList];
    }
}

- (void)nextDay
{
    self.currentDate = [self.currentDate dateByAddingTimeInterval:3600 * 24];
    [self.headerView setTitleLabelText:[self.currentDate orderHeaderString]];
    
    [self getCourseTimeList];
}

#pragma mark - Get Course Time List

- (CourseTimeListRequest *)courseTimeListRequest
{
    if (!_courseTimeListRequest) {
        _courseTimeListRequest = [[CourseTimeListRequest alloc] init];
        _courseTimeListRequest.delegate = self;
    }
    
    return _courseTimeListRequest;
}

- (void)getCourseTimeList
{
    [self cancelGetCourseTimeList];
    
    NSString *stringOfDate = [[NSDate alloc] stringFromDate:self.currentDate];
    [self.courseTimeListRequest getCourseTimeListWithPlanID:self.productID date:stringOfDate];
    [self showHUDWithMessage:@""];
}

- (void)cancelGetCourseTimeList
{
    if (_courseTimeListRequest) {
        [_courseTimeListRequest cancelGetCourseTimeList];
        _courseTimeListRequest = nil;
    }
}

- (void)getCourseTimeListSuccess
{
    [self hideHUD:NO];

    self.courseList = self.courseTimeListRequest.courseTimeList;
    [self.collectionView reloadData];
}

- (void)getCourseTimeListFailure:(NSString *)errorInfo
{
    [self hideHUD:NO];
    [RKDropdownAlert title:errorInfo time:1.0];
}

#pragma mark - CollectionView Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.courseList count];
}

//Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCollectionViewCell *cell = (OrderCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"OrderCollectionViewCellID" forIndexPath:indexPath];
    
    CourseTimeInfo *info = [self.courseList objectAtIndex:indexPath.row];
    [cell setCellType:info.state];
    [cell setTitleLabelText:info.period];
    
    return cell;
}

//代理－选择行的触发事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //点击推出页面
    //NSLog(@"didSelectItemAtIndexPath:%@", indexPath);
    time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
    CourseTimeInfo *info = [self.courseList objectAtIndex:indexPath.row];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *date = [formatter dateFromString:info.classTime];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    if (info.state == 1 && ([timeSp longLongValue] > unixTime + 1800)) {
        self.orderAlertView.hidden = NO;
        self.selectedCourseTimeInfo = info;
        [self setOrderAlertInfo:info];
    }
    if (info.state == 1 && ([timeSp longLongValue] < unixTime + 1800)) {
        [RKDropdownAlert title:@"请预约半小时后的课程" time:2];
    }
}

- (void)setOrderAlertInfo:(CourseTimeInfo *)info
{
    self.orderDayLabel.text = @"请选择上课平台";
    if ([info.period compare:@"12:00"] != NSOrderedDescending) {
        self.orderTimeLabel.text = [NSString stringWithFormat:@"您预约了%@上午%@的一节课", [[NSDate date] stringFromDate2:self.currentDate], info.period];
    }
    else {
        self.orderTimeLabel.text = [NSString stringWithFormat:@"您预约了%@下午%@的一节课", [[NSDate date] stringFromDate2:self.currentDate], info.period];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"OrderCollectionViewHeaderID" forIndexPath:indexPath];
        self.headerView.delegate = self;
        [self.headerView setTitleLabelText:[self.currentDate orderHeaderString]];
        
        return  self.headerView;
    }
    
    return nil;
}

#pragma mark - Class Order Request

- (ClassOrderRequest *)classOrderRequest
{
    if (!_classOrderRequest) {
        _classOrderRequest  = [[ClassOrderRequest alloc] init];
        _classOrderRequest.delegate = self;
    }
    
    return _classOrderRequest;
}

- (void)startClassOrder
{
    [self cancelClassOrder];
    //[self.classOrderRequest orderWithPlanID:self.productID time:self.selectedCourseTimeInfo.begin way:0 productType:self.productLM classCount:1];
    //[self.classOrderRequest orderWithOrderId:self.orderId strDate:self.selectedCourseTimeInfo.classTime];
    //[self showHUDWithMessage:@""];
}

- (void)startClassOrderWithCategory:(int)num
{
    [self cancelClassOrder];
    
    [self.classOrderRequest orderWithNumber:num withOrderId:self.orderId withStrDate:self.selectedCourseTimeInfo.classTime];
    [self showHUDWithMessage:@""];
}

- (void)cancelClassOrder
{
    if (_classOrderRequest) {
        [_classOrderRequest cancelClassOrder];
        _classOrderRequest = nil;
    }
}

- (void)classOrderSuccess
{
    [self showHUDWithCompleteMessage:@"订课成功"];
    
    for (NSInteger i = 0; i < self.courseList.count; i++) {
        CourseTimeInfo *courseTimeInfo = [self.courseList objectAtIndex:i];
        if (courseTimeInfo == self.selectedCourseTimeInfo) {
            courseTimeInfo.state = 2;
        }
    }
    
    [self.collectionView reloadData];
}

- (void)classOrderFailure:(NSString *)errorInfo
{
    [self hideHUD:NO];
    [RKDropdownAlert title:errorInfo time:1.0];
}

#pragma mark - Notification

- (void)chooseDateFinished:(NSNotification *)notification
{
    NSDictionary *dictionary = notification.userInfo;
    self.currentDate = [[NSDate alloc] dateFromString:[dictionary objectForKey:kSelectedDate]];
    [self.headerView setTitleLabelText:[self.currentDate orderHeaderString]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OrderToSelectDateIdentifier"]) {
        ChooseDateViewController *viewController = segue.destinationViewController;
        viewController.selectedDate = self.currentDate;
    }
    
}

#pragma mark - View Above All

- (void)addOrderAlertView
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];
    
    if ([self.orderAlertView superview] != window) {
        [self.orderAlertView setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.5]];
        [window addSubview:self.orderAlertView];
        
        self.orderAlertView.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_orderAlertView);
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_orderAlertView]-0-|"
                                                                       options:0 metrics:nil views:viewsDictionary];
        [window addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_orderAlertView]-0-|"
                                                              options:0 metrics:nil views:viewsDictionary];
        [window addConstraints:constraints];
    }
    
    self.orderAlertView.hidden = YES;
}

- (void)removeOrderAlertView
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];
    
    if ([self.orderAlertView superview] == window) {
        [self.orderAlertView removeFromSuperview];
    }
}

- (IBAction)commitOrder:(id)sender
{
    self.orderAlertView.hidden = YES;
    
    [self startClassOrderWithCategory:2];
    //[self startClassOrder];
}

- (IBAction)cancelOrder:(id)sender
{
    self.orderAlertView.hidden = YES;
    
    [self startClassOrderWithCategory:1];
}

- (void)hideOrderAlertView:(id)sender
{
    self.orderAlertView.hidden = YES;
}

@end
