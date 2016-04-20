//
//  ProductDetailTableViewCell.m
//  ETalk
//
//  Created by Neil's Mac Mini on 15/6/16.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "ProductDetailTableViewCell.h"
#import "ProductDetailInfo.h"

@interface ProductDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;

@end

@implementation ProductDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProductDetailInfo:(ProductDetailInfo *)detailInfo
{
    NSArray *array = [detailInfo.title componentsSeparatedByString:@"："];
    if (array && array.count > 0) {
        _titleLabel.text = array[0];
    }
    
    if (array && array.count > 1) {
        //_detailTextView.text = array[1];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.firstLineHeadIndent = 0;
        paragraphStyle.maximumLineHeight = 18.0;
        paragraphStyle.minimumLineHeight = 18.f;
        paragraphStyle.alignment = NSTextAlignmentJustified;
        
        NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor colorWithWhite:0.5 alpha:1.0]
                                      };
        self.detailTextView.attributedText = [[NSAttributedString alloc]initWithString:array[1] attributes:attributes];
    }
}

- (void)setSecondLevelDataWithModel:(SecondLevelModel *)secondLevelModel
{
    self.titleLabel.text = secondLevelModel.secondName;
    
    if (secondLevelModel.secondIntroduce.length > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.firstLineHeadIndent = 0;
        paragraphStyle.maximumLineHeight = 18.0;
        paragraphStyle.minimumLineHeight = 18.f;
        paragraphStyle.alignment = NSTextAlignmentJustified;
        
        NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor colorWithWhite:0.5 alpha:1.0]
                                      };
        self.detailTextView.attributedText = [[NSAttributedString alloc]initWithString:secondLevelModel.secondIntroduce attributes:attributes];
    }
}


@end
