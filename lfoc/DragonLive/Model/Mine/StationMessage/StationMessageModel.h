//
//  StationMessageModel.h
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StationMessageModel : NSObject

@property (nonatomic,strong) NSString *content;

@property (nonatomic,strong) NSString *sendTime;

@property (nonatomic, copy) NSString *title;

@property (nonatomic,assign) CGSize msgSize;

@property (nonatomic,assign) BOOL shouldShowOpenBtn;

@property (nonatomic,assign) BOOL isOpen;
@end

NS_ASSUME_NONNULL_END
