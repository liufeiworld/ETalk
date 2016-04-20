//
//  OrderedCourseTableViewCell.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/5/30.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "OrderedCourseTableViewCell.h"

@interface OrderedCourseTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDate;
@property (weak, nonatomic) IBOutlet UILabel *effectiveTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainedHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *packagePriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UIView *whiteBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end

@implementation OrderedCourseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCourseInfo:(MyOrderedCourse *)courseInfo
{
    //NSLog(@"%@", courseInfo);
    
//    self.orderNameLabel.text = [NSString stringWithFormat:@"套餐名称：%@", courseInfo.title];
//    self.orderDate.text = [NSString stringWithFormat:@"下单时间：%@", courseInfo.payTime];
//    self.effectiveTimeLabel.text = [NSString stringWithFormat:@"有效时间：%@", courseInfo.wTime];
//    self.totalHoursLabel.text = [NSString stringWithFormat:@"总共课时：%@", courseInfo.lessionNum];
//    self.remainedHoursLabel.text = [NSString stringWithFormat:@"剩余课时：%@", courseInfo.leaveNum];
//    self.packagePriceLabel.text = [NSString stringWithFormat:@"套餐价格：%@", courseInfo.totalMoney];
//    [self setPayButtonWithState:[courseInfo.orderState integerValue]];
    
    self.orderNameLabel.text = [NSString stringWithFormat:@"套餐名称: %@-%@-%@", courseInfo.name1, courseInfo.name2, courseInfo.name3];
    self.orderDate.text = [NSString stringWithFormat:@"下单时间: %@", [courseInfo.buyTime substringToIndex:10]];
    self.effectiveTimeLabel.text = [NSString stringWithFormat:@"有效时间: %@", courseInfo.valid];
    self.totalHoursLabel.text = [NSString stringWithFormat:@"总共课时: %@", courseInfo.lessonCount];
    self.remainedHoursLabel.text = [NSString stringWithFormat:@"剩余课时: %@", courseInfo.leavenum];
    self.packagePriceLabel.text = [NSString stringWithFormat:@"套餐价格: %@", courseInfo.price];
    [self setPayButtonWithState:courseInfo.state];
    
}


- (void)setPayButtonWithState:(NSInteger)orderState
{
    if (orderState == 1) {
        [self.payButton setTitleColor:UIColorFromRGB(0x118401) forState:UIControlStateNormal];
        [self.payButton setTitle:@"已付款" forState:UIControlStateNormal];
        
    }
    else if(orderState == 0){
        [self.payButton setTitleColor:UIColorFromRGB(0xFB0006) forState:UIControlStateNormal];
        [self.payButton setTitle:@"未付款" forState:UIControlStateNormal];
    }
    else{
        [self.payButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.payButton setTitle:@"已过期" forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if(self.top && self.down)
    {
        self.whiteBackgroundView.layer.cornerRadius = 8;
        self.whiteBackgroundView.layer.masksToBounds = YES;
    }
    else if (self.top)
    {
        CAShapeLayer *shape = [[CAShapeLayer alloc] init];
        shape.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.whiteBackgroundView.bounds.size.width, self.whiteBackgroundView.bounds.size.height)
                                           byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                 cornerRadii:CGSizeMake(8, 8)].CGPath;
        self.whiteBackgroundView.layer.mask = shape;
        self.whiteBackgroundView.layer.masksToBounds = YES;
    }
    else if (self.down)
    {
        CAShapeLayer *shape = [[CAShapeLayer alloc] init];
        shape.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.bounds.size.width - 16, self.whiteBackgroundView.bounds.size.height)
                                           byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                 cornerRadii:CGSizeMake(8, 8)].CGPath;
        self.whiteBackgroundView.layer.mask = shape;
        self.whiteBackgroundView.layer.masksToBounds = YES;
    }
    
    self.separatorView.hidden = self.down;
}

@end
