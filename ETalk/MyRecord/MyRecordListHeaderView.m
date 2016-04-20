//
//  MyRecordListHeaderView.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/9.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "MyRecordListHeaderView.h"

@interface MyRecordListHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextMonthButton;
@property (weak, nonatomic) IBOutlet UIButton *previousMonthButton;

- (IBAction)nextMonth:(id)sender;
- (IBAction)previousMonth:(id)sender;


@end

@implementation MyRecordListHeaderView

- (void)setTitleLabelText:(NSString *)text
{
    self.titleLabel.text = text;
}

- (IBAction)nextMonth:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(nextMonth)]) {
        [_delegate nextMonth];
    }
}

- (IBAction)previousMonth:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(previousMonth)]) {
        [_delegate previousMonth];
    }
}

- (void)setNextMonthButtonEnable:(BOOL)enable
{
    self.nextMonthButton.enabled = enable;
}

- (void)setPreviousMonthButtonEnable:(BOOL)enable
{
    self.previousMonthButton.enabled = enable;
}

@end
