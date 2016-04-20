//
//  OrderCollectionViewCell.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/8.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, OrderType)
{
    kOrderType_CanNotOrder = 0,
    kOrderType_CanOrder = 1,
    kOrderType_Ordered = 2,
    kOrderType_OrderedAll =3
};

@interface OrderCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)setTitleLabelText:(NSString *)text;
- (void)setCellType:(OrderType)type;

@end
