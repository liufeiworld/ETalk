//
//  ForgetPasswordViewController.m
//  ETalk
//
//  Created by Neil on 15/4/6.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "UIViewController+MBProgressHUD.h"
#import "RKDropdownAlert.h"
#import "ForgetPasswordRequest.h"
#import "UIViewController+BackButton.h"

@interface ForgetPasswordViewController () <UITextFieldDelegate, ForgetPasswordRequestDelegate>

@property (strong, nonatomic) ForgetPasswordRequest *forgetPasswordRequest;

@end

@implementation ForgetPasswordViewController

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

- (void)viewWillDisappear:(BOOL)animated
{
    [self cancelForgetPasswordRequest];
    [self hideHUD:NO];

    [super viewWillDisappear:animated];
}

#pragma mark - ForgetPasswordRequest

- (ForgetPasswordRequest *)forgetPasswordRequest
{
    if (!_forgetPasswordRequest) {
        _forgetPasswordRequest = [[ForgetPasswordRequest alloc] init];
        _forgetPasswordRequest.delegate = self;
    }
    
    return _forgetPasswordRequest;
}

- (void)cancelForgetPasswordRequest
{
    if (_forgetPasswordRequest) {
        [_forgetPasswordRequest cancelForgetPassword];
        _forgetPasswordRequest.delegate = nil;
        _forgetPasswordRequest = nil;
    }
}

#pragma mark - ForgetPasswordRequestDlegate


- (void)forgetPasswordSuccess
{
    [self showHUDWithCompleteMessage:@"邮件已发送"];
    
    [self performSelector:@selector(back:) withObject:nil afterDelay:2.0];
}

- (void)forgetPasswordFailure:(NSString *)errorInfo
{
    [self hideHUD:NO];

    [RKDropdownAlert title:errorInfo time:1.0];
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)commit:(id)sender
{
    if (self.emailTextField.text.length == 0) {
        [RKDropdownAlert title:@"请输入注册邮箱" time:1.0];
        return;
    }
    
    if (![self isValidEmailFormatterString:self.emailTextField.text]) {
        [RKDropdownAlert title:@"注册邮箱格式错误" time:1.0];
        return;
    }
    
    [self.forgetPasswordRequest forgetPasswordWithEmail:self.emailTextField.text];
    [self showHUDWithMessage:@""];
}

- (BOOL)isValidEmailFormatterString:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
