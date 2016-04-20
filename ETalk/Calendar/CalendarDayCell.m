//
//  CalendarDayCell.m
//  tttttt
//
//  Created by Neil on 14-8-20.
//  Copyright (c) 2014年 Neil. All rights reserved.
//



#import "CalendarDayCell.h"

@implementation CalendarDayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    
    //选中时显示的图片
    CGRect imageViewFrame = IS_SMALL_SCREEN_IPHONE ? CGRectMake(10, 15, self.bounds.size.width-20, self.bounds.size.width-20) : CGRectMake(10, 20, self.bounds.size.width-20, self.bounds.size.width-20);
    imgview = [[UIImageView alloc]initWithFrame:imageViewFrame];
    imgview.image = [UIImage imageNamed:@"rili"];
    [self addSubview:imgview];
    
    //日期
    CGRect dayLabelFrame = IS_SMALL_SCREEN_IPHONE ? CGRectMake(0, 5, self.bounds.size.width, self.bounds.size.width) : CGRectMake(0, 15, self.bounds.size.width, self.bounds.size.width-10);
    day_lab = [[UILabel alloc]initWithFrame:dayLabelFrame];
    day_lab.textAlignment = NSTextAlignmentCenter;
    day_lab.font = [UIFont systemFontOfSize:14];
    [self addSubview:day_lab];

    
    //农历
    day_title = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-15, self.bounds.size.width, 13)];
    //  CGRectMake(0, self.bounds.size.height-15, self.bounds.size.width, 13)
    day_title.textColor = [UIColor lightGrayColor];
    day_title.font = [UIFont boldSystemFontOfSize:10];
    day_title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:day_title];
}


- (void)setModel:(CalendarDayModel *)model
{


    switch (model.style) {
        case CellDayTypeEmpty://不显示
            [self hidden_YES];
            break;
            
        case CellDayTypePast://过去的日期
            [self hidden_NO];
            
            if (model.holiday) {
                day_lab.text = model.holiday;
            }else{
                day_lab.text = [NSString stringWithFormat:@"%d",(int)model.day];
            }
            
            day_lab.textColor = [UIColor lightGrayColor];
            day_title.text = model.Chinese_calendar;
            imgview.hidden = YES;
            break;
            
        case CellDayTypeFutur://将来的日期
            [self hidden_NO];
            
            if (model.holiday) {
                day_lab.text = model.holiday;
                day_lab.textColor = [UIColor orangeColor];
            }else{
                day_lab.text = [NSString stringWithFormat:@"%d",(int)model.day];
                day_lab.textColor = COLOR_THEME;
            }
            
            day_title.text = model.Chinese_calendar;
            imgview.hidden = YES;
            break;
            
        case CellDayTypeWeek://周末
            [self hidden_NO];
            
            if (model.holiday) {
                day_lab.text = model.holiday;
                day_lab.textColor = [UIColor orangeColor];
            }else{
                day_lab.text = [NSString stringWithFormat:@"%d",(int)model.day];
                day_lab.textColor = COLOR_THEME1;
            }
            
            day_title.text = model.Chinese_calendar;
            imgview.hidden = YES;
            break;
            
        case CellDayTypeClick://被点击的日期
            [self hidden_NO];
            day_lab.text = [NSString stringWithFormat:@"%d",(int)model.day];
            day_lab.textColor = [UIColor whiteColor];
            day_title.text = model.Chinese_calendar;
            imgview.hidden = NO;
            
            break;
            
        default:
            
            break;
    }
}



- (void)hidden_YES{
    
    day_lab.hidden = YES;
    day_title.hidden = YES;
    imgview.hidden = YES;
    
}


- (void)hidden_NO{
    
    day_lab.hidden = NO;
    day_title.hidden = NO;
    
}


@end