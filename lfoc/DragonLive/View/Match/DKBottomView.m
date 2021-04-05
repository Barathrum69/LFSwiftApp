//
//  DKBottomView.m
//  changchong2
//
//  Created by Jason Ma on 2019/4/23.
//  Copyright © 2019年 ios. All rights reserved.
//

#import "DKBottomView.h"
#import "HostTableView.h"

//CGFloat containerH = 340;
//CGFloat cornerRadius = 0;

@interface DKBottomView ()
//View
@property (nonatomic, strong) UIButton *bgBtn;//灰色底板

/// 容器,可自己添加需要的内容
@property (nonatomic, strong) UIView *container;

///默认添加的确认按钮
@property (nonatomic, strong) UIButton *confirmBtn;

/// 列表
@property (nonatomic, strong) HostTableView *hostTableView;

//Model//传入的数据
@property (nonatomic, strong) NSMutableArray *params;

///默认340
@property (nonatomic, assign) CGFloat containerH;

///默认0
@property (nonatomic, assign) CGFloat cornerRadius;

/// 请选择主播
@property (nonatomic, strong) UILabel *lab_title;

/// 那条线
@property (nonatomic, strong) UILabel *line_title;

@end

@implementation DKBottomView

#pragma mark - Public
+ (void)showWithParams:(NSMutableArray *)params delegate:(id <DKBottomViewDelegate>)delegate{
    
    [[self sharedView]showWithParams:params delegate:delegate containerH:kWidth(300-192)+kWidth(64*params.count) cornerRadius:10];
}

#pragma mark - Private
+ (DKBottomView*)sharedView {
    static dispatch_once_t once;
    
    static DKBottomView *sharedView;
    
    dispatch_once(&once, ^{ sharedView = [[self alloc] initWithFrame:[[[UIApplication sharedApplication] delegate] window].bounds]; });
    
    return sharedView;
}

-(void)showWithParams:(NSMutableArray *)params delegate:(id <DKBottomViewDelegate>)delegate containerH:(CGFloat)containerH cornerRadius:(CGFloat)cornerRadius{
    
    self.params = params;
    self.delegate = delegate;
    self.containerH = containerH;
    self.cornerRadius = cornerRadius;
    
    [self initSubViews];
    
    [[self frontWindow]addSubview:self];
    
    [self show];
}

//添加自定义view
- (void)initSubViews{
    
    self.bgBtn.frame = CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width), ([UIScreen mainScreen].bounds.size.height));
    [self addSubview:self.bgBtn];
    
    self.container.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height), ([UIScreen mainScreen].bounds.size.width), self.containerH);
    [self addSubview:self.container];
    
    if (!_lab_title) {
        _lab_title = [[UILabel alloc]initWithFrame:CGRectMake(0, kWidth(12), kScreenWidth, kWidth(13))];
        _lab_title.textColor = [UIColor colorFromHexString:@"999999"];
        _lab_title.textAlignment = NSTextAlignmentCenter;
        _lab_title.font = [UIFont systemFontOfSize:kWidth(12)];
        _lab_title.text = @"请选择主播";
        [self.container addSubview:_lab_title];
    }
   
    if (!_line_title) {
        _line_title = [[UILabel alloc]initWithFrame:CGRectMake(0, _lab_title.bottom+kWidth(11), kScreenWidth, 0.7)];
        _line_title.backgroundColor = [UIColor colorFromHexString:@"EDEDED"];
        [self.container addSubview:_line_title];
    }
    
    kWeakSelf(self);
    if (!_hostTableView) {
        _hostTableView = [[HostTableView alloc]initWithFrame:CGRectMake(0, _line_title.bottom, kScreenWidth, _containerH-_line_title.bottom-40-kBottomSafeHeight)style:UITableViewStylePlain];
//        _hostTableView.backgroundColor = [UIColor redColor];
        [self.container addSubview:_hostTableView];
        
        //点击代理传出去
        _hostTableView.tableViewDidSelected = ^(HostModel * _Nonnull model) {
            if ([weakself.delegate respondsToSelector:@selector(hostTableViewDidSelected:)]) {
                [weakself.delegate hostTableViewDidSelected:model];
            }
            [weakself remove];
        };
    }
    
    _hostTableView.dataArray = _params;
    [_hostTableView reloadData];
    
    
    self.confirmBtn.frame = CGRectMake(0, self.containerH - 40-kBottomSafeHeight, ([UIScreen mainScreen].bounds.size.width), 40);
    
    [self.container addSubview:self.confirmBtn];
    
    [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

//关闭按钮点击
- (void)closeClick{
    if ([self.delegate respondsToSelector:@selector(closeWithParams:)]) {
        [self.delegate closeWithParams:nil];

    }
    [self remove];
    
}

//确认按钮点击
- (void)confirmBtnClick
{
    
    if ([self.delegate respondsToSelector:@selector(confirmBtnClickWithParams:)]) {
        [self.delegate confirmBtnClickWithParams:nil];
//        __weak __typeof(self) weakSelf = self;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            [weakSelf.delegate confirmBtnClickWithParams:nil];
//        });
    }
    
    [self remove];
}

- (void)show{
    [UIView animateWithDuration:0.25 animations:^{
        self.bgBtn.alpha = 0.5;
        self.container.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height)-self.containerH, ([UIScreen mainScreen].bounds.size.width), self.containerH);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)remove{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.bgBtn.alpha = 0;
        self.container.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height), ([UIScreen mainScreen].bounds.size.width), self.containerH);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark - Lazy
- (UIWindow *)frontWindow {
    
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        BOOL windowKeyWindow = window.isKeyWindow;
        
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
            return window;
        }
    }
    return nil;
}

-(UIButton *)bgBtn{
    if (!_bgBtn) {
        _bgBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [_bgBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        
        _bgBtn.backgroundColor = [UIColor blackColor];
        _bgBtn.alpha = 0;
        _bgBtn.frame = CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width), ([UIScreen mainScreen].bounds.size.height));
    }
    return _bgBtn;
}

-(UIView *)container{
    if (!_container) {
        _container = [[UIView alloc]init];
        _container.layer.cornerRadius = self.cornerRadius;
        _container.layer.borderWidth = 0.5;
        _container.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _container.backgroundColor = [UIColor whiteColor];
    }
    return _container;
}

-(UIButton *)confirmBtn{
    if (!_confirmBtn) {
        
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                
        [_confirmBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor colorFromHexString:@"222222"] forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(13)];
        [_confirmBtn setBackgroundColor:[UIColor whiteColor]];
        
//        _confirmBtn.layer.cornerRadius = 20;
//        _confirmBtn.clipsToBounds = 1;
        
        
    }
    return _confirmBtn;
}
@end
