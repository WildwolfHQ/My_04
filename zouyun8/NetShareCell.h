#import <UIKit/UIKit.h>
#import "NetShareModel.h"

@protocol NetShareCellDelegate <NSObject>

-(void)showBigImage:(NSMutableArray *)images andCount:(NSInteger)count;

@end

@interface NetShareCell : UITableViewCell
@property(nonatomic,strong)NSMutableArray * imagesArray;


-(void)setCellWithModel:(NetShareModel *)model;
@property (weak, nonatomic) IBOutlet UIImageView *personalImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;

@property(nonatomic,weak)id<NetShareCellDelegate> delegate;

@property(nonatomic,strong)NetShareModel * model;
@property(nonatomic,assign)NSInteger count;

@end
