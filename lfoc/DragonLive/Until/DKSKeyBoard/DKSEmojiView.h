//
//  DKSEmojiView.h
//  DKSChatKeyboard
//
//  Created by aDu on 2018/1/4.
//  Copyright © 2018年 DuKaiShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DREmojiViewDelegate <NSObject>

@optional //非必实现的方法

/// 表情分类切换事件
- (void)typeEmoji;

/// 选择表情
/// @param emojiStr 表情字符串，例如：[1]
- (void)selectEmoji:(NSString *)emojiStr;

/// 发送表情
- (void)sendEmoji;

@end

@interface DKSEmojiView : UIView

@property (nonatomic, weak) id<DREmojiViewDelegate> delegate;

@end
