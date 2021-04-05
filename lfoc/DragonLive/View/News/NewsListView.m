//
//  NewsListView.m
//  DragonLive
//
//  Created by LoaA on 2021/2/17.
//

#import "NewsListView.h"
#import "NewsTableView.h"
#import "HMSegmentedControl.h"
#import "NewsModel.h"
@interface NewsListView()<UIScrollViewDelegate>


//筛选框
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

/// 当前选择的下标
@property (nonatomic, assign) NSInteger selectedSegmentIndex;

//scrollView
@property (nonatomic, strong) UIScrollView *scrollView;

/// 界面view全部存在这个数组里面
@property (nonatomic, strong) NSMutableArray *viewArray;


@end

@implementation NewsListView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = The_MainColor;
        [self initSegmentedControl];//筛选框
        [self initScrollView];//scroll
        self.selectedSegmentIndex = 0;
        //        self.clipsToBounds = NO;
    }
    return self;
}//init
#pragma mark  - 初始化加载的东西
-(void)initSegmentedControl
{
    _segmentedControl = [[HMSegmentedControl alloc] init];
    _segmentedControl.frame = CGRectMake(0, 0, kScreenWidth, 40);
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    
    //indicator位置
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    //选中indicator
    _segmentedControl.selectionIndicatorColor = BXColor(255, 101, 69);
    _segmentedControl.selectionIndicatorHeight = 4.0f;
    _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -4, 0);
    _segmentedControl.backgroundColor =[UIColor colorFromHexString:@"F5F5F5"];
   
    //标题属性
    _segmentedControl.titleTextAttributes = @{
        NSForegroundColorAttributeName : BXColor(61, 61, 61),
        NSFontAttributeName:[UIFont systemFontOfSize:15.0]
    };
    //选中标题属性
    _segmentedControl.selectedTitleTextAttributes =@{
        NSForegroundColorAttributeName : BXColor(61, 61, 61),
        NSFontAttributeName:[UIFont systemFontOfSize:15.0]
    };
    _segmentedControl.selectedSegmentIndex = 0;
    
    [self addSubview:_segmentedControl];
    
    kWeakSelf(self);
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        weakself.selectedSegmentIndex = index;
        [weakself.scrollView scrollRectToVisible:CGRectMake(kScreenWidth * index, 0, kScreenWidth, weakself.scrollView.frame.size.height) animated:YES];
        [weakself addContentView];//滑动加载View

    }];
}//初始化加载SegmentedControl


-(void)initScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _segmentedControl.bottom, kScreenWidth, self.height-40)];
    //    self.scrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, self.height-40) animated:NO];
    [self addSubview:self.scrollView];
}//scroll


#pragma mark  -- scrollViewDidScroll
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmentedControl setSelectedSegmentIndex:page animated:NO];
    self.selectedSegmentIndex = page;
        [self addContentView];
    
    //    [self removeRemindWithBallGameType:self.selectedSegmentIndex];//上了关注再打开
    //    [self noticeSuspensionViewShow];
    //滑动完成后把block传出去
    //    if (self.viewSegmentBlock) {
    //        self.viewSegmentBlock(self.selectedSegmentIndex);
    //    }
}//减速结束了


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    self.segmentedControl.selectionIndicatorOffsetX = scrollView.contentOffset.x / scrollView.contentSize.width;
}//正在滚动

-(void)setSectionTitles:(NSMutableArray *)sectionTitles
{
    if (_sectionTitles != sectionTitles) {
        _sectionTitles = sectionTitles;
            self.segmentedControl.sectionTitles = _sectionTitles;
            
            self.scrollView.contentSize = CGSizeMake(kScreenWidth * _sectionTitles.count, self.height-40);//4
            [self initContentViewArray];
      
    }
        
}//Segment的title数组 赋值

-(void)initContentViewArray
{
    if (self.viewArray == nil) {
        self.viewArray = [[NSMutableArray alloc]initWithCapacity:_sectionTitles.count];
//        self.contentOffsetArry = [[NSMutableArray alloc]initWithCapacity:_sectionTitles.count];
        for (int i=0; i<_sectionTitles.count; i++) {
            NSNull *obj = [NSNull null];
//            [self.contentOffsetArry addObject:[ContentModel new]];
            [self.viewArray addObject:obj];
        }
    }
    [self addContentView];
}//初始化contentArray


-(void)addContentView
{
    id obj =  self.viewArray [self.selectedSegmentIndex];
    if ([obj isKindOfClass:[NSNull class]]) {
        kWeakSelf(self);
        NewsTableView *contentView = [[NewsTableView alloc]initWithFrame:CGRectMake(self.selectedSegmentIndex*kScreenWidth, 0, kScreenWidth, self.height-40)style:UITableViewStylePlain];
        [self.viewArray replaceObjectAtIndex:self.selectedSegmentIndex withObject:contentView];
        [self.scrollView addSubview:contentView];
        
        contentView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //Call this Block When enter the refresh status automatically
            contentView.page = 1;
            if (weakself.tableViewHeaderBlock) {
                weakself.tableViewHeaderBlock(contentView.page,self.selectedSegmentIndex);
            }
         }];
        
        contentView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            //Call this Block When enter the refresh status automatically
            contentView.page ++;
            if (weakself.tableViewFooterBlock) {
                weakself.tableViewFooterBlock(contentView.page,self.selectedSegmentIndex);
            }
         }];
        
        contentView.itemDidSelectBlock = ^(NewsItemModel * _Nonnull model) {
            if (weakself.tableViewDidSelected) {
                weakself.tableViewDidSelected(model);
            }
        };
        
        
        if (self.tableViewFirstRequest) {
            self.tableViewFirstRequest(1,self.selectedSegmentIndex);
        }
    }
}

-(void)headerFooterEnd{
    NewsTableView *obj = self.viewArray[self.selectedSegmentIndex];
    if (![obj isKindOfClass:[NSNull class]]) {
        //这里必须是先给data赋值
        if (obj.mj_header.isRefreshing) {
            [obj.mj_header endRefreshing];

        }
        if (obj.mj_footer.isRefreshing) {
            [obj.mj_footer endRefreshing];
        }
    }
}//头部尾部刷新

-(void)setItemModel:(NewsModel *)itemModel
{
    if (_itemModel != itemModel) {
        _itemModel = itemModel;
    }
    NewsTableView *obj = self.viewArray[_itemModel.type];
    if (![obj isKindOfClass:[NSNull class]]) {
        //这里必须是先给data赋值
        obj.dataArray = _itemModel.dataArray;
        [self headerFooterEnd];
    }
}//setItemmodel 找到这个对应的view 然后赋值


-(NewsTableView *)getCurrtView{
    NewsTableView *obj = self.viewArray[self.selectedSegmentIndex];
    return obj;
}//获取当前页

-(NSMutableArray *)getCurrtDataArray
{
    NewsTableView *obj = self.viewArray[self.selectedSegmentIndex];
    return obj.dataArray;
}//获取当前页的数组

-(void)currtPageRefrash
{
    NewsTableView *obj = self.viewArray[self.selectedSegmentIndex];
    if (![obj isKindOfClass:[NSNull class]]) {
        //这里必须是先给data赋值
        [obj.mj_header beginRefreshing];
    }
}/// 当前页刷新

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
