//
//  UserInstance.m
//  BallSaintSport
//
//  Created by LoaA on 2020/11/12.
//

#import "UserInstance.h"
static UserInstance *_instance;

@implementation UserInstance


+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
       dispatch_once(&onceToken, ^{
       if(_instance == nil)
           _instance = [[UserInstance alloc] init];
      });
       return _instance;
}


-(BOOL)isLogin{
    if (self.userId.length == 0) {
        return NO;
    }else{
        return YES;
    }
}

@end
