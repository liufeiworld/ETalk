//
//  ByCourseTableViewCell.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/5/30.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

#import "FirstLevelModel.h"

@interface ByCourseTableViewCell : UITableViewCell

@property(nonatomic,assign) BOOL top,down;

- (void)setProduct:(Product *)product;

- (void)setCellProduceData:(FirstLevelModel *)firstLevelModel;

@end
