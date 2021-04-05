//
//  UserModel.h
//  BallSaintSport
//
//  Created by LoaA on 2020/11/12.
//

#import <Foundation/Foundation.h>


@interface UserModel : NSObject


/// userId
@property (nonatomic, copy) NSString *userId;

/// 电话号码
@property (nonatomic, copy) NSString *phoneNum;

/// 账号
@property (nonatomic, copy) NSString *userName;

/// 国家区号
@property (nonatomic, copy) NSString *phoneCountryCode;

/// 用户昵称
@property (nonatomic, copy) NSString *nickname;

/// email
@property (nonatomic, copy) NSString *email;

/// 用户类型 ：0 - 超级管理员,1 - 普通用户,2 - 主播,3 - 房管(此处暂时取消), 4 - 平台运营人员'
@property (nonatomic, copy) NSString *userType;

/// 用户在直播间的角色类型 ：1 - 主播或者房管,2 - 普通用户
@property (nonatomic, copy) NSString *userRoomRole;

/// 禁止雷速聊天内容展示
@property (nonatomic, assign) BOOL isLeisuJinyan;

/// 用户状态（0 - 正常,1 - 禁用,2 - 冻结,3 - 锁定,4 - 禁播,5 - 删除）
@property (nonatomic, copy) NSString *userStatus;

/// 用户头像url
@property (nonatomic, copy) NSString *headicon;

/// 用户等级类型：11 - 消费等级,21 - 用户等级,31 - 主播等级
@property (nonatomic, copy) NSString *gradleType;

/// 当前用户等级数
@property (nonatomic, copy) NSString *currentGradle;

/// 当前经验
@property (nonatomic, copy) NSString *currentExperience;

/// 当前等级图标
@property (nonatomic, copy) NSString *currentGradleImg;

/// 当前用户下一等级数
@property (nonatomic, copy) NSString *nextGradle;

/// 下一经验最低值
@property (nonatomic, copy) NSString *nextExperienceMin;

/// 下一等级图标
@property (nonatomic, copy) NSString *nextGradleImg;

/// 上一次申请结果：0 - 审核中,1 - 审核通过,2 - 审核不通过（若是没有申请过则此处为null）
@property (nonatomic, copy) NSString *hostApplyResult;

/// 钱币
@property (nonatomic, copy) NSString *coins;

/// 银行卡卡号
@property (nonatomic, copy) NSString *bankCard;

/// 开户行
@property (nonatomic, copy) NSString *bank;

/// 省份
@property (nonatomic, copy) NSString *province;

/// 城市
@property (nonatomic, copy) NSString *city;


/// 卡的类型
@property (nonatomic, copy) NSString *subbranch;

/// 银行绑定的卡
@property (nonatomic, copy) NSString *bankPhone;

/// 银行的id
@property (nonatomic, copy) NSString *bankId;

/// 富文本钱币
@property (nonatomic, strong) NSMutableAttributedString *coinsAtt;

/// 真实姓名
@property (nonatomic, copy) NSString *realName;

@end

