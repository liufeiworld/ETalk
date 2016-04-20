//
//  CalendarViewController.m
//  Calendar
//
//  Created by Neil on 14-8-21.
//  Copyright (c) 2014年 Neil. All rights reserved.
//



#import "CalendarViewController.h"
//UI
#import "CalendarMonthCollectionViewLayout.h"
#import "CalendarMonthHeaderView.h"
#import "CalendarDayCell.h"
//MODEL
#import "CalendarDayModel.h"


@interface CalendarViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate>
{

     NSTimer* timer;//定时器

}

@end

@implementation CalendarViewController

static NSString *MonthHeader = @"MonthHeaderView";

static NSString *DayCell = @"DayCell";


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)initView
{
    
    [self setTitle:@"预约课程"];
    
    CalendarMonthCollectionViewLayout *layout = [CalendarMonthCollectionViewLayout new];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout]; //初始化网格视图大小
    
    [self.collectionView registerClass:[CalendarDayCell class] forCellWithReuseIdentifier:DayCell];//cell重用设置ID
    
    [self.collectionView registerClass:[CalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader];
    
//    self.collectionView.bounces = NO;//将网格视图的下拉效果关闭
    
    self.collectionView.delegate = self;//实现网格视图的delegate
    
    self.collectionView.dataSource = self;//实现网格视图的dataSource
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    
}



-(void)initData{
    
    self.calendarMonth = [[NSMutableArray alloc] init];//每个月份的数组
}

- (void)nextMonth
{
    if (self.currentMonthIndex < ([self.calendarMonth count] - 1)) {
        self.currentMonthIndex++;
        
        [self.collectionView reloadData];
    }
}

- (void)previousMonth
{
    if (self.currentMonthIndex > 0) {
        self.currentMonthIndex--;
        
        [self.collectionView reloadData];
    }
}


#pragma mark - CollectionView代理方法

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:self.currentMonthIndex];
    
    return monthArray.count;
}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DayCell forIndexPath:indexPath];
    
    NSMutableArray *monthArray = [self.calendarMonth objectAtIndex:self.currentMonthIndex];
    
    CalendarDayModel *model = [monthArray objectAtIndex:indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;

    if (kind == UICollectionElementKindSectionHeader){
        
        NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:self.currentMonthIndex];
        CalendarDayModel *model = [month_Array objectAtIndex:15];

        CalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader forIndexPath:indexPath];
        monthHeader.masterLabel.text = [NSString stringWithFormat:@"%u年 %u月",(unsigned int)model.year,(unsigned int)model.month];//@"日期";
        reusableview = monthHeader;
        
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 15, 10, 17)];
        leftImageView.image = [UIImage imageNamed:@"left_"];
        [reusableview addSubview:leftImageView];
        
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 88, 48)];
        [leftButton addTarget:self action:@selector(previousMonth) forControlEvents:UIControlEventTouchUpInside];
        [reusableview addSubview:leftButton];
        
        UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_SHORT - 26, 15, 10, 17)];
        rightImageView.image = [UIImage imageNamed:@"right_"];
        [reusableview addSubview:rightImageView];
        
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_SHORT - 88, 0, 88, 48)];
        [rightButton addTarget:self action:@selector(nextMonth) forControlEvents:UIControlEventTouchUpInside];
        [reusableview addSubview:rightButton];
    }
    return reusableview;
    
}


//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:self.currentMonthIndex];
    CalendarDayModel *model = [month_Array objectAtIndex:indexPath.row];

    if (model.style == CellDayTypeFutur || model.style == CellDayTypeWeek ||model.style == CellDayTypeClick) {
       
        [self.Logic selectLogic:model];
        
        if (self.calendarblock) {
            
            self.calendarblock(model);//传递数组给上级
            
            timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        }
        [self.collectionView reloadData];
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}




//定时器方法
- (void)onTimer{
    
    [timer invalidate];//定时器无效
    
    timer = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
