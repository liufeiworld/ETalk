//
//  WCAlertview.m
//  ETalk
//
//  Created by etalk365 on 16/1/20.
//  Copyright © 2016年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "WCAlertview.h"

static const CGFloat alertviewWidth = 270.0;
static const CGFloat titleHeight = 50.0;
static const CGFloat imageviewHeight = 150;
static const CGFloat buttonHeight = 50;

@interface WCAlertview()

@property (strong,nonatomic)UIDynamicAnimator * animator;
@property (strong,nonatomic)UIView * alertview;
@property (strong,nonatomic)UIView * backgroundview;
@property (strong,nonatomic)NSString * title;
@property (strong,nonatomic)NSString * cancelButtonTitle;
@property (strong,nonatomic)NSString * okButtonTitle;
@property (strong,nonatomic)UIImage * image;
@property (strong,nonatomic)NSString *timeLabel;
@property (nonatomic,strong)NSString *leftTimeLabel;

@end

@implementation WCAlertview

#pragma mark - Gesture
//-(void)click:(UITapGestureRecognizer *)sender{
//    CGPoint tapLocation = [sender locationInView:self.backgroundview];
//    CGRect alertFrame = self.alertview.frame;
//    if (!CGRectContainsPoint(alertFrame, tapLocation)) {
//        [self dismiss];
//    }
//}

#pragma mark -  private function
-(UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title
{
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    button.titleLabel.textColor = [UIColor blueColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    return button;
}
-(void)clickButton:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(didClickButtonAtIndex:)]) {
        [self.delegate didClickButtonAtIndex:(button.tag -1)];
    }
    [self dismiss];
}
-(void)dismiss{
    [self.animator removeAllBehaviors];
    [UIView animateWithDuration:0.7 animations:^{
        self.alpha = 0.0;
        CGAffineTransform rotate = CGAffineTransformMakeRotation(0.9 * M_PI);
        CGAffineTransform scale = CGAffineTransformMakeScale(0.1, 0.1);
        self.alertview.transform = CGAffineTransformConcat(rotate, scale);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.alertview = nil;
    }];
    
}
-(void)setUp{
    self.backgroundview = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
//    self.backgroundview.backgroundColor = [UIColor blackColor];
//    self.backgroundview.alpha = 0.3;
    [self addSubview:self.backgroundview];
    
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
//    [self.backgroundview addGestureRecognizer:tap];
    
    
    self.alertview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertviewWidth, 250)];
    self.alertview.layer.cornerRadius = 17;
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    self.alertview.center = CGPointMake(CGRectGetMidX(keywindow.frame), -CGRectGetMidY(keywindow.frame));
    self.alertview.backgroundColor = [UIColor whiteColor];
    self.alertview.clipsToBounds = YES;
    
    [self addSubview:self.alertview];
    
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,alertviewWidth,titleHeight)];
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor redColor];
    [self.alertview addSubview:titleLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(alertviewWidth/2-30, titleHeight+50, alertviewWidth/2, 21)];
    timeLabel.text = self.timeLabel;
    timeLabel.font = [UIFont systemFontOfSize:15];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor grayColor];
    [self.alertview addSubview:timeLabel];
    
    UILabel *leftTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(alertviewWidth/2-30, titleHeight+81, alertviewWidth/2, 21)];
    leftTimeLabel.text = self.leftTimeLabel;
    leftTimeLabel.font = [UIFont systemFontOfSize:15];
    leftTimeLabel.textAlignment = NSTextAlignmentCenter;
    leftTimeLabel.textColor = [UIColor grayColor];
    [self.alertview addSubview:leftTimeLabel];
    
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10,titleHeight+40, alertviewWidth/2-50,imageviewHeight/2)];
    imageview.contentMode = UIViewContentModeScaleToFill;
    imageview.image = self.image;
    imageview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imageview.layer.borderWidth = 0.5;
    [self.alertview addSubview:imageview];
    
    CGRect cancelButtonFrame = CGRectMake(0, titleHeight + imageviewHeight,alertviewWidth,buttonHeight);
    if (self.okButtonTitle.length != 0 && self.okButtonTitle !=nil) {
        cancelButtonFrame = CGRectMake(alertviewWidth / 2 ,titleHeight + imageviewHeight, alertviewWidth/2,buttonHeight);
        CGRect okButtonFrame = CGRectMake(0,titleHeight + imageviewHeight, alertviewWidth/2,buttonHeight);
        UIButton * okButton = [self createButtonWithFrame:okButtonFrame Title:self.okButtonTitle];
        okButton.tag = 2;
        [self.alertview addSubview:okButton];
        
    }
    UIButton * cancelButton = [self createButtonWithFrame:cancelButtonFrame Title:self.cancelButtonTitle];
    cancelButton.tag = 1;
    [self.alertview addSubview:cancelButton];
}
#pragma mark -  API
- (void)show {
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    UISnapBehavior * sanp = [[UISnapBehavior alloc] initWithItem:self.alertview snapToPoint:self.center];
    sanp.damping = 0.7;
    [self.animator addBehavior:sanp];
}

-(instancetype)initWithTitle:(NSString *) title
                        time:(NSString *)time
                    leftTime:(NSString *)leftTime
                       Image:(UIImage *)image
                CancelButton:(NSString *)cancelButton
                    OkButton:(NSString *)okButton{
    
    if (self = [super initWithFrame:[[UIApplication sharedApplication]keyWindow].frame]) {
        
        self.title = title;
        self.image = image;
        self.cancelButtonTitle = cancelButton;
        self.okButtonTitle = okButton;
        self.timeLabel = time;
        self.leftTimeLabel = leftTime;
        
        [self setUp];
    }
    return self;
}

@end
