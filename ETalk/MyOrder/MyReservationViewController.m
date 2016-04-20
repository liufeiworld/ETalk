//
//  MyReservationViewController.m
//  ETalk
//
//  Created by etalk365 on 16/2/19.
//  Copyright © 2016年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "MyReservationViewController.h"

@interface MyReservationViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation MyReservationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNavigaionBarBackButtonWithBackStyleDismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *path = @"http://www.etalk365.com/mobile/mlogin.html";
    NSURL *url = [[NSURL alloc] initWithString:path];
    
    NSString *html = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:html baseURL:url];
}

@end
