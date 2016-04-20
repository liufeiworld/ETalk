//
//  UIViewController+MBProgressHUD.m
//  dsPlayer
//
//  Created by Neil on 5/21/14.
//  Copyright (c) 2014 深圳市点视科技有限公司. All rights reserved.
//

#import "UIViewController+MBProgressHUD.h"
#import <objc/runtime.h>

const void *progressHUDKey = &progressHUDKey;

@implementation UIViewController (MBProgressHUD)

- (MBProgressHUD *)progressHUD
{
    MBProgressHUD *hud = objc_getAssociatedObject(self, progressHUDKey);
    if(!hud)
    {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.minShowTime = 0.25;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
        [self.view addSubview:hud];
        self.progressHUD = hud;
    }
    return hud;
}

- (void)setProgressHUD:(MBProgressHUD *)progressHUD
{
    objc_setAssociatedObject(self, progressHUDKey, progressHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHUDWithMessage:(NSString *)message
{
    self.progressHUD.labelText = message;
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    [self.progressHUD show:YES];
}

- (void)hideHUD:(BOOL)animated
{
    [self.progressHUD hide:animated];
}

- (void)showHUDWithCompleteMessage:(NSString *)message
{
    [self.progressHUD show:YES];
    self.progressHUD.labelText = message;
    self.progressHUD.mode = MBProgressHUDModeCustomView;
    [self.progressHUD hide:YES afterDelay:1.0];
}

- (void)showHUDWithFailureMessage:(NSString *)message
{
    [self.progressHUD show:YES];
    self.progressHUD.labelText = message;
    self.progressHUD.mode = MBProgressHUDModeText;
    [self.progressHUD hide:YES afterDelay:2.0];
}

@end
