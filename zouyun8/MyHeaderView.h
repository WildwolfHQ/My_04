#import <UIKit/UIKit.h>

@protocol MyheaderViewDelegate <NSObject>
-(void)detail;
-(void)reCharge;
-(void)changePersonalImage;
-(void)setInformation;
-(void)setUp;
-(void)showMoneyDetail;
@end

@interface MyHeaderView : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UILabel *money;

@property (weak, nonatomic) IBOutlet UIImageView *personalImage;

@property(nonatomic,weak) id<MyheaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageViwe;
@property (weak, nonatomic) IBOutlet UILabel *name2;

@property (weak, nonatomic) IBOutlet UIButton *chongzhiBt;
@property (weak, nonatomic) IBOutlet UIButton *mingxiBt;
@end
