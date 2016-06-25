#import <UIKit/UIKit.h>

//点击cell代理方法
@protocol tableViewCellDelegate <NSObject>

-(void)changeBuyNumber:(NSIndexPath *)index;
-(void)removeGoods:(NSIndexPath *)index;
-(void)refreshTotalPrice;
@end

@interface shoppingcarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *needAll;
@property (weak, nonatomic) IBOutlet UILabel *last;
@property (weak, nonatomic) IBOutlet UILabel *num;


@property (weak, nonatomic) IBOutlet UIImageView *iamgeview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastLabel;
@property (weak, nonatomic) IBOutlet UITextField *buyTextField;
@property (weak, nonatomic) IBOutlet UILabel *canyurenci;

@property (assign ,nonatomic)NSInteger price;

@property (nonatomic,strong)shoppingcartModel * model;

@property (nonatomic,weak)id<tableViewCellDelegate> delegate;
-(void)setCellWithModel:(BOOL)is_tuhao;
- (NSIndexPath *)getIndexPath;
@end
