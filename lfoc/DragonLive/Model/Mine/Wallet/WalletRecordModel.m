//
//  WalletRecordModel.m
//  DragonLive
//
//  Created by LoaA on 2020/12/31.
//

#import "WalletRecordModel.h"

@implementation WalletRecordModel


-(void)setBtype:(NSString *)btype{
    if ([btype isEqualToString:@"1"]) {
        _btype = @"充值入账";
    }else if ([btype isEqualToString:@"2"]) {
        _btype = @"提现出账";
    }else if ([btype isEqualToString:@"3"]) {
        _btype = @"冻结";
    }else if ([btype isEqualToString:@"4"]) {
        _btype = @"解冻";
    }else if ([btype isEqualToString:@"5"]) {
        _btype = @"礼物支出";
    }else if ([btype isEqualToString:@"6"]) {
        _btype = @"礼物收入";
    }else if ([btype isEqualToString:@"7"]) {
        _btype = @"任务收入";
    }
}

-(void)dealData{
    _rowArray = [[NSMutableArray alloc]initWithObjects:_happenTime,_btype,_coinNum,_availableCoins, nil];
}

@end
