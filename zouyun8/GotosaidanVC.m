//
//  GotosaidanVC.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/21.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "GotosaidanVC.h"
#import "SZAddImage.h"
@interface GotosaidanVC ()
@property (strong,nonatomic) SZAddImage * sZAddImage;

@end

@implementation GotosaidanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(up)];
    
    self.navigationItem.rightBarButtonItem=barbtn;
    
    self.scroview.contentSize=CGSizeMake(WIDTH, self.view.frame.size.height);
    [self.image sd_setImageWithURL:[NSURL URLWithString:self.model.thumb]];
     self.name.text=self.model.name;
    self.sZAddImage=[[SZAddImage alloc]init];
    self.sZAddImage.frame=CGRectMake(0, self.xinqing.frame.origin.y+CGRectGetHeight(self.xinqing.frame)+5, WIDTH, 300);
    if (iPhone4||iPhone5) {
        self.sZAddImage.theimageW=65;
    }else{
    
        self.sZAddImage.theimageW=100;
    
    }
    
    [self.view addSubview:self.sZAddImage];
    self.sZAddImage.backgroundColor=[UIColor whiteColor];
    
   // self.xinqing.editable=YES;
    [self.xinqing becomeFirstResponder];
    
    
    //self.scroview.contentSize =CGSizeMake(self.scroview.frame.size.width, <#CGFloat height#>)        CGRectMake(0, 64, WIDTH, self.;
    
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touch)];
    [self.scroview addGestureRecognizer:tap1];
     UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touch)];
     [self.sZAddImage addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touch{
 [self.xinqing endEditing:YES];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.scroview endEditing:YES];
   
}

-(void)up{
    [self.xinqing endEditing:YES];
   
    
    
    if (self.sZAddImage.images.count!=0) {
       
        NSMutableArray *imagedata=[[NSMutableArray alloc]init];
        for (UIImage *image in self.sZAddImage.images) {
            NSData *data1;
            if (UIImagePNGRepresentation(image) == nil)
            {
                data1 = UIImageJPEGRepresentation(image, 1);
            }
            else
            {
                data1 = UIImagePNGRepresentation(image);
            }
            
            //如果图片尺寸大于1m则压缩
            data1 = [self reSizeImageData:[UIImage imageWithData:data1] maxImageSize:70 maxSizeWithKB:40];

            [imagedata addObject:data1];
            
        }
        
        
     
        if(self.xinqing.text.length!=0){
          [SVProgressHUD showWithStatus:@"上传中.."];
          [self postPersonalImage:imagedata];
        
        }else{
        
           [SVProgressHUD showErrorWithStatus:@"你还没有填写心情"];
        }
        
        
    }else {
    
        [SVProgressHUD showErrorWithStatus:@"你还没有选择图片"];
    
    }
    
    
    
    
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
-(void)upload:(NSMutableDictionary *)dic{

//    uid	long	必须	用户ID
//    token	string	必须	用户标识
//    id	long	必须	晒单id，参考晒单列表接口
//    title	string	必须	晒单标题
//    content	string	必须	晒单内容
//    imgs	string	必须	晒单图片
    
    
    //post请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = UID;
    params[@"token"] = TOKEN;
    params[@"id"] = dic[@"id"];
    params[@"title"] = dic[@"title"];
//    params[@"content"] = dic[@"content"];
    params[@"imgs"] = dic[@"imgs"];

    
    [HttpRequest postWithURLString:@"http://zy8.jf-q.com/api/evaluate_add" parameters:params success:^(id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         NSNumber * errcode = dict[@"errcode"];
         NSLog(@"%@",errcode);
         
         if ([errcode integerValue]==0) {
            [SVProgressHUD showErrorWithStatus:@"晒单成功"];
             [SVProgressHUD dismiss];
             [self.navigationController popViewControllerAnimated:YES];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"shaidanFinish" object:nil];
         }
         else
         {   //登录成功,返回并加载个人信息
             [SVProgressHUD dismiss];
             [SVProgressHUD showErrorWithStatus:@"上传失败"];
         }
     } failure:^(NSError *error) {
         [SVProgressHUD dismiss];
     }];

}



//上传图像
-(void)postPersonalImage:(NSArray *)imageData
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
    NSDictionary *dict = @{@"token":TOKEN,@"uid":UID,@"type":@"0"};
    
    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
    [manager POST:@"https://m.zouyun8.com/api/upload_image_multi" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        int i;
        for (NSData *data in imageData) {
            
            
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
            
            i++;
            [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"upfile[%@]",@(i)] fileName:fileName mimeType:@"image/png"];
        }
       
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        
        NSString * errcode = dict[@"errcode"];
        if ([errcode integerValue]==0) {
            //[SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
            NSArray *array=dict[@"data"];
            NSString *imageStr=@"";
            for (NSDictionary *dict1 in array) {
                
                if ([dict1[@"errcode"] integerValue]==0) {
                     NSString *url=dict1[@"url"];
                     if (array.lastObject!=dict1) {
                        
                         
                         imageStr=[imageStr stringByAppendingString:[NSString stringWithFormat:@"%@,",url]];
                     }else{
                        
                         
                         imageStr=[imageStr stringByAppendingString:[NSString stringWithFormat:@"%@",url]];
                     }
                    
                    
                    

                }else{
                
                
                }
                
                
            }
            
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
            
            dic[@"id"]=self.model.ID;
            dic[@"title"]=self.xinqing.text;
            //dic[@"content"]=self.xinqing.text;
            
            dic[@"imgs"]=imageStr;
            
            [self upload:dic];
            
          
        }
        else
        {
            [SVProgressHUD dismiss];
           [SVProgressHUD showSuccessWithStatus:@"上传图片失败"];

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
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
