//
//  RegisterViewController.h
//  ETalk
//
//  Created by Neil on 15/4/7.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *recommendCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

- (IBAction)register:(id)sender;

@end
