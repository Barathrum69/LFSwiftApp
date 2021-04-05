//
//  NewsTableView.m
//  DragonLive
//
//  Created by LoaA on 2021/2/17.
//

#import "NewsTableView.h"
#import "NewsTableViewCell.h"
#import "NoMoreView.h"

static NSString *NewsTableViewCellIdentifier = @"NewsTableViewCell";

@interface NewsTableView ()
/// 没有更多数据.
@property (nonatomic, strong) NoMoreView *noMoreView;

@end

@implementation NewsTableView
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        _page = 1;
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
                [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, kWidth(170))];
            }
        [self setSeparatorColor:[UIColor colorFromHexString:@"EEEEEE"]];
        
        self.dataSource = self;
        self.delegate   = self;
        _dataArray  = [NSMutableArray new];
//        self.layer.cornerRadius = 10;
//        self.clipsToBounds = YES;
        self.tableFooterView = [UIView new];
//        self.separatorStyle = UITableViewCellSelectionStyleNone;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

////        self.clipsToBounds = NO;
//        [self registerClass:[FootBallTableViewCell class] forCellReuseIdentifier:FootBallTableViewCellIdentifier];
        [self registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:NewsTableViewCellIdentifier];

        self.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;

        self.contentInset = UIEdgeInsetsMake(0,0,0,0);//导航栏如果使用系统原生半透明的，top设置为64

        self.scrollIndicatorInsets = self.contentInset;

        self.estimatedRowHeight = 0;

        self.estimatedSectionHeaderHeight = 0;

        self.estimatedSectionFooterHeight = 0;
//        [self setCornerWithType:UIRectCornerAllCorners Radius:10];
        
//        [self LX_SetShadowPathWith:[UIColor blueColor] shadowOpacity:0.8 shadowRadius:10 shadowSide:LXShadowPathAllSide shadowPathWidth:3];
//        self.clipsToBounds = YES;

//        self.layer.shadowOffset = CGSizeMake(3,3);
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.layer.shadowOpacity = 0.3;
//        self.layer.shadowRadius = 3;//设置阴影半径
        
    }
    return self;
}//init
-(void)setDataArray:(NSMutableArray *)dataArray
{
    if (_page == 1&&dataArray.count == 0) {
        if (!_noMoreView) {
            _noMoreView = [[NoMoreView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
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
//    return 50;
}//section返回多少row

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsTableViewCellIdentifier];
    
//    RatioScoreModel *model = _dataArray[indexPath.row];
//    model.indexPath = indexPath;
    if (!cell) {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsTableViewCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    MatchListModel *model = _dataArray[indexPath.section];
//
    cell.model = _dataArray[indexPath.row];
//    [cell teamUpdate];
//    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}//返回cell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWidth(91);
}//返回高度


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.itemDidSelectBlock) {
        self.itemDidSelectBlock(_dataArray[indexPath.row]);
    }
}//点击


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
