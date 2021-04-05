//
//  UserAgreementController.m
//  DragonLive
//
//  Created by LoaA on 2021/1/7.
//

#import "UserAgreementController.h"

@interface UserAgreementController ()

/// textView
@property (nonatomic, strong) UITextView *textView;

@end

@implementation UserAgreementController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = The_MainColor;
    self.navigationItem.title = _navtitle;
    [self initView];
    // Do any additional setup after loading the view.
}


-(void)initView
{
    NSData *fileData = [NSData dataWithContentsOfFile:_path];

    //判断是UNICODE编码
    NSString *string = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
        
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(kWidth(25), kWidth(10), kScreenWidth-kWidth(50), kScreenHeight-kTopHeight-kBottomSafeHeight-kWidth(10))];
    _textView.text = [string stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    _textView.font = [UIFont systemFontOfSize:kWidth(15)];
    _textView.backgroundColor = [UIColor clearColor];
    [_textView setEditable:NO];
    [self.view addSubview:_textView];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
