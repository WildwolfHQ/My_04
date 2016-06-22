#import <UIKit/UIKit.h>
#import "BuyTogetherModel.h"

@protocol BuyTogetherCellDelegate <NSObject>

-(void)directToPay:(NSDictionary *)dict;

@end

@interface BuyTogetherCell : UICollectionViewCell

@property(nonatomic,strong)BuyTogetherModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *buy;
@property (weak, nonatomic) IBOutlet UILabel *last;

-(void)setCellWithModel:(BuyTogetherModel *)model;

@property(nonatomic,weak)id<BuyTogetherCellDelegate> delegate;

@end
