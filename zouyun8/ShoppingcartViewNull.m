#import "ShoppingcartViewNull.h"

@implementation ShoppingcartViewNull

- (void)awakeFromNib
{
    [super awakeFromNib];
    for (int i = 0; i < 10; i++)
    {
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/3*i, 0, WIDTH/3, CGRectGetHeight(self.scrollView.frame))];
        UIView * view = [[NSBundle mainBundle]loadNibNamed:@"GuessView" owner:self options:nil].firstObject;
        view.frame = imageV.frame;
        [imageV addSubview:view];
        [self.scrollView addSubview:imageV];
    }
    self.scrollView.contentSize = CGSizeMake(WIDTH/3 * 10, 0);
}
- (IBAction)立即夺宝:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeTabBar" object:nil];
}
@end
