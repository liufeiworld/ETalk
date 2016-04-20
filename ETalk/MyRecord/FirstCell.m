//
//  FirstCell.m
//  ETalk
//
//  Created by etalk365 on 16/1/24.
//  Copyright © 2016年 深圳市易课科技文化有限公司. All rights reserved.
//

#import "FirstCell.h"

#define MaxLength 65

@interface FirstCell ()
/**听力理解星星宽度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starWidth1;
/**流利度星星宽度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starWidth2;
/**准确性星星宽度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starWidth3;
/**总体表现星星宽度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starWidth4;

/**发音星星宽度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starWidth5;
/**词汇星星宽度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starWidth6;
/**语法星星宽度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starWidth7;

/**发音*/
@property (weak, nonatomic) IBOutlet UILabel *pronuncRankLabel;
/**词汇*/
@property (weak, nonatomic) IBOutlet UILabel *vocabularyRankLabel;
/**语法*/
@property (weak, nonatomic) IBOutlet UILabel *grammarRankLabel;
/**教材信息*/
@property (weak, nonatomic) IBOutlet UILabel *materialsInfoLabel;
/**教师建议与评价*/
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UIView *firstView;

@end

@implementation FirstCell

- (void)refreshUI:(EvaluateOfTeacherModel *)model{
    
    self.pronuncRankLabel.text = model.pronuncRank;
    self.vocabularyRankLabel.text = model.vocabularyRank;
    self.grammarRankLabel.text = model.grammarRank;
    self.commentsLabel.text = model.comments;
    self.materialsInfoLabel.text = model.materialsInfo;
    
    self.starWidth1.constant = ([model.listenLevel floatValue]/5.0) * MaxLength;
    self.starWidth2.constant = ([model.fluencyLevel floatValue]/5.0) * MaxLength;
    self.starWidth3.constant = ([model.accuracyLevel floatValue]/5.0) * MaxLength;
    self.starWidth4.constant = ([model.performanceLevel floatValue]/5.0) * MaxLength;
    
    self.starWidth5.constant = ([model.pronunLevel floatValue]/5.0) * MaxLength;
    self.starWidth6.constant = ([model.vocabularyLevel floatValue]/5.0) * MaxLength;
    self.starWidth7.constant = ([model.grammarLevel floatValue]/5.0) * MaxLength;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
