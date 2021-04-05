//
//  SearchViewModel.h
//  DragonLive
//
//  Created by 11号 on 2020/12/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SearchViewModelDelegate <NSObject>

@optional //非必实现的方法

- (void)requestSearchHotwordsFinish:(nullable NSError *)error;

- (void)requestSearchHostsFinish:(nullable NSError *)error;

- (void)requestSearchLivesFinish:(nullable NSError *)error;

- (void)requestSearchVideosFinish:(nullable NSError *)error;

- (void)requestSearchAllFinish:(nullable NSError *)error;

@end

/// 搜索view model
@interface SearchViewModel : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *hotArray;
@property (nonatomic, strong, readonly) NSMutableArray *allArray;
@property (nonatomic, strong, readonly) NSMutableArray *hostArray;
@property (nonatomic, strong, readonly) NSMutableArray *liveArray;
@property (nonatomic, strong, readonly) NSMutableArray *videoArray;
@property (nonatomic, weak) id<SearchViewModelDelegate> delegate;


- (id)initWithDelegate:(id<SearchViewModelDelegate>)delegate;

- (void)searchRequestWithKeyword:(NSString *)keyword;
- (void)hostRequestMore;
- (void)liveRequestMore;
- (void)videoRequestMore;
- (void)clearHistory;

@end

NS_ASSUME_NONNULL_END
