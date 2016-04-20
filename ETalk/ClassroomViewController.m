//
//  ClassroomViewController.m
//  ETalk
//
//  Created by etalk365 on 15/12/25.
//  Copyright © 2015年 深圳市易课文化科技有限公司. All rights reserved.
//

#import "ClassroomViewController.h"
#include "DrawView.h"

typedef NS_ENUM(NSInteger, Attribute)
{
    NULLL,
    color,
    width,
    alpha,
};

@interface ClassroomViewController ()<UIScrollViewDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIImage * image;
    Attribute    attribute;
    UIImageView *_imageView;
}
@property(nonatomic,strong)  DrawView * drawV;
@property(nonatomic,strong)  UIButton * colorBtn;
@property(nonatomic,strong)  UIButton * widthBtn;
@property(nonatomic,strong)  UIButton * arfBtn;
@property(nonatomic,strong)  UIButton * cleanBtn;
//橡皮擦
@property(nonatomic,strong)  UIButton * rubberBtn;
@property(nonatomic,strong)  UIButton * nextBtn;
@property(nonatomic,strong)  UIButton * back1Btn;
@property(nonatomic,strong)  UIButton * saveBtn;
@property(nonatomic,strong)  UIButton * setBtn;

@property(nonatomic,strong)  UIView * setBtnView;
@property(nonatomic,strong)  UITableView * attributeTableView;
@property(nonatomic,strong)  NSMutableArray * colorsArray;
@property(nonatomic,strong)  NSMutableArray  * widthsArray;
@property(nonatomic,strong)  NSMutableArray  * alphasArray;
@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//返回事件
- (IBAction)BackAction:(UIButton *)sender;
//信息处理事件
- (IBAction)InforAction:(UIButton *)sender;
//页码
@property (weak, nonatomic) IBOutlet UILabel *PageNumberLabel;
//ClassID
@property (weak, nonatomic) IBOutlet UILabel *ClassIDLabel;
//版本号
@property (weak, nonatomic) IBOutlet UILabel *VersionNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *BackBtn;
@property (weak, nonatomic) IBOutlet UIButton *InfoBtn;
- (IBAction)DrawImage:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *DrawImageView;
@property (nonatomic,strong) UIView *mySuperView;
//聊天消息记录
@property (weak, nonatomic) IBOutlet UILabel *messageRecordLabel;

@end

@implementation ClassroomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
    _mySuperView = [self.view viewWithTag:555];
    
    _scrollView.delegate = self;
    _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width - 70, self.view.frame.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    //不让反弹
    _scrollView.bounces = NO;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 5;
    _scrollView.userInteractionEnabled = YES;
    _imageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
//    _imageView.image = [UIImage imageNamed:@"Lesson 1"];
    NSString *str3 = [[NSUserDefaults standardUserDefaults]objectForKey:@"xiazaidejiaocai"];
    if (str3 != 0) {
        _imageView.image = [UIImage imageWithContentsOfFile:str3];
    }else{
        _imageView.image = [UIImage imageNamed:@"Lesson 1"];
    }
    [_scrollView addSubview:_imageView];
    
    [self RoundButtonAction];
    [self setupUI];
    [self printMessageCount];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zhaoPian:) name:@"xianShiTuPian" object:nil];
}

-(void)zhaoPian:(NSNotification *)center{
    
    NSLog(@"消息  cr ");
    if (center.object != nil) {
        [UIView animateWithDuration:0.5 animations:^{
            _imageView.alpha = 0;
            [_imageView removeFromSuperview];
        } completion:^(BOOL finished) {
            _imageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
            _imageView.alpha = 1;
            _imageView.image = center.object;
            [_scrollView addSubview:_imageView];
            [_scrollView reloadInputViews];
        }];
    }
    
}

//返回
- (IBAction)BackAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//信息处理
- (IBAction)InforAction:(UIButton *)sender {
    UserSingleton *singleton = [UserSingleton sharedInstance];
    singleton.messageCount = @"";
    _msgCount = singleton.messageCount;
    self.messageRecordLabel.text = _msgCount;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)printMessageCount{
    
    UserSingleton *singleton = [UserSingleton sharedInstance];
    _msgCount = singleton.messageCount;
    NSLog(@"msgCount = %@",_msgCount);
    self.messageRecordLabel.text = _msgCount;
}

#pragma mark ---setupUI
-(void)setupUI
{
    [_scrollView addSubview:self.drawV];
    [_mySuperView addSubview:self.setBtnView];
    [_mySuperView addSubview:self.saveBtn];
    [_mySuperView addSubview:self.setBtn];
    [_mySuperView addSubview:self.attributeTableView];
}
#pragma mark ---Help  Methods

#pragma mark ----- Events Handle
-(void)colorBtnClick
{
    static int isBtnHidden = 1;
    self.attributeTableView.scrollsToTop = YES;
    attribute = color;
    [self.attributeTableView  reloadData];
    if (isBtnHidden == 1) {
        self.attributeTableView.hidden = NO;
        isBtnHidden = 0;
    }
    else
    {
        self.attributeTableView.hidden = YES;
        isBtnHidden = 1;
    }
}
-(void)widthChangeBtnClick
{    attribute = width;
    self.attributeTableView.scrollsToTop = YES;
    [self.attributeTableView reloadData];
    static int  isWidthHiddening  = 1;
    if (isWidthHiddening == 1) {
        self.attributeTableView.hidden = NO;
        isWidthHiddening = 0;
    }else
    {
        self.attributeTableView.hidden = YES;
        isWidthHiddening = 1;
    }
}
-(void)alphaChangeClick
{    attribute = alpha;
    self.attributeTableView.scrollsToTop = YES;
    [self.attributeTableView reloadData];
    static int  isAlphaHiddening  = 1;
    if (isAlphaHiddening == 1) {
        self.attributeTableView.hidden = NO;
        isAlphaHiddening = 0;
    }else
    {
        self.attributeTableView.hidden = YES;
        isAlphaHiddening = 1;
    }
}
-(void)cleanBtnClick:(UIButton *)btn
{
    [self.drawV cleanAll];
}
-(void)rubberBtnClick
{
    static UIColor * lineColor ;
    static  NSNumber  *  lineWidth ;
    static  float lineArf ;
    static int isRubber = 0;
    if (isRubber == 0) {
        lineColor=  self.drawV.lineColor ;
        lineWidth =  self.drawV.lineWidth;
        lineArf =  self.drawV.lineArf;
        self.drawV.lineColor = [UIColor whiteColor];
        self.drawV.lineWidth = [NSNumber numberWithFloat:10.0f];
        self.drawV.lineArf = 1.0f;
        isRubber = 1;
    }else
    {
        self.drawV.lineColor = lineColor;
        self.drawV.lineWidth = lineWidth;
        self.drawV.lineArf = lineArf;
        isRubber = 0;
    }
}
-(void)backBtnClick
{
    [self.drawV  backStep];
}
-(void)nextBtnClick
{
    [self.drawV nextStep];
}
-(void)saveBtnClick
{
    //创建一个基于位图的上下文（context）,并将其设置为当前上下文(context)
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message: @"确定要保存至手机相册吗?"delegate:nil cancelButtonTitle:@"取消"otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    [alertView show];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error) {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"保存至相册失败" message:   [NSString  stringWithFormat:@"error是%@",error.localizedDescription]delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }else{
    }
}
#pragma mark UIAlertViewDelegate
//点击按钮触发
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        UIImageWriteToSavedPhotosAlbum(image, self, @selector (image:didFinishSavingWithError:contextInfo:), nil);}
}
-(void)setBtnClick
{
    static int setBtnIsHidden = 1;
    if (setBtnIsHidden == 1) {
        self.setBtnView.hidden = NO;
        setBtnIsHidden = 0;
    }else
    {
        self.setBtnView.hidden = YES;
        self.attributeTableView.hidden = YES;
        setBtnIsHidden = 1;
    }
    
    
}
#pragma mark ---- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (attribute) {
        case color:
            return self.colorsArray.count;
            break;
        case width:
            return self.widthsArray.count;
            break;
        case alpha:
            return self.alphasArray.count;
            break;
        default:
            return 0;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIde = @"cellIde";
    UITableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:cellIde];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIde];
    }
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    switch (attribute) {
        case color:
            cell.backgroundColor = self.colorsArray[indexPath.row];
            cell.textLabel.text = @"";
            break;
        case width:
            cell.textLabel.text = self.widthsArray[indexPath.row];
            cell.backgroundColor = [UIColor clearColor];
            break;
        case alpha:
            cell.textLabel.text = self.alphasArray[indexPath.row];
            cell.backgroundColor = [UIColor clearColor];
            break;
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView   deselectRowAtIndexPath:indexPath animated:YES];
    switch (attribute) {
        case color:
            self.drawV.lineColor = self.colorsArray[indexPath.row];
            break;
        case width:
            self.drawV.lineWidth = [NSNumber  numberWithInt:[self.widthsArray[indexPath.row] intValue]];
            break;
        case alpha:
            self.drawV.lineArf = [self.alphasArray[indexPath.row] floatValue];
            break;
        default:
            break;
    }
}
#pragma mark ----Getter
// 画布
-(DrawView *)drawV
{
    if (_drawV == nil) {
        _drawV = [[DrawView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 70, self.view.frame.size.height)];
        _drawV.backgroundColor = [UIColor clearColor];
        
        
    }return _drawV;
    
}
-(UIButton *)colorBtn
{
    if (_colorBtn == nil) {
        _colorBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        [_colorBtn setTitle:@"颜色" forState:UIControlStateNormal];
        [_colorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _colorBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _colorBtn.backgroundColor = [UIColor yellowColor];
        [_colorBtn addTarget:self action:@selector(colorBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _colorBtn;
}
-(UIButton *)widthBtn
{
    if (_widthBtn == nil){
        _widthBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 40, 30)];
        [_widthBtn setTitle:@"粗细" forState:UIControlStateNormal];
        [_widthBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _widthBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_widthBtn addTarget:self action:@selector(widthChangeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _widthBtn.backgroundColor = [UIColor grayColor];
    }return _widthBtn;
}
-(UIButton *)arfBtn
{    if(_arfBtn == nil){
    _arfBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, 40, 30)];
    _arfBtn.backgroundColor = [UIColor yellowColor];
    [_arfBtn setTitle:@"透明" forState:UIControlStateNormal];
    [_arfBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _arfBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [_arfBtn addTarget:self action:@selector(alphaChangeClick) forControlEvents:UIControlEventTouchUpInside];
}
    return _arfBtn;
}
-(UIButton *)cleanBtn
{
    if (_cleanBtn == nil) {
        _cleanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 90, 40, 30)];
        _cleanBtn.backgroundColor = [UIColor  grayColor];
        [_cleanBtn setTitle:@"清除" forState:UIControlStateNormal];
        [_cleanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cleanBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_cleanBtn addTarget:self action:@selector(cleanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cleanBtn;
}
-(UIButton *)rubberBtn
{
    
    if (_rubberBtn == nil) {
        _rubberBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 120, 40, 30)];
        _rubberBtn.backgroundColor = [UIColor yellowColor];
        [_rubberBtn setTitle:@"橡皮" forState:UIControlStateNormal];
        [_rubberBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rubberBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_rubberBtn  addTarget:self action:@selector(rubberBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }return _rubberBtn;
}
-(UIButton *)back1Btn
{
    if (_back1Btn == nil) {
        _back1Btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, 40, 30)];
        _back1Btn.backgroundColor = [UIColor grayColor];
        [_back1Btn setTitle:@"上一步" forState:UIControlStateNormal];
        [_back1Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _back1Btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_back1Btn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _back1Btn;
}
-(UIButton *)nextBtn
{
    if (_nextBtn == nil) {
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 180, 40, 30)];
        _nextBtn.backgroundColor = [UIColor yellowColor];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_nextBtn  addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}
-(UIButton *)saveBtn
{
    if (_saveBtn == nil) {
        _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.mySuperView.frame.size.height - 40, 30, 20)];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _saveBtn.backgroundColor = [UIColor blueColor];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn  addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

- (IBAction)DrawImage:(UIButton *)sender {
    
    [self.DrawImageView addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(UIView *)setBtnView
{
    if (_setBtnView == nil) {
        _setBtnView = [[UIView alloc] initWithFrame:CGRectMake(50, 60, 40, 210)];
        _setBtnView.backgroundColor = [UIColor  cyanColor];
        [_setBtnView  addSubview:self.colorBtn];
        [_setBtnView  addSubview:self.widthBtn];
        [_setBtnView  addSubview:self.arfBtn];
        [_setBtnView  addSubview:self.cleanBtn];
        [_setBtnView  addSubview:self.rubberBtn];
        [_setBtnView  addSubview:self.back1Btn];
        [_setBtnView  addSubview:self.nextBtn];
        _setBtnView.hidden = YES;
    }return _setBtnView;
}
-(UITableView *)attributeTableView
{
    if (_attributeTableView == nil){
        _attributeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, 50, 210) style:UITableViewStylePlain];
        _attributeTableView.delegate = self;
        _attributeTableView.dataSource = self;
        _attributeTableView.showsVerticalScrollIndicator = NO;
        _attributeTableView.hidden = YES;
    }
    return _attributeTableView;
}
-(NSMutableArray *)colorsArray
{
    if (_colorsArray == nil) {
        NSArray * colorArray = @[[UIColor greenColor],[UIColor blueColor],[UIColor blackColor],[UIColor redColor],[UIColor yellowColor],[UIColor orangeColor],[UIColor cyanColor],[UIColor purpleColor],[UIColor brownColor],[UIColor magentaColor],[UIColor grayColor],[UIColor darkGrayColor]];
        _colorsArray = [[NSMutableArray alloc] initWithArray:colorArray];
        for (int i = 0; i < 70 ; i++) {
            UIColor * color = [UIColor  colorWithRed:arc4random()%256/256.0f green:arc4random()%256/256.0f blue:arc4random()%256/256.0f alpha:1.0];
            [_colorsArray  addObject:color];
        }
    }return _colorsArray;
}
-(NSMutableArray *)widthsArray
{
    if (_widthsArray == nil) {
        _widthsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 100; i++) {
            NSString * widthStr = [NSString stringWithFormat:@"%d",i];
            [_widthsArray  addObject:widthStr];
        }
    }return _widthsArray;
}
-(NSMutableArray *)alphasArray
{
    if (_alphasArray == nil) {
        _alphasArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 11; i++) {
            NSString * alphaStr = [NSString stringWithFormat:@"%.1f",i/10.0f];
            [_alphasArray  addObject:alphaStr];
        }
    }return _alphasArray;
}

#pragma mark - 设置按钮为圆角
- (void)RoundButtonAction{

    [_BackBtn.layer setMasksToBounds:YES];
    [_BackBtn.layer setCornerRadius:23.0];
    
    [_InfoBtn.layer setMasksToBounds:YES];
    [_InfoBtn.layer setCornerRadius:15.0];
    
    [_messageRecordLabel.layer setMasksToBounds:YES];
    [_messageRecordLabel.layer setCornerRadius:10];
}

#pragma mark- UIScrollViewDelegate
//返回需要放大的视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return _imageView;
}

//放大缩小完成之后的回调方法
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
    if (scale < 1.0) {
        //缩小
        view.center = CGPointMake(scrollView.frame.size.width/2.0, scrollView.frame.size.height/2.0);
    }else{
        
        //放大
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    }
}

#pragma mark - 横屏的相关实现方法
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}


@end
