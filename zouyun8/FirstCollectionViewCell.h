#import <UIKit/UIKit.h>

@protocol FirstCollectionViewCellDelegate <NSObject>

-(void)selectBuyTogetherNum:(GoodsModel *)model;

-(void)changeCornerMark;

-(void)directToPay:(NSDictionary *)dict;

@end

@interface FirstCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyLabel;
@property (weak, nonatomic) IBOutlet UILabel * singlePrice;
@property (weak, nonatomic) GoodsModel * model;

@property(weak,nonatomic)id<FirstCollectionViewCellDelegate> delegate;

-(void)setCellWithModel;

@end
