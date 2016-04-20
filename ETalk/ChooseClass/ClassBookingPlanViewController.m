//
//  ClassBookingPlanViewController.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/14.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "ClassBookingPlanViewController.h"
#import "ClassBookingPlanRequest.h"
#import "ClassOrderInfo.h"
#import "RKDropdownAlert.h"
#import "UIViewController+MBProgressHUD.h"
#import "ClassBookingViewController.h"
#import "UIViewController+BackButton.h"

@interface ClassBookingPlanViewController () <UITableViewDataSource, UITableViewDelegate, ClassBookingPlanRequestDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) ClassBookingPlanRequest *getPlanRequest;
@property (strong, nonatomic) NSArray *userOrderList;
@property (strong, nonatomic) ClassOrderInfo *classOrderInfo;

@end

@implementation ClassBookingPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        self.navigationController.navigationBar.translucent = NO;
    }

    [self setupNavigaionBarBackButtonWithBackStyleDismiss];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.userOrderList) {
        self.getPlanRequest = [[ClassBookingPlanRequest alloc] init];
        self.getPlanRequest.delegate = self;
        [self.getPlanRequest getClassBookingPlan];
        [self showHUDWithMessage:@""];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.getPlanRequest cancelClassBookingPlan];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userOrderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassBookingPlanReuseIdentifier"];
    ClassOrderInfo *orderInfo = [self.userOrderList objectAtIndex:indexPath.row];
    //cell.textLabel.text = orderInfo.productTitle;
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@-%@", orderInfo.name1, orderInfo.name2, orderInfo.name3];
//    UIView *view = [cell viewWithTag:25064];
//    if ([orderInfo.orderState intValue] == 1) {
//        //cell.textLabel.textColor = [UIColor redColor];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        view.hidden = YES;
//    }
//    else {
//        cell.textLabel.textColor = [UIColor lightGrayColor];
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        view.hidden = NO;
//    }
    
    
    UIView *view = [cell viewWithTag:25064];
    UILabel *label = (UILabel *)view;
    if (orderInfo) {
        if ([orderInfo.state intValue] == 2) {
            //cell.textLabel.textColor = [UIColor redColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            view.hidden = YES;
        }
        if ([orderInfo.state intValue] == 0) {
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            //label.text = @"未购买";
            view.hidden = NO;
        }
        if ([orderInfo.state intValue] == 1) {
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            label.text = @"已过期";
            label.textColor = [UIColor blueColor];
            view.hidden = NO;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    ClassOrderInfo *orderInfo = [self.userOrderList objectAtIndex:indexPath.row];
//    if ([orderInfo.orderState intValue] == 1) {
//        _classOrderInfo = [self.userOrderList objectAtIndex:indexPath.row];
//        [self performSegueWithIdentifier:@"PlanToOrderViewIdentifier" sender:nil];
//    }
    
    
        if ([orderInfo.state intValue] == 2) {
            _classOrderInfo = [self.userOrderList objectAtIndex:indexPath.row];
           [self performSegueWithIdentifier:@"PlanToOrderViewIdentifier" sender:nil];
        }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue.destinationViewController class] isSubclassOfClass:[ClassBookingViewController class]]) {
        ClassBookingViewController *destinationViewController = segue.destinationViewController;
            destinationViewController.orderId = _classOrderInfo.orderId;
//        destinationViewController.productID = _classOrderInfo.productID;
//        destinationViewController.productLM = _classOrderInfo.lm;
    }
}

#pragma mark - Class Booking Plan

- (void)getClassBookingPlanSuccess
{
    [self hideHUD:NO];

    self.userOrderList = self.getPlanRequest.userPlanList;
    [self.tableView reloadData];
}

- (void)getClassBookingPlanFailure:(NSString *)errorInfo
{
    [self hideHUD:NO];
    [RKDropdownAlert title:errorInfo time:1.0];
}


@end
