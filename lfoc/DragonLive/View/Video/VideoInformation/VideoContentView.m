//
//  VideoContentView.m
//  DragonLive
//
//  Created by LoaA on 2020/12/8.
//

#import "VideoContentView.h"
#import "HMSegmentedControl.h"
#import "RecommendVideoTableView.h"
#import "VideoCommentTableView.h"
#import "RecommendHeader.h"
#import "VideoDetailModel.h"
#import "AJKeyboardView.h"
#import "UIScrollView+util.h"

@interface VideoContentView()<UIScrollViewDelegate,AJKeyboardDelegate>

/// keyBoard
@property (nonatomic, strong) AJKeyboardView *keyView;

//筛选框
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, strong) UIView *line;

/// 评论数量
@property (nonatomic, strong) UILabel *commentLab;

/// 当前选择的下标
@property (nonatomic, assign) NSInteger selectedSegmentIndex;

//scrollView
@property (nonatomic, strong) UIScrollView *scrollView;



@end

@implementation VideoContentView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSegmentedControl];
        [self initScrollView];
        [self initVideoMoreTableView];
        [self initVideoCommentTableView];
    }
    return self;
}//初始化

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

-(void)setItemModel:(VideoDetailModel *)itemModel
{
    _itemModel = itemModel;
    
    CGSize contentHeight = [UntilTools boundingALLRectWithSize:_itemModel.title Font:[UIFont systemFontOfSize:kWidth(16)] Size:CGSizeMake(kScreenWidth-kWidth(34), 9999)];
//    _recommendHeader.frame = CGRectMake(0, 0, kScreenWidth,  kWidth(152)+ contentHeight.height);
    if (_recommendHeader == nil) {
        _recommendHeader = [[RecommendHeader alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kWidth(152)+contentHeight.height)];
    }
    
    _recommendHeader.model = itemModel;
    _recommendVideoTableView.tableHeaderView = _recommendHeader;
    _commentLab.text = _itemModel.commentNumberOfCurVideo;
    kWeakSelf(self);
    _recommendHeader.shareBtnBlock = ^{
        if (weakself.recommedShareBlock) {
            weakself.recommedShareBlock();
        }
    };
    //这个视频的头部点赞
    _recommendHeader.likeBtnClickBlock = ^(VideoDetailModel * _Nonnull model) {
        if (weakself.recommedLikeedBlock) {
            weakself.recommedLikeedBlock(model);
        }
    };
    //推荐视频的评论block点击
    _recommendHeader.reCommentBtnClickBlock = ^{
        weakself.selectedSegmentIndex = 1;
        weakself.segmentedControl.selectedSegmentIndex = weakself.selectedSegmentIndex;
        [weakself.scrollView scrollRectToVisible:CGRectMake(weakself.selectedSegmentIndex*kScreenWidth, 0, kScreenWidth, weakself.scrollView.height) animated:YES];

    };
    
    
//    kScreenWidth-kWidth(34)
}//重写Set方法



-(void)setRecommedArray:(NSMutableArray *)recommedArray
{
    _recommedArray = recommedArray;
    _recommendVideoTableView.dataArray = _recommedArray;
}


-(void)setCommentArray:(NSMutableArray *)commentArray{
    _commentArray = commentArray;
    _videoCommentTableView.dataArray = _commentArray;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
//    [self setNeedsLayout];
    [self performSelector:@selector(updateFrame) afterDelay:0.001];  //尼玛大坑啊, 不设置延时调用就卡住了。系统级别的bug么？
    
}//layoutSubviews 延迟刷新一下

-(void)updateFrame
{
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*2, self.scrollView.height);
    [self.scrollView scrollRectToVisible:CGRectMake(_selectedSegmentIndex*kScreenWidth, 0, kScreenWidth, self.scrollView.height) animated:NO];
}//更新界面 防止卡住

#pragma mark  - 初始化加载的东西
-(void)initSegmentedControl
{
    _segmentedControl = [[HMSegmentedControl alloc] init];
    _segmentedControl.frame = CGRectMake(0, 5, 115, 40);

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
        NSForegroundColorAttributeName : BXColor(51, 51, 51),
        NSFontAttributeName:[UIFont systemFontOfSize:15.0]
    };
    //选中标题属性
    _segmentedControl.selectedTitleTextAttributes =@{
        NSForegroundColorAttributeName : BXColor(51, 51, 51),
        NSFontAttributeName:[UIFont boldSystemFontOfSize:15]
    };
    _segmentedControl.selectedSegmentIndex = 0;
    
    [self addSubview:_segmentedControl];
    
    kWeakSelf(self);
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        weakself.selectedSegmentIndex = index;
        [weakself.scrollView scrollRectToVisible:CGRectMake(kScreenWidth * index, 0, kScreenWidth, weakself.scrollView.frame.size.height) animated:YES];
//        [weakself addContentView];//滑动加载View

    }];
    
    _commentLab = [[UILabel alloc]initWithFrame:CGRectMake(_segmentedControl.right-10, _segmentedControl.top+15, 50, 10)];
    _commentLab.font = [UIFont systemFontOfSize:10];
//    _commentLab.text = @"123";
    _commentLab.textColor = [UIColor colorFromHexString:@"999999"];
    [self addSubview:_commentLab];
    
    
    _line = [[UIView alloc]initWithFrame:CGRectMake(0, _segmentedControl.bottom+kWidth(3), kScreenWidth, 1)];
    _line.backgroundColor = [UIColor colorFromHexString:@"eeeeee"];
    [self addSubview:_line];
}//initSegmentedControl

-(void)initScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _line.bottom, kScreenWidth, self.height-46-kWidth(3))];
    //    self.scrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*2, self.scrollView.height);
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, self.scrollView.height) animated:NO];
    [self addSubview:self.scrollView];
}//scroll

-(void)setSectionTitles:(NSMutableArray *)sectionTitles
{
    if (_sectionTitles != sectionTitles) {
        _sectionTitles = sectionTitles;
            self.segmentedControl.sectionTitles = _sectionTitles;
            
//            self.scrollView.contentSize = CGSizeMake(kScreenWidth * _sectionTitles.count, self.height-40);//4
//            [self initContentViewArray];
    }
        
}//Segment的title数组 赋值

-(void)initVideoMoreTableView
{
    kWeakSelf(self);
    _recommendVideoTableView = [[RecommendVideoTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,_scrollView.height) style:UITableViewStylePlain];
    [_scrollView addSubview:_recommendVideoTableView];
    
    _recommendVideoTableView.itemDidSelected = ^(VideoItemModel * _Nonnull model) {
        if (weakself.recommedTableViewDidSelected) {
            weakself.recommedTableViewDidSelected(model);
        }
    };
    
  
}//加载推荐更多的视频

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}


-(void)initVideoCommentTableView
{
    kWeakSelf(self);
    _videoCommentTableView = [[VideoCommentTableView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth,_scrollView.height-52) style:UITableViewStylePlain];
    [_scrollView addSubview:_videoCommentTableView];
    
    _keyView = [[AJKeyboardView alloc] initWithFrame:CGRectMake(kScreenWidth, _scrollView.height - 52, kScreenWidth, 52)superViewHeight:_scrollView.height];
    _keyView.delegate = self;
    [_scrollView addSubview:_keyView];
    
    
    
    
    //滑动隐藏
    _videoCommentTableView.scrollViewWillBegin = ^{
        [weakself endEditing:YES];
    };
    
       //头部尾部刷新 加载更多
    _videoCommentTableView.mj_header =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        weakself.videoCommentTableView.page = 1;
        if (weakself.commentHeaderRefreshBlock) {
            weakself.commentHeaderRefreshBlock(weakself.videoCommentTableView.page);
        }
     }];
    _videoCommentTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        weakself.videoCommentTableView.page ++;
        if (weakself.commentFooterRefreshBlock) {
            weakself.commentFooterRefreshBlock(weakself.videoCommentTableView.page);
        }
     }];
    //点赞
    _videoCommentTableView.cellLikeBtnBlock = ^(VideoCommentModel * _Nonnull model) {
        if (weakself.commentLikeBlock) {
            weakself.commentLikeBlock(model);
        }
    };
    
    //删除
    _videoCommentTableView.cellDeleteBtnBlock = ^(VideoCommentModel * _Nonnull model) {
        if (weakself.commentDeleteBlock) {
            weakself.commentDeleteBlock(model);
        }
    };

    
}//加载评论的view

//发送的文案
- (void)textViewContentText:(NSString *)textStr {
    if (self.textViewContentText) {
        self.textViewContentText(textStr);
    }
}


-(void)headerFooterEnd
{
    if (_recommendVideoTableView.mj_header.isRefreshing) {
        [_recommendVideoTableView.mj_header endRefreshing];

    }
    
    if (_videoCommentTableView.mj_header.isRefreshing) {
        [_videoCommentTableView.mj_header endRefreshing];

    }
    if (_videoCommentTableView.mj_footer.isRefreshing) {
        [_videoCommentTableView.mj_footer endRefreshing];
    }
}//结束头部尾部的刷新
#pragma mark  -- scrollViewDidScroll
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    [self.segmentedControl setSelectedSegmentIndex:page animated:YES];
    self.selectedSegmentIndex = page;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
