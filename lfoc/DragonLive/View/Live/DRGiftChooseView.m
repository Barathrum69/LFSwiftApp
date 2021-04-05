//
//  DRGiftChooseView.m
//  DragonLive
//
//  Created by 11号 on 2020/12/25.
//

#import "DRGiftChooseView.h"
#import "HLHorizontalPageLayout.h"

#define NORMAL_FONT [UIFont systemFontOfSize:11]
#define NORMAL_COLOR [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]
#define SELECTED_COLOR [UIColor colorWithRed:246/255.0 green:124/255.0 blue:55/255.0 alpha:1.0]

@interface GiftCollectionViewCell ()

@property (nonatomic, strong) UIImageView *giftImgView;             //礼物图片
@property (nonatomic, strong) UILabel *titleLabel;                  //礼物标题
@property (nonatomic, strong) UILabel *priceLabel;                  //龙币
@property (nonatomic, assign) BOOL isOrientationLandscape;          //是否横屏

@end;

@implementation GiftCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.giftImgView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.priceLabel];
        
        [self.giftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(0);
            make.left.equalTo(self.contentView).with.offset(0);
            make.right.equalTo(self.contentView).with.offset(0);
            make.height.mas_equalTo(50);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(54);
            make.left.equalTo(self.contentView).with.offset(0);
            make.right.equalTo(self.contentView).with.offset(0);
            make.height.mas_equalTo(12);
        }];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(68);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(12);
        }];
    }
    return self;
}

- (BOOL)isOrientationLandscape
{
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return YES;
    }
    return NO;
}

- (UIImageView *)giftImgView {
    if (!_giftImgView) {
        _giftImgView = [[UIImageView alloc] init];
    }
    return _giftImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:11];
        _titleLabel.textColor = self.isOrientationLandscape?[UIColor whiteColor]:[UIColor colorWithHexString:@"#222222"];
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = [UIFont systemFontOfSize:10];
        _priceLabel.textColor = self.isOrientationLandscape?[UIColor whiteColor]:[UIColor colorWithHexString:@"#999999"];
    }
    return _priceLabel;
}


@end

@interface DRGiftChooseView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *bgView;                       //选择礼物时半透明背景
@property (nonatomic, strong) UIView *numBgView;                    //选择数量时半透明背景
@property (nonatomic, strong) UIView *downView;                     //底部view
@property (nonatomic, strong) UIView *dotsView;                     //分页圆点view
@property (nonatomic, strong) UILabel *userPriceLab;                //用户剩余龙币数量
@property (nonatomic, strong) UILabel *giftNumLab;                  //礼物选择数量
@property (nonatomic, strong) UIImageView *arrowImgView;            //礼物数量选择箭头

@property (nonatomic, copy) NSArray *giftArray;                     //礼物数据集合
@property (nonatomic, strong) RoomGift *selGiftModel;               //选中的礼物
@property (nonatomic, assign) BOOL isOrientationLandscape;          //是否横屏
@property (nonatomic, assign) NSInteger currentPage;                //记录当前页码
@property (nonatomic, strong) HLHorizontalPageLayout *pageLayout;       

@property (nonatomic, copy) void (^selectedItemBlock)(RoomGift *giftModel);

@end

static NSString * const GiftCollectionViewCellIdentifier = @"GiftCollectionViewCell";
static CGFloat const CollectionWidth = 50;              //cell宽
static CGFloat const CollectionHeight = 80;             //cell高
static CGFloat const CollectionViewHeight = 215;

@implementation DRGiftChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = self.isOrientationLandscape?[[UIColor blackColor] colorWithAlphaComponent:0.5]:[UIColor whiteColor];
    }
    return self;
}

+ (DRGiftChooseView *)showGiftViewInWindow:(NSArray *)dataArray changeItem:(void (^)(RoomGift *giftModel))changeItem
{
    DRGiftChooseView *gView = [[DRGiftChooseView alloc] initWithFrame:CGRectZero];
    [gView setUI];
    [gView setDownView];
    
    gView.giftArray = dataArray.copy;
    [gView.collectionView reloadData];
    [gView setUpDotsView];
    
    gView.selectedIndex = 0;
    gView.selectedItemBlock = changeItem;
    
    if ([UserInstance shareInstance].isLogin){
        if ([[UserInstance shareInstance].userModel.coins integerValue] > 0) {
            gView.userPriceLab.text = [UserInstance shareInstance].userModel.coins;
        }
    }
    
    return gView;
}

- (void)setUI{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.bgView];
    [keyWindow addSubview:self];
    [self addSubview:self.collectionView];
    
    CGFloat collectionViewH = self.isOrientationLandscape ? 150 : 215;                  //collectionView高度
    CGFloat collectionBottom = 50 + (kIs_iPhoneX?(24.0):(0));                           //距离底部空间
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 下、右不需要写负号，insets方法中已经为我们做了取反的操作了。
        make.edges.equalTo(keyWindow).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(keyWindow).with.offset(0);
        make.left.equalTo(keyWindow).with.offset(0);
        make.right.equalTo(keyWindow).with.offset(0);
        make.height.mas_equalTo(collectionViewH+collectionBottom);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.height.mas_equalTo(collectionViewH);
    }];
    [self layoutIfNeeded];
    [self setOrigin:CGPointMake(0, kkScreenHeight)];
    [UIView animateWithDuration:0.3 animations:^{
        [self setOrigin:CGPointMake(0, kkScreenHeight-self.size.height)];
    }];
}

- (void)hiddenGiftView{

    [UIView animateWithDuration:0.2 animations:^{
        [self setOrigin:CGPointMake(0, kkScreenHeight)];
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
    }];
//    [UIView animateWithDuration:0.1 animations:^{
//        self.bgView.alpha = 0;
//        [self.bgView removeFromSuperview];
//
//        self.alpha = 0;
//        [self removeFromSuperview];
//    }];
}

//隐藏礼物选择view
- (void)touchOutSide{
    [self hiddenGiftView];
}

//隐藏数量选择view
- (void)touchNumOutSide{
    [self.numBgView removeFromSuperview];
    [UIView animateWithDuration:0.4 animations:^{
        self.arrowImgView.transform = CGAffineTransformMakeRotation(0.001 *M_PI / 180.0);
    }];
}

//充值
- (void)loadMoneyAction{
    [self hiddenGiftView];
    if (self.loadMoneyBlock) {
        self.loadMoneyBlock();
    }
}

//显示礼物数量view
- (void)giftNumAction{
    [self showGiftNumView];
    [UIView animateWithDuration:0.4 animations:^{
        self.arrowImgView.transform = CGAffineTransformMakeRotation(180 *M_PI / 180.0);
    }];
}

//发送
- (void)sendAction
{
    if (self.selectedItemBlock) {
        if ([self.selGiftModel.giftNum integerValue] == 0) {
            self.selGiftModel.giftNum = @"1";
        }
        self.selectedItemBlock(self.selGiftModel);
    }
    [self hiddenGiftView];
}

//选择礼物数量
- (void)giftSelectAction:(UIButton *)but
{
    self.selGiftModel.giftNum = [NSString stringWithFormat:@"%ld",but.tag];
    self.giftNumLab.text = [NSString stringWithFormat:@"%ld",but.tag];
    [self.numBgView removeFromSuperview];
    [UIView animateWithDuration:0.4 animations:^{
        self.arrowImgView.transform = CGAffineTransformMakeRotation(0.001 *M_PI / 180.0);
    }];
}

#pragma mark - Public Method
- (void)changeItemWithTargetIndex:(NSUInteger)targetIndex {
    if (_selectedIndex == targetIndex) {
        return;
    }
    
    RoomGift *selModel = self.giftArray[_selectedIndex];
    selModel.isSelect = NO;

    RoomGift *targetModel = self.giftArray[targetIndex];
    targetModel.isSelect = YES;
//
//    GiftCollectionViewCell *selectedCell = [self getCell:_selectedIndex];
//    if (selectedCell) {     //清空上一次选中
//        selectedCell.giftImgView.layer.borderWidth = 0;
//        selectedCell.giftImgView.layer.cornerRadius = 0;
//        selectedCell.giftImgView.layer.masksToBounds = YES;
//    }
//    GiftCollectionViewCell *targetCell = [self getCell:targetIndex];
//    if (targetCell) {       //当前选中效果
//        targetCell.giftImgView.layer.borderWidth = 2.0;
//        targetCell.giftImgView.layer.borderColor = SELECTED_COLOR.CGColor;
//        targetCell.giftImgView.layer.cornerRadius = 4.0;
//        targetCell.giftImgView.layer.masksToBounds = YES;
//    }
//
    _selectedIndex = targetIndex;
    
    [self layoutAndScrollToSelectedItem];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (self.giftArray == nil || self.giftArray.count == 0) {
        return;
    }

    if (selectedIndex >= self.giftArray.count) {
        _selectedIndex = self.giftArray.count - 1;
    } else {
        _selectedIndex = selectedIndex;
    }
    
    for (NSInteger i=0; i < self.giftArray.count; i++) {
        RoomGift *selModel = self.giftArray[i];
        if (i == selectedIndex) {
            selModel.isSelect = YES;
            self.selGiftModel = selModel;
        }else {
            selModel.isSelect = NO;
        }
    }

    [self layoutAndScrollToSelectedItem];
    
    
    
//    GiftCollectionViewCell *targetCell = [self getCell:selectedIndex];
//    if (targetCell) {       //当前选中效果
//        targetCell.giftImgView.layer.borderWidth = 2.0;
//        targetCell.giftImgView.layer.borderColor = SELECTED_COLOR.CGColor;
//        targetCell.giftImgView.layer.cornerRadius = 4.0;
//        targetCell.giftImgView.layer.masksToBounds = YES;
//    }
}

#pragma mark - Private Method
- (BOOL)isOrientationLandscape
{
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return YES;
    }
    return NO;
}

- (GiftCollectionViewCell *)getCell:(NSUInteger)Index {
    return (GiftCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:Index inSection:0]];
}

- (void)layoutAndScrollToSelectedItem {
    [self.collectionView reloadData];
//    [self.collectionView.collectionViewLayout invalidateLayout];
//    [self.collectionView setNeedsLayout];
//    [self.collectionView layoutIfNeeded];

}

- (CGFloat)getWidthWithContent:(NSString *)content {
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, CollectionViewHeight)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:NORMAL_FONT}
                                        context:nil
                   ];
    return ceilf(rect.size.width + 10);
}

- (void)reloadCurrentPageView
{
    for (NSInteger i=0; i<self.dotsView.subviews.count; i++) {
        UIView *roundView = [self.dotsView.subviews objectAtIndex:i];
        if (i == _currentPage) {
            roundView.backgroundColor = [UIColor colorWithHexString:@"#F67C37"];
        }else {
            roundView.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CollectionWidth, CollectionHeight);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.giftArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GiftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GiftCollectionViewCellIdentifier forIndexPath:indexPath];
    
    RoomGift *gfModel = self.giftArray[indexPath.row];
    [cell.giftImgView setImageURL:[NSURL URLWithString:gfModel.giftIcon]];
    cell.titleLabel.text = gfModel.propName;
    cell.priceLabel.text = [NSString stringWithFormat:@"%@龙币",gfModel.price];
    if (gfModel.isSelect) {
        cell.giftImgView.layer.borderWidth = 2.0;
        cell.giftImgView.layer.borderColor = SELECTED_COLOR.CGColor;
        cell.giftImgView.layer.cornerRadius = 4.0;
        cell.giftImgView.layer.masksToBounds = YES;
    }else {
        cell.giftImgView.layer.borderWidth = 0;
        cell.giftImgView.layer.cornerRadius = 0;
        cell.giftImgView.layer.masksToBounds = YES;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [self changeItemWithTargetIndex:indexPath.row];
    
    RoomGift *gfModel = self.giftArray[indexPath.row];
    self.selGiftModel = gfModel;
}

-(void)resetScrollview:(UIScrollView *)scrollView{
    CGFloat pageWidth = self.frame.size.width - 40;
    int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.currentPage = currentPage;
    [self reloadCurrentPageView];
//    NSLog(@"页码:%d",currentPage);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self resetScrollview:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self resetScrollview:scrollView];
}

#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        CGFloat itemNum = 4;        //每行显示个数
        CGFloat lineSpacing = (kkScreenWidth - 2*20 - itemNum*CollectionWidth)/(itemNum - 1);       //item间距
        if (self.isOrientationLandscape) {
            lineSpacing = 50;
        }
        CGFloat topSpacing = self.isOrientationLandscape? 50 : 15;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = lineSpacing;
        flowLayout.minimumInteritemSpacing = 15;
        flowLayout.sectionInset = UIEdgeInsetsMake(topSpacing, 20, 15, 20);
        
//        HLHorizontalPageLayout *layout = [[HLHorizontalPageLayout alloc] init];
//        layout.sectionInset = UIEdgeInsetsMake(topSpacing, 20, 15, 20);
//        layout.minimumInteritemSpacing = lineSpacing;
//        layout.minimumLineSpacing = 15;
//        layout.itemSize = CGSizeMake(CollectionWidth, CollectionHeight);
//        self.pageLayout = layout;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kkScreenWidth, CollectionHeight) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[GiftCollectionViewCell class] forCellWithReuseIdentifier:GiftCollectionViewCellIdentifier];
    }
    return _collectionView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(touchOutSide)];
        [_bgView addGestureRecognizer: tap];
    }
    return _bgView;
}

//分页圆点
- (void)setUpDotsView {
    
    NSInteger pageCount;
    if (self.isOrientationLandscape) {
        NSInteger itemW = CollectionWidth + 50;
        NSInteger itemCount = self.collectionView.size.width / itemW;
        pageCount = self.giftArray.count / itemCount;
        if (self.giftArray.count % itemCount) {
            pageCount += 1;
        }
    }else {
        pageCount = self.giftArray.count / 8;
        if (self.giftArray.count % 8) {
            pageCount += 1;
        }
    }
    NSInteger dotWH = 5.0;        //圆点宽高
    UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pageCount*dotWH + (pageCount-1)*dotWH, dotWH)];
    for (NSInteger i=0; i<pageCount; i++) {
        UIView  *roundView = [[UIView alloc] initWithFrame:CGRectMake(i*(dotWH+dotWH), 0, dotWH, dotWH)];
//        roundView.tag = 100 + i;
        if (i == 0) {
            roundView.backgroundColor = [UIColor colorWithHexString:@"#F67C37"];
        }else {
            roundView.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
        }
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:roundView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(dotWH * 0.5, dotWH * 0.5)];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        roundView.layer.mask = shape;
        [dotView addSubview:roundView];
        
    }
    [self.downView addSubview:dotView];
    self.dotsView = dotView;
    [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
//        make.width.mas_equalTo(pageSize*dotWH + (pageSize-1)*dotWH);
//        make.height.mas_equalTo(dotWH);
    }];
    
}

//底部钱币、发送按钮view
- (void)setDownView {
    
    UIView *downView = [[UIView alloc] init];
    [self addSubview:downView];
    self.downView = downView;
    
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-12-(kIs_iPhoneX?(24.0):(0)));
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(38);
    }];
    
    UIImageView *iconImgView = [[UIImageView alloc] init];
    iconImgView.image = [UIImage imageNamed:@"mine_icon_money"];
    [downView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(16);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(14);
    }];
    
    //用户的龙币数量
    UILabel *userMoneyLab = [[UILabel alloc] init];
    userMoneyLab.font = [UIFont systemFontOfSize:13];
    userMoneyLab.textAlignment = NSTextAlignmentLeft;
    userMoneyLab.text = @"0";
    userMoneyLab.textColor = self.isOrientationLandscape?[UIColor whiteColor]:[UIColor colorWithHexString:@"#222222"];
    [downView addSubview:userMoneyLab];
    self.userPriceLab = userMoneyLab;
    [userMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(38);
        make.width.mas_equalTo(50);
        make.bottom.mas_equalTo(0);
    }];
    
    UIButton *rechargeBut = [[UIButton alloc] init];
    rechargeBut.layer.cornerRadius = 12.0;
    rechargeBut.layer.masksToBounds = YES;
    rechargeBut.titleLabel.font = [UIFont systemFontOfSize:12];
    [rechargeBut setTitle:@"充值" forState:UIControlStateNormal];
    [rechargeBut setTitleColor:(self.isOrientationLandscape?[UIColor whiteColor]:[UIColor colorWithHexString:@"#F67C37"]) forState:UIControlStateNormal];
    rechargeBut.backgroundColor = self.isOrientationLandscape?[UIColor colorWithHexString:@"#F67C37"]:[UIColor whiteColor];
    [rechargeBut addTarget:self action:@selector(loadMoneyAction) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:rechargeBut];
    [rechargeBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.left.mas_equalTo(82);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(24);
    }];
    
    //礼物数量和发送按钮view
    UIView *changeView = [[UIView alloc] init];
    changeView.backgroundColor = [UIColor clearColor];
    changeView.layer.cornerRadius = 19.0;
    changeView.layer.masksToBounds = YES;
    changeView.layer.borderWidth = 1.0;
    changeView.layer.borderColor = [UIColor colorWithHexString:@"#F67C37"].CGColor;
    [downView addSubview:changeView];
    [changeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-16);
        make.width.mas_equalTo(148);
        make.height.mas_equalTo(38);
    }];
    
    //礼物数量
    UILabel *numLab = [[UILabel alloc] init];
    numLab.font = [UIFont systemFontOfSize:14];
    numLab.textAlignment = NSTextAlignmentRight;
    numLab.text = @"1";
    numLab.textColor = self.isOrientationLandscape?[UIColor whiteColor]:[UIColor colorWithHexString:@"#222222"];
    [changeView addSubview:numLab];
    self.giftNumLab = numLab;
    [numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-111);
        make.width.mas_equalTo(30);
        make.bottom.mas_equalTo(0);
    }];
    
    UIImageView *arrowImgView = [[UIImageView alloc] init];
    arrowImgView.image = [UIImage imageNamed:@"arrow_shouqi"];
    [changeView addSubview:arrowImgView];
    self.arrowImgView = arrowImgView;
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13);
        make.left.mas_equalTo(41);
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(13);
    }];
    
    //选择礼物数量按钮
    UIButton *numBut = [[UIButton alloc] init];
    [numBut addTarget:self action:@selector(giftNumAction) forControlEvents:UIControlEventTouchUpInside];
    [changeView addSubview:numBut];
    [numBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(74);
        make.bottom.mas_equalTo(0);
    }];
    
    //发送按钮
    UIButton *sendBut = [[UIButton alloc] init];
    sendBut.titleLabel.font = [UIFont systemFontOfSize:14];
    [sendBut setTitle:@"发送" forState:UIControlStateNormal];
    [sendBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBut.backgroundColor = [UIColor colorWithHexString:@"#F67C37"];
    [sendBut addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [changeView addSubview:sendBut];
    [sendBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(74);
        make.bottom.mas_equalTo(0);
    }];
}

//展示礼物数量
- (void)showGiftNumView
{
    UIView *numBgView = [[UIView alloc] init];
    numBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    numBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(touchNumOutSide)];
    [numBgView addGestureRecognizer: tap];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:numBgView];
    self.numBgView = numBgView;
    [numBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(keyWindow).with.insets(UIEdgeInsetsMake(0, 0, (kIs_iPhoneX?(24.0):(0)), 0));
    }];
    
    UIView *numView = [[UIView alloc] init];
//    numView.backgroundColor = self.isOrientationLandscape?[[UIColor blackColor] colorWithAlphaComponent:0.5]:[UIColor whiteColor];
    [numBgView addSubview:numView];
    [numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-60);
        make.right.mas_equalTo(-98);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(124);
    }];
    [numBgView layoutIfNeeded];
    
    [self setViewCornersShadow:numView];
    
    CGFloat butH = 30;
    NSArray *butArr = @[@99,@66,@10,@1];
    for (NSInteger i=0; i<butArr.count; i++) {
        UIButton *but = [[UIButton alloc] init];
        but.titleLabel.font = [UIFont systemFontOfSize:14];
        [but setTitle:[butArr objectAtIndex:i] forState:UIControlStateNormal];
        [but setTitleColor:(self.isOrientationLandscape?[UIColor whiteColor]:[UIColor colorWithHexString:@"#F67C37"]) forState:UIControlStateNormal];
        [but setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateSelected];
        but.tag = [[butArr objectAtIndex:i] integerValue];
        [but addTarget:self action:@selector(giftSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [numView addSubview:but];
        [but mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(2+butH*i);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(butH);
        }];
        if (i<butArr.count - 1 && !self.isOrientationLandscape) {
            UIView *lingView = [[UIView alloc] init];
            lingView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
            [numView addSubview:lingView];
            [lingView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(2+butH*(i+1));
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(0.5);
            }];
        }
    }
}

//圆角阴影处理
- (void)setViewCornersShadow:(UIView *)reView
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:reView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = reView.bounds;
    maskLayer.path = maskPath.CGPath;
    maskLayer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.29].CGColor;
    maskLayer.shadowOpacity = 1.0;
    maskLayer.shadowOffset = CGSizeMake(0, 0);
    maskLayer.shadowPath = maskPath.CGPath;
    maskLayer.fillColor = self.isOrientationLandscape?[[UIColor colorWithHexString:@"#232323"] colorWithAlphaComponent:0.8].CGColor:[UIColor whiteColor].CGColor;
    [reView.layer insertSublayer:maskLayer atIndex:0];
}

@end
