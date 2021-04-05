//
//  VideoCommentModel.m
//  DragonLive
//
//  Created by LoaA on 2020/12/21.
//

#import "VideoCommentModel.h"

@implementation VideoCommentModel

-(void)setContent:(NSString *)content
{
    _content = content;
    CGSize size = [UntilTools boundingALLRectWithSize:_content Font:[UIFont systemFontOfSize:kWidth(15)] Size:CGSizeMake(kScreenWidth - kWidth(68), 999999)];
    self.messageHeight = size.height;
    self.cellHeight = size.height+kWidth(82);
    
}//根据内容去算cell的高

@end
