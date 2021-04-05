//
//  XDSDropDownMenu.m
//  shts_ios_xds
//
//  Created by cdj on 2018/5/8.
//  Copyright © 2018年 itiis. All rights reserved.
//

#import "XDSDropDownMenu.h"
#import "LeftTextRightImageBtn.h"
@interface XDSDropDownMenu()
@property(nonatomic, strong) UITableView *menuTableView;
@property(nonatomic, strong) LeftTextRightImageBtn *btnSender;
@property(nonatomic) CGRect buttonFrame;
@property(nonatomic, retain) NSArray *titleList;
@property(nonatomic, retain) NSArray *imageList;
@end

@implementation XDSDropDownMenu

+(NSInteger)returnIndexByString:(NSString *)string fromArray:(NSArray *)array{  //返回选项下标
    NSUInteger index = [array indexOfObject:string];
    return index;
}

- (void)showDropDownMenu:(LeftTextRightImageBtn *)button withButtonFrame:(CGRect)buttonFrame arrayOfTitle:(NSArray *)titleArr arrayOfImage:(NSArray *)imageArr animationDirection:(NSString *)direction{
    
    self.backgroundColor = [UIColor whiteColor];
    self.animationDirection = direction;
    self.btnSender = button;
    self.menuTableView = (UITableView *)[super init];
    
    self.buttonFrame = buttonFrame;
    if (self) {
        CGRect btnRect = buttonFrame;//按钮在视图上的位置
        CGFloat height = 0;//菜单高度
        if ( titleArr.count <= 4) {
            height = titleArr.count *40;
        }else{
            
            if ([[UserInstance shareInstance].userModel.userType isEqualToString:@"2"]) {
                height = titleArr.count *40;
            }else{
                height = 200;
            }
            
        }
        
        self.titleList = [NSArray arrayWithArray:titleArr];
        self.imageList = [NSArray arrayWithArray:imageArr];
        
        //菜单视图的起始大小和位置
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btnRect.origin.x-kWidth(10), btnRect.origin.y-2, btnRect.size.width+kWidth(20), 0);
        }else if ([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btnRect.origin.x-kWidth(10), btnRect.origin.y+btnRect.size.height+2, btnRect.size.width+kWidth(20), 0);
        }
        
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        
        self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btnRect.size.width+kWidth(20), 0)];
        self.menuTableView.delegate = self;
        self.menuTableView.dataSource = self;
        self.menuTableView.layer.cornerRadius = 5;
        self.menuTableView.showsVerticalScrollIndicator = NO;
        self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.menuTableView.separatorColor = [UIColor grayColor];
        self.menuTableView.separatorInset = UIEdgeInsetsMake(0, -20, 0, 0);
        self.menuTableView.backgroundColor = [UIColor whiteColor];
        self.menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnRect.size.width+kWidth(20), 0.001)];//最后无分割线
        [self.menuTableView flashScrollIndicators];//显示滚动条
        
        [UIView beginAnimations:nil context:nil];//动画
        [UIView setAnimationDuration:0.3];
        //菜单视图的最终大小和位置
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btnRect.origin.x-kWidth(10), btnRect.origin.y-height-2, btnRect.size.width+kWidth(20), height);
        } else if([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btnRect.origin.x-kWidth(10), btnRect.origin.y+btnRect.size.height+2, btnRect.size.width+kWidth(20), height);
        }
        self.menuTableView.frame = CGRectMake(0, 0, btnRect.size.width+kWidth(20), height);
        [UIView commitAnimations];
        [self addSubview:self.menuTableView];
    }
    
}


-(void)hideDropDownMenuWithBtnFrame:(CGRect)btnFrame {
    
//    CGRect btn = button.frame;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    if ([self.animationDirection isEqualToString:@"up"]) {
        self.frame = CGRectMake(btnFrame.origin.x-kWidth(10), btnFrame.origin.y-2, btnFrame.size.width+kWidth(20), 0);
    }else if ([self.animationDirection isEqualToString:@"down"]) {
        self.frame = CGRectMake(btnFrame.origin.x-kWidth(10), btnFrame.origin.y+btnFrame.size.height+2, btnFrame.size.width+kWidth(20), 0);
    }
    self.menuTableView.frame = CGRectMake(0, 0, btnFrame.size.width+kWidth(20), 0);
    [UIView commitAnimations];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:kWidth(13)];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    if ([self.imageList count] == [self.titleList count]) {
        cell.textLabel.text =[self.titleList objectAtIndex:indexPath.row];
        cell.imageView.image = [self.imageList objectAtIndex:indexPath.row];
    } else if ([self.imageList count] > [self.titleList count]) {
        cell.textLabel.text =[self.titleList objectAtIndex:indexPath.row];
        if (indexPath.row < [self.imageList count]) {
            cell.imageView.image = [self.imageList objectAtIndex:indexPath.row];
        }
    } else if ([self.imageList count] < [self.titleList count]) {
        cell.textLabel.text =[self.titleList objectAtIndex:indexPath.row];
        if (indexPath.row < [self.imageList count]) {
            cell.imageView.image = [self.imageList objectAtIndex:indexPath.row];
        }
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = v;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDownMenuWithBtnFrame:self.buttonFrame];
    
        [self.delegate setDropDownDelegate:self index:indexPath.row];
//    }

}
- (void) myDelegate {
    
    
}
-(void)dealloc {
    
}
@end
