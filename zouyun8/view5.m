#import "view5.h"

@interface view5()

@property(nonatomic,assign)BOOL b;

@end

@implementation view5
- (IBAction)即将揭晓:(UIButton *)sender {
    [self swipe:sender];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getData" object:nil userInfo:nil];
}
- (IBAction)最火:(id)sender {
    [self swipe:sender];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refresh" object:nil userInfo:@{@"top":@"2"}];
}
- (IBAction)最新:(id)sender {
    [self swipe:sender];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refresh" object:nil userInfo:@{@"top":@"3"}];
}
- (IBAction)价格:(id)sender {
    [self swipe:sender];
    if(self.b == NO)
    {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refresh" object:nil userInfo:@{@"top":@"4"}];
        self.b = YES;
        NSLog(@"按照4排序");
        return;
    }
    if(self.b == YES)
    {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refresh" object:nil userInfo:@{@"top":@"5"}];
        self.b = NO;
        NSLog(@"按照5排序");
        return;
    }
}
-(void)swipe:(UIButton *)b
{
    for (int i=0; i<4; i++)
    {
        UIButton *btn = [self viewWithTag:10+i];
        btn.selected = NO;
    }
    b.selected = YES;
}

@end
