//
//  DRLinkwordsViewController.m
//  DragonLive
//
//  Created by 11号 on 2020/12/15.
//

#import "DRKeywordsViewController.h"
#import "HttpRequest.h"
#import "DRKeywordsCell.h"

@interface DRKeywordsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, copy)  NSString *searchKeyword;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation DRKeywordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
    
    [self.view addSubview:self.contentTableView];
}

- (void)requestSearchKeywords:(NSString *)keyword
{
    __weak __typeof(self)weakSelf = self;
    [HttpRequest requestWithURLType:UrlTypeSearchKeywords parameters:[NSDictionary dictionaryWithObject:keyword forKey:@"keyword"] type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code==200) {
            
            NSMutableArray *arr = responseObject[@"data"];
            [strongSelf.dataArray removeAllObjects];
            [strongSelf.dataArray addObjectsFromArray:arr];
            [strongSelf.contentTableView reloadData];
        }
        
    } failure:^(NSError * _Nonnull error) {

    }];
}

- (UITableView *)contentTableView
{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 88) style:UITableViewStylePlain];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.backgroundColor = [UIColor whiteColor];
//        _contentTableView.tableFooterView = [UIView new];
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _contentTableView;
}

- (void)searchTestChangeWithTest:(NSString *)test
{
    self.searchKeyword = test;
    [self requestSearchKeywords:test];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.scrollBlock) {
        self.scrollBlock();
    }
}

#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"DRKeywordsCell";
    DRKeywordsCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell =  [[NSBundle mainBundle] loadNibNamed:@"DRKeywordsCell" owner:self options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setKeywords:_dataArray[indexPath.row] searchKey:_searchKeyword];
    
    return cell;
}


#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.wordsSelectBlock) {
        self.wordsSelectBlock(_dataArray[indexPath.row]);
    }
}

@end
