//
//  ProductDetailTableViewCell.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/6/16.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondLevelModel.h"

@class ProductDetailInfo;

@interface ProductDetailTableViewCell : UITableViewCell

- (void)setProductDetailInfo:(ProductDetailInfo *)detailInfo;

- (void)setSecondLevelDataWithModel:(SecondLevelModel *)secondLevelModel;

@end
