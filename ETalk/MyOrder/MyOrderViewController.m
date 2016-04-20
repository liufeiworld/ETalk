//
//  MyOrderViewController.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/23.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderHeaderReusableView.h"
#import "MyOrderCell.h"
#import "MyOrderRequest.h"
#import "CourseInfo.h"
#import "UIViewController+MBProgressHUD.h"
#import "RKDropdownAlert.h"
#import "NSDate+WQCalendarLogic.h"
#import "CourseDetailViewController.h"
#import "UIViewController+BackButton.h"

@interface MyOrderViewController () <UICollectionViewDataSource, UICollectionViewDelegate, MyOrderRequestDelegate>

@property (strong, nonatomic) MyOrderRequest *myOrderRequest;
@property (strong, nonatomic) NSArray *myOrderLIst ;

@end

@implementation MyOrderViewController

#pragma mark - MyOrderRequest

- (MyOrderRequest *)myOrderRequest
{
    if (!_myOrderRequest) {
        _myOrderRequest = [[MyOrderRequest alloc] init];
        _myOrderRequest.delegate = self;
    }
    
    return _myOrderRequest;
}

- (void)cancelMyOrderRequest
{
    [self hideHUD:NO];
    
    if (_myOrderRequest) {
        [_myOrderRequest cancelGetMyOrder];
        _myOrderRequest.delegate = nil;
        _myOrderRequest = nil;
    }
}

#pragma mark - Life Circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupCollectionViewLayout];
}


- (void)setupCollectionViewLayout
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(88, 44);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, [self interItemSpacing], 5.0, [self interItemSpacing]);
    flowLayout.minimumInteritemSpacing = [self interItemSpacing];
    flowLayout.minimumLineSpacing = 10.0;
    flowLayout.headerReferenceSize = CGSizeMake(self.collectionView.frame.size.width, 40.0);
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

    [self showHUDWithMessage:@""];
    [self.myOrderRequest getMyOrderList];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self cancelMyOrderRequest];
    
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
    return [self.myOrderLIst count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[(CourseInfoList *)[self.myOrderLIst objectAtIndex:section] infoList] count];
}

//Cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyOrderCell *cell = (MyOrderCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MyOrderCellIdentifier" forIndexPath:indexPath];
    
    CourseInfoList *infoList = [self.myOrderLIst objectAtIndex:indexPath.section];
    CourseInfo *info = [infoList.infoList objectAtIndex:indexPath.row];
    //[cell setTitleLabelText:[info.bespeakPeriod stringByReplacingOccurrencesOfString:@"~" withString:@"-"]];
    [cell setTitleLabelText:info.coursePeriod];
    
    return cell;
}

//代理－选择行的触发事`件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //点击推出页面
    NSLog(@"didSelectItemAtIndexPath:%@", indexPath);
    CourseInfoList *infoList = [self.myOrderLIst objectAtIndex:indexPath.section];
    CourseInfo *info = [infoList.infoList objectAtIndex:indexPath.row];
    NSDictionary *dict = @{@"dateString" : infoList.title , @"courseIfo" : info};
    //[self performSegueWithIdentifier:@"MyOrderToCourseDetail" sender:info];
    [self performSegueWithIdentifier:@"MyOrderToCourseDetail" sender:dict];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        MyOrderHeaderReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MyOrderHeaderReusableViewIdentifier" forIndexPath:indexPath];
        CourseInfoList *infoList = [self.myOrderLIst objectAtIndex:indexPath.section];
        NSDate * date = [[NSDate alloc] dateFromString:infoList.title];
        NSString *week = [date compareIfTodayWithDate];
        [headerView setTitle:[NSString stringWithFormat:@"%@ %@", infoList.title, week]];
        
        return headerView;
    }
    
    return nil;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MyOrderToCourseDetail"]) {
        CourseDetailViewController *detailViewController = (CourseDetailViewController *)segue.destinationViewController;
        //detailViewController.courseInfo = (CourseInfo *)sender;
        detailViewController.getDictionary = (NSDictionary *)sender;
    }
}

#pragma mark - 

- (void)getMyOrderSuccess
{
    [self hideHUD:NO];
    self.myOrderLIst = [NSArray arrayWithArray:self.myOrderRequest.orderList];
    [self.collectionView reloadData];
}

//- (void)getMyOrderSuccess
//{
//    //NSLog(@"%@", self.myOrderRequest.orderList);
//    
//    [self hideHUD:NO];
//
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    NSString *lastOrderInfo = nil;
//    
//        for (int i = 0; i < self.myOrderRequest.orderList.count; i++) {
//            
//            CourseInfo *info = [self.myOrderRequest.orderList objectAtIndex:i];
//            if (!lastOrderInfo || ![info.bespeakDate isEqualToString:lastOrderInfo]) {
//                CourseInfoList *infoList = [[CourseInfoList alloc] init];
//                infoList.title = [info.bespeakDate stringByReplacingOccurrencesOfString:@"~" withString:@"-"];
//                [array addObject:infoList];
//            }
//            
//            CourseInfoList *infoList = [array lastObject];
//            [infoList.infoList addObject:info];
//            lastOrderInfo = infoList.title;
//        }
//    
//    if (array.count > 0) {
//        self.myOrderLIst = [NSArray arrayWithArray:array];
//        [self.collectionView reloadData];
//    }
//}

- (void)getMyOrderFailure:(NSString *)errorInfo
{
    [self hideHUD:NO];
    [RKDropdownAlert title:errorInfo time:1.0];
}


@end
