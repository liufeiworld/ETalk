//
//  MainViewController.h
//  ETalk
//
//  Created by Neil on 15/3/23.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *userHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *integrationLabel;

@property (weak, nonatomic) IBOutlet UIView *customerHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *etalkImageView;
@property (weak, nonatomic) IBOutlet UILabel *etalkTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *etalkPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *etalkNameLabel;
@property (weak, nonatomic) IBOutlet UIView *userFooterView;
@property (weak, nonatomic) IBOutlet UIView *customerFooterView;
@property (weak, nonatomic) IBOutlet UIImageView *loginTagImageView;
@property (strong, nonatomic) IBOutlet UIView *myView;

- (IBAction)orderCourse:(id)sender;
- (IBAction)myOrderList:(id)sender;
- (IBAction)evaluate:(id)sender;
- (IBAction)myCoursePlan:(id)sender;
- (IBAction)myList:(id)sender;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
- (IBAction)signBtnAction:(UIButton *)sender;


@end
