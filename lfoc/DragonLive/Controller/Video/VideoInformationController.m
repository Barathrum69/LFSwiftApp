//
//  VideoInformationController.m
//  DragonLive
//
//  Created by LoaA on 2020/12/3.
//

#import "VideoInformationController.h"
#import "FMGVideoPlayView.h"
#import "RecommendVideoTableView.h"
#import "VideoContentView.h"
#import "VideoItemModel.h"
#import "VideoProxy.h"
#import "VideoDetailModel.h"
#import "VideoCommentTableView.h"
#import "VideoCommentModel.h"
#import "XMNShareView.h"
#import "LiveLoadingView.h"
@interface VideoInformationController ()

@property (nonatomic, strong) LiveLoadingView *loadingView;         //加载动画

@property (nonatomic, strong) NSMutableArray *urlArray;

/// 播放器
@property (nonatomic, strong) FMGVideoPlayView *playView;

/// video详情的下面的View
@property (nonatomic, strong) VideoContentView *videoContentView;

/// 详情model
@property (nonatomic, strong) VideoDetailModel *model;

@end

@implementation VideoInformationController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.title = @"视频详情";
    self.view.backgroundColor = The_MainColor;
    // Do any additional setup after loading the view.
    [self setupVideoPlayView];
    [self initContentView];
    
//    [self play];
    [self initSegData];
    
    [self loadRequest];
    
}



-(void)loadRequest
{
    kWeakSelf(self);
    [STTextHudTool showWaitText:@"加载中..."delay:3];
    
    [VideoProxy getVideoItemDetailsWithVideoId:_itemModel.videoId success:^(VideoDetailModel * _Nonnull obj) {
        //播放Url
        [self.playView removeBadNetWorkView];
        
        [STTextHudTool hideSTHud];
//        [weakself.playView setUrlString:obj.url];
        weakself.model = obj;
        weakself.videoContentView.itemModel = obj;
        [weakself.playView setUrlString:obj.url];
        weakself.playView.titleText = obj.title;
        [weakself loadRecommengListWithPage:1 ctgId:[obj.ctgIdList lastObject]];
        [weakself loadCommentWithPage:1 videoId:obj.videoId];
        
        [DREmptyView hiddenEmptyInView:self.videoContentView.recommendVideoTableView];
        [DREmptyView hiddenEmptyInView:self.videoContentView.videoCommentTableView];
        
    } failure:^(NSError * _Nonnull error) {
        [self.playView addBadNetWorkViewblock:^{
            [weakself loadRequest];
        }];
        if ( self.videoContentView.recommedArray.count == 0) {
            [DREmptyView showEmptyInView:self.videoContentView.recommendVideoTableView emptyType:DRNetworkErrorType refresh:^{
                [weakself loadRequest];
            }];
        }
        if ( self.videoContentView.commentArray.count == 0) {
            [DREmptyView showEmptyInView:self.videoContentView.videoCommentTableView emptyType:DRNetworkErrorType refresh:^{
                [weakself loadRequest];
            }];
        }
        [STTextHudTool hideSTHud];
    }];
}//加载视频的请求


-(void)updateCommtentShare{
    kWeakSelf(self);
    [VideoProxy getVideoItemDetailsWithVideoId:_itemModel.videoId success:^(VideoDetailModel * _Nonnull obj) {
        //播放Url
        weakself.model = obj;
        weakself.videoContentView.itemModel = obj;
    } failure:^(NSError * _Nonnull error) {
        
        
    }];
}//刷新评论数量分享数量


-(void)loadRecommengListWithPage:(NSInteger)page ctgId:(NSNumber *)ctgId
{
    kWeakSelf(self);
    [VideoProxy getRecommendVideoListWithctgId:ctgId page:page success:^(NSMutableArray * _Nonnull obj) {
        weakself.videoContentView.recommedArray = obj;
        [DREmptyView hiddenEmptyInView:self.videoContentView.recommendVideoTableView];
    } failure:^(NSError * _Nonnull error) {
        if ( self.videoContentView.recommedArray.count == 0) {
            [DREmptyView showEmptyInView:self.videoContentView.recommendVideoTableView emptyType:DRNetworkErrorType refresh:^{
                [weakself loadRequest];
            }];
        }
    }];
}//推荐视频的请求


-(void)loadCommentWithPage:(NSInteger)page videoId:(NSString *)videoId
{
    kWeakSelf(self);
    [VideoProxy getCommentListWithPage:page targetId:videoId success:^(NSMutableArray * _Nonnull obj) {
        self->_videoContentView.commentArray = obj;
        [self updateCommtentShare];
        [self->_videoContentView headerFooterEnd];
        [DREmptyView hiddenEmptyInView:self.videoContentView.videoCommentTableView];
    } failure:^(NSError * _Nonnull error) {
        [self->_videoContentView headerFooterEnd];
        if ( self.videoContentView.commentArray.count == 0) {
            [DREmptyView showEmptyInView:self.videoContentView.videoCommentTableView emptyType:DRNetworkErrorType refresh:^{
                [weakself loadRequest];
            }];
        }

    }];
    
}//请求评论列表


- (void)setupVideoPlayView
{
    _playView = [FMGVideoPlayView videoPlayView];
    // 视频资源路径
    // 播放器显示位置（竖屏时）
    _playView.frame = CGRectMake(0, kStatusBarHeight, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
    // 添加到当前控制器的view上
    [self.view addSubview:_playView];
    // 指定一个作为播放的控制器
    _playView.contrainerViewController = self;
    
    kWeakSelf(self);
    _playView.videoPlayEnd = ^{
        [weakself play];
    };
    
    _playView.goBack = ^{
        [weakself.playView removeObject];
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    
}//播放器

-(void)initContentView
{
    kWeakSelf(self);
    
    _videoContentView = [[VideoContentView alloc]initWithFrame:CGRectMake(0,_playView.bottom, kScreenWidth, kScreenHeight-_playView.bottom-kBottomSafeHeight)];
    [self.view addSubview:_videoContentView];
    //评论
    _videoContentView.textViewContentText = ^(NSString * _Nonnull string) {
        NSLog(@"%@",string);
      
        if (![[UserInstance shareInstance]isLogin]){
            if (string.length == 0) {
                [weakself showToast:@"评论不能为空"];
            }
            [UntilTools pushLoginPageSuccess:^{
                [weakself commentLikeRequestWithTargetId:weakself.itemModel.videoId contentType:@"3" cType:@"4" content:string];
            }];
        }else{
            [weakself commentLikeRequestWithTargetId:weakself.itemModel.videoId contentType:@"3" cType:@"4" content:string];
        }
    };
    
    
    //点击推荐视频
    _videoContentView.recommedTableViewDidSelected = ^(VideoItemModel * _Nonnull model) {
        weakself.itemModel = model;
        [weakself loadRequest];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *myNumber = [f numberFromString:weakself.itemModel.ctgId];
        [weakself loadRecommengListWithPage:1 ctgId:myNumber];
        [weakself loadCommentWithPage:1 videoId:weakself.itemModel.videoId];

    };
    
    //评论刷新
    _videoContentView.commentHeaderRefreshBlock = ^(NSInteger page) {
    
        [weakself loadCommentWithPage:page videoId:weakself.itemModel.videoId];

    };
    //评论加载更多。
    _videoContentView.commentFooterRefreshBlock = ^(NSInteger page) {
        [weakself loadCommentWithPage:page videoId:weakself.itemModel.videoId];
    };
    
    
    //评论的点赞
    _videoContentView.commentLikeBlock = ^(VideoCommentModel * _Nonnull model) {

            [STTextHudTool showWaitText:@"请求中..."delay:2];
            [weakself commentLikeRequestWithTargetId:model.commentId contentType:@"5" cType:@"1" content:@""];
    };
    //评论的删除 // 只能删除自己的 别人的不能动
    _videoContentView.commentDeleteBlock = ^(VideoCommentModel * _Nonnull model) {
        
        ZGAlertView *alertView = [[ZGAlertView alloc] initWithTitle:@"确认删除？"
                                               message:nil
                                     cancelButtonTitle:@"取消"
                                     otherButtonTitles:@"确认", nil];
        [alertView show];
        
        alertView.dismissBlock = ^(NSInteger clickIndex) {
            if (clickIndex == 1) {
                [weakself.videoContentView.videoCommentTableView.dataArray removeObject:model];
                [weakself.videoContentView.videoCommentTableView reloadData];
                [VideoProxy deleteCommentWithCommentId:model.commentId success:^(BOOL isSuccess) {
                    [weakself updateCommtentShare];
                } failure:^(NSError * _Nonnull error) {
                    
                }];
            }
        };
    };
    
    //分享
    _videoContentView.recommedShareBlock = ^{
        XMNShareView *shareView = [[XMNShareView alloc]init];
        [UntilTools pushSharePageSysparamCode:@"SHARE_VIDEO_URL" itemId:weakself.itemModel.videoId isTask:NO shareView:shareView success:^{
            [weakself updateCommtentShare];
        }];
    };
    //视频的点赞
    _videoContentView.recommedLikeedBlock = ^(VideoDetailModel * _Nonnull model) {
        [STTextHudTool showWaitText:@"请求中..."delay:2];
        if (![[UserInstance shareInstance]isLogin]) {
            [UntilTools pushLoginPageSuccess:^{
                [weakself commentLikeRequestWithTargetId:model.videoId contentType:@"3" cType:@"1" content:@""];
                
            }];
        }else{
            [weakself commentLikeRequestWithTargetId:model.videoId contentType:@"3" cType:@"1" content:@""];
            
        }
    };
    

    
    
}//简介和评论的View


-(void)commentLikeRequestWithTargetId:(NSString *)targetId contentType:(NSString *)contentType cType:(NSString *)cType content:(NSString *)content{
    
    [VideoProxy sendCommentLikeWithTargetId:targetId contentType:contentType cType:cType content:content success:^(BOOL isSuccess) {
        if ([cType isEqualToString:@"4"]) {
            [self.view endEditing:YES];
            [self showToast:@"评论成功"];
            [self.videoContentView.videoCommentTableView.mj_header beginRefreshing];
        }
        [self updateCommtentShare];

    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}//点赞 评论的请求


-(void)initSegData
{
    _videoContentView.sectionTitles = [[NSMutableArray alloc]initWithObjects:@"简介",@"评论", nil];
}//seg赋值

-(void)play
{
    [_playView setUrlString:_model.url];
}//播放

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setHidden:YES];
    self.navigationController.delegate = self;
    [self addNotification];
}//viewWillAppear

-(void)addNotification{
    //app回到前台
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActive) name:ApplicationDidBecomeActiveNotification object:nil];
    //app进入后台
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidEnterBackground) name:ApplicationDidEnterBackgroundNotification object:nil];
    
}

-(void)applicationDidBecomeActive
{
    if (_playView.isPlaying) {
        [_playView play];
    }
}//app回到前台

-(void)applicationDidEnterBackground
{
    [_playView puase];
}//app进入后台

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setHidden:NO];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
 
}//viewWillDisappear

#pragma mark - 视图移除
- (void)willMoveToParentViewController:(UIViewController *)parent
{
    [super willMoveToParentViewController:parent];
    NSLog(@"%s,%@",__func__,parent);
}
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];
    NSLog(@"%s,%@",__func__,parent);
    if(!parent){
        [self.playView removeObject];
        NSLog(@"页面pop成功了");
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
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
