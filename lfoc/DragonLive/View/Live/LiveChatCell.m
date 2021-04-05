//
//  LiveChatCell.m
//  DragonLive
//
//  Created by 11号 on 2020/12/7.
//

#import "LiveChatCell.h"
#import "RoomChat.h"

@interface LiveChatCell ()

@property (nonatomic, weak) IBOutlet UIImageView *levelImgView;             //等级
@property (nonatomic, weak) IBOutlet UILabel *nameLab;                      //用户昵称
@property (nonatomic, weak) IBOutlet UILabel *chatLab;                      //聊天内容
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *userNameW;         //用户名宽

@end

@implementation LiveChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRoomChat:(RoomChat *)chatModel
{
//    if (chatModel.userLevel.length && chatModel.userLevel.integerValue >= 0) {
//        self.levelImgView.image = [UIImage imageNamed:[self getImgNameWithLevel:chatModel.userLevel]];
//    }else {
//        self.levelImgView.image = nil;
//    }
    self.chatLab.attributedText = chatModel.contentAtt;
    
}

- (NSString *)getImgNameWithLevel:(NSString *)level
{
    NSString *imgName = [NSString stringWithFormat:@"mine_lev_%ld",(long)[level integerValue]];

    return imgName;
}

@end
