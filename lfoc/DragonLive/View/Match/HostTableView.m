//
//  HostTableView.m
//  DragonLive
//
//  Created by LoaA on 2021/1/26.
//

#import "HostTableView.h"
#import "HostTableViewCell.h"
static NSString *HostTableViewCellIdentifier = @"HostTableViewCellID";

@implementation HostTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
                [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            }
        [self setSeparatorColor:[UIColor colorFromHexString:@"EEEEEE"]];
        
        self.dataSource = self;
        self.delegate   = self;
//        self.layer.cornerRadius = 10;
//        self.clipsToBounds = YES;
        self.tableFooterView = [UIView new];
//        self.separatorStyle = UITableViewCellSelectionStyleNone;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

////        self.clipsToBounds = NO;
//        [self registerClass:[FootBallTableViewCell class] forCellReuseIdentifier:FootBallTableViewCellIdentifier];
        [self registerNib:[UINib nibWithNibName:@"HostTableViewCell" bundle:nil] forCellReuseIdentifier:HostTableViewCellIdentifier];

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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
//    return 50;
}//section返回多少row

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HostTableViewCellIdentifier];
    
//    RatioScoreModel *model = _dataArray[indexPath.row];
//    model.indexPath = indexPath;
    if (!cell) {
        cell = [[HostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HostTableViewCellIdentifier];
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
    return kWidth(64);
}//返回高度


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MatchListModel *model = _dataArray[indexPath.section];
    if (self.tableViewDidSelected) {
        self.tableViewDidSelected(_dataArray[indexPath.row]);
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
