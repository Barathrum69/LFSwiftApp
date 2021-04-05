//
//  TaskModel.m
//  DragonLive
//
//  Created by LoaA on 2020/12/25.
//

#import "TaskModel.h"

@implementation TaskModel

-(void)setExperience:(NSString *)experience
{
    _experience = [NSString stringWithFormat:@"奖励:EXP%@",experience];
}

@end
