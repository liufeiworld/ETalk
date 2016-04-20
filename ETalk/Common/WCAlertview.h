//
//  WCAlertview.h
//  ETalk
//
//  Created by etalk365 on 16/1/20.
//  Copyright © 2016年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCALertviewDelegate<NSObject>
@optional
-(void)didClickButtonAtIndex:(NSUInteger)index;

@end

@interface WCAlertview : UIView

@property (weak,nonatomic) id<WCALertviewDelegate> delegate;
-(instancetype)initWithTitle:(NSString *) title time:(NSString *)time leftTime:(NSString *)leftTime Image:(UIImage *)image CancelButton:(NSString *)cancelButton OkButton:(NSString *)okButton;
- (void)show;

@end
