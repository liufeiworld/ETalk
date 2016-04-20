//
//  DrawView.h
//  ETalk
//
//  Created by etalk365 on 16/1/4.
//  Copyright © 2016年 深圳市易课文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

//线条的颜色
@property(nonatomic,strong) UIColor * lineColor;
//线条的粗细
@property(nonatomic,strong) NSNumber * lineWidth;
//线条的颜色透明度(颜色深浅)
@property(nonatomic,assign) float lineArf;


//清除所有
-(void)cleanAll;
//上一步
-(void)backStep;
//下一步
-(void)nextStep;

@end
