//
//  DRStreamerAllCell.h
//  DragonLive
//
//  Created by 11号 on 2020/12/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LiveHosts;

@interface DRStreamerAllCell : UICollectionViewCell

- (void)setLiveHosts:(LiveHosts *)hostsModel;

- (void)setLiveHosts:(LiveHosts *)hostsModel searchKey:(NSString *)searchKey;

@end

NS_ASSUME_NONNULL_END
