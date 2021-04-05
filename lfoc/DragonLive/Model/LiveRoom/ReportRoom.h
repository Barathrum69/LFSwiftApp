//
//  ReportRoom.h
//  DragonLive
//
//  Created by 11号 on 2020/12/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 直播间举报模型
@interface ReportRoom : NSObject

/// 类型id
@property (nonatomic, copy) NSString *tofsId;

/// 类型名
@property (nonatomic, copy) NSString *name;

/// 是否选中
@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
