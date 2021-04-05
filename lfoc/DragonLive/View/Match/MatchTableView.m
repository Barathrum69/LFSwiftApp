//
//  MatchTableView.m
//  DragonLive
//
//  Created by LoaA on 2020/12/4.
//

#import "MatchTableView.h"
#import "MatchTableViewCell.h"
#import "MatchItemModel.h"
#import "MatchListModel.h"
static NSString *MatchTableViewCellIdentifier = @"MatchTableViewCell";


@interface MatchTableView()
/// 没有更多数据.
@property (nonatomic, strong) NoMoreView *noMoreView;

@end

@implementation MatchTableView
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        _page = 1;
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
                [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
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
        [self registerNib:[UINib nibWithNibName:@"MatchTableViewCell" bundle:nil] forCellReuseIdentifier:MatchTableViewCellIdentifier];

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


-(void)setResArray:(NSMutableArray *)resArray{
    
    if (_page == 1&&resArray.count == 0) {
        if (!_noMoreView) {
            _noMoreView = [[NoMoreView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
            [self addSubview:_noMoreView];
        }
    }else{
        if (resArray.count != 0) {
            if (_noMoreView) {
                [_noMoreView removeFromSuperview];
                _noMoreView = nil;
            }
        }
    }
    
    
    if (resArray.count < 10) {
        if (_page != 1&&_resArray.count>0) {
            self.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }
    
    if (_page == 1) {
        self.mj_footer.state = MJRefreshStateIdle;

        _resArray = resArray;
    }else{
        [_resArray addObjectsFromArray:resArray];
    }
    NSLog(@" self.mj_footer.state = %ld", (long)self.mj_footer.state);
    //哈希
    NSMutableDictionary *hashDict = [NSMutableDictionary new];
    //开始把那些数据组合起来.
    for (MatchItemModel *obj in _resArray) {
        //如果有
        if([hashDict objectForKey:[NSString stringWithFormat:@"%@",obj.sectionTime]]) {
            NSMutableArray *array = [hashDict objectForKey:[NSString stringWithFormat:@"%@",obj.sectionTime]];
            [array addObject:obj];
        }else{
            //如果没有这条
            NSMutableArray *array = [NSMutableArray new];
            [array addObject:obj];
            [hashDict setValue:array forKey:[NSString stringWithFormat:@"%@",obj.sectionTime]];
        }
    }
    
    NSArray *keysArr = [hashDict allKeys];
    NSMutableArray *array = [NSMutableArray new];
    
    for (NSString *obj in keysArr) {
        MatchListModel *model = [MatchListModel new];
        model.sectionString = obj;
        model.showTimeString = [UntilTools converTimeWithMMDDString:obj];
        model.dataArray = [hashDict objectForKey:obj];
        [array addObject:model];
    }
    
    NSArray *data = [self sortedArrayUsingComparatorByPaymentTimeWithDataArr:(NSArray *)array];
    
    _dataArray = [NSMutableArray arrayWithArray:data];
    //反转一下
    _dataArray = [[_dataArray reverseObjectEnumerator] allObjects];
    
    //把那个今天明天弄进来
    for (MatchListModel *model in _dataArray) {
        NSString *dateString = model.showTimeString;
        NSString *section = model.sectionString;
        NSString *dateNew = [NSString stringWithFormat:@"%@%@",[UntilTools checkTheDate:section],dateString];
        model.showTimeString = [NSString stringWithFormat:@"%@  %@",dateNew,[UntilTools weekdayStringFromDate:section]];
    }
    
    
//    if (_dataArray.count >= 1) {
//        MatchListModel *model = _dataArray[0];
//        model.sectionString =[NSString stringWithFormat:@"今天 %@", model.sectionString];
//    }
//    
//    if (_dataArray.count >= 2) {
//        MatchListModel *model = _dataArray[1];
//        model.sectionString =[NSString stringWithFormat:@"明天 %@", model.sectionString];
//    }
    
    [self reloadData];
    NSLog(@"1111");
    
}

- (NSArray *)sortedArrayUsingComparatorByPaymentTimeWithDataArr:(NSArray *)dataArr{
    NSArray *sortArray = [dataArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        MatchListModel *model1 = obj1;
        MatchListModel *model2 = obj2;
        
        //时间
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd"];
        NSDate *date1= [dateFormatter dateFromString:model1.sectionString];
        NSDate *date2= [dateFormatter dateFromString:model2.sectionString];
        if (date1 == [date1 earlierDate: date2]) { //不使用intValue比较无效
            return NSOrderedDescending;//降序
        }else if (date1 == [date1 laterDate: date2]) {
            return NSOrderedAscending;//升序
        }else{
            return NSOrderedSame;//相等
        }
        
    }];
    return sortArray;
    
}//排序

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MatchListModel *model = _dataArray[section];
    return model.dataArray.count;
//    return 50;
}//section返回多少row

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_dataArray.count && _dataArray.count > section) {
        MatchListModel *model = _dataArray[section];
        return model.showTimeString;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, (30-13)/2, kScreenWidth-40, 13);
    myLabel.font = [UIFont boldSystemFontOfSize:13];
    myLabel.textColor = [UIColor colorFromHexString:@"222222"];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = The_MainColor;
    [headerView addSubview:myLabel];
    return headerView;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 30;
}

//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//
//{
//    view.tintColor = SelectedBtnColor;
//   //YourColor： view.tintColor = WTGayColor(240);
//
//}
//
//-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
//{
//    view.tintColor = SelectedBtnColor;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MatchTableViewCellIdentifier];
    
//    RatioScoreModel *model = _dataArray[indexPath.row];
//    model.indexPath = indexPath;
    if (!cell) {
        cell = [[MatchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MatchTableViewCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MatchListModel *model = _dataArray[indexPath.section];

    cell.model = model.dataArray[indexPath.row];
//    [cell teamUpdate];
//    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}//返回cell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWidth(78);
}//返回高度


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MatchListModel *model = _dataArray[indexPath.section];
    if (self.tableViewDidSelected) {
        self.tableViewDidSelected(model.dataArray[indexPath.row]);
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
