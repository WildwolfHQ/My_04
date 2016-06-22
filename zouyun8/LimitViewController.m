//
//  LimitViewController.m
//  zouyun8
//
//  Created by 郑浩 on 16/6/2.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "LimitViewController.h"

@interface LimitViewController ()

@end

@implementation LimitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"限价列表";
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
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:64/255.0 blue:64/255.0 alpha:1];
}
-(void)getData:(NSString *)page
{
    [ToolClass getSortDetail:^(NSDictionary *dic) {
        NSArray * marry = [[NSArray alloc]init];
        marry = dic[@"data"];
        NSLog(@"限价的数据为%@",dic);
        for (NSDictionary * dict in marry) {
            GoodsModel * model = [[GoodsModel alloc]initWithDictionary:dict error:nil];
            [self.dataSource addObject:model];
        }
        [self.collectionView reloadData];
        
    } minPrice:nil maxPrice:nil page:page name:nil category:@"222460405" urlStr:LUCKY_LIST];
}
@end
