//
//  SegmentHeaderView.m
//  PersonalCenter
//
//  Created by Arch on 2018/8/20.
//  Copyright © 2018年 mint_bin. All rights reserved.
//

#import "SegmentHeaderView.h"

#define kWidth self.frame.size.width
#define NORMAL_FONT [UIFont systemFontOfSize:12]
#define NORMAL_COLOR [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0]
#define SELECTED_COLOR [UIColor colorWithRed:246/255.0 green:124/255.0 blue:55/255.0 alpha:1.0]

@interface SegmentHeaderViewCollectionViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end;

@implementation SegmentHeaderViewCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
//        self.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(9);
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(5);
            make.height.mas_equalTo(24);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.backgroundColor = [UIColor greenColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = NORMAL_FONT;
        _titleLabel.textColor = NORMAL_COLOR;
    }
    return _titleLabel;
}

@end

@interface SegmentHeaderView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, strong) UIView *moveLine;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, assign) BOOL selectedCellExist;
@end

CGFloat const SegmentHeaderViewHeight = 41;
static NSString * const SegmentHeaderViewCollectionViewCellIdentifier = @"SegmentHeaderViewCollectionViewCell";
static CGFloat const MoveLineHeight = 2;
static CGFloat const SeparatorHeight = 0.5;
static CGFloat const CellSpacing = 8;
static CGFloat const CollectionViewHeight = SegmentHeaderViewHeight - SeparatorHeight;

@implementation SegmentHeaderView

#pragma mark - Life
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
        self.titleArray = titleArray;
        self.selectedIndex = 0;
    }
    return self;
}

#pragma mark - Public Method
- (void)changeItemWithTargetIndex:(NSUInteger)targetIndex {
    if (_selectedIndex == targetIndex) {
        return;
    }
    
    SegmentHeaderViewCollectionViewCell *selectedCell = [self getCell:_selectedIndex];
    if (selectedCell) {
        selectedCell.titleLabel.textColor = NORMAL_COLOR;
        selectedCell.titleLabel.layer.borderWidth = 0;
        selectedCell.titleLabel.layer.cornerRadius = 0;
    }
    SegmentHeaderViewCollectionViewCell *targetCell = [self getCell:targetIndex];
    if (targetCell) {
        targetCell.titleLabel.textColor = SELECTED_COLOR;
        targetCell.titleLabel.layer.borderWidth = 1.0;
        targetCell.titleLabel.layer.borderColor = SELECTED_COLOR.CGColor;
        targetCell.titleLabel.layer.cornerRadius = 12.0;
        targetCell.titleLabel.layer.masksToBounds = YES;
    }
    
    _selectedIndex = targetIndex;
    
    [self layoutAndScrollToSelectedItem];
}

#pragma mark - Private Method
- (void)setupSubViews {
    [self addSubview:self.collectionView];
    [self.collectionView addSubview:self.moveLine];
    [self addSubview:self.separator];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(CollectionViewHeight);
    }];
    [self.moveLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(CollectionViewHeight - MoveLineHeight);
        make.height.mas_equalTo(MoveLineHeight);
    }];
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(SeparatorHeight);
    }];
}

- (SegmentHeaderViewCollectionViewCell *)getCell:(NSUInteger)Index {
    return (SegmentHeaderViewCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:Index inSection:0]];
}

- (void)layoutAndScrollToSelectedItem {
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

    if (self.selectedItemHelper) {
        self.selectedItemHelper(_selectedIndex);
    }
    
    SegmentHeaderViewCollectionViewCell *selectedCell = [self getCell:_selectedIndex];
    if (selectedCell) {
        self.selectedCellExist = YES;
        [self updateMoveLineLocation];
    } else {
        self.selectedCellExist = NO;
        //这种情况下updateMoveLineLocation将在self.collectionView滚动结束后执行（代理方法scrollViewDidEndScrollingAnimation）
    }
}

- (void)setupMoveLineDefaultLocation {
    CGFloat firstCellWidth = [self getWidthWithContent:self.titleArray[0]];
    [self.moveLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(firstCellWidth);
        make.left.mas_equalTo(CellSpacing);
    }];
}

- (void)updateMoveLineLocation {
    SegmentHeaderViewCollectionViewCell *cell = [self getCell:_selectedIndex];
    [UIView animateWithDuration:0.25 animations:^{
        [self.moveLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(CollectionViewHeight - MoveLineHeight);
            make.height.mas_equalTo(MoveLineHeight);
            make.width.centerX.equalTo(cell.titleLabel);
        }];
        [self.collectionView setNeedsLayout];
        [self.collectionView layoutIfNeeded];
    }];
}

- (CGFloat)getWidthWithContent:(NSString *)content {
    
    CGRect rect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, CollectionViewHeight)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:NORMAL_FONT}
                                        context:nil
                   ];
    return ceilf(rect.size.width + 10);
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = [self getWidthWithContent:self.titleArray[indexPath.row]] + 10;
    return CGSizeMake(itemWidth, SegmentHeaderViewHeight - 1);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SegmentHeaderViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SegmentHeaderViewCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    if (_selectedIndex == indexPath.row) {
        cell.titleLabel.textColor = SELECTED_COLOR;
        cell.titleLabel.layer.borderWidth = 1.0;
        cell.titleLabel.layer.borderColor = SELECTED_COLOR.CGColor;
        cell.titleLabel.layer.cornerRadius = 12.0;
        cell.titleLabel.layer.masksToBounds = YES;
    }else {
        cell.titleLabel.textColor = NORMAL_COLOR;
        cell.titleLabel.layer.borderWidth = 0;
        cell.titleLabel.layer.cornerRadius = 0;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self changeItemWithTargetIndex:indexPath.row];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.selectedCellExist) {
        [self updateMoveLineLocation];
    }
}

#pragma mark - Setter
- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray.copy;
    [self.collectionView reloadData];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (self.titleArray == nil || self.titleArray.count == 0) {
        return;
    }
    
    if (selectedIndex >= self.titleArray.count) {
        _selectedIndex = self.titleArray.count - 1;
    } else {
        _selectedIndex = selectedIndex;
    }
    
    //设置初始选中位置
    if (_selectedIndex == 0) {
        [self setupMoveLineDefaultLocation];
    } else {
        [self layoutAndScrollToSelectedItem];
    }
}

#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, CellSpacing, 0, CellSpacing);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, CollectionViewHeight) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[SegmentHeaderViewCollectionViewCell class] forCellWithReuseIdentifier:SegmentHeaderViewCollectionViewCellIdentifier];
    }
    return _collectionView;
}

- (UIView *)moveLine {
    if (!_moveLine) {
        _moveLine = [[UIView alloc] init];
        _moveLine.backgroundColor = [UIColor clearColor];
    }
    return _moveLine;
}

- (UIView *)separator {
    if (!_separator) {
        _separator = [[UIView alloc] init];
        _separator.backgroundColor = [UIColor clearColor];
    }
    return _separator;
}

@end
