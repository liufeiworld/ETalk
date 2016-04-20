//
//  UserViewController.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/5/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "UserViewController.h"
#import "UserHeaderCell.h"
#import "UserSingleton.h"
#import "AppDelegate.h"
#import "HTTPRequest.h"
#import "RKDropdownAlert.h"
#import "UIViewController+MBProgressHUD.h"
#import "UIViewController+BackButton.h"

@interface UserViewController () <UITableViewDataSource, UITableViewDelegate, HTTPRequestDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSArray *userTitleList;

@property (strong, nonatomic) IBOutlet UIView *logoutAlertView;
- (IBAction)cancelLogout:(id)sender;
- (IBAction)logout:(id)sender;

@property (strong, nonatomic) HTTPRequest *request;

@end

@implementation UserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title  = @"个人中心";
    self.userTitleList = @[@[@"修改密码", @"修改手机号码", @"修改QQ号码"], @[@"退出当前账号"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addlogoutAlertView];
    [self setupNavigaionBarBackButtonWithBackStyleDismiss];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self removelogoutAlertView];

    
    [super viewWillDisappear:animated];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? 105.0 : 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UserHeaderCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"UserHeaderCellIdentifier"];
        [cell setUserInfo:[[UserSingleton sharedInstance] userInfo]];
        
        return cell;
    }
    else {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (section == 1) ? 150.0 : 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return  [tableView dequeueReusableCellWithIdentifier:@"UserFooterCellIdentifier"];
    }
    else {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ? 3  : 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"UserCellIdentifier"];
    cell.textLabel.text = [[self.userTitleList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.accessoryType = (indexPath.section == 1) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            NSString *segueIdentifier = nil;
            switch (indexPath.row) {
                case 0:
                    segueIdentifier = @"UserToModifyPassword";
                    break;
                case 1:
                    segueIdentifier = @"UserToModifyPhone";
                    break;
                case 2:
                    segueIdentifier = @"UserToModifyQQ";
                    break;
                default:
                    break;
            }
            
            [self performSegueWithIdentifier:segueIdentifier sender:nil];
        }
            break;
        case 1:
        {
            self.logoutAlertView.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - Logout View

- (void)addlogoutAlertView
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];
    
    if ([self.logoutAlertView superview] != window) {
        [self.logoutAlertView setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0.5]];
        [window addSubview:self.logoutAlertView];
        
        self.logoutAlertView.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_logoutAlertView);
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_logoutAlertView]-0-|"
                                                                       options:0 metrics:nil views:viewsDictionary];
        [window addConstraints:constraints];
        
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_logoutAlertView]-0-|"
                                                              options:0 metrics:nil views:viewsDictionary];
        [window addConstraints:constraints];
    }
    
    self.logoutAlertView.hidden = YES;
}

- (void)removelogoutAlertView
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];
    
    if ([self.logoutAlertView superview] == window) {
        [self.logoutAlertView removeFromSuperview];
    }
}

#pragma mark - Logout

- (IBAction)cancelLogout:(id)sender
{
    self.logoutAlertView.hidden = YES;
}

- (IBAction)logout:(id)sender
{
    self.logoutAlertView.hidden = YES;
//    [self setupHTTPRequest];
//    [self.request startRequest];
    [[UserSingleton sharedInstance] setState:kUserStateLogout];
    [Common clearPasswordForUserName:[Common userName]];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self showHUDWithMessage:@""];
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
    self.request.title = kRequestKeyUserLogout;
    
    //NSString *userID =  [[[UserSingleton sharedInstance] userInfo] identifier];
    //NSDictionary *dic = @{kRequestKeyUserID : userID};
    //self.request.parameters = dic ;
    
    self.request.requestType = kHTTPRequestType_Post;
    self.request.respondType = kHTTPRespondType_None;
}

#pragma mark - HTTPRequestDelegate

- (void)requestSuccess:(id)respondData
{
    //[self showHUDWithCompleteMessage:@"退出登陆成功"];
    [self hideHUD:NO];
    [[UserSingleton sharedInstance] setState:kUserStateLogout];
    [Common clearPasswordForUserName:[Common userName]];

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestFailure:(NSString *)errorInfo
{
    [self hideHUD:NO];
    [RKDropdownAlert title:errorInfo time:1.0];
}

@end
