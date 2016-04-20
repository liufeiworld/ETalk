//
//  MyOrderHeaderReusableView.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/23.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "MyOrderHeaderReusableView.h"

@interface MyOrderHeaderReusableView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MyOrderHeaderReusableView

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

@end
