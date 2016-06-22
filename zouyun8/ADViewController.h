#import <UIKit/UIKit.h>

@interface ADViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,copy)NSString * url;
@property (nonatomic,copy)NSString * tip;
@end
