//
//  StationMessageTableView.m
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import "StationMessageTableView.h"
#import "StationMessageCell.h"
#import "StationMessageModel.h"
static NSString *StationMessageCellIdentifier = @"StationMessageCell";

@interface StationMessageTableView ()

/// 没有更多数据.
@property (nonatomic, strong) NoMoreView *noMoreView;

@end

@implementation StationMessageTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        _page = 1;
        self.backgroundColor = [UIColor clearColor];
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
                [self setSeparatorInset:UIEdgeInsetsMake(0, 25, 0, 25)];
            }
        [self setSeparatorColor:[UIColor colorFromHexString:@"EEEEEE"]];
//        [self setSeparatorColor:[UIColor redColor]];

        
        self.dataSource = self;
        self.delegate   = self;
        _dataArray  = [NSMutableArray new];
//        self.layer.cornerRadius = 10;
//        self.clipsToBounds = YES;
        self.tableFooterView = [UIView new];
//        self.separatorStyle = UITableViewCellSelectionStyleNone;

////        self.clipsToBounds = NO;
//        [self registerClass:[FootBallTableViewCell class] forCellReuseIdentifier:FootBallTableViewCellIdentifier];
        [self registerNib:[UINib nibWithNibName:@"StationMessageCell" bundle:nil] forCellReuseIdentifier:StationMessageCellIdentifier];
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
    
    StationMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:StationMessageCellIdentifier];
    if (!cell) {
        cell = [[StationMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StationMessageCellIdentifier];
    }
    
    cell.model = _dataArray[indexPath.row];

    [cell doRefreshModel:^(id model, NSInteger rowNum, NSInteger sectionNum) {
        StationMessageModel * ttmodel = (StationMessageModel *)model;
        ttmodel.isOpen = !ttmodel.isOpen;
        //刷新选中的某一行
        [self->_dataArray replaceObjectAtIndex:indexPath.row withObject:ttmodel];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}//返回cell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StationMessageModel * model = _dataArray[indexPath.row];
    if (model.isOpen) {
        //如果是打开的状态  就显示实际需要的高度
       return model.msgSize.height + kWidth(65);
    }else{
        //如果需要显示 展开的按钮 就返回80的高度  如果不需要 就返回60的高度
        return kWidth(76);
    }
}//返回高度
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
