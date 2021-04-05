//
//  DRSearchHistoryView.m
//  DragonLive
//
//  Created by 11号 on 2020/12/15.
//

#import "DRSearchHistoryView.h"

@interface DRSearchHistoryView ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) UIView *searchHistoryView;
@property (nonatomic, strong) UIView *hotSearchView;

@end
@implementation DRSearchHistoryView

- (instancetype)initWithFrame:(CGRect)frame hotArray:(NSMutableArray *)hotArr historyArray:(NSMutableArray *)historyArr
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.historyArray = historyArr;
        self.hotArray = hotArr;
        
        if (_historyArray.count > 0) {
            [self addSubview:self.searchHistoryView];
        }
        
        [self addSubview:self.hotSearchView];
    
    }
    return self;
}

- (UIView *)searchHistoryView
{
    if (!_searchHistoryView) {
        if (_historyArray.count > 0) {
            self.searchHistoryView = [self setViewWithOriginY:0 textArr:self.historyArray];
        }
    }
    return _searchHistoryView;
}

- (UIView *)hotSearchView
{
    if (!_hotSearchView) {
        CGRect rect = CGRectMake(0, CGRectGetMaxY(_searchHistoryView.frame), kDRScreenWidth, 200);
        self.hotSearchView = [self setHotView:rect textArr:self.hotArray];
    }
    return _hotSearchView;
}

//刷新搜索历史
- (void)reloadHistoryView
{
    if (self.searchHistoryView) {
        [self.searchHistoryView removeFromSuperview];
        self.searchHistoryView = nil;
    }
    
    [self addSubview:self.searchHistoryView];
    
    CGRect frame = _hotSearchView.frame;
    frame.origin.y = CGRectGetMaxY(_searchHistoryView.frame);
    _hotSearchView.frame = frame;
}

//搜索历史view
- (UIView *)setViewWithOriginY:(CGFloat)riginY textArr:(NSMutableArray *)textArr
{
    UIView *contentView = [[UIView alloc] init];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(19, 10, 100, 38)];
    titleL.text = @"搜索历史";
    titleL.font = [UIFont boldSystemFontOfSize:12];
    titleL.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    titleL.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:titleL];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kDRScreenWidth - 62, 15, 30, 30);
    [btn setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clearnSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    
    UILabel *deleteLab = [[UILabel alloc] initWithFrame:CGRectMake(kDRScreenWidth - 38, 24, 24, 12)];
    deleteLab.text = @"清空";
    deleteLab.font = [UIFont systemFontOfSize:10];
    deleteLab.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    deleteLab.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:deleteLab];
    
    CGFloat const horizonMargin = 19.0;     //contentView内的水平边距
    CGFloat const horizonPadding = 12.0;    //contentView内label水平方向间距
    CGFloat const verticalPadding = 14.0;   //contentView内label垂直方向间距
    CGFloat const labHeight = 20.0;         //label 高度
    NSInteger maxCount = 10;                //历史记录最大条数
    
    CGFloat labOriginX = 19;
    CGFloat labOriginY = CGRectGetMaxY(titleL.frame) + 10;
    
    for (int i = 0; i < textArr.count; i++) {
        NSString *text = textArr[i];
        CGFloat width = [self getWidthWithStr:text] + 16;
        
        if (i >= maxCount) {
            [self removeTestDataWithTextArr:textArr index:i];
            break;
        }
        
        //换行
        if (labOriginX + width + horizonMargin > kDRScreenWidth) {
            labOriginY += labHeight + verticalPadding;
            labOriginX = horizonMargin;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labOriginX, labOriginY, width, labHeight)];
        label.userInteractionEnabled = YES;
        label.font = [UIFont systemFontOfSize:12];
        label.text = text;
        label.layer.cornerRadius = 10.0;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1.0];
        label.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:247/255.0 alpha:1.0];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        [contentView addSubview:label];
        labOriginX += width + horizonPadding;
    }
    contentView.frame = CGRectMake(0, riginY, kDRScreenWidth, labOriginY + 30);
    
    return contentView;
}

//热搜榜view
- (UIView *)setHotView:(CGRect)rect textArr:(NSMutableArray *)textArr
{
    UIView *contentView = [[UIView alloc] initWithFrame:rect];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(19, 10, kDRScreenWidth - 30 - 45, 38)];
    titleL.text = @"热搜榜";
    titleL.font = [UIFont boldSystemFontOfSize:12];
    titleL.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    titleL.textAlignment = NSTextAlignmentLeft;
    [contentView addSubview:titleL];
    
    NSInteger const rowCount = 2;           //每行显示的个数
    CGFloat const horizonMargin = 23.0;     //contentView内的左右边距
    CGFloat const verticaMargin = 10.0;     //contentView内的上下边距
    CGFloat const horizonPadding = 12.0;    //contentView内item水平方向间距
    CGFloat const verticalPadding = 20.0;   //contentView内item垂直方向间距
    CGFloat const itembWidth = (kDRScreenWidth - 2*horizonMargin - horizonPadding) / rowCount;         //item 高度
    CGFloat const itemHeight = 15.0;         //item高度
    
    for (NSInteger i=0; i<textArr.count; i++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.frame = CGRectMake(horizonMargin + (itembWidth + horizonPadding) * (i % rowCount), CGRectGetMaxY(titleL.frame) + verticaMargin + (itemHeight + verticalPadding) * (i / rowCount), itembWidth, itemHeight);
        [contentView addSubview:itemView];
        
        UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 14, 14)];
        numLab.font = [UIFont boldSystemFontOfSize:10.0];
        numLab.textAlignment = NSTextAlignmentCenter;
        numLab.text = [NSString stringWithFormat:@"%ld",i+1];
        numLab.layer.cornerRadius = 7.0;
        numLab.layer.masksToBounds = YES;
        [itemView addSubview:numLab];
        
        //热搜前三标记橙色
        if (i < 3) {
            numLab.textColor = [UIColor whiteColor];
            numLab.backgroundColor = [UIColor colorWithRed:246/255.0 green:124/255.0 blue:55/255.0 alpha:1.0];
        }else {
            numLab.textColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1.0];
            numLab.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
        }
        
        UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, itembWidth - 18, 15)];
        textLab.userInteractionEnabled = YES;
        textLab.font = [UIFont systemFontOfSize:12];
        textLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        textLab.text = textArr[i];
        [textLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        [itemView addSubview:textLab];
    }
    
    return contentView;
}

- (UIView *)setNoHistoryView
{
    UIView *historyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDRScreenWidth, 80)];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(19, 10, kDRScreenWidth - 30, 30)];
    titleL.text = @"搜索历史";
    titleL.font = [UIFont systemFontOfSize:13];
    titleL.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    titleL.textAlignment = NSTextAlignmentLeft;
    
    UILabel *notextL = [[UILabel alloc] initWithFrame:CGRectMake(19, CGRectGetMaxY(titleL.frame) + 10, 100, 20)];
    notextL.text = @"无搜索历史";
    notextL.font = [UIFont systemFontOfSize:12];
    notextL.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    notextL.textAlignment = NSTextAlignmentLeft;
    [historyView addSubview:titleL];
    [historyView addSubview:notextL];
    return historyView;
}

- (void)tagDidCLick:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)tap.view;
    if (self.tapAction) {
        self.tapAction(label.text);
    }
}

- (CGFloat)getWidthWithStr:(NSString *)text
{
    CGFloat width = [text boundingRectWithSize:CGSizeMake(kDRScreenWidth, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size.width;
    return width;
}

- (void)clearnSearchHistory:(UIButton *)sender
{
    [self.searchHistoryView removeFromSuperview];
//    self.searchHistoryView = [self setNoHistoryView];
    [_historyArray removeAllObjects];
    [NSKeyedArchiver archiveRootObject:_historyArray toFile:KHistorySearchPath];
    
//    [self addSubview:self.searchHistoryView];
    CGRect frame = _hotSearchView.frame;
    frame.origin.y = 10;
    _hotSearchView.frame = frame;
}

- (void)removeTestDataWithTextArr:(NSMutableArray *)testArr index:(int)index
{
    NSRange range = {index, testArr.count - index - 1};
    [testArr removeObjectsInRange:range];
    [NSKeyedArchiver archiveRootObject:testArr toFile:KHistorySearchPath];
}

@end
