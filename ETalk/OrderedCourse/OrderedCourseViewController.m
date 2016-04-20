//
//  OrderedCourseViewController.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/5/28.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "OrderedCourseViewController.h"
#import "HTTPRequest.h"
#import "UserSingleton.h"
#import "MyOrderedCourse.h"
#import "Product.h"
#import "UIViewController+MBProgressHUD.h"
#import "RKDropdownAlert.h"
#import "OrderedCourseTableViewCell.h"
#import "ByCourseTableViewCell.h"
#import "ProductDetailViewController.h"
#import "UIViewController+BackButton.h"

#import "FirstLevelModel.h"
#import "SecondLevelModel.h"
#import "ThirdLevelModel.h"

#import "HTTPProduceRequest.h"

@interface OrderedCourseViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) HTTPRequest *request;

@property (strong, nonatomic) NSArray *courseInfoList;
@property (strong, nonatomic) NSArray *productList;

//新增购买套餐请求
@property (strong, nonatomic) HTTPProduceRequest *produceRequest;

@end

@implementation OrderedCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNavigaionBarBackButtonWithBackStyleDismiss];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupHTTPRequest];
    [self.request startRequest];
    
    [self setupProduceHTTPRequest];
    [self.produceRequest startProduceRequest];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.courseInfoList.count == 0) section++;
    
    NSInteger numberOfRowsInSection = 0;
    switch (section) {
        case 0:
            numberOfRowsInSection = self.courseInfoList.count;
            break;
            case 1:
            numberOfRowsInSection = self.productList.count;
            break;
            
        default:
            break;
    }
    
    return numberOfRowsInSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (self.courseInfoList.count == 0) section++;

    NSInteger heightForHeaderInSection = 0;
    switch (section) {
        case 0:
            heightForHeaderInSection = 128;
            break;
        case 1:
            heightForHeaderInSection = 96;
            break;
            
        default:
            break;
    }
    
    return heightForHeaderInSection;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = 0;
    if (self.courseInfoList.count > 0) {
        numberOfSections++;
    }
    
    if (self.productList.count > 0) {
        numberOfSections++;
    }
    
    return numberOfSections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (self.courseInfoList.count == 0) section++;

    switch (section) {
        case 0:
        {
            OrderedCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderedCourseTableViewCellIdentifier"];
            [cell setCourseInfo:[self.courseInfoList objectAtIndex:indexPath.row]];
            if ((indexPath.row + 1) == self.courseInfoList.count) cell.down = YES;
            cell.userInteractionEnabled = NO;
            
            return cell;
        }
            break;
        case 1:
        {
            ByCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ByCourseTableViewCellIdentifier"];
            [cell setCellProduceData:[self.productList objectAtIndex:indexPath.row]];
            if ((indexPath.row + 1) == self.productList.count) cell.down = YES;
            cell.userInteractionEnabled = YES;
            
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 72.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ((self.courseInfoList.count > 0) && section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyProductDtailInfoIdentifier"];
        return cell;
    }
    
    if (((self.courseInfoList.count == 0) && section == 0) || ((self.courseInfoList.count > 0) && section == 1)) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ByProductHeaderIndentifier"];
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"ProductToDetailIdentifier" sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.destinationViewController isKindOfClass:[ProductDetailViewController class]]) {
        ProductDetailViewController *productDetailViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(ByCourseTableViewCell *)sender];
        FirstLevelModel *senderFirstModel = _productList[indexPath.row];
        NSArray *secondLevelArray = senderFirstModel.secondListArray;
        productDetailViewController.secondLevelModelArray = secondLevelArray;
        productDetailViewController.productName = senderFirstModel.firstName;
        //Product * product = _productList[indexPath.row];
        //productDetailViewController.productID = product.idLM;
        //productDetailViewController.productName = product.title;
    }
    
}

#pragma mark - HTTPRequestDelegate

- (void)requestSuccess:(id)respondData
{
    [self hideHUD:NO];
    
    if (((NSArray *)respondData).count > 0) {
        NSArray *myCourseList = (NSArray *)respondData;
        NSMutableArray *myCourseArray = [[NSMutableArray alloc] init];
        for (NSDictionary *courseDic in myCourseList) {
            MyOrderedCourse *curCourseInfo = [[MyOrderedCourse alloc] initWithNewDictionary:courseDic];
            [myCourseArray addObject:curCourseInfo];
        }
        self.courseInfoList = myCourseArray;
    }
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
    if (_request) {
        [_request cancelRequest];
        _request.delegate = nil;
        _request = nil;
    }
}



- (void)setupHTTPRequest
{
    //self.request.title = @"user_get_orderandfirsttile_list";
    self.request.title = @"app_getMyOrderList.action";
    
//    NSString *userID =  [[[UserSingleton sharedInstance] userInfo] identifier];
//    NSDictionary *dic = @{kRequestKeyUserID : userID};
    NSString *tokenString = [[UserSingleton sharedInstance] tokenString];
    NSDictionary *dic = @{kRespondKeyNewTokenString : tokenString};
    self.request.parameters = dic ;
    
    self.request.requestType = kHTTPRequestType_Post;
    self.request.respondType = kHTTPRespondType_Data;
}

//新增购买套餐请求
- (HTTPProduceRequest *)produceRequest
{
    if (!_produceRequest) {
        _produceRequest = [[HTTPProduceRequest alloc] init];
        _produceRequest.produceDelegate = self;
    }
    return _produceRequest;
}

//新增购买套餐请求
- (void)setupProduceHTTPRequest
{
    self.produceRequest.produceSubUrl = @"app_getPackageList.action";
    NSString *tokenString = [[UserSingleton sharedInstance] tokenString];
    NSDictionary *dic = @{kRespondKeyNewTokenString : tokenString};
    self.produceRequest.producePara = dic;
    
    self.produceRequest.requestType = kHTTPProduceRequestType_Post;
    self.produceRequest.respondType = kHTTPProduceRespondType_Data;
}

//新增购买套餐请求
- (void)cancelProduceRequest
{
    if (_produceRequest) {
        _produceRequest.produceDelegate = nil;
        _produceRequest = nil;
    }
}

//新增购买套餐请求
- (void)requestProduceSuccess:(id)respondProduceData
{
    
    [self hideHUD:NO];
    self.productList = (NSArray *)respondProduceData;
    [self.tableView reloadData];
}

//新增购买套餐请求
- (void)requestProduceFailure:(NSString *)errorInfo
{
    [self hideHUD:NO];
    [RKDropdownAlert title:errorInfo time:1.0];
}

@end
