//
//  SearchViewModel.m
//  DragonLive
//
//  Created by 11号 on 2020/12/19.
//

#import "SearchViewModel.h"
#import "LiveHosts.h"
#import "LiveItem.h"
#import "VideoItemModel.h"
#import "SearchAllModel.h"

@interface SearchViewModel ()

@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *allArray;
@property (nonatomic, strong) NSMutableArray *hostArray;
@property (nonatomic, strong) NSMutableArray *liveArray;
@property (nonatomic, strong) NSMutableArray *videoArray;
@property (nonatomic, copy) NSString *searchKeyword;
@property (nonatomic) NSInteger hostPage;
@property (nonatomic) NSInteger livePage;
@property (nonatomic) NSInteger videoPage;

@end

@implementation SearchViewModel

static const NSInteger pageSize = 20;

- (id)initWithDelegate:(id<SearchViewModelDelegate>)delegate
{
    self = [super init];
    if (self) {
        
        self.delegate = delegate;
        self.allArray = [NSMutableArray array];
        self.hostArray = [NSMutableArray array];
        self.liveArray = [NSMutableArray array];
        self.videoArray = [NSMutableArray array];
        
        [self requestSearchHotwords];
    }
    
    return self;
}

- (void)clearHistory
{
    [self.allArray removeAllObjects];
    [self.hostArray removeAllObjects];
    [self.liveArray removeAllObjects];
    [self.videoArray removeAllObjects];
}

- (void)searchRequestWithKeyword:(NSString *)keyword
{
    self.searchKeyword = keyword;
    self.hostPage = 0;
    self.livePage = 0;
    self.videoPage = 0;
    [self.allArray removeAllObjects];
    [self.hostArray removeAllObjects];
    [self.liveArray removeAllObjects];
    [self.videoArray removeAllObjects];
    
    [self requestSearchAll:keyword];
    
}

- (void)hostRequestMore
{
    self.hostPage++;
    
    [self requestSearchHosts:self.searchKeyword];
}

- (void)liveRequestMore
{
    self.livePage++;
    
    [self requestSearchLives:self.searchKeyword];
}

- (void)videoRequestMore
{
    self.videoPage++;
    
    [self requestSearchVideos:self.searchKeyword];
}

- (void)requestSearchHotwords
{
    __weak __typeof(self)weakSelf = self;
    [HttpRequest requestWithURLType:UrlTypeSearchHotwords parameters:nil type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code==200) {
            
            NSMutableArray *arr = responseObject[@"data"];
            strongSelf.hotArray = [NSMutableArray arrayWithCapacity:arr.count];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [strongSelf.hotArray addObject:obj[@"search_text"]];
            }];
            if (strongSelf.delegate) {
                [strongSelf.delegate requestSearchHotwordsFinish:nil];
            }
        }else {
            NSError *error = [NSError errorWithDomain:responseObject[@"message"] code:code userInfo:nil];
            if (strongSelf.delegate) {
                [strongSelf.delegate requestSearchHotwordsFinish:error];
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.delegate) {
            [strongSelf.delegate requestSearchHotwordsFinish:error];
        }
    }];
}

- (void)requestSearchHosts:(NSString *)keyword
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:keyword,@"keyword",[NSNumber numberWithInteger:self.hostPage],@"page",[NSNumber numberWithInteger:pageSize],@"size", nil];
    __weak __typeof(self)weakSelf = self;
    [HttpRequest requestWithURLType:UrlTypeSearchSteamer parameters:dic type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code==200) {
            NSMutableArray *arr = responseObject[@"data"][@"list"];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LiveHosts *hostModel = [LiveHosts modelWithDictionary:obj];
                [strongSelf.hostArray addObject:hostModel];
            }];
            if (strongSelf.delegate) {
                [strongSelf.delegate requestSearchHostsFinish:nil];
            }
        }else {
            if (self.hostPage>0) {
                self.hostPage--;
            }
            if (strongSelf.delegate) {
                [strongSelf.delegate requestSearchHostsFinish:nil];
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.delegate) {
            [strongSelf.delegate requestSearchHostsFinish:error];
        }
    }];
}

- (void)requestSearchLives:(NSString *)keyword
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:keyword,@"keyword",[NSNumber numberWithInteger:self.livePage],@"page",[NSNumber numberWithInteger:pageSize],@"size", nil];
    __weak __typeof(self)weakSelf = self;
    [HttpRequest requestWithURLType:UrlTypeSearchLive parameters:dic type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code==200) {
            NSMutableArray *arr = responseObject[@"data"][@"list"];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LiveItem *hostModel = [[LiveItem alloc] init];
                hostModel.liveId = obj[@"id"];
                hostModel.belongHostName = obj[@"nickname"];
                hostModel.liveTitle = obj[@"livetitle"];
                hostModel.ctgId = obj[@"ctgid"];
                hostModel.ctgName = obj[@"ctgname"];
                hostModel.liveStatus = obj[@"status"];
                hostModel.roomId = obj[@"roomid"];
                hostModel.coverImg = obj[@"coverimg"];
                [strongSelf.liveArray addObject:hostModel];
            }];
            
            if (strongSelf.delegate) {
                [strongSelf.delegate requestSearchLivesFinish:nil];
            }
        }else {
            
            if (self.livePage>0) {
                self.livePage--;
            }
            if (strongSelf.delegate) {
                [strongSelf.delegate requestSearchLivesFinish:nil];
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.delegate) {
            [strongSelf.delegate requestSearchLivesFinish:error];
        }
    }];
}

- (void)requestSearchVideos:(NSString *)keyword
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:keyword,@"keyword",[NSNumber numberWithInteger:self.videoPage],@"page",[NSNumber numberWithInteger:pageSize],@"size", nil];
    __weak __typeof(self)weakSelf = self;
    [HttpRequest requestWithURLType:UrlTypeSearchVideo parameters:dic type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code==200) {
            NSMutableArray *arr = responseObject[@"data"][@"list"];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:obj[@"id"],@"videoId",obj[@"videotitle"],@"title",obj[@"url"],@"url",obj[@"coverimg"],@"coverImg",obj[@"videoduration"],@"videoDuration",obj[@"hot"],@"playNum",obj[@"commentnum"],@"commentNumberOfCurVideo", nil];
                VideoItemModel *videoModel = [VideoItemModel modelWithDictionary:resultDic];
                videoModel.watchAndCommentAtt = [UntilTools videoItemWatchNum:videoModel.playNum comment:videoModel.commentNumberOfCurVideo];
                [strongSelf.videoArray addObject:videoModel];
            }];
            if (strongSelf.delegate) {
                [strongSelf.delegate requestSearchVideosFinish:nil];
            }
        }else {
            if (self.videoPage>0) {
                self.videoPage--;
            }
            if (strongSelf.delegate) {
                [strongSelf.delegate requestSearchVideosFinish:nil];
            }
        }
        
    } failure:^(NSError * _Nonnull error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.delegate) {
            [strongSelf.delegate requestSearchVideosFinish:error];
        }
    }];
}

//搜索全部
- (void)requestSearchAll:(NSString *)keyword
{
    [STTextHudTool showWaitText:@"加载中..."];
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue= dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:keyword,@"keyword",[NSNumber numberWithInteger:0],@"page",[NSNumber numberWithInteger:pageSize],@"size", nil];
    //搜索主播
    dispatch_group_async(group, queue, ^{
        __weak __typeof(self)weakSelf = self;
        [HttpRequest requestWithURLType:UrlTypeSearchSteamer parameters:dic type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code==200) {
                NSMutableArray *arr = responseObject[@"data"][@"list"];
                NSMutableArray *htArray = [NSMutableArray arrayWithCapacity:arr.count];
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    LiveHosts *hostModel = [LiveHosts modelWithDictionary:obj];
                    [strongSelf.hostArray addObject:hostModel];
                    [htArray addObject:hostModel];
                }];
                if (htArray.count) {
                    SearchAllModel *allModel = [[SearchAllModel alloc] init];
                    allModel.resultTitle = @"相关主播";
                    allModel.resultArray = htArray;
                    [strongSelf.allArray addObject:allModel];
                }
            }
            dispatch_semaphore_signal(semaphore);
            
        } failure:^(NSError * _Nonnull error) {
            dispatch_semaphore_signal(semaphore);
        }];

        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    //搜索直播
    dispatch_group_async(group, queue, ^{
        __weak __typeof(self)weakSelf = self;
        [HttpRequest requestWithURLType:UrlTypeSearchLive parameters:dic type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code==200) {
                NSMutableArray *arr = responseObject[@"data"][@"list"];
                NSMutableArray *lvArray = [NSMutableArray arrayWithCapacity:arr.count];
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    LiveItem *hostModel = [[LiveItem alloc] init];
                    hostModel.liveId = obj[@"id"];
                    hostModel.belongHostName = obj[@"nickname"];
                    hostModel.liveTitle = obj[@"livetitle"];
                    hostModel.ctgId = obj[@"ctgid"];
                    hostModel.ctgName = obj[@"ctgname"];
                    hostModel.liveStatus = obj[@"status"];
                    hostModel.roomId = obj[@"roomid"];
                    hostModel.coverImg = obj[@"coverimg"];
                    [strongSelf.liveArray addObject:hostModel];
                    [lvArray addObject:hostModel];
                }];
                if (lvArray.count) {
                    SearchAllModel *allModel = [[SearchAllModel alloc] init];
                    allModel.resultTitle = @"相关直播";
                    allModel.resultArray = lvArray;
                    [strongSelf.allArray addObject:allModel];
                }
            }
            dispatch_semaphore_signal(semaphore);
            
        } failure:^(NSError * _Nonnull error) {
            dispatch_semaphore_signal(semaphore);
        }];

        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    //搜索视频
    dispatch_group_async(group, queue, ^{
        __weak __typeof(self)weakSelf = self;
        [HttpRequest requestWithURLType:UrlTypeSearchVideo parameters:dic type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code==200) {
                NSMutableArray *arr = responseObject[@"data"][@"list"];
                NSMutableArray *vdArray = [NSMutableArray arrayWithCapacity:arr.count];
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *resultDic = [NSDictionary dictionaryWithObjectsAndKeys:obj[@"id"],@"videoId",obj[@"videotitle"],@"title",obj[@"url"],@"url",obj[@"coverimg"],@"coverImg",obj[@"videoduration"],@"videoDuration",obj[@"hot"],@"playNum",obj[@"commentnum"],@"commentNumberOfCurVideo", nil];
                    VideoItemModel *videoModel = [VideoItemModel modelWithDictionary:resultDic];
                    videoModel.watchAndCommentAtt = [UntilTools videoItemWatchNum:videoModel.playNum comment:videoModel.commentNumberOfCurVideo];
                    [strongSelf.videoArray addObject:videoModel];
                    [vdArray addObject:videoModel];
                }];
                if (vdArray.count) {
                    SearchAllModel *allModel = [[SearchAllModel alloc] init];
                    allModel.resultTitle = @"相关视频";
                    allModel.resultArray = vdArray;
                    [strongSelf.allArray addObject:allModel];
                }
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(NSError * _Nonnull error) {
            dispatch_semaphore_signal(semaphore);
        }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [STTextHudTool hideSTHud];
        //所有请求返回数据后执行
        if (self.delegate) {
            [self.delegate requestSearchAllFinish:nil];
        }
    });
}

@end
