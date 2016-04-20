//
//  LoginWebViewController.m
//  ETalk
//
//  Created by etalk365 on 16/2/19.
//  Copyright © 2016年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "LoginWebViewController.h"

@interface LoginWebViewController ()<UIScrollViewDelegate,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong)NSString *webURL;

@end

@implementation LoginWebViewController

- (NSString *)webURL{
    
    if (!_webURL) {
        
        _webURL = @"http://www.etalk365.com/mobile/mlogin.html";
    }
    return _webURL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view = [[NSBundle mainBundle] loadNibNamed:@"LoginWebViewController" owner:self options:0][0];
    NSArray *array = [NSArray arrayWithArray:[self.webView subviews]];
    UIScrollView *webScrollView = (UIScrollView *)[array objectAtIndex:0];
    webScrollView.delegate = self;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self requestURL:self.webURL];
    
    [self prefersStatusBarHidden];
}

- (void)requestURL:(NSString *)URL{
    
    NSURL *webURL = [NSURL URLWithString:URL];
    NSString *webHtmlStr = [[NSString alloc] initWithContentsOfURL:webURL encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:webHtmlStr baseURL:webURL];
}

- (IBAction)backAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
