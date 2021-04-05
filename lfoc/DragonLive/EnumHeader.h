//
//  111.h
//  DragonLive
//
//  Created by LoaA on 2020/12/8.
//
#ifndef EnumHeader_h
#define EnumHeader_h
//个人中心的cell的样式
typedef NS_ENUM(NSInteger, SettingAccessoryType) {
    SettingAccessoryTypeNone,                   // 啥都没有的
    SettingAccessoryTypeDisclosureIndicator,    // 箭头
    SettingAccessoryTypeSwitch,                 //  选择器
    SettingAccessoryTypeTextFeild,              // 带有输入框
    SettingAccessoryTypeLogout                  // 退出
    
};

//个人资料的类型枚举
typedef NS_ENUM(NSInteger, SettingItemType) {
    SettingItemTypeHeadImage,                   // 头像
    SettingItemTypeNickName,                    // 姓名
    SettingItemTypeAge,                         // 年龄
    SettingItemTypeGender,                      // 性别
    SettingItemTypeSign                         // 签名
};

//充值的类型枚举
typedef NS_ENUM(NSInteger, RechargeStyleType) {
    RechargeStyleTypeNormal,//普通样式
    RechargeStyleTypeTextField,//输入框的
};
typedef NS_ENUM(NSInteger, VideoListType) {
    VideoListTypePopular,       //热门
    VideoListTypeFootBall,      //足球
    VideoListTypeBasketBall,    //篮球
    VideoListTypeGaming,        //电竞
    VideoListTypeComprehensive, //综合
};

typedef NS_ENUM(NSInteger, NewsListType) {
    NewsListTypeAll,                 //全部
    NewsListTypeNews,                //新闻
    NewsListTypeActivity,            //活动
    NewsListTypeAnnouncement,        //公告
};

#endif /* EnumHeader_h */
