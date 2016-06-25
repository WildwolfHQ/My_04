#import "MyViewController.h"
#import "MyHeaderView.h"
#import "LoginViewController.h"
#import "MoneyDetailViewController.h"
#import "YongJinViewController.h"
#import "JiangJinViewController.h"
#import "AllOrderViewController.h"
#import "SetUpViewController.h"
#import "JointPurchaseViewController.h"
#import "GetGoodsViewController.h"
#import "MySaiSingleViewController.h"
#import "MyPartnerViewController.h"
@interface MyViewController ()<MyheaderViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MySectionHeaderDelegate>{
    UIImage *_iconImage;
    UILabel *labeldengji;
    UILabel *label;

}
@property(nonatomic,strong)NSArray * titles;
@property(nonatomic,strong)NSArray * imageIcons;
@property(nonatomic,strong)MyHeaderView * headerView;
@property(nonatomic,strong)MySectionHeader * SectionHeaderView;
@property(nonatomic,copy)NSString * url;

@property(nonatomic,assign)BOOL is_selected;
@end

@implementation MyViewController

-(void)viewWillAppear:(BOOL)animated
{
    
    NSLog(@"即将显示");
    self.navigationController.navigationBar.hidden = YES;

    
    [self loadData];
    
    
    
}
//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    self.titles = @[@[@"全部订单",@"获得的商品"],@[@"邀请二维码"],@[@"我的合伙人",@"我的消息",@"我的晒单",@"我的地址"],@[@"走运客服"]];
    self.imageIcons = @[@[IMAGE(@"ic_record"),IMAGE(@"ic_cup")],@[IMAGE(@"ic_wallet")],@[IMAGE(@"ic_coupon"),IMAGE(@"ic_heart"),IMAGE(@"ic_share"),IMAGE(@"baoshi_big"),IMAGE(@"ic_yuan")],@[IMAGE(@"ic_kefu")]];
    //加载表头视图
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MyHeaderView" owner:self options:nil];
    self.headerView = [nib objectAtIndex:0];
    self.headerView.delegate = self;
    self.headerView.frame = CGRectMake(0, 0, WIDTH,200);
    self.tableView.tableHeaderView = self.headerView;
   labeldengji=[[UILabel alloc]init];
    labeldengji.frame=CGRectMake(self.headerView.level.frame.origin.x+self.headerView.level.frame.size.width+4, self.headerView.level.frame.origin.y, 0, 0) ;
    labeldengji.textColor=[UIColor whiteColor];
    [self.headerView addSubview:labeldengji];
    
    label=  [[UILabel alloc]init];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"loadData" object:nil];
    
    
}


-(void)loadData{

    
    
    
    [ToolClass getUserInfoSuccess:^(NSDictionary *dic) {
        self.SectionHeaderView.yongjin.text = [NSString stringWithFormat:@"佣金:%.2f",[dic[@"data"][@"comm"] floatValue]];
        self.SectionHeaderView.prize.text = [NSString stringWithFormat:@"奖金:%@",dic[@"data"][@"score"]];
        
        
       
        
        
        
        
        NSString *str=ICON;
        if (str.length!=0)
        {
            
             [self changeImage:str];
//            if (self.is_selected == NO) {
//                //NSString * str = [NSString stringWithFormat:@"%@?t=%d",ICON,arc4random()%50000];
//               
//            }
//            if (self.is_selected == YES) {
//                NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//                NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
//                self.headerView.personalImage.image = [UIImage imageWithContentsOfFile:filePath];
//            }
            
        }else{
            
            [self.headerView.personalImage setImage:[UIImage imageNamed:@"star"]];
            
            
        }
        
        //视图将要显示时 显示用户余额和奖金等信息
        [ToolClass getPayInfo:^(NSDictionary *dic)
         {
             
             
             NSLog(@"用户账户为%@",dic);
             self.headerView.level.text = LEVEL;
             
             NSString * money = dic[@"data"][@"money"];
             CGFloat totalMoney = [money floatValue];
             self.headerView.money.text = [NSString stringWithFormat:@"%.2f走运币",totalMoney];
             labeldengji.font= self.headerView.level.font;
             NSString *str=EXP;
             labeldengji.text=[NSString stringWithFormat:@"(经验值：%@)",str];
             CGSize size = [labeldengji.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:labeldengji.font,NSFontAttributeName, nil]];
             // 名字的H
             CGFloat nameH = size.height;
             // 名字的W
             CGFloat nameW = size.width;
             
             
             labeldengji.frame =CGRectMake(self.headerView.level.frame.origin.x+self.headerView.level.frame.size.width+2,  self.headerView.level.frame.origin.y,nameW,nameH);
             
             
             
             NSString * type = TYPE;
             NSString * nick = NICK;
             if (nick.length != 0)
             {
                 if ([type integerValue] != 2){
                     if([type integerValue]==1){
                     
                         self.headerView.userNameLabel.text = [NSString stringWithFormat:@"%@",nick];
                         
                         
                      
                         
                         //判断
                         if (self.headerView.userNameLabel.frame.origin.x+self.headerView.userNameLabel.frame.size.width+65>=WIDTH) {
                             label.frame=CGRectMake(WIDTH-65, self.headerView.userNameLabel.frame.origin.y, 65, self.headerView.userNameLabel.frame.size.height);
                             self.headerView.userNameLabel.frame=CGRectMake(self.headerView.userNameLabel.frame.origin.x, self.headerView.userNameLabel.frame.origin.y, label.frame.origin.x-self.headerView.userNameLabel.frame.origin.x, self.headerView.userNameLabel.frame.size.height);
                             
                         }else{
                             label.frame =CGRectMake(self.headerView.userNameLabel.frame.origin.x+self.headerView.userNameLabel.frame.size.width, self.headerView.userNameLabel.frame.origin.y, 65, self.headerView.userNameLabel.frame.size.height);
                         }
                         [self.headerView addSubview:label];
                         label.text=@"(代理)";
                         label.font=self.headerView.userNameLabel.font;
                         label.textColor=[UIColor whiteColor];

                         
                         
                     }else{
                       self.headerView.userNameLabel.text = nick;
                     
                     }
                
                     
                 }
                 else
                 {
                     self.headerView.userNameLabel.text = [NSString stringWithFormat:@"%@",nick];
                     
                     //判断
                     if (self.headerView.userNameLabel.frame.origin.x+self.headerView.userNameLabel.frame.size.width+65>=WIDTH) {
                         label.frame=CGRectMake(WIDTH-65, self.headerView.userNameLabel.frame.origin.y, 65, self.headerView.userNameLabel.frame.size.height);
                    self.headerView.userNameLabel.frame=CGRectMake(self.headerView.userNameLabel.frame.origin.x, self.headerView.userNameLabel.frame.origin.y, label.frame.origin.x-self.headerView.userNameLabel.frame.origin.x, self.headerView.userNameLabel.frame.size.height);
                         
                     }else{
                         label.frame =CGRectMake(self.headerView.userNameLabel.frame.origin.x+self.headerView.userNameLabel.frame.size.width, self.headerView.userNameLabel.frame.origin.y, 65, self.headerView.userNameLabel.frame.size.height);
                     }
                     [self.headerView addSubview:label];
                     label.text=@"(试购员)";
                     label.font=self.headerView.userNameLabel.font;
                     label.textColor=[UIColor whiteColor];
                     
                 }
             }
             else
             {
                 if ([type integerValue] != 2)
                 {
                     if([type integerValue]==1){
                         
                         self.headerView.userNameLabel.text = [NSString stringWithFormat:@"%@",USER_NAME];
                         
                         
                    NSInteger lenth = [self getToInt:self.headerView.userNameLabel.text];
                         //判断
                         if (self.headerView.userNameLabel.frame.origin.x+lenth+65>=WIDTH) {
                             label.frame=CGRectMake(WIDTH-65, self.headerView.userNameLabel.frame.origin.y, 65, self.headerView.userNameLabel.frame.size.height);
                             self.headerView.userNameLabel.frame=CGRectMake(self.headerView.userNameLabel.frame.origin.x, self.headerView.userNameLabel.frame.origin.y, label.frame.origin.x-self.headerView.userNameLabel.frame.origin.x, self.headerView.userNameLabel.frame.size.height);
                             
                         }else{
                             label.frame =CGRectMake(self.headerView.userNameLabel.frame.origin.x+self.headerView.userNameLabel.frame.size.width, self.headerView.userNameLabel.frame.origin.y, 65, self.headerView.userNameLabel.frame.size.height);
                         }
                         [self.headerView addSubview:label];
                         label.text=@"(代理)";
                         label.font=self.headerView.userNameLabel.font;
                         label.textColor=[UIColor whiteColor];
                         
                         
                         
                     }else{
                         self.headerView.userNameLabel.text = nick;
                         
                     }
                     
                 }
                 else
                 {
                     self.headerView.userNameLabel.text = [NSString stringWithFormat:@"%@",USER_NAME];
                      //判断self.headerView.userNameLabel.frame.size.width(苹果公司字符串计算混合字符长度有误差)
                    NSInteger lenth = [self getToInt:self.headerView.userNameLabel.text];
                     if (self.headerView.userNameLabel.frame.origin.x+lenth+65>=WIDTH) {
                         label.frame=CGRectMake(WIDTH-65, self.headerView.userNameLabel.frame.origin.y, 65, self.headerView.userNameLabel.frame.size.height);
                         self.headerView.userNameLabel.frame=CGRectMake(self.headerView.userNameLabel.frame.origin.x, self.headerView.userNameLabel.frame.origin.y, label.frame.origin.x-self.headerView.userNameLabel.frame.origin.x, self.headerView.userNameLabel.frame.size.height);
                         
                     }else{
                         label.frame =CGRectMake(self.headerView.userNameLabel.frame.origin.x+self.headerView.userNameLabel.frame.size.width, self.headerView.userNameLabel.frame.origin.y, 65, self.headerView.userNameLabel.frame.size.height);
                     }
                     [self.headerView addSubview:label];
                     label.text=@"(试购员)";
                     label.font=self.headerView.userNameLabel.font;
                     label.textColor=[UIColor whiteColor];


                 }
             }
         }];

        
        
        
        
    }];


}
#pragma mark - 计算混合字符串长度
- (NSInteger)getToInt:(NSString*)strtemp

{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return [da length];
}

-(void)reCharge
{
    RechargeViewController * recharge = [[RechargeViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recharge animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark - headerView代理方法：走运币明细
-(void)showMoneyDetail
{
    //跳转到走运币明细界面
    MoneyDetailViewController * money = [[MoneyDetailViewController alloc]init];
    money.zouyunbi = self.headerView.money.text;
    [self.navigationController pushViewController:money animated:YES];
}

#pragma mark - 设置页面
-(void)setUp
{
    SetUpViewController * VC = [[SetUpViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
     self.hidesBottomBarWhenPushed = NO;
}


#pragma mark - 个人信息设置页面
-(void)setInformation
{
    ADViewController * ad = [[ADViewController alloc]init];
    ad.url = [NSString stringWithFormat:@"http://m.zouyun8.com/u/user_info/?uid=%@&token=%@",UID,TOKEN];
    [self.navigationController pushViewController:ad animated:YES];
}

#pragma mark - headerView代理方法：设置个人头像
-(void)changePersonalImage
{
    NSLog(@"开始调用相册");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf takePhoto];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf localPhoto];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:^{
            NSLog(@"取消准备照片");
        }];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
}
//打开相机
- (void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])//相机
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        [self presentViewController:picker animated:YES completion:^{
            NSLog(@"调取相机成功");
        }];
    }
    else{
        NSLog(@"模拟器情况下无法打开");
    }
}
//打开相册
- (void)localPhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])//相册
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{
            NSLog(@"调取相册成功");
        }];
    }
    else{
        NSLog(@"相册打不开应该是出问题了");
    }
}
//当选择一张图片后进入到这个协议方法里
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.is_selected = YES;
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        _iconImage=image;
        NSData *data1;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data1 = UIImageJPEGRepresentation(image, 1);
        }
        else
        {
            data1 = UIImagePNGRepresentation(image);
        }
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data1 attributes:nil];
        //得到选择后沙盒中图片的完整路径
        NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        
        long long abc = [self fileSizeAtPath:filePath];
        NSLog(@"%@",filePath);
        if (abc < 1024000) {
            NSLog(@"小于1m");
            //直接上传
            [self postPersonalImage:data1];
        }
        else {
            NSLog(@"压缩至1m以内");
            //如果图片尺寸大于1m则压缩
            data1 = [self reSizeImageData:[UIImage imageWithData:data1] maxImageSize:70 maxSizeWithKB:64];
            //上传到服务器
            [self postPersonalImage:data1];
        }
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            NSLog(@"关闭相册界面");
        }];
//        [self.tableView reloadData];
    }
}
//判断文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//压缩图片
-(NSData *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize
{
    if (maxSize <= 0.0) maxSize = 1024.0;
    if (maxImageSize <= 0.0) maxImageSize = 1024.0;
    
    //先调整分辨率
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / maxImageSize;
    CGFloat tempWidth = newSize.width / maxImageSize;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    CGFloat sizeOriginKB = imageData.length / 1024.0;
    
    CGFloat resizeRate = 0.9;
    while (sizeOriginKB > maxSize && resizeRate > 0.1) {
        imageData = UIImageJPEGRepresentation(newImage,resizeRate);
        sizeOriginKB = imageData.length / 1024.0;
        resizeRate -= 0.1;
    }
    return imageData;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"您取消了选择图片222");
    }];
}
//上传图像
-(void)postPersonalImage:(NSData *)data
{
    /*
     此段代码如果需要修改，可以调整的位置
     1. 把upload.php改成网站开发人员告知的地址
     2. 把file改成网站开发人员告知的字段名
     */
    //AFN3.0+基于封住HTPPSession的句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    NSDictionary *dict = @{@"token":TOKEN,@"uid":UID,@"type":@"1"};
    
    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
    [manager POST:@"https://m.zouyun8.com/api/upload_image" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        //上传
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"]
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        [formData appendPartWithFileData:data name:@"upfile" fileName:fileName mimeType:@"image/png"];
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSString * errcode = dict[@"errcode"];
        if ([errcode integerValue]) {
            [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
        }
        else
        {
            
            [self.headerView.personalImage setImage:_iconImage];
            //上传成功
            NSLog(@"%@",dict[@"data"]);
//            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            //将最新图像地址保存到本地
            [ToolClass savePersonalImageUrl:dict[@"data"][@"url"]];
            self.url = dict[@"data"][@"url"];
            NSLog(@"图像的url地址为%@",dict[@"data"][@"url"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败 %@", error);
    }];
}

//变更图像
-(void)changeImage:(NSString *)url
{
    NSString * str = [NSString stringWithFormat:@"%@?t=%d",url,arc4random()%50000];
    [self.headerView.personalImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@""]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titles.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==self.titles.count) {
        return 1;
    }
    NSArray * array = self.titles[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    
    if (indexPath.section ==self.titles.count ) {
        
        UITableViewCell*cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        FooterView * footerview1 = [[NSBundle mainBundle]loadNibNamed:@"FooterView" owner:self
                                                              options:nil].firstObject;
        footerview1.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
        
        [cell addSubview:footerview1];
        cell.userInteractionEnabled=NO;
        
        return cell;
        
    }
    
    
    static NSString * ID = @"cell";
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
        cell.imageView.image = self.imageIcons[indexPath.section][indexPath.row];
        cell.textLabel.text =  self.titles[indexPath.section][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == 3) {
        AddAddressController * add = [[AddAddressController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:add animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        AllOrderViewController * allOrder = [[AllOrderViewController alloc]init];
        [self.navigationController pushViewController:allOrder animated:YES];
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        GetGoodsViewController * VC = [[GetGoodsViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        InviteViewController * Invite = [[InviteViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:Invite animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        MyPartnerViewController * VC = [[MyPartnerViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        MyMessageViewController * msg = [[MyMessageViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:msg animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
    if (indexPath.section == 2 && indexPath.row == 2) {
        MySaiSingleViewController * VC = [[MySaiSingleViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    if (indexPath.section == 3 && indexPath.row == 0) {
        ServiceViewController * msg = [[ServiceViewController alloc]init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:msg animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section ==self.titles.count ) {
    
        return 0.0001;
    }
    if (section == 0)
    {
        return 60;
    }
    else
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        //获取到组头视图
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MySectionHeader" owner:self options:nil];
        self.SectionHeaderView = [nib objectAtIndex:0];
        self.SectionHeaderView.frame = CGRectMake(0, 0, WIDTH,60);
        self.SectionHeaderView.backgroundColor = [UIColor whiteColor];
        self.SectionHeaderView.delegate = self;
        [self.SectionHeaderView.faqidehegou addTarget:self action:@selector(pushTofaqidehegou) forControlEvents:UIControlEventTouchUpInside];

        return self.SectionHeaderView;
        
        
        
    }
    else
        return nil;
}

-(void)pushToYongJin
{
    //跳转到明细界面
    YongJinViewController * yongjin = [[YongJinViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:yongjin animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)pushToJiangJin
{
    //跳转到奖金明细界面
    JiangJinViewController * jiangjin = [[JiangJinViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jiangjin animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
-(void)pushTofaqidehegou{

    JointPurchaseViewController * VC = [[JointPurchaseViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
@end
