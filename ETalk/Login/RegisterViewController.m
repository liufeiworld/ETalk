//
//  RegisterViewController.m
//  ETalk
//
//  Created by Neil on 15/4/7.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIViewController+MBProgressHUD.h"
#import "RKDropdownAlert.h"
#import "RegisterRequest.h"
#import "UIViewController+BackButton.h"

@interface RegisterViewController () <UITextFieldDelegate, RegisterRequestDelegate>

@property (strong, nonatomic) RegisterRequest *registerRequest;
@property (assign , nonatomic) CGFloat animationOffset;

@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNavigaionBarBackButtonWithBackStyleDismiss];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    if (self.registerRequest) {
        [self.registerRequest cancelRegister];
    }
    [self.progressHUD hide:NO];

    [super viewWillDisappear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Register

- (IBAction)register:(id)sender
{
    if (self.userNameTextField.text.length == 0) {
        [RKDropdownAlert title:@"请输入用户名" time:1.0];
        return;
    }
    
    if (self.passwordTextField.text.length == 0) {
        [RKDropdownAlert title:@"请输入密码" time:1.0];
        return;
    }
    
    if (![self isPasswordValid]) {
        [RKDropdownAlert title:@"密码格式错误，6-16位字母+数字组合" time:1.0];
        return;
    }
    
    if (self.emailTextField.text.length == 0){
        [RKDropdownAlert title:@"请输入您的手机号码" time:1.0];
        return;
    }
    
    if (self.phoneNumberTextField.text.length != 0){
        if(![self isValidEmailFormatterString:self.phoneNumberTextField.text]){
            [RKDropdownAlert title:@"请输入正确的邮箱地址" time:1.0];
            return;
        }
    }

//    if(self.emailTextField.text.length != 0)
//    {
//        if(![self isValidEmailFormatterString:self.emailTextField.text])
//        {
//            [RKDropdownAlert title:@"请输入正确的邮箱地址" time:1.0];
//            return;
//        }
//    }
//
//    if (self.phoneNumberTextField.text.length == 0) {
//        [RKDropdownAlert title:@"请输入您的手机号码" time:1.0];
//        return;
//    }
    
    self.registerRequest = [[RegisterRequest alloc] init];
    self.registerRequest.delegate = self;
    [self.registerRequest registerWithUserName:self.userNameTextField.text
                                      password:self.passwordTextField.text
                                         email:self.phoneNumberTextField.text
                                   phoneNumber:self.emailTextField.text
                                   refereeCode:self.recommendCodeTextField.text];
    [self showHUDWithMessage:@""];
}

- (BOOL)isPasswordValid
{
    NSString *password = self.passwordTextField.text;
    if (password.length > 16 || password.length < 6) {
        return NO;
    }
    
    for (NSInteger i = 0; i < password.length; i++) {
        unichar char1 = [password characterAtIndex:i];
        if (![self isCharacterLetterOrNumber:char1]) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)isCharacterLetterOrNumber:(unichar)char1
{
    if ((char1 >= 0x30 && char1 <= 0x39) || (char1 >= 0x41 && char1 <= 0x5A) ||
        (char1 >= 0x61 && char1 <= 0x7A)) {
        return YES;
    }
    else {
        return NO;
    }
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

#pragma mark - Register Delegate

- (void)registerSuccess
{
    [self showHUDWithCompleteMessage:@"注册成功"];
    [self performSelector:@selector(back:) withObject:nil afterDelay:2.0];
}

- (void)back:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerFailure:(NSString *)errorInfo
{
    NSLog(@"errorInfo00000000.........%@",errorInfo);
    [self hideHUD:NO];
    [RKDropdownAlert title:errorInfo time:1.0];
    
}

#pragma mark - TextField

- (void)handleTap:(id)sender
{
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
    [self.recommendCodeTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    
    [self recoveryViewAnimation];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self recoveryViewAnimation];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"t:%@", textField);
    
    CGFloat offset = [self currentOffsetOfTextField:textField];
    CGFloat currentOffset = offset - self.animationOffset;
    self.animationOffset = offset;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.view.frame;
        self.view.frame = CGRectMake(frame.origin.x, frame.origin.y - currentOffset, frame.size.width, frame.size.height);
    }];
    
    return YES;
}

- (CGFloat)currentOffsetOfTextField:(UITextField *)textField
{
    CGFloat deviceOffset = IS_SMALL_SCREEN_IPHONE ? 52.0 : 0.0;
    
    if (self.emailTextField == textField) {
        return 52.0 + deviceOffset;
    }
    
    if (self.phoneNumberTextField == textField) {
        return 52.0 * 2 + deviceOffset;
    }
    
    if (self.recommendCodeTextField == textField) {
        return 52.0 * 3 + deviceOffset;
    }
    
    return 0;
}

- (void)recoveryViewAnimation
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.view.frame;
        self.view.frame = CGRectMake(frame.origin.x, frame.origin.y + self.animationOffset, frame.size.width, frame.size.height);
    }];
    
    self.animationOffset = 0.0;
}

@end
