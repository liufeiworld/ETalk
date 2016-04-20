//
//  UIViewController+BackButton.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/5/7.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "UIViewController+BackButton.h"


@implementation UIViewController (BackButton)

- (void)setupNavigaionBarBackButtonWithBackStylePop
{
    SEL selector = @selector(backPop);
    [self  setupNavigaionBarBackButtonWithBackSelector:selector];
}

- (void)setupNavigaionBarBackButtonWithBackStyleDismiss
{
    SEL selector = @selector(backDismiss);
    [self  setupNavigaionBarBackButtonWithBackSelector:selector];
}

- (void)setupNavigaionBarBackButtonWithBackSelector:(SEL)selector
{
    if (self.navigationController) {
        [self.navigationItem setHidesBackButton:YES];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 44);
        [button setTitle:@"      " forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"BackPreWhite"] forState:UIControlStateNormal];
        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)backPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backDismiss
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}

- (void)setupNavigaionBarHomeButton
{
    if (self.navigationController) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
        [button setTitle:@"      " forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"1_7_4"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backDismiss) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    
}

@end
