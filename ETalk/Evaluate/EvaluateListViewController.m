//
//  EvaluateListViewController.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/23.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "EvaluateListViewController.h"
#import "EvaluateListCell.h"
#import "EvaluateListRequest.h"
#import "CourseInfo.h"
#import "UIViewController+MBProgressHUD.h"
#import "RKDropdownAlert.h"
#import "NSDate+WQCalendarLogic.h"
#import "EvaluateDailyViewController.h"
#import "UIViewController+BackButton.h"

@interface EvaluateListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, EvaluateListRequestDelegate>

@property (strong, nonatomic) EvaluateListRequest *evaluateListRequest;
@property (strong, nonatomic) NSArray *evaluateList ;

@end

@implementation EvaluateListViewController

#pragma mark - EvaluateListRequest

- (EvaluateListRequest *)evaluateListRequest
{
    if (!_evaluateListRequest) {
        _evaluateListRequest = [[EvaluateListRequest alloc] init];
        _evaluateListRequest.delegate = self;
    }
    
    return _evaluateListRequest;
}

- (void)cancelEvaluateListRequest
{
    [self hideHUD:NO];
    
    if (_evaluateListRequest) {
        [_evaluateListRequest cancelGetEvaluateList];
        _evaluateListRequest.delegate = nil;
        _evaluateListRequest = nil;
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
}


- (void)setupCollectionViewLayout
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(88, 44);
    flowLayout.sectionInset = UIEdgeInsetsMake(20.0, [self interItemSpacing], 20.0, [self interItemSpacing]);
    flowLayout.minimumInteritemSpacing = [self interItemSpacing];
    flowLayout.minimumLineSpacing = 10.0;
    flowLayout.headerReferenceSize = CGSizeZero;
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
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [self showHUDWithMessage:@""];
    [self.evaluateListRequest getEvaluateList];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self cancelEvaluateListRequest];
    
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
    return [self.evaluateList count];
}

//Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluateListCell *cell = (EvaluateListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"EvaluateListCellIdentifier" forIndexPath:indexPath];
    
    CourseInfoList *infoList = [self.evaluateList objectAtIndex:indexPath.row];
    [cell setTitleLabelText:infoList.title];
    
    return cell;
}

//代理－选择行的触发事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //点击推出页面
    NSLog(@"didSelectItemAtIndexPath:%@", indexPath);
    CourseInfoList *infoList = [self.evaluateList objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"EvaluateListToEvaluateDaily" sender:infoList];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EvaluateListToEvaluateDaily"]) {
        EvaluateDailyViewController *evaluateDailyViewController = (EvaluateDailyViewController *)segue.destinationViewController;
        //evaluateDailyViewController.dailyCourseList = [(CourseInfoList *)sender infoList];
        evaluateDailyViewController.dailyCourseInfoModel = (CourseInfoList *)sender;
    }
}

#pragma mark - 

- (void)getEvaluateListSuccess
{
    [self hideHUD:NO];
    self.evaluateList = [NSArray arrayWithArray:self.evaluateListRequest.evaluateList];
    [self.collectionView reloadData];
    
    if (self.evaluateList.count == 0) {
        [RKDropdownAlert title:@"您已经评价所有课程，谢谢！" time:1.5];
    }
}

//- (void)getEvaluateListSuccess
//{
//    NSLog(@"Before: %@", self.evaluateListRequest.evaluateList);
//    
//    [self hideHUD:NO];
//    
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    NSString *lastOrderInfo = nil;
//    
//    for (int i = 0; i < self.evaluateListRequest.evaluateList.count; i++) {
//        
//        CourseInfo *info = [self.evaluateListRequest.evaluateList objectAtIndex:i];
//        if (!lastOrderInfo || ![info.bespeakDate isEqualToString:lastOrderInfo]) {
//            
//            CourseInfoList *infoList = [[CourseInfoList alloc] init];
//            infoList.title = [info.bespeakDate stringByReplacingOccurrencesOfString:@"~" withString:@"-"];
//            [array addObject:infoList];
//            lastOrderInfo = info.bespeakDate;
//        }
//
//        CourseInfoList *infoList = [array lastObject];
//        [infoList.infoList addObject:info];
//    }
//    
//    if (array.count > 0) {
//        self.evaluateList = [NSArray arrayWithArray:array];
//    }
//    
//    [self.collectionView reloadData];
//    
//    
//    NSLog(@"After: %@", self.evaluateList);
//}

- (void)getEvaluateListFailure:(NSString *)errorInfo
{
    [self hideHUD:NO];
    [RKDropdownAlert title:errorInfo time:1.0];
}


@end
