//
//  ByCourseListTableViewCell.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/6/3.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "ByCourseListTableViewCell.h"
#import "ProductDetailInfo.h"

@interface ByCourseListTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *timesLabel;
@property (weak, nonatomic) IBOutlet UILabel *validDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricePerCourseLable;
@property (weak, nonatomic) IBOutlet UILabel *giftLable;

@end

@implementation ByCourseListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*
 @property (strong, nonatomic) NSString *indentifier;
 @property (strong, nonatomic) NSString *buyCoursesNumber;
 @property (strong, nonatomic) NSString *validDate;
 @property (strong, nonatomic) NSString *price;
 @property (strong, nonatomic) NSString *pricePerMonth;
 @property (strong, nonatomic) NSString *gift;
 */
- (void)setBuyCourseInfo:(BuyCourseInfo *)buyCourseInfo
{
    _timesLabel.text = buyCourseInfo.buyCoursesNumber;
    _validDateLabel.text = buyCourseInfo.validDate;
    _priceLabel.text = buyCourseInfo.price;
    _pricePerCourseLable.text = buyCourseInfo.pricePerMonth;
    _giftLable.text = buyCourseInfo.gift;
}

- (void)setThirdLevelDataWithModel:(ThirdLevelModel *)thirdLevelModel
{
    _timesLabel.text = thirdLevelModel.packageName;
    if (thirdLevelModel.packageValid == 0) {
        _validDateLabel.text = @"无限期";
    }
    else{
        _validDateLabel.text = [NSString stringWithFormat:@"%d天", thirdLevelModel.packageValid];
    }
    _priceLabel.text = [NSString stringWithFormat:@"¥%d", thirdLevelModel.packagePrice];
    
    if (thirdLevelModel.packagePrice != 0 && thirdLevelModel.packageLessonCount != 0) {
        _pricePerCourseLable.text = [NSString stringWithFormat:@"¥%d", thirdLevelModel.packagePrice / thirdLevelModel.packageLessonCount];
    }
    _giftLable.text = nil;
}


























@end
