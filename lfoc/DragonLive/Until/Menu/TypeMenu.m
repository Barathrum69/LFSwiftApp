//
//  TypeMenu.m
//  Alerts
//
//  Created by 王明 on 2019/10/29.
//  Copyright © 2019 王明. All rights reserved.
//

#import "TypeMenu.h"
#import "TypeMenuTabCell.h"

#define MenuViewBgColor [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.9]

@interface TypeMenu ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *menuTab;
@property (nonatomic,strong)UIView *menuTabBackView;
@property (nonatomic,strong)UIView *menuView;
@property (nonatomic,strong)UIView *menuBackView;

@end

@implementation TypeMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark --- 初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame] ) {
        self.backgroundColor =  [UIColor clearColor];
        self.alpha = 0;
    }
    return self;
}

+ (TypeMenu *)createMenuWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray{
    TypeMenu *typeMenu  = [[TypeMenu alloc]initWithFrame:frame];
#pragma mark--- 设置动画 锚点
    typeMenu.layer.anchorPoint = CGPointMake(0.1, 0);
    typeMenu.frame = frame;
    [typeMenu setUI];
    typeMenu.dataArray = dataArray;
    return typeMenu;
}

#pragma mark --- 数据源
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.menuTab reloadData];
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TypeMenuTabCell *cell = [TypeMenuTabCell msGetInstance];
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.label.text = dic[@"title"];
    cell.img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"img"]]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    if (self.selectRowBlcok) {
        self.selectRowBlcok(dic[@"title"],indexPath.row);
        [self hiddenMenu];
    }
}
#pragma mark --- 视图弹出
- (void)showMenu{
    self.hidden = NO;
    self.menuBackView.hidden = NO;
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    [window addSubview:self.menuBackView];
    [window addSubview:self];
    self.transform = CGAffineTransformMakeScale(1.0, 0.01);
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1.0;
        self.menuBackView.alpha = 1.0;
    }];
}
#pragma mark --- 视图隐藏
- (void)hiddenMenu{
    [UIView animateWithDuration:0.01 animations:^{
        self.hidden = YES;
        self.menuBackView.hidden = YES;
        self.alpha = 0;
        self.menuBackView.alpha = 0;
        self.transform = CGAffineTransformMakeScale(1.0, 0.01);
        [self removeFromSuperview];
        [self.menuBackView removeFromSuperview];
    }];
}
- (void)touchOutSide{
    [self hiddenMenu];
    
}
#pragma mark --- UI布局
- (void)setUI{
    [self addSubview:self.menuTabBackView];
    [self.menuTabBackView addSubview:self.menuTab];
}

- (UIView *)menuTabBackView{
    if (!_menuTabBackView) {
        _menuTabBackView = [[UIView alloc]init];
        _menuTabBackView.frame = CGRectMake(0, 10, self.frame.size.width, self.frame.size.height-10);
        _menuTabBackView.backgroundColor = MenuViewBgColor;
        _menuTabBackView.layer.cornerRadius = 5.0;
        _menuTabBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _menuTabBackView.layer.masksToBounds = YES;
    }
    return _menuTabBackView;
}

- (UIView *)menuBackView{
    if (!_menuBackView) {
        _menuBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _menuBackView.backgroundColor = [UIColor redColor];
        _menuBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.05];
        _menuBackView.alpha = 0.0;
        _menuBackView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(touchOutSide)];
        [_menuBackView addGestureRecognizer: tap];
    }
    return _menuBackView;
}

- (UITableView *)menuTab{
    if (!_menuTab) {
        _menuTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.menuTabBackView.frame.size.width, self.menuTabBackView.frame.size.height) style:UITableViewStylePlain];
        _menuTab.dataSource = self;
        _menuTab.delegate = self;
        _menuTab.bounces = NO;
        _menuTab.showsVerticalScrollIndicator = NO;
        _menuTab.backgroundColor = [UIColor clearColor];
//        _menuTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuTab.tableHeaderView = [[UIView alloc]initWithFrame:CGRectZero];
        _menuTab.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _menuTab;
}

#pragma mark --- 绘制三角符号
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, rect.size.width*0.5, 0);//设置起始位置
    CGContextAddLineToPoint(context,rect.size.width*0.5-10, 10);//从起始位置到这个点连线
    CGContextAddLineToPoint(context,rect.size.width*0.5+10, 10);
    CGContextClosePath(context);//结束画线..自动封闭  不写也可封闭
    [MenuViewBgColor setFill]; //设置填充色 不设置默认黑色
    [[UIColor clearColor] setStroke];//边框颜色，不设置默认黑色
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径
}


@end
