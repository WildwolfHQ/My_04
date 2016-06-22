#import "RedPacketViewController.h"

@interface RedPacketViewController ()

@end

@implementation RedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包";
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName: [UIColor redColor],
                                                                   NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
}

-(void)getData:(NSString *)page
{
    [ToolClass getSortDetail:^(NSDictionary *dic) {
        NSArray * marry = [[NSArray alloc]init];
        marry = dic[@"data"];
        NSLog(@"红包的数据为%@",dic);
        for (NSDictionary * dict in marry) {
            GoodsModel * model = [[GoodsModel alloc]initWithDictionary:dict error:nil];
            [self.dataSource addObject:model];
        }
        [self.collectionView reloadData];
        
    } minPrice:nil maxPrice:nil page:page name:nil category:@"3067895684" urlStr:LUCKY_LIST];
}

-(void)viewWillAppear:(BOOL)animated
{
    for (UIImageView * view in self.navigationController.navigationBar.subviews)
    {
        if (view.tag == 10)
        {
            [view removeFromSuperview];
        }
    }
        //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:64/255.0 blue:64/255.0 alpha:1];
}
@end
