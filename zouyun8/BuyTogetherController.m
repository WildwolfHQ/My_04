#import "BuyTogetherController.h"
#import "BuyTogetherCell.h"
#import "BuyTogetherModel.h"
#import "HgGoodsDetailController.h"
#import "DirectSettleViewController.h"
#import "GoodsWebViewController.h"
@interface BuyTogetherController ()<UICollectionViewDataSource,UICollectionViewDelegate,BuyTogetherCellDelegate>

@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)BOOL is_Pull;
@end

@implementation BuyTogetherController

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

-(void)viewWillAppear:(BOOL)animated
{
    for (UIImageView * view in self.navigationController.navigationBar.subviews)
    {
        if (view.tag == 10) {
            [view removeFromSuperview];
        }
    }
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.title = @"公开列表";
    [self createCollectionView];
    [self getData:[NSString stringWithFormat:@"%ld",(long)self.page]];
}

- (void)viewDidLayoutSubviews
{
    __weak BuyTogetherController *weakSelf = self;
    //上下拉刷新
    [self.collectionView addPullToRefreshWithActionHandler:^{
        //page值加一后请求数据
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            weakSelf.is_Pull = YES;
            weakSelf.page = 1;
            [weakSelf getData:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
            [weakSelf.collectionView.pullToRefreshView stopAnimating];
        });
    }];
    
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        weakSelf.is_Pull = NO;
        weakSelf.page = 1 + weakSelf.page;
        [weakSelf getData:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
    }];
}


-(void)getData:(NSString *)page
{
    NSLog(@"页码%ld",self.page);
    [ToolClass getPub_lucky:^(NSDictionary *dic) {
        
        NSLog(@"合购公开%@",dic);
        
       NSArray *  array = dic[@"data"];
        
        if (self.is_Pull == YES)
        {
            [self.dataSource removeAllObjects];
        }
        for (NSDictionary * dict in array) {
            BuyTogetherModel * model = [[BuyTogetherModel alloc]initWithDictionary:dict error:nil];
            model.type=@"1";
            [self.dataSource addObject:model];
        }
        [self.collectionView reloadData];
    } page:[NSString stringWithFormat:@"%ld",self.page]];
}

-(void)directToPay:(NSDictionary *)dict
{
    ShoppingcartViewController *vc=[[ShoppingcartViewController alloc]init];
    
     vc.is_tabBarHidden=YES;
//    vc.is_tuhao=YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    

}

#pragma mark - 创建collectionview
-(void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    CGFloat wid = WIDTH / 3 - 10;
    flowLayout.itemSize = CGSizeMake(wid, WIDTH/2);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"BuyTogetherCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"BuyTogetherCell"];
}
#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"BuyTogetherCell";
    BuyTogetherCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.delegate = self;
    [cell sizeToFit];
    BuyTogetherModel * model;
    model = self.dataSource[indexPath.row];
    cell.model = model;
    [cell setCellWithModel:model];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    
    NSLog(@"%f",[[UIScreen mainScreen] currentMode].size.width);
    NSLog(@"%f",[[UIScreen mainScreen] currentMode].size.height);
    if (iPhone5) {
        NSLog(@"当前设备为5");
        return CGSizeMake((WIDTH-1)/2, (WIDTH-1)/2*1.45);
    }
    else if (iPhone6) {
        NSLog(@"当前设备为6");
        return CGSizeMake((WIDTH-1)/2, (WIDTH-1)/2*1.4);
    }
    else if(iPhone6_plus)
    {
        NSLog(@"当前设备为6_plus");
        
        return CGSizeMake((WIDTH-1)/2, (WIDTH-1)/2*1.4);
    }
    else
    {
        NSLog(@"当前设备为4");
        
        return CGSizeMake((WIDTH-1)/2, (WIDTH-1)/2*1.45);
    }
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BuyTogetherModel * model;
    model = self.dataSource[indexPath.row];
    //http://zy8.jf-q.com/l/v/[lucky_id]/?uid=[uid]&token=[token]
    NSString * url = [NSString stringWithFormat:@"http://m.zouyun8.com/l/v/%@/?uid=%@&token=%@",model.ID,UID,TOKEN];
    
    GoodsWebViewController * VC = [[GoodsWebViewController alloc]init];
    
    VC.urlStr = url;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
