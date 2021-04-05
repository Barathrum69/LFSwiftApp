//
//  DKSEmojiView.m
//  DKSChatKeyboard
//
//  Created by aDu on 2018/1/4.
//  Copyright © 2018年 DuKaiShun. All rights reserved.
//

#import "DKSEmojiView.h"
#import "UIView+FrameTool.h"

typedef enum : NSUInteger {
    DKDefaultEmojiType,                         //默认表情
    DKKuailongEmojiType,                        //快龙表情
} DKEmojiType;

@interface DKSEmojiView ()<UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isOrientationLandscape;          //是否横屏
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIScrollView *centerScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *defaultBut;                 //默认表情分类按钮
@property (nonatomic, strong) UIButton *klongBut;                   //快龙表情分类按钮
@property (nonatomic, assign) DKEmojiType emojiType;

@end

@implementation DKSEmojiView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
//        if (self.isOrientationLandscape) {
//            [self setupCenterViewLandscape];
//        }else {
//            [self setupCenterView];
//        }
        
        [self setupCenterView];
        [self setupDownView];
        [self setEmojiView];
    }
    return self;
}

//中间表情显示scrollView
- (void)setupCenterView
{
    UIScrollView *centerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height - 41)];
    centerScrollView.delegate = self;
    centerScrollView.backgroundColor = [UIColor colorWithHexString:@"#F5F7F6"];
    centerScrollView.scrollEnabled=YES;
    centerScrollView.pagingEnabled=YES;
    centerScrollView.showsHorizontalScrollIndicator=NO;//横向显示滚动条
    centerScrollView.showsVerticalScrollIndicator=NO;
    [self addSubview:centerScrollView];
    self.centerScrollView = centerScrollView;
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height - 41 - 20, self.width, 20)];
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#CCCCCC"];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#F67C37"];
    pageControl.hidesForSinglePage = NO;       //用于控制是否只有一个页面时隐藏页面控件(默认值为NO)
    [self addSubview:pageControl];
    self.pageControl = pageControl;
}

//中间表情view横屏模式
- (void)setupCenterViewLandscape
{
    NSArray *emojiNameArr = [NSArray arrayWithObjects:@"老实微笑",@"害羞",@"真香",@"脑壳痛",@"么么哒",@"哼哼",@"呵呵",@"喔耶",@"嘿嘿嘿",@"哭哭",@"心塞",@"好困",@"思考",@"我去",@"无语",@"开心",@"嘻嘻",@"得瑟",@"哈罗",@"生气",@"无聊",@"找事",@"惊呆了",@"暴怒",@"好冷",@"暴打", nil];
    self.dataArray = emojiNameArr;
    
    UIScrollView *centerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height - 41)];
    centerScrollView.delegate = self;
    centerScrollView.backgroundColor = [UIColor colorWithHexString:@"#F5F7F6"];
    centerScrollView.scrollEnabled=YES;
    centerScrollView.pagingEnabled=YES;
    centerScrollView.showsHorizontalScrollIndicator=NO;//横向显示滚动条
    centerScrollView.showsVerticalScrollIndicator=NO;
    [self addSubview:centerScrollView];
    
    CGFloat itemWidth = 42.0;           //item宽
    CGFloat itemHeight = 53.0;          //item高
    CGFloat leftMargin = 14.0;          //左右边距
    CGFloat topMargin = 10.0;           //上下边距
    CGFloat horSpace = 15.0;            //水平间距
    NSInteger pageNum = (self.width - 2 * leftMargin) / (itemWidth + horSpace);             //每页显示表情总个数
    CGFloat endWidth = self.width - 2 * leftMargin - pageNum * itemWidth - (pageNum - 1) *horSpace;      //显示完表情视图后的剩余视图宽度
    if (endWidth >= itemWidth) {    //如果剩余视图足够显示一个item则增加一个表情显示
        pageNum++;
    }else {     //如果不够一个表情显示则让水平间距变宽
        horSpace = horSpace + endWidth / (pageNum - 1);
    }
    NSInteger pageSum = emojiNameArr.count / pageNum;   //总页数
    if (emojiNameArr.count % pageNum) {
        pageSum++;
    }
        
    for (NSInteger i = 0; i < emojiNameArr.count; i++) {
        
        NSInteger pageIndex = i / pageNum;           //页码
        UIView *itemView = [self setupItemView:i emojiName:emojiNameArr[i]];
   
        itemView.x = leftMargin + pageIndex * self.width + i % pageNum * (itemWidth + horSpace);
        itemView.y = topMargin;
        itemView.width = itemWidth;
        itemView.height = itemHeight;
        
        [centerScrollView addSubview:itemView];
    }
    
    //设置页数
    [self setupPageControl:pageSum];
    [centerScrollView setContentSize:CGSizeMake(pageSum * self.size.width, centerScrollView.height)];
}

//默认表情显示
- (void)setEmojiView
{
    [self.centerScrollView removeAllSubviews];
    
    NSArray *emojiNameArr = [NSArray arrayWithObjects:@"老实微笑",@"害羞",@"真香",@"脑壳痛",@"么么哒",@"哼哼",@"呵呵",@"喔耶",@"嘿嘿嘿",@"哭哭",@"心塞",@"好困",@"思考",@"我去",@"无语",@"开心",@"嘻嘻",@"得瑟",@"哈罗",@"生气",@"无聊",@"找事",@"惊呆了",@"暴怒",@"好冷",@"暴打", nil];
    if (self.emojiType == DKKuailongEmojiType) {
        emojiNameArr = [NSArray arrayWithObjects:@"爱你唷",@"开心",@"666",@"宝宝",@"有点慌",@"难受",@"财迷",@"美女",@"吃瓜",@"打",@"真的吗",@"有毒",@"加油",@"鬼脸",@"发狂",@"吃惊",@"足球",@"篮球",@"大哭",@"走起",@"犯规",@"社会人",@"心碎",@"住嘴",@"真香",@"疑惑",@"害羞",@"skr",@"阵亡",@"欠揍",@"打扰了",@"潜水",@"垃圾球",@"上车",@"搬砖", nil];
    }
    self.dataArray = emojiNameArr;
    
    CGFloat itemWidth = 42.0;           //item宽
    CGFloat itemHeight = 53.0;          //item高
    CGFloat leftMargin = 14.0;          //左右边距
    CGFloat topMargin = 10.0;           //上下边距
    CGFloat verSpace = 7.0;             //item垂直间距
    NSInteger itemCount = 5;            //每行显示表情个数
    NSInteger pageNum = 15.0;           //每页显示表情总个数
    NSInteger pageSum = emojiNameArr.count / pageNum;   //总页数
    if (emojiNameArr.count % pageNum) {
        pageSum++;
    }
    
    CGFloat horSpace = (kkScreenWidth - 2 * leftMargin - itemCount * itemWidth) / 4.0;            //item水平间距
    
    for (NSInteger i = 0; i < emojiNameArr.count; i++) {
        
        NSInteger pageIndex = i / pageNum;           //页码
        
        UIView *itemView = [self setupItemView:i emojiName:emojiNameArr[i]];

        itemView.x = leftMargin + pageIndex * self.width + i % itemCount * (itemWidth + horSpace);
        itemView.y = topMargin + i % pageNum / itemCount * (itemHeight + verSpace);
        itemView.width = itemWidth;
        itemView.height = itemHeight;
        
        [self.centerScrollView addSubview:itemView];
    }
    
    [self setupPageControl:pageSum];
    [self.centerScrollView setContentSize:CGSizeMake(pageSum * self.size.width, self.centerScrollView.height)];
    [self.centerScrollView setContentOffset:CGPointMake(0, 0)];
}

//快龙表情显示
- (void)setKuailongEmoji
{
    NSArray *emojiNameArr = [NSArray arrayWithObjects:@"爱你唷",@"开心",@"666",@"宝宝",@"有点慌",@"难受",@"财迷",@"美女",@"吃瓜",@"打",@"真的吗",@"有毒",@"加油",@"鬼脸",@"发狂",@"吃惊",@"足球",@"篮球",@"大哭",@"走起",@"犯规",@"社会人",@"心碎",@"住嘴",@"真香",@"疑惑",@"害羞",@"skr",@"阵亡",@"欠揍",@"打扰了",@"潜水",@"垃圾球",@"上车",@"搬砖", nil];
    self.dataArray = emojiNameArr;
    
    CGFloat itemWidth = 42.0;           //item宽
    CGFloat itemHeight = 53.0;          //item高
    CGFloat leftMargin = 14.0;          //左右边距
    CGFloat topMargin = 10.0;           //上下边距
    CGFloat verSpace = 7.0;             //item垂直间距
    NSInteger itemCount = 5;            //每行显示表情个数
    NSInteger pageNum = 15.0;           //每页显示表情总个数
    NSInteger pageSum = emojiNameArr.count / pageNum;   //总页数
    if (emojiNameArr.count % pageNum) {
        pageSum++;
    }
    
    CGFloat horSpace = (kkScreenWidth - 2 * leftMargin - itemCount * itemWidth) / 4.0;            //item水平间距
    
    for (NSInteger i = 0; i < emojiNameArr.count; i++) {
        
        NSInteger pageIndex = i / pageNum;           //页码
        
        UIView *itemView = [self setupItemView:i emojiName:emojiNameArr[i]];
        
//        itemView.frame = CGRectMake(leftMargin + pageIndex * self.width + i % itemCount * (itemWidth + horSpace), topMargin + i / itemCount * (itemHeight + verSpace), itemWidth, itemHeight);
        
        itemView.x = leftMargin + pageIndex * self.width + i % itemCount * (itemWidth + horSpace);
        itemView.y = topMargin + i % pageNum / itemCount * (itemHeight + verSpace);
        itemView.width = itemWidth;
        itemView.height = itemHeight;
        
        [self.centerScrollView addSubview:itemView];
    }
    
    [self setupPageControl:pageSum];
    [self.centerScrollView setContentSize:CGSizeMake(pageSum * self.size.width, self.centerScrollView.height)];
    [self.centerScrollView setContentOffset:CGPointMake(0, 0)];
}

//表情item view
- (UIView *)setupItemView:(NSInteger)index emojiName:(NSString *)emojiName
{
    UIView *itemView = [UIView new];
    
    long emojiIndex = 0;
    if (self.emojiType == DKDefaultEmojiType) {
        emojiIndex = index + 1;
    }else if (self.emojiType == DKKuailongEmojiType) {
        emojiIndex = index + 101;
    }
    UIImageView *emojiImgView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 40.0, 40.0)];
    emojiImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"emoji_%ld",emojiIndex]];
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

//分页圆点
- (void)setupPageControl:(NSInteger)pageCount
{
    self.pageControl.numberOfPages = pageCount;
    self.pageControl.currentPage = 0;
}

//底部表情分类view
- (void)setupDownView
{
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, self.size.height - 41, self.size.width, 41)];
    downView.backgroundColor = [UIColor whiteColor];
    [self addSubview:downView];
    
    UIButton *defaultBut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 41, 41)];
    [defaultBut setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [defaultBut setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#F2F2F2"]] forState:UIControlStateSelected];
    [defaultBut setImage:[UIImage imageNamed:@"emoji_type"] forState:UIControlStateNormal];
    [defaultBut addTarget:self action:@selector(defaultButAction) forControlEvents:UIControlEventTouchUpInside];
    defaultBut.selected = YES;
    [downView addSubview:defaultBut];
    self.defaultBut = defaultBut;
    
    UIButton *klongBut = [[UIButton alloc] initWithFrame:CGRectMake(41, 0, 41, 41)];
    [klongBut setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [klongBut setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#F2F2F2"]] forState:UIControlStateSelected];
    [klongBut setImage:[UIImage imageNamed:@"emoji_kulong"] forState:UIControlStateNormal];
    [klongBut addTarget:self action:@selector(klongButAction) forControlEvents:UIControlEventTouchUpInside];
    klongBut.selected = NO;
    [downView addSubview:klongBut];
    self.klongBut = klongBut;
    
    UIButton *sendBut = [[UIButton alloc] initWithFrame:CGRectMake(self.size.width - 72, 0, 72, 41)];
    [sendBut setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#F67C37"]] forState:UIControlStateNormal];
    [sendBut setTitle:@"发送" forState:UIControlStateNormal];
    [sendBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBut.titleLabel.font = [UIFont systemFontOfSize:13];
    [sendBut addTarget:self action:@selector(emojiSendAction) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:sendBut];
}

//表情选择
- (void)emojiSelectAction:(UIButton *)but
{
    if (self.delegate) {
        [self.delegate selectEmoji:[NSString stringWithFormat:@"[%@]",self.dataArray[but.tag]]];
    }
}

//默认表情分类选择
- (void)defaultButAction
{
//    if (self.delegate) {
//        [self.delegate typeEmoji];
//    }
    if (self.defaultBut.selected) {
        return;
    }
    self.emojiType = DKDefaultEmojiType;
    self.defaultBut.selected = YES;
    self.klongBut.selected = NO;
    
    [self setEmojiView];
}

//快龙表情分类选择
- (void)klongButAction
{
    if (self.klongBut.selected) {
        return;
    }
    self.emojiType = DKKuailongEmojiType;
    self.klongBut.selected = YES;
    self.defaultBut.selected = NO;
    
    [self setEmojiView];
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

-(void)resetScrollview:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / self.width;
    self.pageControl.currentPage = page;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self resetScrollview:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self resetScrollview:scrollView];
}

@end
