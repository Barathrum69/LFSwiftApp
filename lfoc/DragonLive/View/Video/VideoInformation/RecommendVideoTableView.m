//
//  RecommendVideoTableView.m
//  DragonLive
//
//  Created by LoaA on 2020/12/7.
//

#import "RecommendVideoTableView.h"
#import "RecommendVideoTableViewCell.h"
static NSString *RecommendVideoTableViewCellIdentifier = @"RecommendVideoTableViewCell";


@interface RecommendVideoTableView()
/// 没有更多数据.
@property (nonatomic, strong) NoMoreView *noMoreView;
@end

@implementation RecommendVideoTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
//        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
//                [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//            }
//        [self setSeparatorColor:[UIColor colorFromHexString:@"EEEEEE"]];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;

        self.dataSource = self;
        self.delegate   = self;
        _dataArray  = [NSMutableArray new];

        self.tableFooterView = [UIView new];

        
        [self registerNib:[UINib nibWithNibName:@"RecommendVideoTableViewCell" bundle:nil] forCellReuseIdentifier:RecommendVideoTableViewCellIdentifier];

        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

        self.contentInset = UIEdgeInsetsMake(0,0,0,0);//导航栏如果使用系统原生半透明的，top设置为64

        self.scrollIndicatorInsets = self.contentInset;

        self.estimatedRowHeight = 0;

        self.estimatedSectionHeaderHeight = 0;

        self.estimatedSectionFooterHeight = 0;

        
    }
    return self;
}//init


-(void)setDataArray:(NSMutableArray *)dataArray
{
    if (dataArray.count == 0) {
        if (!_noMoreView) {
            _noMoreView = [[NoMoreView alloc]initWithFrame:self.frame];
            [self addSubview:_noMoreView];
        }
    }else{
        if (_noMoreView) {
            [_noMoreView removeFromSuperview];
            _noMoreView = nil;
        }
    }
    _dataArray = dataArray;
    [self reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
    return 50;
}//section返回多少row

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RecommendVideoTableViewCellIdentifier];
    
//    RatioScoreModel *model = _dataArray[indexPath.row];
//    model.indexPath = indexPath;
    if (!cell) {
        cell = [[RecommendVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RecommendVideoTableViewCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArray[indexPath.row];
//    [cell teamUpdate];
//    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}//返回cell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWidth(101);
}//返回高度

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.itemDidSelected) {
        self.itemDidSelected(_dataArray[indexPath.row]);
    }
}//cell点击


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
