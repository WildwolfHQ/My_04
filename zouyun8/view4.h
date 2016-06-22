#import <UIKit/UIKit.h>

@protocol view4Delegate <NSObject>

-(void)OpenHeGou;
-(void)OpenHeGouDetail:(NSDictionary *)dict;

@end

@interface view4 : UIView
@property (weak, nonatomic) IBOutlet UIImageView *image1;

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIButton *tips;

@property (weak, nonatomic) IBOutlet UILabel *price1;
@property (weak, nonatomic) IBOutlet UILabel *price2;
@property (weak, nonatomic) IBOutlet UILabel *price3;
@property (weak, nonatomic) IBOutlet UILabel *last1;
@property (weak, nonatomic) IBOutlet UILabel *last2;
@property (weak, nonatomic) IBOutlet UILabel *last3;

@property(nonatomic,weak)id<view4Delegate> delegate;

@property(nonatomic,strong)NSArray * GoodsArray;













@end
