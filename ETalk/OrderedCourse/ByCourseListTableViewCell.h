//
//  ByCourseListTableViewCell.h
//  ETalk
//
//  Created by Neil's Mac Mini on 15/6/3.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThirdLevelModel.h"

@class BuyCourseInfo;

@interface ByCourseListTableViewCell : UITableViewCell

- (void)setBuyCourseInfo:(BuyCourseInfo *)buyCourseInfo;

- (void)setThirdLevelDataWithModel:(ThirdLevelModel *)thirdLevelModel;

@end
