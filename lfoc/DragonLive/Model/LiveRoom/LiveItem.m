//
//  LiveItem.m
//  DragonLive
//
//  Created by 11号 on 2020/11/26.
//

#import "LiveItem.h"

@implementation LiveItem

-(void)setHot:(NSString *)hot
{
    _hot = [UntilTools getDealNumwithstring:hot];
}
@end
