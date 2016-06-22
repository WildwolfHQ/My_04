#import <UIKit/UIKit.h>
#import "AllOrderModel.h"

@interface AllOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *realMoney;

@property(nonatomic,strong)AllOrderModel * model;

-(void)setCellWithModel:(AllOrderModel *)model;

@end
