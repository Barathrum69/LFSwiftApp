//
//  HttpUrl.h
//  BallSaintSport
//
//  Created by 11号 on 2020/11/4.
//

#import <Foundation/Foundation.h>


//移动端-首页直播房间查询
//http://172.21.34.77:8080/doc/QsYFc8egz
//
//
//根据分类ID查询子级分类列表
//http://172.21.34.77:8080/doc/QtoTwHqm2
//
//分类ID传type就行(4=足球,5=篮球,2=电竞,3=综合)

//正式地址
//#define SeverUrlTest  @"https://www.kuailong.com/koklive"
//#define UploadingFied @"https://www.kuailong.com/koklive"


//测试  //测试环境新的
#define SeverUrlTest @"http://47.241.32.2:8090/koklive"       //   接口的服务器
#define UploadingFied @"http://47.241.61.80:8088"             //图片上传的服务器

//测试  据说服务器到期 已经给废弃
//#define SeverUrlTest @"http://47.241.16.13"      //接口的服务器
//#define UploadingFied @"http://47.241.56.74:8088" //图片上传的服务器

typedef enum : NSUInteger {
    UrlTypeHomeBanner,                  //首页广告轮播
    UrlTypeLiveList,                    //首页直播列表
    UrlTypeLiveChildrenList,            //查询直播子级分类列表
    UrlTypeLiveRoom,                    //我的直播间
    UrlTypeLivePull,                    //直播房间拉流
    UrlTypeLiveHotQuery,                //直播实时热度查询
    UrlTypeSystemNotice,                //系统公告
    UrlTypeLiveGift,                    //直播礼物道具
    UrlTypeLiveGiftReward,              //直播间礼物打赏
    UrlTypeReportRoomClass,             //举报类型
    UrlTypeReportRoom,                  //用户举报
    UrlTypeForbidUserStatus,            //查询用户是否被禁言
    UrlTypeForbidUser,                  //直播页禁言
    UrlTypeSearchSteamer,               //搜索主播
    UrlTypeSearchLive,                  //搜索直播
    UrlTypeSearchVideo,                 //搜索视频
    UrlTypeSearchHotwords,              //搜索热搜榜
    UrlTypeSearchKeywords,              //搜索关键词联想
    UrlTypeAttentionList,               //获取关注列表
    UrlTypeDoAttentionUser,             //用户关注/取关
    UrlTypeQueryAttentionUser,          //查询是否关注过
    //视频
    UrlTypeCategoryOfVideoList,         //获取视频模块分类下的列表
    UrlTypeVideoItemDetails,            //获取视频详情
    UrlTypeRecommendVideoList,          //获取推荐视频
    UrlTypeVideoDetailsCommentList,     //获取视频评论列表
    //赛事
    UrlTypeVideoGetGameTypeList,        //请求赛事足球篮球电竞的分类
    UrlTypeVideoGetMatchList,           //获取赛事列表
    //登录注册
    UrlTypeUserRegister,                //注册
    UrlTypeCommonSalt,                  //获取盐
    UrlTypeVerificationCode,            //获取验证码
    UrlTypeUserLogin,                   //登录
    UrlTypeGetAccountCoins,             //获取账户钱币
    UrlTypeStationMeesgae,              //站内信
    UrlTypeTaskList,                    //任务列表
    UrlTypeMyFocusList,                 //我的关注列表
    UrlTypeGetAnchor,                   //获取主播中心的信息
    UrlTypeGetUserInfo,                 //获取用户个人信息
    UrlTypeHostVerificationCode,        //主播认证短信发送
    UrlTypeHostApplyLive,               //认证主播
    UrlTypeUpLoadingFile,               //上传文件
    //钱包
    UrlTypeQueryPayinfo,                //钱包充值信息查询
    UrlTypeFindRecord,                  //获取账户明细的纪录
    UrlTypeRechargeOrder,               //确认充值
    UrlTypeQueryRevenueInfo,            //提现明细查询
    UrlTypeApproveRevenue,              //发起提现
    UrlTypeModifyPassword,              //修改密码
    UrlTypeModifyPhone,                 //修改手机号
    UrlTypeModifyEmail,                 //更换Email
    UrlTypeGetEmailCode,                //获取Email验证码
    UrlTypeModifyHeadImage,             //修改头像
    UrlTypeModifyName,                  //修改名字
    UrlTypeSendCommentLike,             //视频的点赞评论，
    UrlTypeDeleteComment,               //视频评论的删除，只能删除自己的评论
    UrlTypeFindPassWord,                //找回密码
    UrlTypeCompleteTask,                //完成任务
    UrlTypeBingBankCardInfo,            //绑定银行卡
    UrlTypeUpdateRoomSetting,           //房间更新设置
    UrlTypeRecivedTask,                 //领取任务
    UrlTypeGetSysparam,                 //获取分享参数值
    UrlTypeVerificationCompare,         //验证码校验
    UrlTypeGetBankCard,                 //获取银行卡
    UrlTypeGetCurrentAppVersions,       //检测版本
    UrlTypeXMPPServer,                  //xmpp服务ip获取
    UrlTypeGetRoomSetting,              //获取直播房间的设置
    UrlTypeQueryServerTime,             //获取服务器时间和传入时间差
    UTTypeGetNewsList,                  //获取新闻列表
} UrlType;


@interface HttpUrl : NSObject

+ (NSString *)getRquestUrl:(UrlType)type;

@end
