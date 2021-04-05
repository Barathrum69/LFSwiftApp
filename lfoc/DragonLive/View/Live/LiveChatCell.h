//
//  LiveChatCell.h
//  DragonLive
//
//  Created by 11号 on 2020/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RoomChat;

@interface LiveChatCell : UITableViewCell

- (void)setRoomChat:(RoomChat *)chatModel;

@end

NS_ASSUME_NONNULL_END
