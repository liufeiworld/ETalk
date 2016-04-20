//
//  UserHeaderCell.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/5/12.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "UserHeaderCell.h"

@implementation UserHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserInfo:(Userinfo *)userInfo
{
    self.nickNameLabel.text = userInfo.cnName;
    self.studentIDLabel.text = [NSString stringWithFormat:@"用户名: %@",userInfo.username];
    //self.integrationLabel.text = [NSString stringWithFormat:@"推荐码: %@",userInfo.qrcode];
    self.gradeLabel.text = @"";
}

@end
