//
//  MyRecordListHeaderView.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/9.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyRecordListHeaderViewDelegate <NSObject>

- (void)nextMonth;
- (void)previousMonth;

@end

@interface MyRecordListHeaderView : UICollectionReusableView

@property (weak, nonatomic) id delegate;

- (void)setTitleLabelText:(NSString *)text;
- (void)setNextMonthButtonEnable:(BOOL)enable;
- (void)setPreviousMonthButtonEnable:(BOOL)enable;

@end
