//
//  UserHeaderCell.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/5/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Userinfo.h"

@interface UserHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *integrationLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;

- (void)setUserInfo:(Userinfo *)userInfo;

@end
