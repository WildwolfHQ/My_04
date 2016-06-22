#import <UIKit/UIKit.h>

@protocol RechargeCellDelegate <NSObject>

-(void)changeRechargeNum:(NSString *)num;

@end

@interface RechargeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *otherMoneyTextField;

@property(nonatomic,weak)id<RechargeCellDelegate> delegate;

@end
