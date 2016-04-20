//
//  UIViewController+MBProgressHUD.h
//  dsPlayer
//
//  Created by Neil on 5/21/14.
//  Copyright (c) 2014 深圳市点视科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (MBProgressHUD)

@property (nonatomic, readonly) MBProgressHUD *progressHUD;

- (void)showHUDWithMessage:(NSString *)message;

- (void)hideHUD:(BOOL)animated;

- (void)showHUDWithCompleteMessage:(NSString *)message;

- (void)showHUDWithFailureMessage:(NSString *)message;


@end
