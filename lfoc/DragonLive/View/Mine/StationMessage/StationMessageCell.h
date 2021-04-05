//
//  StationMessageCell.h
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import <UIKit/UIKit.h>
typedef void(^RefreshBlock)(id model,NSInteger rowNum,NSInteger sectionNum);


@interface StationMessageCell : UITableViewCell


@property (nonatomic,strong) id model;

@property (nonatomic,copy) RefreshBlock refreshBlock;

-(void)doRefreshModel:(RefreshBlock)refreshBlock;


@end

