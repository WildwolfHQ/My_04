#import <UIKit/UIKit.h>

@protocol SettleView6Delegate <NSObject>

-(void)submitOrder;

@end

@interface SettleView6 : UIView
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) id<SettleView6Delegate> delegate;
@end
