//
//  ByCourseHeaderTableViewCell.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/6/7.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "ByCourseHeaderTableViewCell.h"

@interface ByCourseHeaderTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ByCourseHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}


@end
