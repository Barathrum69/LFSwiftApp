//
//  NewsModel.m
//  DragonLive
//
//  Created by LoaA on 2021/2/19.
//

#import "NewsModel.h"

@implementation NewsModel
-(instancetype)initWithType:(NewsListType)type dataArray:(NSMutableArray *)dataArray
{
    self = [super init];
    if (self) {
        _type = type;
        _dataArray = dataArray;
    }
    return self;
}
@end
