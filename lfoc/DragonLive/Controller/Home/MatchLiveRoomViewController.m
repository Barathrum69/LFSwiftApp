//
//  MatchLiveRoomViewController.m
//  DragonLive
//
//  Created by 11号 on 2021/2/5.
//

#import "MatchLiveRoomViewController.h"
#import "BAWebViewController.h"
#import <WebKit/WKWebView.h>
#import <WebKit/WKWebViewConfiguration.h>

@interface MatchLiveRoomViewController ()

@end

@implementation MatchLiveRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = The_MainColor;
    CGFloat ratio = 365.0/206.0;         //广告view宽高比
    CGFloat hei = kkScreenWidth/ratio > 250 ?:250;
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.allowsInlineMediaPlayback=true;

    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kkScreenWidth, hei) configuration:configuration];
    [self.view addSubview:webView];
    NSURL *url = [NSURL URLWithString:@"https://m.b8b8.tv/live/28890"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
//    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)];
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
