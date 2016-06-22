#import "SettleView6.h"

@implementation SettleView6

- (IBAction)submitOrder:(id)sender {
    if ([self.delegate respondsToSelector:@selector(submitOrder)]) {
        [self.delegate submitOrder];
    }
}


@end
