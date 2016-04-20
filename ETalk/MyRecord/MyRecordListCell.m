//
//  MyRecordListCell.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/23.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "MyRecordListCell.h"

@interface MyRecordListCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MyRecordListCell

- (void)setTitleLabelText:(NSString *)text
{
    self.titleLabel.text = text;
}

@end
