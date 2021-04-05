//
//  RoomChat.m
//  DragonLive
//
//  Created by 11号 on 2020/12/7.
//

#import "RoomChat.h"

@implementation RoomChat

- (CGFloat)getStrHeight:(NSMutableAttributedString *)str
{
    CGFloat maxW = kkScreenWidth - 25.0;        //最大宽
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(maxW, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    return size.height+2;
}

- (NSMutableAttributedString *)getContentAttri
{
    NSMutableAttributedString *contentAttri;
    
    if (_userName.length && [_userName rangeOfString:@"系统消息"].location != NSNotFound) {
        contentAttri = [self getAttriWithSystemNotice];
    }else {
        contentAttri = [self getAttributedString];
    }
    self.contentHeight = [self getStrHeight:contentAttri];
    
    return contentAttri;
}

//系统消息富文本处理
- (NSMutableAttributedString *)getAttriWithSystemNotice
{
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] init];

    //图标
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"player_note"];
    //使图片大小与文字大小相同
    attachment.bounds = CGRectMake(0, -3, 19, 15);
    //将附件对象包装成一个属性文字
    NSAttributedString *iconAttri = [NSAttributedString attributedStringWithAttachment:attachment];
    [attri appendAttributedString:iconAttri];
    [attri insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:1];
    
    NSAttributedString *userNameAttri = [[NSAttributedString alloc] initWithString:_userName?:@""];
    [attri appendAttributedString:userNameAttri];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"#8595BD"] range:[attri.string rangeOfString:_userName]];
    
    NSAttributedString *contentAttri = [[NSAttributedString alloc] initWithString:_userChat?:@""];
    [attri appendAttributedString:contentAttri];
    
    // 段落
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = 2;         // 首行缩进
    paragraphStyle.headIndent = 0;                 // 其它行缩进
    paragraphStyle.lineSpacing = 5;                // 行间距
    [attri addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attri.length)];// 段落
    [attri addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSKernAttributeName:@(0)} range:NSMakeRange(0, attri.length)];
    
    return attri;
}

//聊天消息富文本处理
- (NSMutableAttributedString *)getAttributedString
{
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] init];
    
    if (_userLevel && _userLevel.integerValue >= 0) {
        
        //图标
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:[self getImgNameWithLevel:_userLevel.length?_userLevel:@"0"]];
        //使图片大小与文字大小相同
        attachment.bounds = CGRectMake(0, -2, 27, 11);
        //将附件对象包装成一个属性文字
        NSAttributedString *iconAttri = [NSAttributedString attributedStringWithAttachment:attachment];
        [attri appendAttributedString:iconAttri];
//        [attri insertAttributedString:iconAttri atIndex:0];
        
        [attri insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:1];
    }
    
    NSString *custUserName = _userName;
    NSAttributedString *userNameAttri = [[NSAttributedString alloc] initWithString:custUserName];
    [attri appendAttributedString:userNameAttri];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"#A8A8A8"] range:[attri.string rangeOfString:custUserName]];
    
    NSMutableAttributedString *attriChat = [[NSMutableAttributedString alloc] initWithString:_userChat?:@""];
    attriChat = [self replaceEmojiWithAttri:attriChat];
//    NSAttributedString *contentAttri = [[NSAttributedString alloc] initWithString:_userChat?:@""];
    [attri appendAttributedString:attriChat];
    
    //快龙+雷速聊天同时开启的时候，主播或房管看见的雷速消息是黑色，快龙消息是红色
    if ([[UserInstance shareInstance].userModel.userRoomRole integerValue] == 1 && ![UserInstance shareInstance].userModel.isLeisuJinyan) {
        if (_leisu && [_leisu integerValue] == 2) {
            [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"#333333"] range:[attri.string rangeOfString:attriChat.string]];
        }else{
            [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"#FF0000"] range:[attri.string rangeOfString:attriChat.string]];
        }
    }else {
        [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"#333333"] range:[attri.string rangeOfString:attriChat.string]];
    }
    
    
    //段落
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = 2;         // 首行缩进
    paragraphStyle.headIndent = 0;                 // 其它行缩进
    paragraphStyle.lineSpacing = 5;                // 行间距
    [attri addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attri.length)];// 段落
    [attri addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSKernAttributeName:@(1)} range:NSMakeRange(0, attri.length)];
    
    return attri;
}

//正则解析聊天内容中携带的表情
- (NSMutableAttributedString *)replaceEmojiWithAttri:(NSMutableAttributedString *)text
{
    NSString *pattern = @"\\[[face0-9]+\\]";
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *resultArray = [regular matchesInString:[text string] options:0 range:NSMakeRange(0, text.length)];

    if (resultArray.count) {
        NSTextCheckingResult *result = [resultArray firstObject];
        NSRange range = result.range;

        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        NSString *emojiName = [[text string] substringWithRange:NSMakeRange(range.location+5, range.length-6)];
        attach.image = [UIImage imageNamed:[NSString stringWithFormat:@"emoji_%@",emojiName]];
        attach.bounds = CGRectMake(0, -5, 22, 22);
        
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attach];
        [text replaceCharactersInRange:range withAttributedString:imageStr];
        
        return [self replaceEmojiWithAttri:text];
    }
    return text;
}

- (NSString *)getImgNameWithLevel:(NSString *)level
{
    NSString *imgName = [NSString stringWithFormat:@"mine_lev_%ld",(long)[level integerValue]];

    return imgName;
}

@end
