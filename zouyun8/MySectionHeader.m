#import "MySectionHeader.h"
@implementation MySectionHeader

- (IBAction)佣金:(id)sender
{
    //显示佣金明细界面
    if([self.delegate respondsToSelector:@selector(pushToYongJin)])
    {
        [self.delegate pushToYongJin];
    }
}
- (IBAction)奖金:(id)sender {
    //显示奖金明细界面
    if([self.delegate respondsToSelector:@selector(pushToJiangJin)])
    {
        [self.delegate pushToJiangJin];
    }
}

@end
