//
//  MatchItemModel.m
//  DragonLive
//
//  Created by LoaA on 2020/12/22.
//

#import "MatchItemModel.h"
#import "HostModel.h"

@implementation MatchItemModel

-(void)setStartTime:(NSString *)startTime
{
    _startTime = startTime;
    self.time = [UntilTools converTimeWithString:_startTime format:@"HH:mm"];
    self.sectionTime = [UntilTools converTimeWithString:_startTime format:@"YYYY-MM-dd"];
    
//   NSString *dateNew = [NSString stringWithFormat:@"%@%@",[UntilTools checkTheDate:dateString],dateString];
//    self.sectionTime = [NSString stringWithFormat:@"%@  %@",dateNew,[UntilTools weekdayStringFromDate:dateString]];
    
}

-(void)setRefHosts:(NSMutableArray *)refHosts{
    NSMutableArray *objArray = [NSMutableArray new];
    for (NSDictionary *obj in refHosts) {
        HostModel *model = [HostModel modelWithDictionary:obj];
        [objArray addObject:model];
    }
    _refHosts = objArray;
    
}

-(void)coverRefHosts
{
    if (_url.length != 0) {
        if (_refHosts.count != 0) {
            HostModel *model = [_refHosts lastObject];
            model.startTime = _startTime;
            model.url = _url;
            model.teamA = _teamA;
            model.teamB = _teamB;
            model.status = _status;
        }
    }
}


-(void)setLiveHosts
{
    if (_url.length != 0) {
        _liveHosts = [_refHosts mutableCopy];
        [_liveHosts removeLastObject];
    }else{
        _liveHosts = [_refHosts mutableCopy];
    }
}


@end
