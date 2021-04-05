//
//  HostModel.m
//  DragonLive
//
//  Created by LoaA on 2021/1/26.
//

#import "HostModel.h"

@implementation HostModel


-(void)setHot:(NSString *)hot
{
    _hot = [UntilTools getDealNumwithstring:hot];
    self.hotAtt = [UntilTools attHostFans:_hot];
}

@end
