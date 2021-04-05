//
//  HttpUrl.m
//  BallSaintSport
//
//  Created by 11号 on 2020/11/4.
//

#import "HttpUrl.h"

@implementation HttpUrl

+ (NSString *)getRquestUrl:(UrlType)type
{
    NSString *urlStr = @"";
    switch (type) {
        case UrlTypeHomeBanner:
            urlStr = [NSString stringWithFormat:@"%@/content/f/image/carousel.api",SeverUrlTest];
            break;
        case UrlTypeLiveList:
            urlStr = [NSString stringWithFormat:@"%@/live/f/room/m/page.api",SeverUrlTest];
            break;
        case UrlTypeLiveChildrenList:
            urlStr = [NSString stringWithFormat:@"%@/live/f/category/id/children.api",SeverUrlTest];
            break;
        case UrlTypeLiveRoom:
            urlStr = [NSString stringWithFormat:@"%@/live/f/live/enter-room.api",SeverUrlTest];
            break;
        case UrlTypeLivePull:
            urlStr = [NSString stringWithFormat:@"%@/live/f/room/pull-url.api",SeverUrlTest];
            break;
        case UrlTypeLiveHotQuery:
            urlStr = [NSString stringWithFormat:@"%@/live/f/live/query-live-instant-hot.api",SeverUrlTest];
            break;
        case UrlTypeSystemNotice:
            urlStr = [NSString stringWithFormat:@"%@/live/f/roomNotice/query-system-notice.api",SeverUrlTest];
            break;
        case UrlTypeLiveGift:
            urlStr = [NSString stringWithFormat:@"%@/live/f/gift/get-props.api",SeverUrlTest];
            break;
        case UrlTypeLiveGiftReward:
            urlStr = [NSString stringWithFormat:@"%@/mall/f/account-flow/reward-anchor.api",SeverUrlTest];
            break;
        case UrlTypeReportRoomClass:
            urlStr = [NSString stringWithFormat:@"%@/live/f/tifoffSetting/simple-list.api",SeverUrlTest];
            break;
        case UrlTypeReportRoom:
            urlStr = [NSString stringWithFormat:@"%@/live/f/tipoff/apply-tipoff.api",SeverUrlTest];
            break;
        case UrlTypeForbidUserStatus:
            urlStr = [NSString stringWithFormat:@"%@/live/f/manager/forbid-user-status.api",SeverUrlTest];
            break;
        case UrlTypeForbidUser:
            urlStr = [NSString stringWithFormat:@"%@/live/f/manager/forbid-user.api",SeverUrlTest];
            break;
        case UrlTypeSearchSteamer:
            urlStr = [NSString stringWithFormat:@"%@/search/f/search-for-hosts.api",SeverUrlTest];
            break;
        case UrlTypeSearchLive:
            urlStr = [NSString stringWithFormat:@"%@/search/f/search-for-lives.api",SeverUrlTest];
            break;
        case UrlTypeSearchVideo:
            urlStr = [NSString stringWithFormat:@"%@/search/f/search-for-videos.api",SeverUrlTest];
            break;
        case UrlTypeSearchHotwords:
            urlStr = [NSString stringWithFormat:@"%@/search/f/get-day-rank.api",SeverUrlTest];
            break;
        case UrlTypeSearchKeywords:
            urlStr = [NSString stringWithFormat:@"%@/search/f/search-for-words.api",SeverUrlTest];
            break;
        case UrlTypeAttentionList:
            urlStr = [NSString stringWithFormat:@"%@/user/f/attention/queryAttentionList.api",SeverUrlTest];
            break;
        case UrlTypeDoAttentionUser:
            urlStr = [NSString stringWithFormat:@"%@/user/f/attention/do-attention-user.api",SeverUrlTest];
            break;
        case UrlTypeQueryAttentionUser:
            urlStr = [NSString stringWithFormat:@"%@/user/f/attention/queryAttention.api",SeverUrlTest];
            break;
        case UrlTypeCategoryOfVideoList:         //获取视频模块分类下的列表
            urlStr = [NSString stringWithFormat:@"%@/live/f/videos/query-video-list.api",SeverUrlTest];
            break;
        case UrlTypeVideoItemDetails:            //获取视频详情
            urlStr = [NSString stringWithFormat:@"%@/live/f/videos/find-video-by-video-id.api",SeverUrlTest];
            break;
        case UrlTypeRecommendVideoList:          //获取推荐列表
            urlStr = [NSString stringWithFormat:@"%@/live/f/videos/find-about-or-hot-video-list.api",SeverUrlTest];
            break;
        case UrlTypeVideoDetailsCommentList:     //获取视频评论列表
            urlStr = [NSString stringWithFormat:@"%@/live/f/comments/find-comment.api",SeverUrlTest];
            break;
        case UrlTypeVideoGetGameTypeList:        //请求赛事足球篮球电竞的分类
            urlStr = [NSString stringWithFormat:@"%@/live/f/category/id/children.api",SeverUrlTest];
            break;
        case UrlTypeVideoGetMatchList:          //获取赛事列表
            urlStr = [NSString stringWithFormat:@"%@/live/f/match/m/list.api",SeverUrlTest];
            break;
        case UrlTypeUserRegister:               //注册
            urlStr = [NSString stringWithFormat:@"%@/user/f/register-mobile.api",SeverUrlTest];
            break;
        case UrlTypeCommonSalt:                 //获取盐
            urlStr = [NSString stringWithFormat:@"%@/user/common/f/get-salt-str.api",SeverUrlTest];
            break;
        case UrlTypeVerificationCode:           //获取验证码
            urlStr = [NSString stringWithFormat:@"%@/user/sms/f/send-login-sms.api",SeverUrlTest];
            break;
        case UrlTypeUserLogin:                  //登录
            urlStr = [NSString stringWithFormat:@"%@/user/login/f/login-mobile.api",SeverUrlTest];
            break;
        case UrlTypeGetAccountCoins:            //获取账户钱币
            urlStr = [NSString stringWithFormat:@"%@/mall/f/account-flow/get-coin-balance-by-user-id.api",SeverUrlTest];
            break;
        case UrlTypeStationMeesgae:             //站内信
            urlStr = [NSString stringWithFormat:@"%@/user/f/sitemessage/all",SeverUrlTest];
            break;
        case UrlTypeTaskList:                   //任务列表
            urlStr = [NSString stringWithFormat:@"%@/task/f/task/query_task_details.api",SeverUrlTest];
            break;
        case UrlTypeMyFocusList:                //我的关注列表
            urlStr = [NSString stringWithFormat:@"%@/user/f/attention/queryAttentionList.api",SeverUrlTest];
            break;
        case UrlTypeGetAnchor:                  //获取主播中心的信息
            urlStr = [NSString stringWithFormat:@"%@/user/f/get-anchor.api",SeverUrlTest];
            break;
        case UrlTypeGetUserInfo:                //获取用户个人信息
            urlStr = [NSString stringWithFormat:@"%@/user/f/get-user-info-mobile.api",SeverUrlTest];
            break;
        case UrlTypeHostVerificationCode:       //主播认证短信发送
            urlStr = [NSString stringWithFormat:@"%@/user/f/sms/host-apply-live.api",SeverUrlTest];
            break;
        case UrlTypeHostApplyLive:              //认证主播
            urlStr = [NSString stringWithFormat:@"%@/user/f/update/host-apply-live.api",SeverUrlTest];
            break;
        case UrlTypeUpLoadingFile:              //上传文件 base 64
            urlStr = [NSString stringWithFormat:@"%@/upload/f/upload-image-base64.api",UploadingFied];
            break;
        case UrlTypeQueryPayinfo:               //钱包充值信息查询
            urlStr = [NSString stringWithFormat:@"%@/mall/f/personal/query-pay-info.api",SeverUrlTest];
            break;
        case UrlTypeFindRecord:                 //获取账户明细的纪录
            urlStr = [NSString stringWithFormat:@"%@/mall/f/account-flow/find-api-record-list.api",SeverUrlTest];
            break;
        case UrlTypeRechargeOrder:              //确认充值
            urlStr = [NSString stringWithFormat:@"%@/mall/f/pay/order.api",SeverUrlTest];
            break;
        case UrlTypeQueryRevenueInfo:           //提现明细查询
            urlStr = [NSString stringWithFormat:@"%@/mall/f/settle/query-revenue.api",SeverUrlTest];
            break;
        case UrlTypeApproveRevenue:             //发起提现
            urlStr = [NSString stringWithFormat:@"%@/mall/f/settle/approve-revenue.api",SeverUrlTest];
            break;
        case UrlTypeModifyPassword:             //修改密码
            urlStr = [NSString stringWithFormat:@"%@/user/f/update-pwd.api",SeverUrlTest];
            break;
        case UrlTypeModifyPhone:                //修改手机号
            urlStr = [NSString stringWithFormat:@"%@/user/f/bind-phone.api",SeverUrlTest];
            break;
        case UrlTypeModifyEmail:                //修改邮箱
            urlStr = [NSString stringWithFormat:@"%@/user/f/bind-email.api",SeverUrlTest];
            break;
        case UrlTypeGetEmailCode:               //获取邮箱验证码
            urlStr = [NSString stringWithFormat:@"%@/user/email/f/send-login-email.api",SeverUrlTest];
            break;
        case UrlTypeModifyHeadImage:            //修改头像
            urlStr = [NSString stringWithFormat:@"%@/user/f/update-head-pic.api",SeverUrlTest];
            break;
        case UrlTypeModifyName:                 //修改昵称
            urlStr = [NSString stringWithFormat:@"%@/user/f/update-nickname.api",SeverUrlTest];
            break;
        case UrlTypeSendCommentLike:            //视频的点赞评论，
            urlStr = [NSString stringWithFormat:@"%@/live/f/comments/post-comment.api",SeverUrlTest];
            break;
        case UrlTypeDeleteComment:              //删除评论
            urlStr = [NSString stringWithFormat:@"%@/live/f/comments/delete-comment-of-cur-user.api",SeverUrlTest];
            break;
        case UrlTypeFindPassWord:               //找回密码
            urlStr = [NSString stringWithFormat:@"%@/user/f/update-pwd-by-find.api",SeverUrlTest];
            break;
        case UrlTypeCompleteTask:               //完成任务
            urlStr = [NSString stringWithFormat:@"%@/task/f/task/complete-task.api",SeverUrlTest];
            break;
        case UrlTypeBingBankCardInfo:           //绑定银行卡
            urlStr = [NSString stringWithFormat:@"%@/mall/f/bank-card/bind.api",SeverUrlTest];
            break;
        case UrlTypeUpdateRoomSetting:          //房间更新设置
            urlStr = [NSString stringWithFormat:@"%@/live/f/room/update-room-setting.api",SeverUrlTest];
            break;
        case UrlTypeRecivedTask:                //领取任务
            urlStr = [NSString stringWithFormat:@"%@/task/f/task/receive_task_rewards.api",SeverUrlTest];
            break;
        case UrlTypeGetSysparam:                //获取分享参数值
            urlStr = [NSString stringWithFormat:@"%@/user/f/param/get-sysparam.api",SeverUrlTest];
            break;
        case UrlTypeVerificationCompare:        //验证码校验
            urlStr = [NSString stringWithFormat:@"%@/user/f/verification-code-compare.api",SeverUrlTest];
            break;
        case UrlTypeGetBankCard:                //获取银行卡
            urlStr = [NSString stringWithFormat:@"%@/mall/f/bank-card/card.api",SeverUrlTest];
            break;
        case UrlTypeGetCurrentAppVersions:      //获取最新版本
            urlStr = [NSString stringWithFormat:@"%@/user/f/app-versions/query/get-current-app-versions.api",SeverUrlTest];
            break;
        case UrlTypeXMPPServer:                 //xmpp服务ip获取
            urlStr = [NSString stringWithFormat:@"%@/live/f/protocol/query-last-protocol.api",SeverUrlTest];
            break;
        case UrlTypeGetRoomSetting:             //获取直播房间的设置
            urlStr = [NSString stringWithFormat:@"%@/live/f/live/setting-record.api",SeverUrlTest];
            break;
        case UrlTypeQueryServerTime:             //获取服务器时间和传入时间差
            urlStr = [NSString stringWithFormat:@"%@/live/f/common/query-server-time.api",SeverUrlTest];
            break;
        case UTTypeGetNewsList:                 //获取新闻列表
            urlStr = [NSString stringWithFormat:@"%@/content/f/article/list.api",SeverUrlTest];
            break;
        default:
            break;
    }
    return urlStr;
}

@end
