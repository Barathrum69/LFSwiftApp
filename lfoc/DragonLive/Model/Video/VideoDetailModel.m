//
//  VideoDetailModel.m
//  DragonLive
//
//  Created by LoaA on 2020/12/21.
//

#import "VideoDetailModel.h"

@implementation VideoDetailModel

-(void)setFansNumberOfCurUser:(NSString *)fansNumberOfCurUser{
    _fansNumberOfCurUser = [UntilTools getDealNumwithstring:fansNumberOfCurUser];
}//粉丝数

-(void)setLikeNumberOfCurVideo:(NSString *)likeNumberOfCurVideo{
    _likeNumberOfCurVideo = [UntilTools getDealNumwithstring:likeNumberOfCurVideo];
}//点赞数

-(void)setCommentNumberOfCurVideo:(NSString *)commentNumberOfCurVideo{
    _commentNumberOfCurVideo = [UntilTools getDealNumwithstring:commentNumberOfCurVideo];
}//评论数

-(void)setShareNumberOfCurVideo:(NSString *)shareNumberOfCurVideo
{
    _shareNumberOfCurVideo = [UntilTools getDealNumwithstring:shareNumberOfCurVideo];

}

@end
