#import "ShoppingcartViewNull.h"

@implementation ShoppingcartViewNull

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.lijixuangouBt.layer.cornerRadius=4;
  
}
- (IBAction)立即夺宝:(id)sender {
 
    
}
- (IBAction)lijigoumaiBt:(id)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTabBar" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pushtoroot" object:nil];
}
@end
