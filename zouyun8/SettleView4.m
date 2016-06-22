#import "SettleView4.h"

@implementation SettleView4

-(void)awakeFromNib
{
    [self.is_discount addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        NSLog(@"选择了折扣");
        if ([self.delegate respondsToSelector:@selector(changeTotalPrice:)]) {
            [self.delegate changeTotalPrice:^() {
                switchButton.on = NO;
                NSLog(@"执行了block");
            }];
        }
    }else {
        NSLog(@"没有选择折扣");
        if ([self.delegate respondsToSelector:@selector(resetTotalPrice)]) {
            [self.delegate resetTotalPrice];
        }
    }
}

@end
