//
//  InformationController.m
//  DragonLive
//
//  Created by LoaA on 2020/12/9.
//

#import "InformationController.h"
#import "SettingItemModel.h"
#import "SettingSectionModel.h"
#import "SettingCell.h"
#import "AccountSecurityController.h"
#import "AddBankCardController.h"
#import "MineProxy.h"
#import "ModifyNameController.h"

//#import <LCActionSheet/LCActionSheet.h>


typedef void (^ImageBlock)(UIImage *image);


@interface InformationController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/// section模型数组
@property (nonatomic, strong) NSArray  *sectionArray;

/// tableView
@property (nonatomic, strong) UITableView *tableView;
//图片block
@property (nonatomic, copy) ImageBlock imageBlock;

@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation InformationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"个人资料";
    self.view.backgroundColor = The_MainColor;
    
    [self initTableView];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getBankUser];
}

-(void)getBankUser{
    [MineProxy getBankCardSuccess:^(NSString * _Nonnull success) {
        [self setupSections];


    } failure:^(NSError * _Nonnull error) {
  
        [self setupSections];

    }];
}

-(void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTopHeight)style:UITableViewStyleGrouped];
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, kWidth(23), 0, kWidth(23))];
    }
    [self.tableView setSeparatorColor:[UIColor colorFromHexString:@"EEEEEE"]];
    self.tableView.backgroundColor = The_MainColor;
    self.tableView.dataSource = self;
//    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
}//初始化tableView


- (void)setupSections
{
    
    //************************************section1*******
    SettingItemModel *item1 = [[SettingItemModel alloc]init];
    item1.funcName = @"头像";
    item1.titleColor = TitleColor;
    item1.settingItemType = SettingItemTypeHeadImage;
    item1.executeCode = ^(SettingItemModel *model) {
        NSLog(@"头像");
        [self showAlertController:^(UIImage *image) {
            self->_imageView.image = image;
            model.detailImage = image;
            [self submitWithModel:model];
            [self.tableView reloadData];
        }];
    };
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[UserInstance shareInstance].userModel.headicon] placeholderImage:[UIImage imageNamed:@"headNomorl"]];
    }
    item1.accessoryType = SettingAccessoryTypeNone;
    item1.detailImage = _imageView.image;
    SettingItemModel *item2 = [[SettingItemModel alloc]init];
    item2.funcName =   @"昵称";
    item2.settingItemType = SettingItemTypeNickName;
    item2.count    = 10;
    //名字
//    if (_userModel.nickName.length == 0) {
        item2.detailText = [UserInstance shareInstance].userModel.nickname;
//    }else{
//        item2.detailText = _userModel.nickName;
//    }
    item2.detailColor = DetailColor;
    item2.titleColor = TitleColor;

    item2.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    item2.executeCode = ^(SettingItemModel *model) {
        NSLog(@"昵称");
        
        ModifyNameController *vc = [ModifyNameController new];
        [self.navigationController pushViewController:vc animated:YES];
        
//        SettingItemModel *editModel = [self getNewModel:model];
//        __block SettingItemModel *cellModel = model;
//        EditContentController *vc = [[EditContentController alloc]initWithModel:[self getNewModel:model] saveBlock:^(SettingItemModel * _Nonnull saveModel,BOOL isSave) {
//            if (isSave) {
//                cellModel.detailText = saveModel.detailText;
//                [self submitWithModel:cellModel];
//
//            }else{
//                cellModel.accessoryType = SettingAccessoryTypeDisclosureIndicator;
//            }
//
//            [self.tableView reloadData];
//        }];
//
//        [self.navigationController pushViewController:vc animated:YES];
    };
 
    SettingItemModel *item3 = [[SettingItemModel alloc]init];
    item3.funcName = @"账户与安全";
//    item3.detailText = [UserInstance shareInstance].userModel.phoneNum;
    item3.detailColor = DetailColor;
    item3.titleColor = TitleColor;
    item3.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    
    item3.executeCode = ^(SettingItemModel *model) {
        AccountSecurityController *vc = [AccountSecurityController new];
        [self.navigationController pushViewController:vc animated:YES];
        
    };

    SettingItemModel *item4 = [[SettingItemModel alloc]init];
    item4.funcName = @"银行卡";
    if ([UserInstance shareInstance].userModel.bankCard.length != 0) {
        item4.detailText = [UserInstance shareInstance].userModel.bankCard;
    }else{
        item4.detailText = @"未绑定";
    }
    item4.detailColor = DetailColor;
    item4.titleColor = TitleColor;
    item4.accessoryType = SettingAccessoryTypeDisclosureIndicator;
    item4.executeCode = ^(SettingItemModel *model) {
        AddBankCardController *vc = [AddBankCardController new];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    SettingSectionModel *section1 = [[SettingSectionModel alloc]init];
    section1.sectionHeaderHeight = kWidth(3);
    
    if ([[UserInstance shareInstance].userModel.userType isEqualToString:@"2"]) {
        section1.itemArray = @[item1,item2,item3,item4];
    }else{
        section1.itemArray = @[item1,item2,item3];
    }

    
    self.sectionArray = @[section1];
    [self.tableView reloadData];
}//组建model


// MARK: - 弹出AlertController
- (void)showAlertController:(ImageBlock)imageBlock
{
    self.imageBlock = imageBlock;
    
    
    ACActionSheet *actionSheet = [[ACActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"手机相册"] actionSheetBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [self selectImageFromCamera:self];
          
        }else if(buttonIndex == 1){
            [self selectImageFromAlbum:self];
        }
    }];
    [actionSheet show];
    
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"点击了拍照");
//        [self selectImageFromCamera:self];
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"点击了相册");
//        [self selectImageFromAlbum:self];
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//    [self presentViewController:alert animated:true completion:nil];
    
//    [LCActionSheet sheetWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitleArray:@[@"拍照",@"手机相册"]];

    
    
}//AlertController


// MARK: - 弹出相机界面
- (void)selectImageFromCamera:(UIViewController *)target
{
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [target presentViewController:picker animated:YES completion:nil];
    } else {
//        DebugLog(@"该设备无摄像头");
    }
}//弹出相机

// MARK: - 弹出相册界面
- (void)selectImageFromAlbum:(UIViewController *)target
{
    UIImagePickerController *picker = [UIImagePickerController new];
    //资源类型为图片库
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    [target presentViewController:picker animated:YES completion:nil];
}//弹出相册界面

// MARK: - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (img == nil) {
        img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    NSData *data = UIImagePNGRepresentation(img);
    float mb = 1024.0 * 1024.0 * 0.2;
    float size = [data length];
    if (size > mb) {
        img = [UntilTools imageWithImageSimple:img scaledToSize:CGSizeMake(img.size.width * mb / size, img.size.height * mb / size)];
    }
//    self.headImageView.image = img;
    __weak typeof(self) weakSelf = self;
    if (weakSelf.imageBlock) {
        weakSelf.imageBlock(img);
    }
}//选择图片的回调

-(void)submitWithModel:(SettingItemModel *)model
{
    [STTextHudTool showWaitText:@"上传中"];
    [MineProxy uploadImageWith:model.detailImage success:^(NSString * _Nonnull url) {
        [MineProxy modifyHeadImageWithPicGuid:url success:^(BOOL success) {
            [self showToast:@"修改头像成功"];
            [STTextHudTool hideSTHud];
        } failure:^(NSError * _Nonnull error) {
            [STTextHudTool hideSTHud];
        }];
    } failure:^(NSError * _Nonnull error) {
        [STTextHudTool hideSTHud];
    }];
}//提交数据

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return self.sectionArray.count;
}//section返回数量

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    SettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.itemArray.count;}//section下返回的数量

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"setting";
    SettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    SettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.item = itemModel;
//    cell.selectionStyle =
    return cell;
}//cell

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    SettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.sectionHeaderHeight;
}//header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}//footer的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWidth(50);
}//row的高度

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    SettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
   
//    if(itemModel.settingItemType == SettingItemTypeSign||itemModel.settingItemType == SettingItemTypeNickName){
//        if (_userModel.sign.length == 0) {
//            itemModel.detailText = @"";
//        }
//    }

    
    if (itemModel.executeCode) {
        itemModel.executeCode(itemModel);
    }
}//选择

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
