//
//  ReportRoomViewController.m
//  DragonLive
//
//  Created by 11号 on 2020/12/11.
//

#import "ReportRoomViewController.h"
#import "HttpRequest.h"
#import "ReportRoom.h"
#import "EasyShowView.h"
#import "MineProxy.h"
#import "EasyLoadingView.h"

typedef void (^ImageBlock)(UIImage *image);

@interface ReportRoomViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UIView *bgView;                //底层view
@property (nonatomic, weak) IBOutlet UIView *contentView;           //举报类型 super view
@property (nonatomic, weak) IBOutlet UITextView *infoTextView;      //textView placeholder
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;   //联系方式
@property (nonatomic, weak) IBOutlet UILabel *endNumLab;            //字数限制
@property (nonatomic, weak) IBOutlet UILabel *noticeLab;            //textView placeholder
@property (nonatomic, weak) IBOutlet UIButton *submitBut;           
@property (nonatomic, strong) UIButton *addImageBut;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *butArray;             //举报类型按钮集合
@property (nonatomic, strong) NSMutableArray *imageArray;           //上传图片数据集合
@property (nonatomic, copy) NSString *upImgUrlStr;                  //上传图片url拼接
@property (nonatomic, copy) ImageBlock imageBlock;
@property (nonatomic, assign) NSInteger addImgCount;                //记录上传图片个数（最大三张图片）
@property (nonatomic, strong) ReportRoom *selectReport;             //记录选择的举报原因

@end

static NSInteger MAX_LIMIT_NUMS = 100;

@implementation ReportRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"举报房间";
    self.imageArray = [NSMutableArray array];
    
    [self requestReportClasss];
    [self setup];
}

- (void)setup
{
    UIButton *addImgBut = [[UIButton alloc] initWithFrame:CGRectMake(11, 317, 80, 80)];
    [addImgBut setImage:[UIImage imageNamed:@"report_addImgIcon"] forState:UIControlStateNormal];
    [addImgBut addTarget:self action:@selector(addImageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:addImgBut];
    self.addImageBut = addImgBut;
}

- (void)setupImageWithImage:(UIImage *)image {
    if ([self.infoTextView.text length] > 0) {
        self.submitBut.enabled = YES;
    }
    UIImageView *addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11+self.addImgCount*100, 317, 80, 80)];
    addImageView.layer.cornerRadius = 4.0;
    addImageView.layer.masksToBounds = YES;
    addImageView.image = image;
    [self.bgView addSubview:addImageView];
    [self.imageArray addObject:image];
    
    self.addImageBut.hidden = self.addImgCount == 2;
    [UIView animateWithDuration:0.2 animations:^{
        self.addImageBut.frame = CGRectMake(CGRectGetMaxX(addImageView.frame) + 20, 317, 80, 80);
    }];
}

- (void)addImageAction
{
    [self showAlertController:^(UIImage *image) {
        [self setupImageWithImage:image];
        self.addImgCount++;
    }];
}

- (IBAction)submitAction:(id)sender
{
    [EasyLoadingView showLoadingText:@"正在提交..."];
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue= dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    for (NSInteger i=0; i<self.imageArray.count; i++) {

        dispatch_group_async(group, queue, ^{
            UIImage *upImage = [self.imageArray objectAtIndex:i];
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setObject:[UntilTools convertImage:upImage] forKey:@"base64"];
            [params setObject:[NSString stringWithFormat:@"1111%@",[UntilTools getImageName:upImage]] forKey:@"fileName"];

            [HttpRequest requestWithURLType:UrlTypeUpLoadingFile parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
                int code = [[responseObject objectForKey:@"code"]intValue];
                if (code == RequestSuccessCode) {
                    NSDictionary *data = responseObject[@"data"];
                    if (self.upImgUrlStr) {
                        self.upImgUrlStr = [NSString stringWithFormat:@"%@,%@",self.upImgUrlStr,data[@"url"]];
                    }else {
                        self.upImgUrlStr = data[@"url"];
                    }
                }
                dispatch_semaphore_signal(semaphore);
            } failure:^(NSError * _Nonnull error) {
                dispatch_semaphore_signal(semaphore);
            }];

            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //所有请求返回数据后执行
        [self requestReport];
    });
//
//    for (NSInteger i=0; i<self.imageArray.count; i++) {
//        UIImage *upImage = [self.imageArray objectAtIndex:i];
//        [self submitWithImage:upImage];
//    }

}

- (void)typeSelectAction:(UIButton *)but
{
    for (int i=0; i<self.dataArray.count; i++) {
        ReportRoom *rModel = [self.dataArray objectAtIndex:i];
        UIButton *button = [self.butArray objectAtIndex:i];
        if (i == but.tag) {
            rModel.isSelect = YES;
            self.selectReport = rModel;
            [button setImage:[UIImage imageNamed:@"icon_single_sel"] forState:UIControlStateNormal];
        }else {
            rModel.isSelect = NO;
            [button setImage:[UIImage imageNamed:@"icon_single_unSel"] forState:UIControlStateNormal];
        }
    }
}

/// 举报类型
- (void)requestReportClasss
{
    __weak __typeof(self)weakSelf = self;
    [HttpRequest requestWithURLType:UrlTypeReportRoomClass parameters:nil type:HttpRequestTypeGet success:^(id  _Nonnull responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code==200) {
            NSMutableArray *arr = responseObject[@"data"][@"items"];
            strongSelf.dataArray = [NSMutableArray arrayWithCapacity:arr.count];
            strongSelf.butArray = [NSMutableArray arrayWithCapacity:arr.count];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ReportRoom *model = [ReportRoom modelWithDictionary:obj];
                if (idx == 0) {
                    model.isSelect = YES;
                    strongSelf.selectReport = model;
                }
                [strongSelf.dataArray addObject:model];
            }];
            if (strongSelf.dataArray.count) {
                [strongSelf creatReportClassInfoView];
            }
        }
        
    } failure:^(NSError * _Nonnull error) {

    }];
}

/// 举报
- (void)requestReport
{
    NSString *tofsId = @"";
    for (int i=0; i<self.dataArray.count; i++) {
        ReportRoom *rModel = [self.dataArray objectAtIndex:i];
        if (rModel.isSelect) {
            tofsId = rModel.tofsId;
        }
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"tofsId"] = tofsId;
    params[@"desp"] = _infoTextView.text;
    params[@"defendant"] = _streamerId;
    params[@"contactWay"] = _phoneTextField.text;
    params[@"imgUrl"] = self.upImgUrlStr;
    
    __weak __typeof(self)weakSelf = self;
    [HttpRequest requestWithURLType:UrlTypeReportRoom parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [EasyLoadingView hidenLoading];
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code==200) {
            [EasyTextView showText:@"提交成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.navigationController popViewControllerAnimated:YES];
             });
            
        }else {
            [EasyTextView showText:@"提交失败"];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [EasyTextView showText:@"提交失败"];
        [EasyLoadingView hidenLoading];
    }];
}

//创建举报类型item view
- (void)creatReportClassInfoView
{
    NSInteger count = 3;                //每行显示个数
    CGFloat leading = 15;               //左右间距
    CGFloat rowSpace = 10.0;            //列间距
    CGFloat itemViewHeight = 30.0;
    CGFloat itemViewWidth = (kkScreenWidth - leading*2 - rowSpace*(count - 1)) / count;
    
    for (int i=0; i<self.dataArray.count; i++) {
        ReportRoom *rModel = [self.dataArray objectAtIndex:i];
        CGRect rect = CGRectMake(leading + (rowSpace + itemViewWidth) * (i%count), i/count * itemViewHeight, itemViewWidth, itemViewHeight);
        UIView *itemView = [self creatButItemWithRect:rect model:rModel index:i];
        [self.contentView addSubview:itemView];
    }
}

- (UIView *)creatButItemWithRect:(CGRect)rect model:(ReportRoom *)rmodel index:(int)index
{
    UIView *itemView = [[UIView alloc] initWithFrame:rect];
    itemView.backgroundColor = [UIColor clearColor];
    
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    but.tag = index;
    [but addTarget:self action:@selector(typeSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:but];
    if (rmodel.isSelect) {
        [but setImage:[UIImage imageNamed:@"icon_single_sel"] forState:UIControlStateNormal];
    }else {
        [but setImage:[UIImage imageNamed:@"icon_single_unSel"] forState:UIControlStateNormal];
    }
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, rect.size.width - 30, 30)];
    nameLab.font = [UIFont systemFontOfSize:13];
    nameLab.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1.0];
    nameLab.text = rmodel.name;
    [itemView addSubview:nameLab];
    
    [self.butArray addObject:but];
    
    return itemView;
}

// MARK: - 弹出AlertController
- (void)showAlertController:(ImageBlock)imageBlock
{
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
    float mb = 1024.0 * 1024.0 * 0.5;
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

-(void)submitWithImage:(UIImage *)rpImage
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:[UntilTools convertImage:rpImage] forKey:@"base64"];
    [params setObject:[NSString stringWithFormat:@"1111%@",[UntilTools getImageName:rpImage]] forKey:@"fileName"];
    
    [HttpRequest requestWithURLType:UrlTypeUpLoadingFile parameters:params type:HttpRequestTypePost success:^(id  _Nonnull responseObject) {
        int code = [[responseObject objectForKey:@"code"]intValue];
        if (code == RequestSuccessCode) {
            NSDictionary *data = responseObject[@"data"];
            if (self.upImgUrlStr) {
                self.upImgUrlStr = [NSString stringWithFormat:@"%@,%@",self.upImgUrlStr,data[@"url"]];
            }else {
                self.upImgUrlStr = data[@"url"];
            }
        }
    } failure:^(NSError * _Nonnull error) {

    }];
}//提交数据

-(BOOL) textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text rangeOfString:@"\n"].length > 0) {

          [textView resignFirstResponder];

          return NO;

      }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            self.endNumLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)MAX_LIMIT_NUMS,(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
 
}
 
- (void)textViewDidChange:(UITextView *)textView
{
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        existTextNum = MAX_LIMIT_NUMS;
        
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数
    self.endNumLab.text = [NSString stringWithFormat:@"%ld/%ld",existTextNum,(long)MAX_LIMIT_NUMS];

    if (existTextNum == 0) {
        self.noticeLab.hidden = NO;
        self.submitBut.enabled = NO;
    }else {
        self.noticeLab.hidden = YES;
        
        if (self.selectReport && self.addImgCount > 0 ) {
            self.submitBut.enabled = YES;
        }
    }
}

@end
