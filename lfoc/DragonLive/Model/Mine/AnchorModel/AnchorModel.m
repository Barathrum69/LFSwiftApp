//
//  AnchorModel.m
//  DragonLive
//
//  Created by LoaA on 2020/12/28.
//

#import "AnchorModel.h"
#import "GradleModel.h"
@implementation AnchorModel

-(void)setFansNumber:(NSString *)fansNumber
{
    
    _fansNumber = [UntilTools getDealNumwithstring:fansNumber];
}

-(void)setGradle:(NSDictionary *)gradle
{
    _gradle = gradle;
    _gradleModel = [GradleModel modelWithDictionary:_gradle];
}

-(void)setLiveBoardcastRoomNum:(NSString *)liveBoardcastRoomNum{
    if (liveBoardcastRoomNum.length != 0) {
        _liveBoardcastRoomNum = liveBoardcastRoomNum;
    }else{
        _liveBoardcastRoomNum = @"";
    }
}


@end
