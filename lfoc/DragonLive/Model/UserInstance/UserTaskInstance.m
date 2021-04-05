//
//  UserTaskInstance.m
//  DragonLive
//
//  Created by 11号 on 2021/1/11.
//

#import "UserTaskInstance.h"

@implementation UserTaskInstance

+(instancetype)shareInstance{
    static UserTaskInstance *instance =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    if(instance == nil)
       instance = [[UserTaskInstance alloc] init];
    });
    return instance;
}

@end
