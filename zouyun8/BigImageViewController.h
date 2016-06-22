#import <UIKit/UIKit.h>

@interface BigImageViewController : UIViewController

@property(nonatomic,copy)NSMutableArray * images;
@property(nonatomic,assign)NSInteger count;

-(CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center;

@end
