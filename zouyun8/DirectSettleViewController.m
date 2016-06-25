#import "DirectSettleViewController.h"

@interface DirectSettleViewController ()

@end

@implementation DirectSettleViewController

-(void)viewWillAppear:(BOOL)animated
{
    for (UIImageView * view in self.navigationController.navigationBar.subviews)
    {
        if (view.tag == 10)
        {
            [view removeFromSuperview];
        }
    }
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor redColor],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"确认订单";
    //[self getOrders];
}
-(void)getOrders
{
    self.orders = [NSMutableArray arrayWithObject:self.dic];
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [self.tabBarController.tabBar removeFromSuperview];
//}

@end
