//
//  VideoCommentTableView.m
//  DragonLive
//
//  Created by LoaA on 2020/12/8.
//

#import "VideoCommentTableView.h"
#import "VideoCommentTableViewCell.h"
#import "VideoCommentModel.h"
#import "CommentNoMoreView.h"

static NSString *VideoCommentTableViewCellIdentifier = @"VideoCommentTableViewCell";

@interface VideoCommentTableView ()
/// 没有更多数据.
@property (nonatomic, strong) CommentNoMoreView *noMoreView;

@end

@implementation VideoCommentTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        _page = 1;
//        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
//                [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//            }
//        [self setSeparatorColor:[UIColor colorFromHexString:@"EEEEEE"]];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;

        self.dataSource = self;
        self.delegate   = self;
        _dataArray  = [NSMutableArray new];

        self.tableFooterView = [UIView new];

        
        [self registerNib:[UINib nibWithNibName:@"VideoCommentTableViewCell" bundle:nil] forCellReuseIdentifier:VideoCommentTableViewCellIdentifier];

        self.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;

        self.contentInset = UIEdgeInsetsMake(0,0,0,0);//导航栏如果使用系统原生半透明的，top设置为64

        self.scrollIndicatorInsets = self.contentInset;

        self.estimatedRowHeight = 0;

        self.estimatedSectionHeaderHeight = 0;

        self.estimatedSectionFooterHeight = 0;

        
    }
    return self;
}//init


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.scrollViewWillBegin) {
        self.scrollViewWillBegin();
    }
    
}


-(void)setDataArray:(NSMutableArray *)dataArray
{
    
    if (_page == 1 &&dataArray.count == 0) {
        if (!_noMoreView) {
            _noMoreView = [[CommentNoMoreView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
            [self addSubview:_noMoreView];
        }
    }else{
        if (dataArray.count != 0) {
            if (_noMoreView) {
                [_noMoreView removeFromSuperview];
                _noMoreView = nil;
            }
        }
    }
    
    
    if (dataArray.count < 10) {
        if (_page != 1&&_dataArray.count>0) {
            self.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }
    
    
    if (_page == 1) {
        self.mj_footer.state = MJRefreshStateIdle;

        _dataArray = dataArray;
    }else{
        [_dataArray addObjectsFromArray:dataArray];
    }
    
   
    
    [self reloadData];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
    return 50;
}//section返回多少row

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoCommentTableViewCellIdentifier];
    
//    RatioScoreModel *model = _dataArray[indexPath.row];
//    model.indexPath = indexPath;
    if (!cell) {
        cell = [[VideoCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VideoCommentTableViewCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = [UIColor redColor];
    cell.model =  _dataArray[indexPath.row];
    kWeakSelf(self);
    //点赞
    cell.likeBtnOnClick = ^(VideoCommentModel * _Nonnull model) {
        if (weakself.cellLikeBtnBlock) {
            weakself.cellLikeBtnBlock(model);
        }
    };
    
    //删除
    cell.deleteBtnOnClick = ^(VideoCommentModel * _Nonnull model) {
        if (weakself.cellDeleteBtnBlock) {
            weakself.cellDeleteBtnBlock(model);
        }
    };
    
    
//    [cell teamUpdate];
//    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}//返回cell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return kWidth(97);
    VideoCommentModel *model = _dataArray[indexPath.row];
    return model.cellHeight;
}//返回高度

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
