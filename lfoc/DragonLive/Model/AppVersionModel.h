//
//  AppVersionModel.h
//  DragonLive
//
//  Created by LoaA on 2021/1/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppVersionModel : NSObject

/// 更新模式：1-强更，0-非强更
@property (nonatomic, assign) long  modeType;


/// 版本号
@property (nonatomic, copy)  NSString *versions;

/// 下载连接
@property (nonatomic, copy)  NSString *goToUrl;

/// 版本描述
@property (nonatomic, copy)  NSString *descriptions;

@end

NS_ASSUME_NONNULL_END
