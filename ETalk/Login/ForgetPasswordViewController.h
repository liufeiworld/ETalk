//
//  ForgetPasswordViewController.h
//  ETalk
//
//  Created by Neil on 15/4/6.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;


- (IBAction)commit:(id)sender;

@end
