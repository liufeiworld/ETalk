//
//  ProductDetailViewController.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/6/7.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondLevelModel.h"

@interface ProductDetailViewController : UITableViewController

@property (strong, nonatomic) NSString *productID;
@property (strong, nonatomic) NSString *productName;

@property (strong, nonatomic) NSArray *secondLevelModelArray;

@end
