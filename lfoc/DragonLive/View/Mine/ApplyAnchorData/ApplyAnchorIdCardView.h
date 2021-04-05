//
//  ApplyAnchorIdCardView.h
//  DragonLive
//
//  Created by LoaA on 2020/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ApplyAnchorIdCardView;
typedef void(^SelectedThumbBlock)(ApplyAnchorIdCardView *currentView);
typedef void(^CancelBlock)(void);
@interface ApplyAnchorIdCardView : UIView

/// 图片
@property (nonatomic, strong) UIImageView *imageView;

/// 选择过没有
@property (nonatomic, assign) BOOL isSelected;

/// 图片的Url
@property (nonatomic, strong) NSString *imageUrl;
/// 选择照片或者是
@property (nonatomic, copy) SelectedThumbBlock selectedThumbBlock;

/// 关闭按钮执行方法
@property (nonatomic, copy) CancelBlock cancelBlock;

/// 初始化
/// @param frame frame
/// @param title title
/// @param imageNamed 图片名
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title imageNamed:(NSString *)imageNamed;
@end

NS_ASSUME_NONNULL_END
