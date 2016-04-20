//
//  TeacherEvaluateViewController.m
//  ;
//
//  Created by Neil's Mac Mini on 15/5/10.
//  Copyright (c) 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "TeacherEvaluateViewController.h"
#import "UIViewController+BackButton.h"
#import "FirstCell.h"
#import "EvaluateOfTeacherModel.h"

@interface TeacherEvaluateViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation TeacherEvaluateViewController

- (NSMutableArray *)dataArr{

    if (!_dataArr) {
        
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNavigaionBarBackButtonWithBackStylePop];
    [self setupNavigaionBarHomeButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FirstCell" bundle:nil] forCellReuseIdentifier:@"FirstCell"];
    
    [self requestData];
}

- (void)requestData{
    
    NSDictionary *dict = [[UserSingle sharedInstance] dict];
    EvaluateOfTeacherModel *model = [[EvaluateOfTeacherModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    [self.dataArr addObject:model];
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
        FirstCell *firstCell = [tableView dequeueReusableCellWithIdentifier:@"FirstCell" forIndexPath:indexPath];
        firstCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [firstCell refreshUI:self.dataArr[indexPath.row]];
        
        return firstCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    FirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirstCell" forIndexPath:indexPath];
//    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
    
    return 1200;
}

@end
