//
//  ChooseDateViewController.m
//  ETalk
//
//  Created by Neil on 15/4/8.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "ChooseDateViewController.h"
#import "Color.h"
#import "UIViewController+BackButton.h"

@interface ChooseDateViewController ()
{
    int daynumber;//天数
    int optiondaynumber;//选择日期数量
    //    NSMutableArray *optiondayarray;//存放选择好的日期对象数组
    
}

@end

@implementation ChooseDateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    daynumber = 42;
    optiondaynumber = 1;//选择一个后返回数据对象
    NSString *dateString = nil;
    
    NSInteger currentMonth = [[NSDate date] YMDComponents].month;
    NSInteger selectedMonth = [self.selectedDate YMDComponents].month;

    
    if (self.selectedDate) {
        dateString = [self.selectedDate stringFromDate:self.selectedDate];
    }
    self.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:dateString];
    self.currentMonthIndex = (selectedMonth - currentMonth);
    
    __weak typeof(self) _weakSelf = self;
    self.calendarblock = ^(CalendarDayModel *model){
        
        NSLog(@"\n---------------------------");
        NSLog(@"1星期 %@",[model getWeek]);
        NSLog(@"2字符串 %@",[model toString]);
        NSLog(@"3节日  %@",model.holiday);
        
        NSDictionary *dictionary = @{kSelectedDate:[model toString]};
        [[NSNotificationCenter defaultCenter] postNotificationName:kChooseDateFinishedNofitication object:nil userInfo:dictionary];
        [_weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

- (void)dealloc
{
    DLog();
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];//刷新
    
    [self setupNavigaionBarBackButtonWithBackStylePop];
    [self setupNavigaionBarHomeButton];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 逻辑代码初始化

//获取时间段内的天数数组
- (NSMutableArray *)getMonthArrayOfDayNumber:(int)day ToDateforString:(NSString *)todate
{
    
    NSDate *date = [NSDate date];
    
    NSDate *selectdate  = [NSDate date];
    
    if (todate) {
        
        selectdate = [selectdate dateFromString:todate];
        
    }
    
    self.Logic = [[CalendarLogic alloc]init];
    
    return [self.Logic reloadCalendarView:date selectDate:selectdate  needDays:day];
}



#pragma mark - 设置标题

- (void)setCalendartitle:(NSString *)calendartitle
{
    
    [self.navigationItem setTitle:calendartitle];
    
}


@end
