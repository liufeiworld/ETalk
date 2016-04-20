//
//  OrderCollectionViewCell.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/4/8.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "OrderCollectionViewCell.h"

@implementation OrderCollectionViewCell

- (void)setTitleLabelText:(NSString *)text
{
    self.titleLabel.text = text;
}


- (void)setCellType:(OrderType)type
{
    switch (type) {
        case kOrderType_CanOrder:
        {
            self.titleLabel.textColor = UIColorFromRGB(0x378011);
            self.backgroundColor = UIColorFromRGB(0xCFEA91);
        }
            break;
            
        case kOrderType_CanNotOrder:
        {
            self.titleLabel.textColor = UIColorFromRGB(0x666666);
            self.backgroundColor = UIColorFromRGB(0xCCCCCC);
        }
            break;
            
        case kOrderType_Ordered:
        {
            self.titleLabel.textColor = UIColorFromRGB(0xDD0000);
            self.backgroundColor = UIColorFromRGB(0xF77D7D);
        }
            break;
            
        case kOrderType_OrderedAll:
        {
            self.titleLabel.textColor = UIColorFromRGB(0x378011);
            self.backgroundColor = UIColorFromRGB(0xCFEA91);
        }
            break;
            
        default:
            break;
    }
}

@end
