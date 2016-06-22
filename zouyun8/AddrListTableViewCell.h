#import <UIKit/UIKit.h>

@protocol AddrListTableViewCellDelegate <NSObject>

-(void)deleteAddress:(NSIndexPath *)index;
-(void)setDefaultAddress:(NSIndexPath *)index;
@end

@interface AddrListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *detaillabel;

@property (weak, nonatomic) IBOutlet UIButton *is_default;

@property (weak, nonatomic) IBOutlet UIButton *deleteAddress;


@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@property(nonatomic,weak)id<AddrListTableViewCellDelegate> delegate;

@end
