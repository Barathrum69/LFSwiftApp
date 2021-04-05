//
//  DRSearchHostCell.h
//  DragonLive
//
//  Created by 11号 on 2020/12/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LiveHosts;

@interface DRSearchHostCell : UITableViewCell

- (void)setHostModel:(LiveHosts *)hostModel;

@end

NS_ASSUME_NONNULL_END
