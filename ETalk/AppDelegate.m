//
//  AppDelegate.m
//  ETalk
//
//  Created by Neil on 15/2/5.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [[UINavigationBar appearance] setBackgroundColor:RGB(155, 203, 45)];
    [[UINavigationBar appearance] setBarTintColor:RGB(155, 203, 45)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [[UINavigationBar appearance] setTranslucent:NO];
    }

    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    
    /***************************推送相关************************/
    
    if ([UIDevice currentDevice].systemVersion.doubleValue <= 8.0) {
        UIRemoteNotificationType type = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        [application registerForRemoteNotificationTypes:type];
    }else
    {
        UIUserNotificationType type = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        // 注册通知类型
        [application registerUserNotificationSettings:settings];
        
        // 申请试用通知
        [application registerForRemoteNotifications];
    }

    return YES;
}


/*****************************推送相关********************************/
/**
 *  获取到用户对应当前应用程序的deviceToken时就会调用
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
    NSString *token1 = [token substringToIndex:[token length] - 1];
    NSString *token2 = [token1 substringFromIndex:1];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:token2 forKey:kRespondKeyDeviceToken];
    
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@", userInfo);
    
//        static int count = 0;
//        count++;
//        UILabel *label = [[UILabel alloc] init];
//        label.frame = CGRectMake(0, 40, self.window.frame.size.width, 60);
//        label.numberOfLines = 0;
//        label.textColor = [UIColor whiteColor];
//        label.text = [NSString stringWithFormat:@"%@ \n %d", userInfo, count];
//        label.font = [UIFont systemFontOfSize:11];
//        label.backgroundColor = [UIColor grayColor];
//        [self.window.rootViewController.view addSubview:label];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
//    NSNumber *contentid =  userInfo[@"content-id"];
//    if (contentid) {
//        UILabel *label = [[UILabel alloc] init];
//        label.frame = CGRectMake(0, 40, self.window.frame.size.width, 60);
//        label.numberOfLines = 0;
//        label.textColor = [UIColor whiteColor];
//        label.text = [NSString stringWithFormat:@"%@", contentid];
//        label.font = [UIFont systemFontOfSize:30];
//        label.backgroundColor = [UIColor grayColor];
//        [self.window.rootViewController.view addSubview:label];
//        
//        completionHandler(UIBackgroundFetchResultNewData);
//    }else
//    {
//        completionHandler(UIBackgroundFetchResultFailed);
//    }
    
}
/*****************************推送相关********************************/



void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"url.host = %@", url.host);
    
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"111result = %@", resultDic);
        }];
    }
    
    return YES;
}
         


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
