//
//  VideoModel.m
//  DragonLive
//
//  Created by LoaA on 2020/12/19.
//

#import "VideoModel.h"

@implementation VideoModel

-(instancetype)initWithType:(VideoListType)type dataArray:(NSMutableArray *)dataArray
{
    self = [super init];
    if (self) {
        _type = type;
        _dataArray = dataArray;
    }
    return self;
}

@end
