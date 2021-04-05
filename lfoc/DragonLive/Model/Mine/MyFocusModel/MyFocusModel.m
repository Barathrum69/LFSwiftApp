//
//  MyFocusModel.m
//  DragonLive
//
//  Created by LoaA on 2020/12/26.
//

#import "MyFocusModel.h"

@implementation MyFocusModel

-(void)setFansNum:(NSString *)fansNum
{
    _fansNum = [NSString stringWithFormat:@"粉丝数 : %@",[UntilTools getDealNumwithstring:fansNum]];
}


@end
