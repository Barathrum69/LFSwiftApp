//
//  UserModel.m
//  BallSaintSport
//
//  Created by LoaA on 2020/11/12.
//

#import "UserModel.h"

@implementation UserModel

- (UIImage *)stringToImage:(NSString *)str {
    
    NSData * imageData =[[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    UIImage *photo = [UIImage imageWithData:imageData ];
    
    return photo;
}

-(void)setCoins:(NSString *)coins{
    _coins = coins;
    self.coinsAtt = [self setCionsAttWithCion:coins];
}


-(NSMutableAttributedString *)setCionsAttWithCion:(NSString *)coins{
    NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@龙币",coins]];
    // 2.添加表情图片
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        // 表情图片
        attch.image = [UIImage imageNamed:@"mine_icon_money"];
        
//        attch.image = [UIImage imageNamed:@"football.gif"];
        // 设置图片大小
        attch.bounds = CGRectMake(0, kWidth(-3), kWidth(16), kWidth(16));

        // 创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attri insertAttributedString:string atIndex:0];// 插入某个位置
    return attri;
}

-(void)setHostApplyResult:(NSString *)hostApplyResult{
    if (hostApplyResult.length != 0) {
        _hostApplyResult = hostApplyResult;
    }else{
        _hostApplyResult = @"-1";
    }
}

@end
