#import "accountView.h"

@implementation accountView

-(void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeAccount:) name:@"changeAccount" object:nil];
}
-(void)changeAccount:(NSNotification *)info
{
    self.totalNumber.text = [info.userInfo[@"key"] stringValue];
}
- (IBAction)结算:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"settleAccounts" object:nil userInfo:nil];
}

@end
