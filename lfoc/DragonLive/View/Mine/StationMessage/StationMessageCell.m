//
//  StationMessageCell.m
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import "StationMessageCell.h"
#import "StationMessageModel.h"
#import "LeftLabel.h"
@interface StationMessageCell()


/// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

/// 信息
@property (weak, nonatomic) IBOutlet LeftLabel *messageLab;

/// 时间
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

/// 展开按钮
@property (weak, nonatomic) IBOutlet UIButton *showBtn;

@end


@implementation StationMessageCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    _titleLab.frame = CGRectMake(kWidth(25), kWidth(25), kWidth(100), kWidth(13));
    _titleLab.font  = [UIFont boldSystemFontOfSize:kWidth(13)];
    _titleLab.textColor = [UIColor colorFromHexString:@"333333"];
    _titleLab.text = @"系统通知";
    
   

    
    _timeLab.frame = CGRectMake(kScreenWidth-kWidth(35+100), 0, kWidth(100), kWidth(12));
    _timeLab.center = CGPointMake(_timeLab.centerX, _titleLab.centerY);
    _timeLab.font  = [UIFont systemFontOfSize:kWidth(12)];
    _timeLab.textColor = [UIColor colorFromHexString:@"333333"];
    _timeLab.textAlignment = NSTextAlignmentRight;
    _timeLab.text = @"2020/03/22";
    

//    _showBtn.backgroundColor = [UIColor redColor];
    [_showBtn addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];
    [_showBtn setImage:[UIImage imageNamed:@"showBtn_nomorl"] forState:UIControlStateNormal];
    
    _messageLab.frame = CGRectMake(_titleLab.left, _titleLab.bottom+kWidth(10), kScreenWidth-kWidth(35+40), kWidth(15));
    _messageLab.numberOfLines = 0;
    _messageLab.font = [UIFont systemFontOfSize:kWidth(12)];
    _messageLab.textColor = [UIColor colorFromHexString:@"333333"];
    _messageLab.lineBreakMode = NSLineBreakByTruncatingTail;
    _showBtn.frame = CGRectMake(_timeLab.right-kWidth(16), _messageLab.top, kWidth(16), kWidth(16));
    
//    _showBtn.hidden = YES;
}//awakeFromNib

-(void)setModel:(id)model
{
    StationMessageModel *tmodel  = (StationMessageModel *)model;
    _model = tmodel;
    _timeLab.text = tmodel.sendTime;
    _titleLab.text = tmodel.title;
    _messageLab.text = tmodel.content;
    _showBtn.hidden = !tmodel.shouldShowOpenBtn;
    
    if (!tmodel.isOpen) {
        NSLog(@"%f",_messageLab.top);
        //收起来
        [_showBtn setImage:[UIImage imageNamed:@"showBtn_nomorl"] forState:UIControlStateNormal];
        _messageLab.frame = CGRectMake(_titleLab.left, _titleLab.bottom+kWidth(10), kScreenWidth-kWidth(35+40), kWidth(15));

    }else{
        NSLog(@"%f",_messageLab.top);
        NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:tmodel.content];
        NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle1.alignment = NSTextAlignmentJustified;
        NSDictionary * dic =@{
                              //这两个一定要加哦。否则就没效果啦
                              NSParagraphStyleAttributeName:paragraphStyle1,
                              NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleNone],
                              };
        [attributedString1 setAttributes:dic range:NSMakeRange(0, attributedString1.length)];
        [_messageLab setAttributedText:attributedString1];
        //展开
        [_showBtn setImage:[UIImage imageNamed:@"showBtn_unfold"] forState:UIControlStateNormal];
        _messageLab.frame = CGRectMake(_titleLab.left, _titleLab.bottom+kWidth(10), kScreenWidth-kWidth(35+40), tmodel.msgSize.height);
//        _showBtn.backgroundColor = [UIColor greenColor];

        
    }
    
}//setModel

-(void)showMore:(id)sender
{
    StationMessageModel *tmodel  = _model;
    if (tmodel.isOpen) {


        //设置label每行文字之间的行间距
        _refreshBlock(_model,1,1);
    }else{
        _refreshBlock(_model,0,1);
    }
}//显示更多


-(void)doRefreshModel:(RefreshBlock)refreshBlock
{
    _refreshBlock = refreshBlock;
}//点击收起来


@end
