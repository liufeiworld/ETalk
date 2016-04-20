//
//  LoginViewController.m
//  ETalk
//
//  Created by Neil on 15/2/5.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginRequest.h"
#import "UIViewController+MBProgressHUD.h"
#import "RKDropdownAlert.h"
#import "MainViewController.h"
#import "ClassInvitationViewController.h"
#import "TeacherInvateModel.h"
#import <pthread.h>


#define kViewAnimationOffset 120

@interface LoginViewController () <LoginRequestDelegate, UITextFieldDelegate>

@property (strong, nonatomic) LoginRequest *loginRequest;
@property (assign, nonatomic, getter=isKeyboardAnimated) BOOL keyboardAnimated;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _userNameBackgroundView.borderType = BorderTypeSolid;
    _userNameBackgroundView.borderWidth = 1;
    _userNameBackgroundView.cornerRadius = 4;
    _userNameBackgroundView.borderColor = COLOR(140, 197, 0, 1.0);
    
    [_userNameTextField setValue:UIColorFromRGB(0x9BCB2D)
                      forKeyPath:@"_placeholderLabel.textColor"];
    
    _passwordBackgroundView.borderType = BorderTypeSolid;
    _passwordBackgroundView.borderWidth = 1;
    _passwordBackgroundView.cornerRadius = 4;
    _passwordBackgroundView.borderColor = COLOR(140, 197, 0, 1.0);
    
    [_passwordTextField setValue:UIColorFromRGB(0x9BCB2D)
                      forKeyPath:@"_placeholderLabel.textColor"];
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusBarView.backgroundColor  =  UIColorFromRGB(0x9BCB2D);
    [self.view addSubview:statusBarView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    if (IS_SMALL_SCREEN_IPHONE) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.loginRequest) {
        [self.loginRequest cancelLogin];
    }
    [self.progressHUD hide:NO];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)forgetPassword:(id)sender
{

}

#pragma mark - Login

- (IBAction)login:(id)sender
{
    if (self.userNameTextField.text.length == 0) {
        [RKDropdownAlert title:@"请输入用户名" time:1.0];
        return;
    }
    
    if (self.passwordTextField.text.length == 0) {
        [RKDropdownAlert title:@"请输入密码" time:1.0];
        return;
    }
    
    self.loginRequest = [[LoginRequest alloc] init];
    self.loginRequest.delegate = self;
    [self.loginRequest loginWithUserName:self.userNameTextField.text password:self.passwordTextField.text];
    
/*****************将用户名和密码存储到NSUserDefaults中***********************/

    NSString *setPassWord = self.passwordTextField.text;
    NSString *setUserName = self.userNameTextField.text;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:setPassWord forKey:kRequestKeyPassword];
    [user setObject:setUserName forKey:kRespondKeyUserName];
    [self showHUDWithMessage:nil];
    [self requestData];
}

#pragma mark - 网络请求实现对tokenString信息的缓存
- (void)requestData{
    
    NSUserDefaults *_user  = [NSUserDefaults standardUserDefaults];
    NSString *username = [_user objectForKey:kRespondKeyUserName];
    NSString *password = [_user objectForKey:kRequestKeyPassword];
    NSDictionary *parameters = @{@"username":username,@"password":password};
    
    [[AFHTTPRequestOperationManager manager] POST:app_login_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *tokenString = responseObject[@"data"][@"tokenString"];
        [_user setValue:tokenString forKey:kRespondKeyNewTokenString];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
    }];
}

- (void)loginSuccess
{
    [self hideHUD:NO];
    [self back:nil];
    
}

- (void)loginFailure:(NSString *)errorInfo
{
    [self hideHUD:NO];
    [RKDropdownAlert title:errorInfo time:1.0];
}

#pragma mark - Back

- (IBAction)back:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Keyboard

- (void)handleTap:(id)sender
{
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

#pragma mark - Keyboard notification

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (self.isKeyboardAnimated) return;
    self.keyboardAnimated = YES;
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        CGRect frame = self.view.frame;
        self.view.frame = CGRectMake(frame.origin.x, frame.origin.y - kViewAnimationOffset, frame.size.width, frame.size.height);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (!self.isKeyboardAnimated) return;
    self.keyboardAnimated = NO;
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        CGRect frame = self.view.frame;
        self.view.frame = CGRectMake(frame.origin.x, frame.origin.y + kViewAnimationOffset, frame.size.width, frame.size.height);
    }];
}

@end
