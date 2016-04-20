//
//  MyEvaluateViewController.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/5/10.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "MyEvaluateViewController.h"
#import "UIViewController+BackButton.h"

@interface MyEvaluateViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *score1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *score2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *score3ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *score4ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *score5ImageView;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation MyEvaluateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        DLog(@"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        statusBarView.backgroundColor  =  UIColorFromRGB(0x9BCB2D);
        [self.view addSubview:statusBarView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //self.textView.text = self.courseInfo.stuCommentText;
    self.textView.text = self.stuRecordMothInfo.courseStuComment;
    
    [self setupNavigaionBarBackButtonWithBackStylePop];
    [self setupNavigaionBarHomeButton];
    
    //int rank = [self.courseInfo.stuCommentRank intValue];
    int rank = self.stuRecordMothInfo.courseStuScore;
    if ((rank > 0) && (rank < 6)) {
        UIImage *image = [UIImage imageNamed:@"1_3_1"];
        switch (rank) {
            case 5:
                self.score5ImageView.image = image;
            case 4:
                self.score4ImageView.image = image;
            case 3:
                self.score3ImageView.image = image;
            case 2:
                self.score2ImageView.image = image;
            case 1:
                self.score1ImageView.image = image;
                
            default:
                break;
        }
    }
    else {
//        NSLog(@"stuCommentRank:%@", self.courseInfo.stuCommentRank);
    }
}

@end
