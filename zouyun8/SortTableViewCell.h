#import <UIKit/UIKit.h>
#import "SortModel.h"

@protocol SortTableViewCellDelegate <NSObject>

-(void)SelectSection:(SortModel *)model;

@end

@interface SortTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;

@property(weak,nonatomic)id<SortTableViewCellDelegate> delegate;

@property(nonatomic,strong)SortModel * model;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *pricequjian;

@end
