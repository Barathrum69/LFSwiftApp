//
//  RoomInfo.m
//  DragonLive
//
//  Created by 11号 on 2020/12/2.
//

#import "RoomInfo.h"

@implementation RoomInfo

-(void)setHot:(NSString *)hot
{
    _hot = hot ? [UntilTools getDealNumwithstring:hot] : @"0";
}

- (void)setRoomId:(NSString *)roomId
{
    _roomId = roomId ? roomId : @"";
}

- (void)setHostFansNum:(NSString *)hostFansNum
{
    _hostFansNum = hostFansNum ? [UntilTools getDealNumwithstring:hostFansNum] : @"0";
}

@end
