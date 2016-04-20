//
//  EvaluateView.m
//  ETalk
//
//  Created by etalk365 on 16/1/27.
//  Copyright © 2016年 深圳市易课科技文化有限公司. All rights reserved.
//

#import "EvaluateView.h"
#import "ProposalView.h"

@interface EvaluateView ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *subCommitBtn;
- (IBAction)subCommitAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn101;
- (IBAction)btnAction101:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn102;
- (IBAction)btnAction102:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn103;
- (IBAction)btnAction103:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn104;
- (IBAction)btnAction104:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn105;
- (IBAction)btnAction105:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (nonatomic,assign)NSInteger score;
@property (nonatomic,strong)UILabel *uilabel;
@property (nonatomic,strong)UITextView *textView;

@end

@implementation EvaluateView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //首先定义UITextView
    _textView = [[UITextView alloc] init];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.frame =CGRectMake(0, 150, self.view.bounds.size.width, self.view.bounds.size.height/2);
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _textView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_textView];
    _textView.hidden = NO;
    _textView.delegate = self;
    //其次在UITextView上面覆盖个UILable,UILable设置为全局变量。
    _uilabel = [[UILabel alloc] init];
    _uilabel.frame =CGRectMake(0, 5, _textView.bounds.size.width, 25);
    _uilabel.font = [UIFont systemFontOfSize:15];
    _uilabel.text = @"请输入评价内容!";
    _uilabel.enabled = NO;//lable必须设置为不可用
    _uilabel.backgroundColor = [UIColor lightGrayColor];
    [_textView addSubview:_uilabel];
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(check) object:nil];
    [thread start];
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    _textView.text =  textView.text;
    if (textView.text.length == 0) {
        _uilabel.text = @"请输入评价内容!";
    }else{
        _uilabel.text = @"";
        _uilabel.frame = CGRectMake(0, 0, 0, 0);
    }
}

- (void)check{

    while (1) {
        
        NSString *textView = self.textView.text;
        NSString *score = [NSString stringWithFormat:@"%ld",(long)self.score];
        
        if ([textView isEqualToString:@""] && [score isEqualToString:@"0"]) {
            
            _subCommitBtn.enabled = NO;
            _subCommitBtn.backgroundColor = [UIColor lightGrayColor];
        }else if(![textView isEqualToString:@""] && ![score isEqualToString:@"0"]){
        
            _subCommitBtn.enabled = YES;
            _subCommitBtn.backgroundColor = [UIColor greenColor];
            break;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}

- (IBAction)subCommitAction:(UIButton *)sender {
    
    NSString *textView = self.textView.text;
    NSString *score = [NSString stringWithFormat:@"%ld",(long)self.score];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *courseId = [user objectForKey:kRespondKeyCourseId];
    
    NSLog(@"textView = %@",textView);
    NSLog(@"score = %@",score);
    NSLog(@"courseId = %@",courseId);
    
    NSString *tokenString = [[UserSingleton sharedInstance] tokenString];
    NSDictionary *parameters = @{@"tokenString" : tokenString, @"courseId" : courseId, @"comment" : textView, @"score" : score};
    NSString *URLString = [NSString stringWithFormat:@"%@%@", kHTTPRequestURL, kRequestKeySubmitReview];
    
    [[AFHTTPRequestOperationManager manager] POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"1802:本节课已投诉");
        NSLog(@"responseObject = %@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"1801:提交投诉失败");
    }];
    
    // 获取故事板
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // 获取故事板中某个View
    UIViewController *next = [board instantiateViewControllerWithIdentifier:@"ProposalView"];
    // 跳转
    [self.navigationController pushViewController:next animated:YES];
    
}

- (void)clearScore
{
    UIImage *image = [UIImage imageNamed:@"1_4_2"];
    [self.btn101 setImage:image forState:UIControlStateNormal];
    [self.btn102 setImage:image forState:UIControlStateNormal];
    [self.btn103 setImage:image forState:UIControlStateNormal];
    [self.btn104 setImage:image forState:UIControlStateNormal];
    [self.btn105 setImage:image forState:UIControlStateNormal];
}

- (IBAction)btnAction101:(UIButton *)sender {
    
    if (sender) {
        self.score = 1;
        [self clearScore];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn101 setImage:image forState:UIControlStateNormal];
    
}

- (IBAction)btnAction102:(UIButton *)sender {
    
    if (sender) {
        self.score = 2;
        [self clearScore];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn102 setImage:image forState:UIControlStateNormal];
    [self btnAction101:nil];
    
}

- (IBAction)btnAction103:(UIButton *)sender {
    
    if (sender) {
        self.score = 3;
        [self clearScore];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn103 setImage:image forState:UIControlStateNormal];
    [self btnAction102:nil];
    
}

- (IBAction)btnAction104:(UIButton *)sender {
    
    if (sender) {
        self.score = 4;
        [self clearScore];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn104 setImage:image forState:UIControlStateNormal];
    [self btnAction103:nil];
    
}

- (IBAction)btnAction105:(UIButton *)sender {
    
    if (sender) {
        self.score = 5;
        [self clearScore];
    }
    
    UIImage *image = [UIImage imageNamed:@"1_4_1"];
    [self.btn105 setImage:image forState:UIControlStateNormal];
    [self btnAction104:nil];
}


@end
