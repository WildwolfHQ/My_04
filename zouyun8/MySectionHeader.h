#import <UIKit/UIKit.h>

@protocol MySectionHeaderDelegate <NSObject>

-(void)pushToYongJin;

-(void)pushToJiangJin;

@end

@interface MySectionHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *yongjin;
@property (weak, nonatomic) IBOutlet UILabel *prize;

@property (weak, nonatomic) IBOutlet UIButton *faqidehegou;
@property(nonatomic,weak)id<MySectionHeaderDelegate> delegate;

@end
