//
//  DRLinkwordsViewController.h
//  DragonLive
//
//  Created by 11号 on 2020/12/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^KeywordsSelectBlock)(NSString *searchTest);
typedef void(^KeywordsScrollBlock)(void);

@interface DRKeywordsViewController : UIViewController

@property (nonatomic, copy) KeywordsSelectBlock wordsSelectBlock;
@property (nonatomic, copy) KeywordsScrollBlock scrollBlock;

- (void)searchTestChangeWithTest:(NSString *)test;

@end

NS_ASSUME_NONNULL_END
