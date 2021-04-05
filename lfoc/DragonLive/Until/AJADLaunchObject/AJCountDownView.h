//
//  AJCountDownView.h
//  AJADLaunchObject
//
//  Created by Jame on 19/6/16.
//  Copyright © 2019年 Jame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AJCountDownView : UIView
@property (nonatomic, strong) void(^countFinished)(void);
-(void)showWithTime:(NSInteger)time;
-(void)end;


@end
