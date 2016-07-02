#import <UIKit/UIKit.h>

@interface YongJinViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet UILabel *rechargeMoney;
@property (weak, nonatomic) IBOutlet UILabel *yongjin;

@property(nonatomic,strong)NSMutableArray * dataSource;

- (IBAction)duihuanzouyunbiBt:(UIButton *)sender;
@end
