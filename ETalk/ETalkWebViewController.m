//
//  ETalkWebViewController.m
//  ETalk
//
//  Created by etalk365 on 16/2/26.
//  Copyright © 2016年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "ETalkWebViewController.h"
#import "UIViewController+BackButton.h"

@interface ETalkWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ETalkWebViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNavigaionBarBackButtonWithBackStyleDismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *path = @"http://www.etalk365.cn/etalk/pronunciation.jsp";
    NSURL *url = [[NSURL alloc] initWithString:path];
    
    NSString *html = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:html baseURL:url];
}

@end
