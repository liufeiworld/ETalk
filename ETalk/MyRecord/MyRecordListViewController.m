//
//  MyRecordListViewController.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/23.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "MyRecordListViewController.h"
#import "MyRecordListCell.h"
#import "MyRecordListRequest.h"
#import "CourseInfo.h"
#import "UIViewController+MBProgressHUD.h"
#import "RKDropdownAlert.h"
#import "NSDate+WQCalendarLogic.h"
#import "MyRecordDailyViewController.h"
#import "MyRecordListHeaderView.h"
#import "MyRecordMothInfo.h"
#import "UIViewController+BackButton.h"

@interface MyRecordListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, MyRecordListRequestDelegate, MyRecordListHeaderViewDelegate>

@property (strong, nonatomic) MyRecordListRequest *myRecordListRequest;
@property (strong, nonatomic) MyRecordListHeaderView *headerView;

@property (strong, nonatomic) NSArray *courseListArray;

@property (strong, nonatomic) NSString *selectedBespeakDay;
@property (strong, nonatomic) MyRecordInfoList *selectedMyRecordInfoList;
@property (strong, nonatomic) NSString *currentRecordMonth;
@property (nonatomic,strong) NSMutableArray *EvaluateArr;

@end

@implementation MyRecordListViewController

- (NSMutableArray *)EvaluateArr{

    if (!_EvaluateArr) {
        
        _EvaluateArr = [NSMutableArray array];
    }
    return _EvaluateArr;
}

#pragma mark - MyRecordListRequest

- (MyRecordListRequest *)myRecordListRequest
{
    if (!_myRecordListRequest) {
        _myRecordListRequest = [[MyRecordListRequest alloc] init];
        _myRecordListRequest.delegate = self;
    }
    
    return _myRecordListRequest;
}

- (void)cancelMyRecordListRequest
{
    [self hideHUD:NO];
    
    if (_myRecordListRequest) {
        [_myRecordListRequest cancelGetMyRecordList];
        _myRecordListRequest.delegate = nil;
        _myRecordListRequest = nil;
    }
}

#pragma mark - Life Circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupCollectionViewLayout];
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        statusBarView.backgroundColor  =  UIColorFromRGB(0x9BCB2D);
        [self.view addSubview:statusBarView];
    }
    
    self.currentRecordMonth = [self currentMonthString];
}

- (void)setupCollectionViewLayout
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(88, 44);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, [self interItemSpacing], 5.0, [self interItemSpacing]);
    flowLayout.minimumInteritemSpacing = [self interItemSpacing];
    flowLayout.minimumLineSpacing = 10.0;
    flowLayout.headerReferenceSize = CGSizeMake(self.collectionView.frame.size.width, 60.0);
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
    
    [self setupNavigaionBarBackButtonWithBackStyleDismiss];

    [self resetNextMonthButtonEnableState];
    if (!self.courseListArray) {
        [self showHUDWithMessage:@""];

        self.myRecordListRequest.bespeakMonth = self.currentRecordMonth;
        [self.myRecordListRequest getMyRecordList];
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self cancelMyRecordListRequest];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.courseListArray.count;
}

//Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyRecordListCell *cell = (MyRecordListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MyRecordListCellIdentifier" forIndexPath:indexPath];
    
//    MyRecordInfoList *infoList =[self.myRecordList lastObject];
//    NSArray *recordList = infoList.myRecordMothInfoList;
//    MyRecordMothInfo *info = recordList[indexPath.row];
//    [cell setTitleLabelText:info.bespeakTime];
    MyRecordInfoList *model = [self.courseListArray objectAtIndex:indexPath.row];
    [cell setTitleLabelText:model.recordMoth];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MyRecordListHeaderIdentifier" forIndexPath:indexPath];
        self.headerView.delegate = self;
        [self.headerView setTitleLabelText:[self formatDateString:self.currentRecordMonth]];
        
        return  self.headerView;
    }
    
    return nil;
}


//代理－选择行的触发事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyRecordInfoList *putMyRecordInfoList = [self.courseListArray objectAtIndex:indexPath.row];
    
    self.selectedMyRecordInfoList = putMyRecordInfoList;
    
    //点击推出页面
//    NSLog(@"didSelectItemAtIndexPath:%@", indexPath);
//    MyRecordInfoList *infoList =[self.myRecordList lastObject];
//    NSArray *recordList = infoList.myRecordMothInfoList;
//
//    self.selectedBespeakDay = [(MyRecordMothInfo *)[recordList objectAtIndex:indexPath.row] bespeakTime];
    [self performSegueWithIdentifier:@"MyRecordListToMyRecordDaily" sender:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MyRecordListToMyRecordDaily"]) {
        MyRecordDailyViewController *myRecordDailyViewController = (MyRecordDailyViewController *)segue.destinationViewController;
        //myRecordDailyViewController.bespeakDay = self.selectedBespeakDay;
        myRecordDailyViewController.getMyRecordInfoList = self.selectedMyRecordInfoList;
    }
}

- (NSString *)currentMonthString
{
    NSString *currentMonth = nil;
    if (self.courseListArray && self.courseListArray.count > 0) {
        //currentMonth = ((MyRecordInfoList *)self.myRecordList.lastObject).recordMoth;
        NSString *recordMoth = [(MyRecordInfoList *)self.courseListArray.lastObject recordMoth];
        currentMonth = [recordMoth substringToIndex:7];
    }
    else {
        currentMonth = [self monthOfTodayString];
    }
    return currentMonth;
}

- (NSString *)monthOfTodayString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (NSString *)previousMonthString
{
    NSString *currentMonth = self.currentRecordMonth;
    NSArray *stringArray = [currentMonth componentsSeparatedByString:@"-"];
    if (stringArray.count > 1) {
        int year = [stringArray.firstObject intValue];
        int month = [stringArray.lastObject intValue];
        if (month == 1) {
            year--;
            month = 12;
        }
        else {
            month--;
        }
        
        return [NSString stringWithFormat:@"%d-%02d", year, month];
    }
    
    return currentMonth;
}

- (NSString *)nextMonthString
{
    NSString *currentMonth = self.currentRecordMonth;
    NSArray *stringArray = [currentMonth componentsSeparatedByString:@"-"];
    if (stringArray.count > 1) {
        int year = [stringArray.firstObject intValue];
        int month = [stringArray.lastObject intValue];
        if (month == 12) {
            year++;
            month = 1;
        }
        else {
            month++;
        }
        
        return [NSString stringWithFormat:@"%d-%02d", year, month];
    }
    
    return currentMonth;
}

#pragma mark - 
- (void)getMyRecordListSuccess
{
//    NSLog(@"Before: %@", self.myRecordListRequest.myRecordList);
    [self hideHUD:NO];
    NSMutableArray *monthRecordInfoList = [[NSMutableArray alloc] init];
    for (NSDictionary *courseDic in self.myRecordListRequest.myRecordList) {
        MyRecordInfoList *recordInfoListModel = [[MyRecordInfoList alloc] init];
        recordInfoListModel.recordMoth = [courseDic objectForKey:kRespondKeyNewCourseDate];
        NSArray *courseListArray = [courseDic objectForKey:kRespondKeyNewCourseList];
        NSMutableArray *courseDayInfoListArray = [[NSMutableArray alloc] init];
        for (NSDictionary *courseListDic in courseListArray) {
            MyRecordMothInfo *mothInfoModel = [[MyRecordMothInfo alloc] initWithNewDictionary:courseListDic];
            [courseDayInfoListArray addObject:mothInfoModel];
        }
        if (courseDayInfoListArray.count > 0) {
            recordInfoListModel.myRecordMothInfoList = courseDayInfoListArray;
        }
        [monthRecordInfoList addObject:recordInfoListModel];
    }
    if (monthRecordInfoList.count > 0) {
        self.courseListArray = [NSArray arrayWithArray:monthRecordInfoList];
    }
    else {
        NSString *errorInfo = [NSString stringWithFormat:@"%@无上课记录", self.currentRecordMonth];
        [RKDropdownAlert title:errorInfo time:1.0];
    }
    
    [self.headerView setTitleLabelText:[self formatDateString:self.currentRecordMonth]];
    [self resetNextMonthButtonEnableState];
    [self.collectionView reloadData];
}


//- (void)getMyRecordListSuccess
//{
//    NSLog(@"Before: %@", self.myRecordListRequest.myRecordList);
//    
//    [self hideHUD:NO];
//    
//    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
//    for (int i = 0; i < self.myRecordListRequest.myRecordList.count; i++) {
//        NSDictionary *infoDic = [self.myRecordListRequest.myRecordList objectAtIndex:i];
//        MyRecordMothInfo *monthInfo = [[MyRecordMothInfo alloc] initWithDictionary:infoDic];
//        [mutableArray addObject:monthInfo];
//    }
//    
//    MyRecordInfoList *infoList = [[MyRecordInfoList alloc] init];
//    infoList.myRecordMothInfoList = [NSArray arrayWithArray:mutableArray];
//    infoList.recordMoth = self.myRecordListRequest.bespeakMonth;
//    if (!self.myRecordList) {
//        self.myRecordList = [[NSMutableArray alloc] init];
//    }
//    [self.myRecordList addObject:infoList];
//    
//    if (mutableArray.count == 0) {
//        NSString *errorInfo = [NSString stringWithFormat:@"%@无上课记录", infoList.recordMoth];
//        [RKDropdownAlert title:errorInfo time:1.0];
//    }
//    
//    [self.headerView setTitleLabelText:[self currentMonthString]];
//    [self.collectionView reloadData];
//}

- (void)getMyRecordListFailure:(NSString *)errorInfo
{
    [self hideHUD:NO];
    NSString *errorInf1o = [NSString stringWithFormat:@"%@无上课记录", [self formatDateString:self.currentRecordMonth]];
    [RKDropdownAlert title:errorInf1o time:1.0];
    
    /*
    MyRecordInfoList *infoList = [[MyRecordInfoList alloc] init];
    infoList.myRecordMothInfoList = [NSArray array];
    infoList.recordMoth = self.myRecordListRequest.bespeakMonth;
    */
    [self.headerView setTitleLabelText:[self formatDateString:self.currentRecordMonth]];
    self.courseListArray = nil;

    [self.collectionView reloadData];
}

#pragma mark - MyRecordListHeaderViewDelegate

- (void)nextMonth
{
    DLog(@"下一个月");

    if ([self.currentRecordMonth isEqualToString:[self monthOfTodayString]]) {
        NSString *message = [NSString stringWithFormat:@"现在就是%@", [self formatDateString:[self monthOfTodayString]]];
        [RKDropdownAlert title:message time:1.0];
    }
    else {
        self.myRecordListRequest.bespeakMonth = [self nextMonthString];
        self.currentRecordMonth = [self nextMonthString];
        [self.myRecordListRequest getMyRecordList];
    }
}

- (void)previousMonth
{
    [self showHUDWithMessage:@""];
    
    self.myRecordListRequest.bespeakMonth = [self previousMonthString];
    self.currentRecordMonth = [self previousMonthString];
    [self.myRecordListRequest getMyRecordList];

}

- (void)resetNextMonthButtonEnableState
{
    BOOL isNextMonthButtonEnabled = NO;
    if (_courseListArray && ![self.currentRecordMonth isEqualToString:[self monthOfTodayString]]) {
        isNextMonthButtonEnabled = YES;
    }

    [self.headerView setNextMonthButtonEnable:isNextMonthButtonEnabled];
}

- (NSString *)formatDateString:(NSString *)dateString
{
    if (dateString && dateString.length > 5) {
        NSRange range = NSMakeRange(5, 1);
        NSString *subString = [dateString substringWithRange:range];
        if ([subString isEqualToString:@"0"]) {
            dateString = [dateString stringByReplacingCharactersInRange:range withString:@""];
        }
    }
    
    return [NSString stringWithFormat:@"%@月", [dateString stringByReplacingOccurrencesOfString:@"-" withString:@"年"]];
}

@end
