//
//  ByCourseTableViewController.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/6/3.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "ByCourseTableViewController.h"
#import "UIViewController+BackButton.h"
#import "ProductDetailInfo.h"
#import "ByCourseHeaderTableViewCell.h"
#import "ByCourseListTableViewCell.h"   
#import "HTTPRequest.h"
#import "RKDropdownAlert.h"
#import "UIViewController+MBProgressHUD.h"
#import "UserSingleton.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@interface ByCourseTableViewController ()

@property (strong, nonatomic) HTTPRequest *request;
@property (strong, nonatomic) BuyCourseInfo *courseInfo;

@property (strong, nonatomic) ThirdLevelModel *willBuyInfo;

@end

@implementation ByCourseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    if (self.productName.length > 0) {
//        NSArray *array = [self.productName componentsSeparatedByString:@"："];
//        if (array && array.count > 0) {
//            self.title = array[0];
//        }
//    }
    if (self.mainName.length > 0) {
        self.title = self.mainName;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigaionBarBackButtonWithBackStylePop];
    [self setupNavigaionBarHomeButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.productDetailInfo.courseList.count;
    return self.thirdLevelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ByCourseHeaderTableViewCell *headerTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ByCourseHeaderIndentifier"];
    if (self.mainName.length > 0) {
        [headerTableViewCell setTitle:self.mainName];
    }

    return headerTableViewCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ByCourseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ByCourseListTableViewCellIdentifier" forIndexPath:indexPath];
    //[cell setBuyCourseInfo:self.productDetailInfo.courseList[indexPath.row]];
    [cell setThirdLevelDataWithModel:self.thirdLevelArray[indexPath.row]];
    UIButton *button = (UIButton *)[cell viewWithTag:314169427];
    [button addTarget:self action:@selector(buyCourse:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)buyCourse:(id)sender
{
    UITableViewCell *cell = [self getSuperTableViewCell:sender];
    if (cell) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        if (indexPath) {
            //self.courseInfo = self.productDetailInfo.courseList[indexPath.row];
            self.willBuyInfo = self.thirdLevelArray[indexPath.row];
            
            [self setupHTTPRequest];
            [self.request startRequest];
            [self showHUDWithMessage:@""];
        }
    }
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

#pragma mark - Pay

- (void)startPayWithDictionray:(NSDictionary *)dic
{
    //生成订单信息及签名
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = @"2088711044544770";
    order.seller = @"jiangyan@etalk365.com";
    order.tradeNO = dic[@"orderId"]; //订单ID（由商家自行制定）
    order.productName = dic[@"packageTitle"]; //商品标题
    order.productDescription = dic[@"packageTitle"]; //商品描述
    order.amount =  [NSString stringWithFormat:@"%d",[dic[@"payMoney"] intValue]]; //商品价格
    //order.amount = [NSString stringWithFormat:@"%0.2f",0.01];
    order.notifyURL =  @"http://www.etalk365.com"; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(@"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBANzFsvsnCJEouPWegGJi4i9YaxA35GxHvU0sezDMXdnbZ7sOoBLUu2QbN3c7sMvpMCSRD157zyhmJ8lhHB9KRNjuxBdj7kr1a0aek+5CF+Hfc1k6YW9zFx/Ajpvguv8cqc4azkETYY1FKNq/kGTeRpShRlcZ0Cdx6+EkOpZjR049AgMBAAECgYASWxmzih5LO3CNc31HMOOPfjGAqrUCT8Csjvs7JnLTL0vjoKasiiV+gEjPUBY2DhBjqe/2MiMaP8wlET7uVxV8MG0p9xBCQpjucaWp2Z2hRhIE1qz6xrcFR/vRKa6ANFkrCL8pCAnmZlVvIGYHcmCsY1aEKkl5RajHYkTBRdZLfQJBAO/Rny+W9Vmyyz5wzl2yjUEBqY2V1n8OebSm2g6MNueaSQoHRg9H2PdxUwvt47J5V/ArlEThFN31KZFrq+vgVwcCQQDrqxY8+aOOgouyoYcAp+hvfwh7zXSar26Dv9z/6UFg7GgtGQUbjBUq6WcCvl8jPtkvcPKe7C4yVanyXH3RfDubAkByX+8jq0NofDUimnpRhY6IqlpLBGNARY8V8V2eApFM8/BRsBZhw0pe+NU6o0ItJGIkUSRtlUt2cC5bBJcB8ASRAkBynS1ekEZ0K5dHU/l1XzPS7eQxWbWo+UL1Pl179HRAcBkmPbHXOOSejw7zLaTVXl6ADR1iHxlEj5bscQEb3aCbAkEAuEVjKQKL7HCwTD3zdKWNJPVqj8S54AhEZ7DAEuTtxsXo5zBdiQa/yCF4Ns9jH54fh4ipa7713r9S68K2BJ2yjg==");
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];

                 
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"eTalkForAlipay" callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);

            int stateCode = [resultDic[@"resultStatus"] intValue];
            NSString *info = [self infoForAlipayResultState:stateCode];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (stateCode == 9000) {
                    [self showHUDWithCompleteMessage:info];
                }
                else {
                    [self showHUDWithFailureMessage:info];
                }
            });
        }];
    }
}

- (NSString *)infoForAlipayResultState:(int)state
{
    
    switch (state) {
        case 9000:
            return @"订单支付成功";
            break;
        case 8000:
            return @"正在处理中";
            break;
        case 4000:
            return @"订单支付失败";
            break;
        case 6001:
            return @"用户中途取消";
            break;
        case 6002:
            return @"网络连接出错";
            break;
        default:
            break;
    }
    
    return @"订单支付失败";
}

#pragma mark - HTTPRequestDelegate

- (void)requestSuccess:(id)respondData
{
    NSLog(@"AlipaySDK %@", respondData);
    NSDictionary *dictionary = (NSDictionary *)respondData;
    NSLog(@"----------%@",dictionary[@"packageTitle"]);
    
    if (respondData) {
        [self hideHUD:NO];
        [self startPayWithDictionray:(NSDictionary *)respondData];
    }
    else {
        [self showHUDWithFailureMessage:@"付款失败"];
    }
    
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

#pragma mark - HTTP Request

- (void)setupHTTPRequest
{
    //self.request.title = kRequestKeyUserBuy;
    
    self.request.title = @"app_saveOrderInfo.action";
    
    NSString *tokenString = [[UserSingleton sharedInstance] tokenString];
    NSDictionary *dic = @{kRespondKeyNewTokenString : tokenString , kRequestKeyNewPackageId : @(self.willBuyInfo.packageId)};
    self.request.parameters = dic;
    
    self.request.requestType = kHTTPRequestType_Post;
    self.request.respondType = kHTTPRespondType_Data;
}


@end
