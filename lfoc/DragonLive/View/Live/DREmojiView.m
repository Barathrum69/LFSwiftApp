;//
//  DREmojiView.m
//  DragonLive
//
//  Created by 11号 on 2021/1/22.
//

#import "DREmojiView.h"

@interface DREmojiView ()

@property (nonatomic, assign) BOOL isOrientationLandscape;          //是否横屏

@end

@implementation DREmojiView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

//中间表情view
- (void)setupCenterView
{
    NSArray *emojiNameArr = [NSArray arrayWithObjects:@"老实微笑",@"害羞",@"真香",@"脑壳痛",@"么么哒",@"哼哼",@"呵呵",@"喔耶",@"嘿嘿嘿",@"哭哭",@"心塞",@"好困",@"思考",@"我去",@"无语",@"开心",@"嘻嘻",@"得瑟",@"哈罗",@"生气",@"无聊",@"找事",@"惊呆了",@"暴怒",@"好冷",@"暴打", nil];
    
    UIScrollView *centerScrollView = [UIScrollView new];
    centerScrollView.backgroundColor = [UIColor colorWithHexString:@"#F5F7F6"];
    centerScrollView.scrollEnabled=YES;
    centerScrollView.pagingEnabled=YES;
    centerScrollView.showsHorizontalScrollIndicator=NO;//横向显示滚动条
    centerScrollView.showsVerticalScrollIndicator=NO;
    [self addSubview:centerScrollView];
    
    NSInteger itemCount = 5;            //每行显示表情个数
    CGFloat itemWidth = 42.0;           //item宽
    CGFloat itemHeight = 53.0;          //item高
    CGFloat leftMargin = 14.0;          //左右边距
    CGFloat topMargin = 10.0;           //上下边距
    CGFloat verSpace = 7.0;             //item垂直间距
    CGFloat horSpace = (kkScreenWidth - 2 * leftMargin - itemCount * itemWidth) / 4.0;            //item水平间距
    
    for (NSInteger i = 0; i < emojiNameArr.count; i++) {
        
        UIView *itemView = [self setupItemView:i emojiName:emojiNameArr[i]];
        
        itemView.frame = CGRectMake(leftMargin + i % itemCount * (itemWidth + horSpace), topMargin + i / itemCount * (itemHeight + verSpace), itemWidth, itemHeight);
        [centerScrollView addSubview:itemView];
    }
    
}

//表情item view
- (UIView *)setupItemView:(NSInteger)index emojiName:(NSString *)emojiName
{
    UIView *itemView = [UIView new];
    
    UIImageView *emojiImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 42.0, 42.0)];
    emojiImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"emoji_%ld",(long)(index+1)]];
    [itemView addSubview:emojiImgView];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, 42.0, 9)];
    nameLab.textColor = [UIColor colorWithHexString:@"#999999"];
    nameLab.text = emojiName;
    nameLab.font = [UIFont systemFontOfSize:8];
    nameLab.textAlignment = NSTextAlignmentCenter;
    [itemView addSubview:nameLab];
    
    UIButton *selectBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 53)];
    selectBut.tag = index;
    [selectBut addTarget:self action:@selector(emojiSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:selectBut];
    
    return itemView;
}

//底部表情分类view
- (void)setupDownView
{
    UIView *downView = [UIView new];
    downView.backgroundColor = [UIColor whiteColor];
    [self addSubview:downView];
    
    UIButton *typeBut = [UIButton new];
    [typeBut setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [typeBut setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#F2F2F2"]] forState:UIControlStateSelected];
    [typeBut setImage:[UIImage imageNamed:@"emoji_type"] forState:UIControlStateNormal];
    typeBut.selected = YES;
    [typeBut addTarget:self action:@selector(typeButAction) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:typeBut];
    
    UIButton *sendBut = [UIButton new];
    [sendBut setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#F67C37"]] forState:UIControlStateNormal];
    [sendBut setTitle:@"发送" forState:UIControlStateNormal];
    [sendBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBut.titleLabel.font = [UIFont systemFontOfSize:13];
    [sendBut addTarget:self action:@selector(emojiSendAction) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:sendBut];
    
    //布局
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(41);
    }];
    
    [typeBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(41);
        make.height.mas_equalTo(41);
    }];
    
    [sendBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(41);
    }];
}

//表情选择
- (void)emojiSelectAction:(UIButton *)but
{
    if (self.delegate) {
        [self.delegate selectEmoji:[NSString stringWithFormat:@"[%ld]",(long)but.tag]];
    }
}

//表情分类选择
- (void)typeButAction
{
    if (self.delegate) {
        [self.delegate typeEmoji];
    }
}

//发送
- (void)emojiSendAction
{
    if (self.delegate) {
        [self.delegate sendEmoji];
    }
}

- (BOOL)isOrientationLandscape
{
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return YES;
    }
    return NO;
}

@end
