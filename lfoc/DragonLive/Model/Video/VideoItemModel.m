//
//  VideoItemModel.m
//  DragonLive
//
//  Created by LoaA on 2020/12/19.
//

#import "VideoItemModel.h"

@implementation VideoItemModel
//播放量
-(void)setPlayNum:(NSString *)playNum{
    _playNum = [UntilTools getDealNumwithstring:playNum];
}
//评论量
-(void)setCommentNumberOfCurVideo:(NSString *)commentNumberOfCurVideo{
    _commentNumberOfCurVideo = [UntilTools getDealNumwithstring:commentNumberOfCurVideo];
}
//转换时长
-(void)setVideoDuration:(NSString *)videoDuration{
    _videoDuration = [UntilTools getMMSSFromSS:videoDuration];
}

@end
