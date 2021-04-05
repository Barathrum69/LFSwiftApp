//
//  LiveChatSystemCell.m
//  DragonLive
//
//  Created by 11号 on 2020/12/29.
//

#import "LiveChatSystemCell.h"
#import "RoomChat.h"

@interface LiveChatSystemCell ()

@property (nonatomic, weak) IBOutlet UILabel *chatLab;                      

@end

@implementation LiveChatSystemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRoomChat:(RoomChat *)chatModel
{
    self.chatLab.attributedText = [chatModel getContentAttri];
}


@end
