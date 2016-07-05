#import <UIKit/UIKit.h>

@interface NetShareViewController : UITableViewController

@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,strong)NSMutableArray * counts;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,copy)NSString * ID;//id	int	必须	晒单ID
@end
