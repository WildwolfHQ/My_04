#import <UIKit/UIKit.h>

@interface NetShareViewController : UITableViewController

@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,strong)NSMutableArray * counts;
@property(nonatomic,assign)NSInteger page;

@end
