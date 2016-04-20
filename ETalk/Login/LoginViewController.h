//
//  LoginViewController.h
//  ETalk
//
//  Created by Neil on 15/2/5.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBorderView.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet LBorderView *userNameBackgroundView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet LBorderView *passwordBackgroundView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic,assign) NSInteger ThreadFlag;

- (IBAction)forgetPassword:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)back:(id)sender;

@end
