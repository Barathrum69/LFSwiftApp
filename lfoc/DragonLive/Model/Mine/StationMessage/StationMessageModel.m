//
//  StationMessageModel.m
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import "StationMessageModel.h"

@implementation StationMessageModel

-(void)setContent:(NSString *)content{
    _content = content;
//    _msgSize = [userMsg boundingRectWithSize:CGSizeMake(kScreenWidth-kWidth(21+77), 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kWidth(12)]} context:nil].size;
    _msgSize = [UntilTools boundingALLRectWithSize:_content Font:[UIFont systemFontOfSize:kWidth(12)] Size:CGSizeMake(kScreenWidth-kWidth(35+40), 9990)];
    //为什么是 设置当为40的时候 改变高度，主要是头像的高度为40，label小于头像的高度的时候 也为40
    if (_msgSize.height > kWidth(15)) {
        _shouldShowOpenBtn = YES;
    }else{
        _shouldShowOpenBtn = NO;
    }
    _isOpen = NO;
}
-(CGSize)msgSize{
    if (_content) {
        
    }else{
        _content = @"";
    }
    _msgSize = [_content boundingRectWithSize:CGSizeMake(kScreenWidth-kWidth(35+40), 999) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kWidth(12)]} context:nil].size;
    return _msgSize;
}

-(void)setSendTime:(NSString *)sendTime{
    _sendTime = [UntilTools converTimeWithString:sendTime format:@"YYYY/MM/dd"];
}


@end
