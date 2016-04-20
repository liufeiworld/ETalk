//
//  OrderCollectionHeaderView.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/9.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "OrderCollectionHeaderView.h"

@implementation OrderCollectionHeaderView

- (void)setTitleLabelText:(NSString *)text
{
    self.titleLabel.text = text;
}
- (IBAction)nextDay:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(nextDay)]) {
        [_delegate nextDay];
    }
}

- (IBAction)previousDay:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(previousDay)]) {
        [_delegate previousDay];
    }
}

- (IBAction)showCalendar:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(showCalendar)]) {
        [_delegate showCalendar];
    }
}

@end
