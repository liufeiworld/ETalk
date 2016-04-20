//
//  ClassInvitationViewController.h
//  ETalk
//
//  Created by etalk365 on 15/12/24.
//  Copyright © 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassInvitationViewController : UIViewController

//拒绝
- (IBAction)refuseActionrefuseAction:(UIButton *)sender;
//接听
- (IBAction)answerAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;
@property (weak, nonatomic) IBOutlet UIButton *answerBtn;
@property (nonatomic,strong) AVAudioPlayer *myPlayer;
@property (weak, nonatomic) IBOutlet UIImageView *answerImage;

@end
