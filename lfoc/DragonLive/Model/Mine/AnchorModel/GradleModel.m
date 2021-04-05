//
//  GradleModel.m
//  DragonLive
//
//  Created by LoaA on 2020/12/28.
//

#import "GradleModel.h"
#import "GradleSettingsModel.h"
@implementation GradleModel

-(void)setGradleSettings:(NSDictionary *)gradleSettings
{
    _gradleSettings = gradleSettings;
    _gradleSettingsModel = [GradleSettingsModel modelWithDictionary:gradleSettings];
}

@end
