//
//  ProductDetailViewController.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/6/7.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "HTTPRequest.h"
#import "UserSingleton.h"
#import "UIViewController+MBProgressHUD.h"
#import "RKDropdownAlert.h"
#import "UIViewController+BackButton.h"
#import "ProductDetailInfo.h"
#import "ByCourseTableViewController.h"
#import "ProductDetailTableViewCell.h"

@interface ProductDetailViewController ()

@property (strong, nonatomic) HTTPRequest *request;
@property (strong, nonatomic) NSArray *productList;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.productName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNavigaionBarBackButtonWithBackStylePop];
    [self setupNavigaionBarHomeButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //[self setupHTTPRequest];
    //[self.request startRequest];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.secondLevelModelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondLevelModel *secondModel = self.secondLevelModelArray[indexPath.row];
    if (secondModel.secondIntroduce.length > 0) {
        return 88.0;
    }
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isMultiLine = NO;
    SecondLevelModel *secondModel = self.secondLevelModelArray[indexPath.row];
    if (secondModel.secondIntroduce.length > 0) {
        isMultiLine = YES;
    }
    
    if (isMultiLine) {
        ProductDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductDetailCellIdentifier" forIndexPath:indexPath];
        [cell setSecondLevelDataWithModel:self.secondLevelModelArray[indexPath.row]];
        return cell;
    }
    else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProductDetailCellDefault"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = secondModel.secondName;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ByCourseToDetailIdentifier" sender:cell];
}



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[ByCourseTableViewController class]]) {
        ByCourseTableViewController *byCourseTableViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
        //byCourseTableViewController.productDetailInfo =  (ProductDetailInfo *)_productList[indexPath.row];
        //byCourseTableViewController.productName =  self.productName;
        SecondLevelModel *secondModel = self.secondLevelModelArray[indexPath.row];
        byCourseTableViewController.mainName = secondModel.secondName;
        byCourseTableViewController.thirdLevelArray = secondModel.packageListArray;
    }
}

#pragma mark - HTTPRequestDelegate

- (void)requestSuccess:(id)respondData
{
    [self hideHUD:NO];
    
    NSArray *products =  (NSArray *)respondData;
    NSMutableArray *mutableList = [[NSMutableArray alloc] init];
    for (int i = 0; i < products.count; i++) {
        ProductDetailInfo *detailInfo = [[ProductDetailInfo alloc] initWithDictionary:products[i]];
        [mutableList addObject:detailInfo];
    }
    _productList = [NSArray arrayWithArray:mutableList];
    
    
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
    self.request.title = @"get_product_list";
    
    NSDictionary *dic = @{@"pro_id_lm" : self.productID};
    self.request.parameters = dic ;
    
    self.request.requestType = kHTTPRequestType_Post;
    self.request.respondType = kHTTPRespondType_Data;
}


@end
