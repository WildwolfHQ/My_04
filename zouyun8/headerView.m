#import "headerView.h"

@implementation headerView

//滑动下划线，按钮变色
-(void)swipe:(UIButton *)b
{
    for (int i=0; i<4; i++)
    {
        UIButton *btn = [self viewWithTag:10+i];
        btn.selected = NO;
    }
    for (int i = 0; i < 4; i++) {
        UIView * view = [self viewWithTag:20+i];
        if (view.tag - b.tag != 10) {
            view.hidden = YES;
        }
        else
            view.hidden = NO;
    }
    b.selected = YES;
}

- (IBAction)button1:(id)sender {
    
    NSLog(@"揭晓1");
}
- (IBAction)button2:(id)sender {
    NSLog(@"揭晓2");
}
- (IBAction)button3:(id)sender {
    NSLog(@"揭晓3");
}

- (IBAction)分类:(id)sender {
    NSLog(@"跳转到分类");
    if([self.delegate respondsToSelector:@selector(pushToSort)])
    {
        [self.delegate pushToSort];
    }
}
- (IBAction)元专区:(id)sender {
    NSLog(@"跳转到专区");
}
- (IBAction)晒单:(id)sender {
    NSLog(@"跳转到晒单");
}
- (IBAction)常见问题:(id)sender {
    NSLog(@"跳转到常见问题");
}
- (IBAction)即将揭晓:(id)sender {
    [self swipe:sender];
}
- (IBAction)最火:(id)sender {
    [self swipe:sender];
}
- (IBAction)最新:(id)sender {
    [self swipe:sender];
}
- (IBAction)价格:(id)sender {
    [self swipe:sender];
}






@end
