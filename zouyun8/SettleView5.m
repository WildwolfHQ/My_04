#import "SettleView5.h"

@implementation SettleView5
- (IBAction)moreAddress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(moreAddress)]) {
        [self.delegate moreAddress];
    }
}

@end
