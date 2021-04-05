//
//  MatchView.m
//  DragonLive
//
//  Created by LoaA on 2020/12/4.
//

#import "MatchView.h"
#import "HMSegmentedControl.h"
#import "MatchTableView.h"

@interface MatchView()<UIScrollViewDelegate>

//筛选框
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
/// 当前选择的下标
@property (nonatomic, assign) NSInteger selectedSegmentIndex;



//scrollView
//@property (nonatomic, strong) UIScrollView *scrollView;
//
///// 界面view全部存在这个数组里面
//@property (nonatomic, strong) NSMutableArray *viewArray;

@end

@implementation MatchView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = The_MainColor;
        [self initSegmentedControl];//筛选框
        self.selectedSegmentIndex = 0;
//        [self initScrollView];//scroll
    }
    return self;
}


#pragma mark  - 初始化加载的东西
-(void)initSegmentedControl
{
    _segmentedControl = [[HMSegmentedControl alloc] init];
    _segmentedControl.frame = CGRectMake(0, 0, kScreenWidth, 40);
//    _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    //indicator和文本等宽（含inset）、和segment一样宽，背景大方块，箭头
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    
    //indicator位置
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    //选中indicator
    _segmentedControl.selectionIndicatorColor = BXColor(255, 101, 69);
    _segmentedControl.selectionIndicatorHeight = 4.0f;
    _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -4, 0);
    //        _segmentedControl.backgroundColor =[UIColor whiteColor];
    //标题属性
    _segmentedControl.titleTextAttributes = @{
        NSForegroundColorAttributeName : BXColor(61, 61, 61),
        NSFontAttributeName:[UIFont systemFontOfSize:15.0]
    };
    //选中标题属性
    _segmentedControl.selectedTitleTextAttributes =@{
        NSForegroundColorAttributeName : BXColor(0, 0, 0),
        NSFontAttributeName:[UIFont boldSystemFontOfSize:19]
    };
    _segmentedControl.selectedSegmentIndex = 0;
    
//    [self addSubview:_segmentedControl];
    
    kWeakSelf(self);
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        weakself.selectedSegmentIndex = index;
//        [weakself.scrollView scrollRectToVisible:CGRectMake(kScreenWidth * index, 0, kScreenWidth, weakself.scrollView.frame.size.height) animated:YES];
//        [weakself addContentView];//滑动加载View
        [weakself.matchTableView.mj_header beginRefreshing];
    }];
}//initSegmentedControl

-(void)setSectionTitles:(NSMutableArray *)sectionTitles
{
    if (_sectionTitles != sectionTitles) {
        _sectionTitles = sectionTitles;
            self.segmentedControl.sectionTitles = _sectionTitles;
            
//            self.scrollView.contentSize = CGSizeMake(kScreenWidth * _sectionTitles.count, self.height-40);//4
//            [self initContentViewArray];
        [self initMatchTableView];
    }
        
}//Segment的title数组 赋值

-(void)initMatchTableView
{
    kWeakSelf(self);
    _matchTableView = [[MatchTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.height)];
    [self addSubview:_matchTableView];
    //下啦刷新
    _matchTableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        weakself.matchTableView.page = 1;
        if (weakself.matchHeaderRefreshBlock) {
            weakself.matchHeaderRefreshBlock(weakself.matchTableView.page,weakself.selectedSegmentIndex);
        }
     }];
    
    
    //上拉加载更多
    _matchTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        weakself.matchTableView.page ++;
        if (weakself.matchFooterRefreshBlock) {
            weakself.matchFooterRefreshBlock(weakself.matchTableView.page,weakself.selectedSegmentIndex);
        }
     }];
    //点击跳转到下一个界面
    _matchTableView.tableViewDidSelected = ^(MatchItemModel * _Nonnull model) {
        if (weakself.matchItemDidSelected) {
            weakself.matchItemDidSelected(model);
        }
    };
    
}//初始化TableView

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    _matchTableView.resArray = dataArray;
}
-(void)headerFooterEnd
{
    if (_matchTableView.mj_header.isRefreshing) {
        [_matchTableView.mj_header endRefreshing];
    }
    if (_matchTableView.mj_footer.isRefreshing) {
        [_matchTableView.mj_footer endRefreshing];
    }
}//结束头部尾部的刷新

//-(void)initScrollView
//{
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _segmentedControl.bottom, kScreenWidth, self.height-40)];
//    //    self.scrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
//    self.scrollView.pagingEnabled = YES;
//    self.scrollView.bounces = NO;
//    self.scrollView.showsHorizontalScrollIndicator = NO;
//    self.scrollView.delegate = self;
//    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, self.height-40) animated:NO];
//    [self addSubview:self.scrollView];
//}//scroll

#pragma mark  -- scrollViewDidScroll
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    CGFloat pageWidth = scrollView.frame.size.width;
//    NSInteger page = scrollView.contentOffset.x / pageWidth;
//    [self.segmentedControl setSelectedSegmentIndex:page animated:NO];
//    self.selectedSegmentIndex = page;
//        [self addContentView];
    
    //    [self removeRemindWithBallGameType:self.selectedSegmentIndex];//上了关注再打开
    //    [self noticeSuspensionViewShow];
    //滑动完成后把block传出去
    //    if (self.viewSegmentBlock) {
    //        self.viewSegmentBlock(self.selectedSegmentIndex);
    //    }
//}//减速结束了
//-(void)initContentViewArray
//{
//    if (self.viewArray == nil) {
//        self.viewArray = [[NSMutableArray alloc]initWithCapacity:_sectionTitles.count];
////        self.contentOffsetArry = [[NSMutableArray alloc]initWithCapacity:_sectionTitles.count];
//
//        for (int i=0; i<_sectionTitles.count; i++) {
//            NSNull *obj = [NSNull null];
////            [self.contentOffsetArry addObject:[ContentModel new]];
//            [self.viewArray addObject:obj];
//        }
//    }
//    [self addContentView];
//}//初始化contentArray
#pragma mark  - 主view 加载的时候才会调用
//-(void)addContentView
//{

//    kWeakSelf(self);

//    __block CGFloat num = 3*(self.height-40);
//    __block ContentModel *block_model;
////    __block ContentModel *content_model;
//    id obj =  self.viewArray [self.selectedSegmentIndex];
//    if ([obj isKindOfClass:[NSNull class]]) {
//
//        MatchTableView *matchTableView = [[MatchTableView alloc]initWithFrame:CGRectMake(self.selectedSegmentIndex*kScreenWidth, 0, kScreenWidth, self.height-50)];
//        [self.viewArray replaceObjectAtIndex:self.selectedSegmentIndex withObject:matchTableView];
//        [self.scrollView addSubview:matchTableView];
//        footBallView.backgroundColor = BXRandomColor;
        //blcok
//        footBallView.dateConllectionViewItemDidSelectBlock = ^(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, BallGameType ballGameType) {
//            if (weakself.footBallDataItemDidSelectBlock) {
//                weakself.footBallDataItemDidSelectBlock(collectionView,indexPath,ballGameType);
//            }
//        };
//
//        // 滑动有改变了
//        footBallView.footBallTableViewDidScrollBlock = ^(CGFloat y) {
//            block_model = [weakself.contentOffsetArry objectAtIndex:weakself.selectedSegmentIndex];
//            block_model.y = y;
//            if (y > num) {
//                if (weakself.suspensionViewShowBlcok) {
//                    weakself.suspensionViewShowBlcok(YES);
//                }
////                NSLog(@"我已经超过限制了");
//            }else{
//                if (weakself.suspensionViewShowBlcok) {
//                    weakself.suspensionViewShowBlcok(NO);
//                }
////                NSLog(@"我还在限制内");
//            }
//        };
//
//        //头部尾部刷新
//        footBallView.headerRefreshBlock = ^(NSInteger page) {
//            if (weakself.contentHeaderRefreshBlock) {
//                weakself.contentHeaderRefreshBlock(page,weakself.selectedSegmentIndex);
//            }
//        };
//        footBallView.footerRefreshBlock = ^(NSInteger page) {
//            if (weakself.contentFooterRefreshBlock) {
//                weakself.contentFooterRefreshBlock(page,weakself.selectedSegmentIndex);
//            }
//        };
//
//        //tableView点击
//        matchTableView.collectionViewItemDidSelectBlock = ^(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath) {
//            if (weakself.videoListItemDidSelectBlock) {
//                weakself.videoListItemDidSelectBlock(collectionView,indexPath);
//            }
//        };
//
 

        //在这里执行第一次的网络请求 。 包括固定数据赋值 等等 一定是加载好以后再放上去 血泪史
//        if (self.footViewFirstRequest) {
//            self.footViewFirstRequest(0,self.selectedSegmentIndex);
//        }
//    }
//}//添加ContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
