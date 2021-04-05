//
//  ApplyAnchorDataController.m
//  DragonLive
//
//  Created by LoaA on 2020/12/28.
//

#import "ApplyAnchorDataController.h"
#import "ApplyAnchorTextView.h"
#import "ApplyAnchorIdCardView.h"
#import "MineProxy.h"
#import "UIScrollView+util.h"
#import "LeftRightTextField.h"


typedef void (^ImageBlock)(UIImage *image);

@interface ApplyAnchorDataController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/// 名字
@property (nonatomic, strong) ApplyAnchorTextView *nameView;

/// 身份证
@property (nonatomic, strong) ApplyAnchorTextView *idCard;

/// 身份证正面
@property (nonatomic, strong) ApplyAnchorIdCardView *idCardPositive;

/// 身份证反面
@property (nonatomic, strong) ApplyAnchorIdCardView *idCardNegative;

/// 身份证手持
@property (nonatomic, strong) ApplyAnchorIdCardView *idCardHands;

/// 当前选中的imageView
@property (nonatomic, strong) ApplyAnchorIdCardView *currentView;

//scrollView
@property (nonatomic, strong) UIScrollView *scrollView;

//图片block
@property (nonatomic, copy) ImageBlock imageBlock;

@property (nonatomic, strong) UIButton *submit;

@end

@implementation ApplyAnchorDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申请直播";
    self.view.backgroundColor = The_MainColor;
    [self initScrollView];
    [self initView];
    // Do any additional setup after loading the view.
}


-(void)initScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight-kTopHeight-kBottomSafeHeight)];
//    self.scrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    self.scrollView.pagingEnabled = NO;
    self.scrollView.userInteractionEnabled = YES;
//    self.scrollView.scrollEnabled = NO;
//    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, kWidth(908));
//    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, kMainViewHeight) animated:NO];
    [self.view addSubview:self.scrollView];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUiscrollView)];
    //设置手势属性
    tapGesture.numberOfTapsRequired=1;//设置点按次数，默认为1，注意在iOS中很少用双击操作
    tapGesture.numberOfTouchesRequired=1;//点按的手指数
    [self.scrollView addGestureRecognizer:tapGesture];
    
}
-(void)tapUiscrollView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

}

-(void)initView{
    _nameView = [[ApplyAnchorTextView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kWidth(88)) title:@"*名字" placeholder:@"请输入姓名"];
    [self.scrollView addSubview:_nameView];
    
    
    _idCard = [[ApplyAnchorTextView alloc]initWithFrame:CGRectMake(0, _nameView.bottom, kScreenWidth, kWidth(88)) title:@"*身份证号码" placeholder:@"请输入身份证号码"];
    _idCard.textField.keyboardType = UIKeyboardTypeASCIICapable;
    [self.scrollView addSubview:_idCard];
    
    
    
    _idCardPositive = [[ApplyAnchorIdCardView alloc]initWithFrame:CGRectMake(0, _idCard.bottom+kWidth(27), kScreenWidth, kWidth(157))title:@"*身份证正面" imageNamed:@"idCardPositive"];
    [self.scrollView addSubview:_idCardPositive];
    
    
    _idCardNegative = [[ApplyAnchorIdCardView alloc]initWithFrame:CGRectMake(0, _idCardPositive.bottom+kWidth(15), kScreenWidth, kWidth(157))title:@"*身份证反面" imageNamed:@"idCardNegative"];
    [self.scrollView addSubview:_idCardNegative];
    
    
    _idCardHands =  [[ApplyAnchorIdCardView alloc]initWithFrame:CGRectMake(0, _idCardNegative.bottom+kWidth(13), kScreenWidth, kWidth(157))title:@"*手持身份证" imageNamed:@"idCardHands"];
    [self.scrollView addSubview:_idCardHands];

    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(kWidth(37), _idCardHands.bottom+kWidth(35), kScreenWidth-kWidth(37*2), kWidth(40))];
    
    lab.font = [UIFont systemFontOfSize:kWidth(12)];
    lab.numberOfLines = 0;
    lab.textColor = SelectedBtnColor;
    lab.text = @"1.支持JPG,PNG格式，2M以内\n2.非大陆用户请使用当地的相关证件照";
    [self.scrollView addSubview:lab];
    
    _submit = [[UIButton alloc]initWithFrame:CGRectMake(kWidth(37), lab.bottom+kWidth(20), lab.width, kWidth(41))];
    [_submit addTarget:self action:@selector(submitBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [_submit setTitle:@"提交" forState:UIControlStateNormal];
    [_submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submit.titleLabel.font = [UIFont systemFontOfSize:kWidth(19)];
    _submit.backgroundColor = UnSelectedBtnColor;
    _submit.userInteractionEnabled = NO;
    [_submit setCornerWithType:UIRectCornerAllCorners Radius:_submit.width/2];
    [self.scrollView addSubview:_submit];
    
    
    //block
    kWeakSelf(self);
    _idCard.textField.textFieldDidChange = ^(NSString * _Nonnull text) {
        weakself.idCard.textField.text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (text.length > 18) {
            weakself.idCard.textField.text = [text substringToIndex:18];
        }
        [weakself noticationSubmitBtn];
    };
        
    _nameView.textField.textFieldDidChange = ^(NSString * _Nonnull text) {
        weakself.nameView.textField.text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (text.length > 20) {
            weakself.nameView.textField.text = [text substringToIndex:20];
        }
        [weakself noticationSubmitBtn];
    };
    
    _idCardPositive.selectedThumbBlock = ^(ApplyAnchorIdCardView * _Nonnull currentView) {
    
        weakself.currentView = currentView;
        [weakself showImagePicker];
    };
    
    _idCardPositive.cancelBlock = ^{
        [weakself noticationSubmitBtn];
    };
    
    _idCardNegative.selectedThumbBlock = ^(ApplyAnchorIdCardView * _Nonnull currentView) {
        weakself.currentView = currentView;
        [weakself showImagePicker];
    };
    _idCardNegative.cancelBlock = ^{
        [weakself noticationSubmitBtn];
    };
    _idCardHands.selectedThumbBlock =^(ApplyAnchorIdCardView * _Nonnull currentView) {
        weakself.currentView = currentView;
        [weakself showImagePicker];
    };
    _idCardHands.cancelBlock = ^{
        [weakself noticationSubmitBtn];
    };
}


-(void)noticationSubmitBtn
{
    if (_nameView.textField.text.length != 0 &&_idCard.textField.text.length != 0&& _idCardPositive.isSelected && _idCardNegative.isSelected && _idCardHands.isSelected) {
      
        _submit.backgroundColor = SelectedBtnColor;
        _submit.userInteractionEnabled = YES;
          
    }else{
        _submit.backgroundColor = UnSelectedBtnColor;
        _submit.userInteractionEnabled = NO;
    }
}



-(void)submitBtnOnClick
{
    if (_nameView.textField.text.length == 0) {
        [[HCToast shareInstance]showToast:@"请输入名字"];
        return;
    }
    
    if (_nameView.textField.text.length < 2 || _nameView.textField.text.length > 20) {
        [self showToast:@"名字长度2-20个字符"];
        return;
    }
    
    if (![UntilTools validateIDCardNumber:_idCard.textField.text]) {
        [[HCToast shareInstance]showToast:@"身份证号码格式不正确"];
        return;
    }
    
    if (!_idCardPositive.isSelected) {
        [[HCToast shareInstance]showToast:@"请上传身份证正面照片"];
        return;
    }
    
    if (!_idCardNegative.isSelected) {
        [[HCToast shareInstance]showToast:@"请上传身份证反面照片"];
        return;
    }
    
    if (!_idCardHands.isSelected) {
        [[HCToast shareInstance]showToast:@"请上传手持身份证照片"];
        return;
    }
    
    [STTextHudTool showWaitText:@"请求中..."];
    [MineProxy hostApplyLiveWithVerificationCode:self.codeText phoneNum:self.phoneText realName:_nameView.textField.text idCard:_idCard.textField.text idImgFrontUrlGuid:_idCardPositive.imageUrl idImgBackUrlGuid:_idCardNegative.imageUrl idImgHandUrlGuid:_idCardHands.imageUrl success:^(BOOL isSuccess) {
        [STTextHudTool hideSTHud];
        [self showToast:@"申请成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError * _Nonnull error) {
        [STTextHudTool hideSTHud];
        [self showToast:@"申请失败"];
    }];
    
}//提交按钮点击执行

#pragma mark-- 以下是相机的东西.
-(void)showImagePicker{
    kWeakSelf(self);
    [self showAlertController:^(UIImage *image) {
        
        [STTextHudTool showWaitText:@"上传中..."];
        [MineProxy uploadImageWith:image success:^(NSString * _Nonnull url) {
            weakself.currentView.imageView.image = image;
            weakself.currentView.isSelected = YES;
            weakself.currentView.imageUrl = url;
            [weakself noticationSubmitBtn];
            [self showToast:@"上传成功"];
            [STTextHudTool hideSTHud];
        } failure:^(NSError * _Nonnull error) {
            [self showToast:@"上传失败"];
            [STTextHudTool hideSTHud];
        }];
      
    }];
}//照片照片


// MARK: - 弹出AlertController
- (void)showAlertController:(ImageBlock)imageBlock {
    self.imageBlock = imageBlock;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了拍照");
        [self selectImageFromCamera:self];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了相册");
        [self selectImageFromAlbum:self];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}
// MARK: - 弹出相机界面
- (void)selectImageFromCamera:(UIViewController *)target{
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
//        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [target presentViewController:picker animated:YES completion:nil];
    } else {
//        DebugLog(@"该设备无摄像头");
    }
}
// MARK: - 弹出相册界面
- (void)selectImageFromAlbum:(UIViewController *)target{
    UIImagePickerController *picker = [UIImagePickerController new];
    //资源类型为图片库
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    picker.allowsEditing = YES;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;

    [target presentViewController:picker animated:YES completion:nil];
}
// MARK: - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (img == nil) {
        img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
//    CGFloat scaleSize = 0.2f;
//    UIImage *smallImage = [UIImage imageWithCGImage:img.CGImage scale:scaleSize orientation:img.imageOrientation];
    
    NSData *data = UIImagePNGRepresentation(img);
    float mb = 1000 * 1000 * 0.7;
    float size = [data length];
    if (size > mb) {
        img = [self imageWithImageSimple:img scaledToSize:CGSizeMake(img.size.width * mb / size, img.size.height * mb / size)];
    }
    __weak typeof(self) weakSelf = self;
    if (weakSelf.imageBlock) {
        weakSelf.imageBlock(img);
    }
}

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}//

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
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
