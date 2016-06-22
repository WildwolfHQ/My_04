#import <UIKit/UIKit.h>

@protocol SettleView4Delegate <NSObject>

-(void)changeTotalPrice:(void(^)())b;

-(void)resetTotalPrice;
@end

@interface SettleView4 : UIView
@property (weak, nonatomic) IBOutlet UILabel *discountMoney;
@property (weak, nonatomic) IBOutlet UISwitch *is_discount;

@property(nonatomic,weak)id<SettleView4Delegate> delegate;

@end
