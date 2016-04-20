//
//  OrderCollectionHeaderView.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/9.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderCollectionHeaderViewDelegate <NSObject>

- (void)nextDay;
- (void)previousDay;
- (void)showCalendar;

@end

@interface OrderCollectionHeaderView : UICollectionReusableView

@property (weak, nonatomic) id delegate;
//预约时间
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)setTitleLabelText:(NSString *)text;
//后一天
- (IBAction)nextDay:(id)sender;
//前一天
- (IBAction)previousDay:(id)sender;
//显示日历
- (IBAction)showCalendar:(id)sender;

@end
