//
//  TypeAlert.h
//  Alerts
//
//  Created by 王明 on 2019/10/29.
//  Copyright © 2019 王明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^SelectRowBlcok)(NSString *title,NSInteger index);

@interface TypeMenu : UIView

@property (nonatomic,strong)NSArray *dataArray;

@property (nonatomic,copy)SelectRowBlcok selectRowBlcok;

- (void)showMenu;
- (void)hiddenMenu;

+ (TypeMenu *)createMenuWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray;

@end

NS_ASSUME_NONNULL_END
