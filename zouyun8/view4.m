#import "view4.h"

@interface view4()<MZTimerLabelDelegate>
{
    UILabel *timer_show1;//倒计时label
    UILabel *timer_show2;//倒计时label
    UILabel *timer_show3;//倒计时label
}
@end

@implementation view4

-(void)awakeFromNib
{
    NSLog(@"唤醒了");
    //为图像增加点击事件
    [self.imageView1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalImageBtn1:)]];
    [self.imageView2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalImageBtn2:)]];
    [self.imageView3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personalImageBtn3:)]];
}

- (void)personalImageBtn1:(id)sender
{
    NSLog(@"%@",self.GoodsArray[0]);
    NSDictionary * dic = [[NSDictionary alloc]init];
    dic = self.GoodsArray[0];
    if ([self.delegate respondsToSelector:@selector(OpenHeGouDetail:)]) {
        [self.delegate OpenHeGouDetail:dic];
    }
}
- (void)personalImageBtn2:(id)sender
{
    if (self.GoodsArray.count>1) {
        NSDictionary * dic = [[NSDictionary alloc]init];
        dic = self.GoodsArray[1];
        if ([self.delegate respondsToSelector:@selector(OpenHeGouDetail:)]) {
            [self.delegate OpenHeGouDetail:dic];
        }

    }
   
   }
- (void)personalImageBtn3:(id)sender
{
    if (self.GoodsArray.count>2) {
        NSDictionary * dic = [[NSDictionary alloc]init];
        if (self.GoodsArray.count!=0) {
            dic = self.GoodsArray[2];
        }
        
        if ([self.delegate respondsToSelector:@selector(OpenHeGouDetail:)]) {
            [self.delegate OpenHeGouDetail:dic];
        }

    }
   // NSLog(@"%@",self.GoodsArray[2]);
   }
- (IBAction)OpenHeGou:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(OpenHeGou)]) {
        [self.delegate OpenHeGou];
    }
    
}
//
//-(CGFloat)widthOfString:(NSString *)string font:(UIFont *)font height:(CGFloat)height
//{
//    NSDictionary * dict=[NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
//    CGRect rect=[string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
//    return rect.size.width;
//}
//
//-(void)timeCount1:(NSTimeInterval)time
//{//倒计时函数
//    [self.countTime1 setHidden:YES];//把按钮原先的名字消掉
//    timer_show1 = [[UILabel alloc] initWithFrame:self.countTime1.frame];//UILabel设置成和UIButton一样的尺寸和位置
//    [self addSubview:timer_show1];//把timer_show添加到_dynamicCode_btn按钮上
//    MZTimerLabel *timer_cutDown1 = [[MZTimerLabel alloc] initWithLabel:timer_show1 andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
//    timer_cutDown1.tag = 1;
//    [timer_cutDown1 setCountDownTime:time];//倒计时时间60s
//    timer_cutDown1.timeFormat = @"mm:ss:SS";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
//    CGFloat wid = [self widthOfString:timer_cutDown1.timeLabel.text font:[UIFont systemFontOfSize:20.0] height:CGRectGetHeight(self.countTime1.frame)];
//     
//    CGRect frame = timer_cutDown1.timeLabel.frame;
//    frame.origin.x = ([UIScreen mainScreen].bounds.size.width/3 - wid)/2;
//    timer_cutDown1.timeLabel.frame = frame;
//    
//    timer_cutDown1.timeLabel.textColor = [UIColor redColor];//倒计时字体颜色
//    timer_cutDown1.timeLabel.font = [UIFont systemFontOfSize:20.0];//倒计时字体大小
//    
//    timer_cutDown1.delegate = self;//设置代理，以便后面倒计时结束时调用代理
//    self.countTime1.userInteractionEnabled = YES;//按钮禁止点击
//    [timer_cutDown1 start];//开始计时
//}
//
//-(void)timeCount2:(NSTimeInterval)time
//{
//    //倒计时函数
//    [self.countTime2 setHidden:YES];//把按钮原先的名字消掉
//    timer_show2 = [[UILabel alloc] initWithFrame:self.countTime2.frame];//UILabel设置成和UIButton一样的尺寸和位置
//    [self addSubview:timer_show2];//把timer_show添加到_dynamicCode_btn按钮上
//    MZTimerLabel *timer_cutDown2 = [[MZTimerLabel alloc] initWithLabel:timer_show2 andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
//    timer_cutDown2.tag = 2;
//    [timer_cutDown2 setCountDownTime:time];//倒计时时间60s
//    timer_cutDown2.timeFormat = @"mm:ss:SS";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
//    CGFloat wid = [self widthOfString:timer_cutDown2.timeLabel.text font:[UIFont systemFontOfSize:20.0] height:CGRectGetHeight(self.countTime1.frame)];
//    
//    CGRect frame = timer_cutDown2.timeLabel.frame;
//    frame.origin.x = [UIScreen mainScreen].bounds.size.width/3 + ([UIScreen mainScreen].bounds.size.width/3 - wid)/2;
//    timer_cutDown2.timeLabel.frame = frame;
//    
//    timer_cutDown2.timeLabel.textColor = [UIColor redColor];//倒计时字体颜色
//    timer_cutDown2.timeLabel.font = [UIFont systemFontOfSize:20.0];//倒计时字体大小
////    timer_cutDown2.timeLabel.textAlignment = NSTextAlignmentCenter;//剧中
//    timer_cutDown2.delegate = self;//设置代理，以便后面倒计时结束时调用代理
//    self.countTime2.userInteractionEnabled = YES;//按钮禁止点击
//    [timer_cutDown2 start];//开始计时
//
//}
//
//-(void)timeCount3:(NSTimeInterval)time
//{
//    //倒计时函数
//    [self.countTime3 setHidden:YES];//把按钮原先的名字消掉
//    timer_show3 = [[UILabel alloc] initWithFrame:self.countTime3.frame];//UILabel设置成和UIButton一样的尺寸和位置
//    [self addSubview:timer_show3];//把timer_show添加到_dynamicCode_btn按钮上
//    MZTimerLabel *timer_cutDown3 = [[MZTimerLabel alloc] initWithLabel:timer_show3 andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
//    timer_cutDown3.tag = 3;
//    [timer_cutDown3 setCountDownTime:time];//倒计时时间60s
//    timer_cutDown3.timeFormat = @"mm:ss:SS";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
//    
//    CGFloat wid = [self widthOfString:timer_cutDown3.timeLabel.text font:[UIFont systemFontOfSize:20.0] height:CGRectGetHeight(self.countTime1.frame)];
//    
//    CGRect frame = timer_cutDown3.timeLabel.frame;
//    frame.origin.x = [UIScreen mainScreen].bounds.size.width/3*2 + ([UIScreen mainScreen].bounds.size.width/3 - wid)/2;
//    timer_cutDown3.timeLabel.frame = frame;
//    
//
//    timer_cutDown3.timeLabel.textColor = [UIColor redColor];//倒计时字体颜色
//    timer_cutDown3.timeLabel.font = [UIFont systemFontOfSize:20.0];//倒计时字体大小
////    timer_cutDown3.timeLabel.textAlignment = NSTextAlignmentCenter;//剧中
//    timer_cutDown3.delegate = self;//设置代理，以便后面倒计时结束时调用代理
//    self.countTime1.userInteractionEnabled = YES;//按钮禁止点击
//    [timer_cutDown3 start];//开始计时
//
//}
//
////倒计时结束后的代理方法
//- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
//    if (timerLabel.tag == 1) {
//        [self.countTime1 setHidden:NO];
//        [timer_show1 removeFromSuperview];//移除倒计时模块
//      self.countTime1.userInteractionEnabled = YES;//按钮可以点击
//    }
//    else if (timerLabel.tag == 2) {
//        [self.countTime2 setTitle:@"发送验证码" forState:UIControlStateNormal];//倒计时结束后按钮名称改为"发送验证码"
//        [timer_show2 removeFromSuperview];//移除倒计时模块
//        [self.countTime2 setHidden:NO];
//        self.countTime2.userInteractionEnabled = YES;//按钮可以点击
//    }
//    else
//    {
//        [self.countTime3 setTitle:@"发送验证码" forState:UIControlStateNormal];//倒计时结束后按钮名称改为"发送验证码"
//        [timer_show3 removeFromSuperview];//移除倒计时模块
//        [self.countTime3 setHidden:NO];
//        self.countTime3.userInteractionEnabled = YES;//按钮可以点击
//    }
//}
//- (IBAction)倒计时1:(id)sender {
//}
- (IBAction)tips:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"合购公开专区:" message:@"发起者若没有足够多的好友参与合购，可将发起的合购公开，让其他走运网会员参与，有助于快速完成该合购。" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
}



@end
