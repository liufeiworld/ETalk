//
//  ProposalView.m
//  ETalk
//
//  Created by etalk365 on 16/1/27.
//  Copyright © 2016年 深圳市易课科技文化有限公司. All rights reserved.
//

#import "ProposalView.h"
#import "MainViewController.h"

@interface ProposalView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *subCommitBtn;
- (IBAction)subCommitAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn204;
@property (weak, nonatomic) IBOutlet UIButton *btn205;
- (IBAction)btnAction204:(UIButton *)sender;
- (IBAction)btnAction205:(UIButton *)sender;
@property (nonatomic,assign)NSInteger yesOrNo;

@property (weak, nonatomic) IBOutlet UIButton *btn401;
- (IBAction)btnAction401:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn402;
- (IBAction)btnAction402:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn403;
- (IBAction)btnAction403:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn404;
- (IBAction)btnAction404:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn405;
- (IBAction)btnAction405:(UIButton *)sender;
@property (nonatomic,assign)NSInteger score400;

@property (weak, nonatomic) IBOutlet UIButton *btn501;
- (IBAction)btnAction501:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn502;
- (IBAction)btnAction502:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn503;
- (IBAction)btnAction503:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn504;
- (IBAction)btnAction504:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn505;
- (IBAction)btnAction505:(UIButton *)sender;
@property (nonatomic,assign)NSInteger score500;

@property (weak, nonatomic) IBOutlet UIButton *btn601;
- (IBAction)btnAction601:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn602;
- (IBAction)btnAction602:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn603;
- (IBAction)btnAction603:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn604;
- (IBAction)btnAction604:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn605;
- (IBAction)btnAction605:(UIButton *)sender;
@property (nonatomic,assign)NSInteger score600;

@property (weak, nonatomic) IBOutlet UIButton *btn701;
- (IBAction)btnAction701:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn702;
- (IBAction)btnAction702:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn703;
- (IBAction)btnAction703:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn704;
- (IBAction)btnAction704:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn705;
- (IBAction)btnAction705:(UIButton *)sender;
@property (nonatomic,assign)NSInteger score700;

@end

@implementation ProposalView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    _yesOrNo = 1;
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(check) object:nil];
    [thread start];
    
}

- (void)check{

    while (1) {
        
        NSString *score400 = [NSString stringWithFormat:@"%ld",(long)self.score400];
        NSString *score500 = [NSString stringWithFormat:@"%ld",(long)self.score500];
        NSString *score600 = [NSString stringWithFormat:@"%ld",(long)self.score600];
        NSString *score700 = [NSString stringWithFormat:@"%ld",(long)self.score700];
        
        if ([score400 isEqualToString:@"0"] && [score500 isEqualToString:@"0"] && [score600 isEqualToString:@"0"] && [score700 isEqualToString:@"0"]) {
            
            _subCommitBtn.enabled = NO;
            _subCommitBtn.backgroundColor = [UIColor lightGrayColor];
        }else if (![score400 isEqualToString:@"0"] && ![score500 isEqualToString:@"0"] && ![score600 isEqualToString:@"0"] && ![score700 isEqualToString:@"0"]){
        
            _subCommitBtn.enabled = YES;
            _subCommitBtn.backgroundColor = [UIColor greenColor];
            break;
        }
    }
}

- (IBAction)subCommitAction:(UIButton *)sender {
    
    //外教是否迟到
    NSString *instruction = [NSString stringWithFormat:@"%ld",(long)_yesOrNo];
    //上课网络效果
    NSString *networkEffect = [NSString stringWithFormat:@"%ld",(long)self.score400];
    //外教发音标准
    NSString *articulation = [NSString stringWithFormat:@"%ld",(long)self.score500];
    //外教上课态度
    NSString *practiceCorrection = [NSString stringWithFormat:@"%ld",(long)self.score600];
    //外教教学水平
    NSString *attitude = [NSString stringWithFormat:@"%ld",(long)self.score700];
    
    NSLog(@"instruction = %@",instruction);
    NSLog(@"networkEffect = %@",networkEffect);
    NSLog(@"articulation = %@",articulation);
    NSLog(@"practiceCorrection = %@",practiceCorrection);
    NSLog(@"attitude = %@",attitude);
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *courseId = [user objectForKey:kRespondKeyCourseId];
    NSString *tokenString = [[UserSingleton sharedInstance] tokenString];
    NSDictionary *param = @{@"tokenString":tokenString,@"courseId":courseId,@"stuComplain.instruction":instruction,@"stuComplain.networkEffect":networkEffect,@"stuComplain.articulation":articulation,@"stuComplain.practiceCorrection":practiceCorrection,@"stuComplain.attitude":attitude};
    [[AFHTTPRequestOperationManager manager] POST:ProposalView_URL parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"1802:本节课已投诉");
        NSLog(@"responseObject = %@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"1801:提交投诉失败");
        
    }];
    
    
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"已经收到您的建议，我们不怕批评，我们只想做得更好！" preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
}

- (IBAction)btnAction204:(UIButton *)sender {
    
    _yesOrNo = 1;
    [_btn204 setBackgroundColor:[UIColor orangeColor]];
    [_btn204 setTitle:@"是" forState:UIControlStateNormal];
    [_btn204 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btn205 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btn205 setBackgroundColor:[UIColor lightGrayColor]];
}

- (IBAction)btnAction205:(UIButton *)sender {
    
    _yesOrNo = 0;
    [_btn204 setBackgroundColor:[UIColor lightGrayColor]];
    [_btn205 setTitle:@"否" forState:UIControlStateNormal];
    [_btn204 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btn205 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btn205 setBackgroundColor:[UIColor orangeColor]];
}

- (void)clear400Score
{
    UIImage *image = [UIImage imageNamed:@"1_4_2"];
    [self.btn401 setImage:image forState:UIControlStateNormal];
    [self.btn402 setImage:image forState:UIControlStateNormal];
    [self.btn403 setImage:image forState:UIControlStateNormal];
    [self.btn404 setImage:image forState:UIControlStateNormal];
    [self.btn405 setImage:image forState:UIControlStateNormal];
}

- (void)clear500Score
{
    UIImage *image = [UIImage imageNamed:@"1_4_2"];
    [self.btn501 setImage:image forState:UIControlStateNormal];
    [self.btn502 setImage:image forState:UIControlStateNormal];
    [self.btn503 setImage:image forState:UIControlStateNormal];
    [self.btn504 setImage:image forState:UIControlStateNormal];
    [self.btn505 setImage:image forState:UIControlStateNormal];
}

- (void)clear600Score
{
    UIImage *image = [UIImage imageNamed:@"1_4_2"];
    [self.btn601 setImage:image forState:UIControlStateNormal];
    [self.btn602 setImage:image forState:UIControlStateNormal];
    [self.btn603 setImage:image forState:UIControlStateNormal];
    [self.btn604 setImage:image forState:UIControlStateNormal];
    [self.btn605 setImage:image forState:UIControlStateNormal];
}

- (void)clear700Score
{
    UIImage *image = [UIImage imageNamed:@"1_4_2"];
    [self.btn701 setImage:image forState:UIControlStateNormal];
    [self.btn702 setImage:image forState:UIControlStateNormal];
    [self.btn703 setImage:image forState:UIControlStateNormal];
    [self.btn704 setImage:image forState:UIControlStateNormal];
    [self.btn705 setImage:image forState:UIControlStateNormal];
}

- (IBAction)btnAction401:(UIButton *)sender {
    
    if (sender) {
        self.score400 = 1;
        [self clear400Score];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn401 setImage:image forState:UIControlStateNormal];
    
}

- (IBAction)btnAction402:(UIButton *)sender {
    
    if (sender) {
        self.score400 = 2;
        [self clear400Score];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn402 setImage:image forState:UIControlStateNormal];
    [self btnAction401:nil];
    
}

- (IBAction)btnAction403:(UIButton *)sender {
    
    if (sender) {
        self.score400 = 3;
        [self clear400Score];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn403 setImage:image forState:UIControlStateNormal];
    [self btnAction402:nil];
    
}

- (IBAction)btnAction404:(UIButton *)sender {
    
    if (sender) {
        self.score400 = 4;
        [self clear400Score];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn404 setImage:image forState:UIControlStateNormal];
    [self btnAction403:nil];
    
}

- (IBAction)btnAction405:(UIButton *)sender {
    
    if (sender) {
        self.score400 = 5;
        [self clear400Score];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn405 setImage:image forState:UIControlStateNormal];
    [self btnAction404:nil];
    
}

- (IBAction)btnAction501:(UIButton *)sender {
    
    if (sender) {
        self.score500 = 1;
        [self clear500Score];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn501 setImage:image forState:UIControlStateNormal];
    
}

- (IBAction)btnAction502:(UIButton *)sender {
    
    if (sender) {
        self.score500 = 2;
        [self clear500Score];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn502 setImage:image forState:UIControlStateNormal];
    [self btnAction501:nil];
    
}

- (IBAction)btnAction503:(UIButton *)sender {
    
    if (sender) {
        self.score500 = 3;
        [self clear500Score];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn503 setImage:image forState:UIControlStateNormal];
    [self btnAction502:nil];
    
}

- (IBAction)btnAction504:(UIButton *)sender {
    
    if (sender) {
        self.score500 = 4;
        [self clear500Score];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn504 setImage:image forState:UIControlStateNormal];
    [self btnAction503:nil];
    
}

- (IBAction)btnAction505:(UIButton *)sender {
    
    if (sender) {
        self.score500 = 5;
        [self clear500Score];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn505 setImage:image forState:UIControlStateNormal];
    [self btnAction504:nil];
    
}

- (IBAction)btnAction601:(UIButton *)sender {
    
    if (sender) {
        self.score600 = 1;
        [self clear600Score];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn601 setImage:image forState:UIControlStateNormal];
    
}

- (IBAction)btnAction602:(UIButton *)sender {
    
    if (sender) {
        self.score600 = 2;
        [self clear600Score];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn602 setImage:image forState:UIControlStateNormal];
    [self btnAction601:nil];
    
}

- (IBAction)btnAction603:(UIButton *)sender {
    
    if (sender) {
        self.score600 = 3;
        [self clear600Score];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn603 setImage:image forState:UIControlStateNormal];
    [self btnAction602:nil];
    
}

- (IBAction)btnAction604:(UIButton *)sender {
    
    if (sender) {
        self.score600 = 4;
        [self clear600Score];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn604 setImage:image forState:UIControlStateNormal];
    [self btnAction603:nil];
    
}

- (IBAction)btnAction605:(UIButton *)sender {
    
    if (sender) {
        self.score600 = 5;
        [self clear600Score];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn605 setImage:image forState:UIControlStateNormal];
    [self btnAction604:nil];
    
}

- (IBAction)btnAction701:(UIButton *)sender {
    
    if (sender) {
        self.score700 = 1;
        [self clear700Score];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn701 setImage:image forState:UIControlStateNormal];
    
}

- (IBAction)btnAction702:(UIButton *)sender {
    
    if (sender) {
        self.score700 = 2;
        [self clear700Score];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn702 setImage:image forState:UIControlStateNormal];
    [self btnAction701:nil];
    
}

- (IBAction)btnAction703:(UIButton *)sender {
    
    if (sender) {
        self.score700 = 3;
        [self clear700Score];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn703 setImage:image forState:UIControlStateNormal];
    [self btnAction702:nil];
    
}

- (IBAction)btnAction704:(UIButton *)sender {
    
    if (sender) {
        self.score700 = 4;
        [self clear700Score];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn704 setImage:image forState:UIControlStateNormal];
    [self btnAction703:nil];
    
}

- (IBAction)btnAction705:(UIButton *)sender {
    
    if (sender) {
        self.score700 = 5;
        [self clear700Score];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn705 setImage:image forState:UIControlStateNormal];
    [self btnAction704:nil];
}

- (IBAction)btnAction202:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
