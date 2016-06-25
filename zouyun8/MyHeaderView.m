#import "MyHeaderView.h"

@implementation MyHeaderView

//即将显示时从宏定义中获取用户信息到控件
- (void)awakeFromNib {
    [super awakeFromNib];
    self.userNameLabel.text = USER_NAME;
    //个人头像圆角
    self.personalImage.layer.cornerRadius = 35;
    self.personalImage.layer.masksToBounds = YES;
    //为个人图像增加点击事件
    [self.backImageViwe addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backImageBtn:)]];
    [self.personalImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalImageBtn:)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)充值:(id)sender {
    if([self.delegate respondsToSelector:@selector(reCharge)])
    {
        [self.delegate reCharge];
    }
}

- (IBAction)退出:(id)sender {
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出走运网" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        

        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"directLogin" object:nil];
   
        
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    //膜态时一定要判断你膜态的ViewController是不是空 ，空才能去膜态 、非空不能。
    if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController == nil)
        
    {
        
        
        [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:alertController  animated: NO completion:nil];
        
        
    }

//    //获取当前view的控制器 UIViewController
//    for (UIView* next = [self superview]; next; next = next.superview) {
//        UIResponder* nextResponder = [next nextResponder];
//        if ([nextResponder isKindOfClass:[UIViewController class]]) {
//            
//            
//            
//            
//             //[(UIViewController*)nextResponder presentViewController:alertController animated:YES completion:nil];
//        }
//    }
//   
    
    
   
}
- (void)personalImageBtn:(id)sender
{
    if([self.delegate respondsToSelector:@selector(changePersonalImage)])
    {
        [self.delegate changePersonalImage];
    }
}

- (void)backImageBtn:(id)sender
{
    if([self.delegate respondsToSelector:@selector(setInformation)])
    {
        [self.delegate setInformation];
    }
}

- (IBAction)setInformation:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(setUp)])
    {
        [self.delegate setUp];
    }
}
- (IBAction)明细:(id)sender {
    if ([self.delegate respondsToSelector:@selector(showMoneyDetail)])
    {
        [self.delegate showMoneyDetail];
    }
}

@end
