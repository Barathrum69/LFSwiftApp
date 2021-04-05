//
//  SettingItemModel.h
//  BallSaintSport
//
//  Created by LoaA on 2020/11/6.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface SettingItemModel : NSObject<NSCopying,NSMutableCopying>

@property (nonatomic,copy) NSString *placeholderText;

@property (nonatomic,assign) BOOL isOn;

/// 字数限制
@property (nonatomic, assign) NSInteger count;

/// cell的类型 主要是为了提交数据的时候用
@property (nonatomic, assign) SettingItemType settingItemType;

///    功能名称
@property (nonatomic,copy) NSString  *funcName;

//// 功能图片
@property (nonatomic,strong) UIImage *img;

/// 标题颜色
@property (nonatomic,strong) UIColor *titleColor;

/// 描述颜色
@property (nonatomic,strong) UIColor *detailColor;

///更多信息-提示文字
@property (nonatomic,copy) NSString *detailText;

/// 更多信息-提示图片
@property (nonatomic,strong) UIImage *detailImage;

/// accessory
@property (nonatomic,assign) SettingAccessoryType  accessoryType;
////    点击item要执行的代码
@property (nonatomic,copy) void (^executeCode)(SettingItemModel *model);

///  SettingAccessoryTypeSwitch下开关变化
@property (nonatomic,copy) void (^switchValueChanged)(BOOL isOn);

@end
