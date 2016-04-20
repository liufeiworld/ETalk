//
//  ByCourseTableViewCell.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/5/30.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "ByCourseTableViewCell.h"

@interface ByCourseTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *packageTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *whiteBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@end

@implementation ByCourseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProduct:(Product *)product
{
    self.packageTitleLabel.text = product.title;
    NSString *detailInfo = [product.introduce stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.firstLineHeadIndent = 0;
    paragraphStyle.maximumLineHeight = 18.0;
    paragraphStyle.minimumLineHeight = 18.f;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor colorWithWhite:0.5 alpha:1.0]
                                  };
    self.textView.attributedText = [[NSAttributedString alloc]initWithString:detailInfo attributes:attributes];
}

- (void)setCellProduceData:(FirstLevelModel *)firstLevelModel
{
    self.packageTitleLabel.text = firstLevelModel.firstName;
    NSString *introduce = firstLevelModel.firstIntroduce;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = 0;
    paragraphStyle.maximumLineHeight = 18.0;
    paragraphStyle.minimumLineHeight = 18.f;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14] , NSParagraphStyleAttributeName : paragraphStyle , NSForegroundColorAttributeName : [UIColor colorWithWhite:0.5 alpha:1.0]};
    
    self.textView.attributedText = [[NSAttributedString alloc] initWithString:introduce attributes:attributes];
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
