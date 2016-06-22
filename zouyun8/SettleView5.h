#import <UIKit/UIKit.h>

@protocol SettleView5Delegate <NSObject>

-(void)moreAddress;

@end

@interface SettleView5 : UIView

@property (weak, nonatomic) IBOutlet UILabel *defaultAddress;
@property (weak, nonatomic) id<SettleView5Delegate> delegate;
@end
