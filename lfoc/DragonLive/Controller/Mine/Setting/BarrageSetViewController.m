//
//  BarrageSetViewController.m
//  DragonLive
//
//  Created by 11号 on 2021/1/6.
//

#import "BarrageSetViewController.h"

@interface BarrageSetViewController ()

@property (nonatomic,weak) IBOutlet UISwitch *openSwitch;
@property (nonatomic,weak) IBOutlet UISlider *alphaSlider;
@property (nonatomic,weak) IBOutlet UILabel *alphaLab;
@property (nonatomic,weak) IBOutlet UIButton *largeFontBut;
@property (nonatomic,weak) IBOutlet UIButton *middleFontBut;
@property (nonatomic,weak) IBOutlet UIButton *smallFontBut;
@property (nonatomic,weak) IBOutlet UIButton *upPosiBut;
@property (nonatomic,weak) IBOutlet UIButton *fullPosiBut;
@property (nonatomic,weak) IBOutlet UIButton *downPosiBut;

@property (nonatomic,strong) UIButton *beforeFontBut;       //记录上一次点击的弹幕大小
@property (nonatomic,strong) UIButton *beforePosiBut;       //记录上一次点击的弹幕位置

@end

@implementation BarrageSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"弹幕设置";
    self.view.backgroundColor = The_MainColor;
    
    [self updateSetInfo];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//更新弹幕设置信息
- (void)updateSetInfo
{
    self.openSwitch.on = [UserInstance shareInstance].isSetBarrageOpen;
    self.alphaSlider.value = [UserInstance shareInstance].barrageFontAlpha;
    NSInteger alphaValue = [UserInstance shareInstance].barrageFontAlpha * 100;
    self.alphaLab.text = [NSString stringWithFormat:@"%ld%%",(long)alphaValue];
    
    if ([UserInstance shareInstance].barrageFontSize == 26) {
        self.largeFontBut.selected = YES;
        _beforeFontBut = self.largeFontBut;
    }else if ([UserInstance shareInstance].barrageFontSize == 16) {
        self.middleFontBut.selected = YES;
        _beforeFontBut = self.middleFontBut;
    }else if ([UserInstance shareInstance].barrageFontSize == 10) {
        self.smallFontBut.selected = YES;
        _beforeFontBut = self.smallFontBut;
    }
    
    if ([UserInstance shareInstance].barrageFontPosition == 0) {
        self.upPosiBut.selected = YES;
        _beforePosiBut = self.upPosiBut;
    }else if ([UserInstance shareInstance].barrageFontPosition == 1) {
        self.fullPosiBut.selected = YES;
        _beforePosiBut = self.fullPosiBut;
    }else if ([UserInstance shareInstance].barrageFontPosition == 2) {
        self.downPosiBut.selected = YES;
        _beforePosiBut = self.downPosiBut;
    }
}

// 弹幕字体大小
- (IBAction)barrageFontAction:(UIButton *)sender
{
    CGFloat fontSize = 26.0;
    if (sender.tag == 1) {
        fontSize = 16.0;
    }else if (sender.tag == 2) {
        fontSize = 10.0;
    }
    [UserInstance shareInstance].barrageFontSize = fontSize;
    [[NSUserDefaults standardUserDefaults] setFloat:fontSize forKey:kkBarrageFontSize];
    
    sender.selected = YES;
    if (_beforeFontBut) {
        _beforeFontBut.selected = NO;
    }
    _beforeFontBut = sender;
}

// 弹幕位置
- (IBAction)barragePositionAction:(UIButton *)sender
{
    [UserInstance shareInstance].barrageFontPosition = sender.tag;
    [[NSUserDefaults standardUserDefaults] setInteger:sender.tag forKey:kkBarrageFontPosition];
    
    sender.selected = YES;
    if (_beforePosiBut) {
        _beforePosiBut.selected = NO;
    }
    _beforePosiBut = sender;
}

// 拉动Slider划块触发
- (IBAction)onChangeAction:(UISlider *)sender
{
    NSInteger alphaValue = sender.value * 100;
    self.alphaLab.text = [NSString stringWithFormat:@"%ld%%",(long)alphaValue];
    [UserInstance shareInstance].barrageFontAlpha = sender.value;
    [[NSUserDefaults standardUserDefaults] setFloat:sender.value forKey:kkBarrageFontAlpha];
}

// 选择Switch触发
- (IBAction)onSwitchAction:(UISwitch *)sender
{
    [UserInstance shareInstance].isSetBarrageOpen = sender.isOn;
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:kkBarrageOpenManager];
}

@end
