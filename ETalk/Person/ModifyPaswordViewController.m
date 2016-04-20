//
//  ModifyPaswordViewController.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/5/13.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "ModifyPaswordViewController.h"
#import "HTTPRequest.h"
#import "RKDropdownAlert.h"
#import "UIViewController+MBProgressHUD.h"
#import "UserSingleton.h"
#import "UIViewController+BackButton.h"

@interface ModifyPaswordViewController () <UITextFieldDelegate, HTTPRequestDelegate>

@property (weak, nonatomic) IBOutlet UITextField *originPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *freshPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

- (IBAction)save:(id)sender;


@property (strong, nonatomic) HTTPRequest *request;

@end

@implementation ModifyPaswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


- (IBAction)save:(id)sender
{
    if (self.originPasswordTextField.text.length == 0) {
        [RKDropdownAlert title:@"请输入原密码" time:1.0];
        return;
    }
    
    if (self.freshPasswordTextField.text.length == 0) {
        [RKDropdownAlert title:@"请输入新密码" time:1.0];
        return;
    }
    
    if (self.confirmPasswordTextField.text.length == 0) {
        [RKDropdownAlert title:@"请再次输入新密码" time:1.0];
        return;
    }
    
    if (![self.freshPasswordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [RKDropdownAlert title:@"两次新密码不一致，请重新输入" time:1.0];
        self.freshPasswordTextField.text = nil;
        self.confirmPasswordTextField.text = nil;
        return;
    }
    
    [self setupHTTPRequest];
    [self.request startRequest];
    [self showHUDWithMessage:@""];
}

#pragma mark - HTTPRequestDelegate

- (void)requestSuccess:(id)respondData
{
    [self showHUDWithCompleteMessage:@"修改成功"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });

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

- (void)setupHTTPRequest
{
    self.request.title = @"app_editUserInfo.action";
    
    NSString *tokenString =  [[UserSingleton sharedInstance] tokenString];
    NSDictionary *dic = @{kRespondKeyNewTokenString : tokenString, kRequestKeyOldPassword : self.originPasswordTextField.text, kRequestKeyNewPassword : self.freshPasswordTextField.text};
    self.request.parameters = dic ;
    
    self.request.requestType = kHTTPRequestType_Post;
    self.request.respondType = kHTTPRespondType_None;
}


@end
