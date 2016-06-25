#import "SortDetailViewController.h"
#import "HgGoodsDetailController.h"
#import "DirectSettleViewController.h"
#import "CZPicker.h"
#import "GoodsWebViewController.h"
@interface SortDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,FirstCollectionViewCellDelegate,CZPickerViewDataSource, CZPickerViewDelegate>

@property NSMutableArray *fruits;
@property NSMutableArray *fruitImages;
@property CZPickerView *pickerWithImage;
@property (strong,nonatomic) GoodsModel *model;

@end

@implementation SortDetailViewController

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
}

- (void)viewDidLoad {
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    NSString * type = TYPE;
    if ([type integerValue] == 2) {
        for (int i = 5; i <= 50; i ++) {
            [array addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    else
    {
        for (int i = 2; i <= 50; i ++) {
            [array addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    self.fruits = array;

    
    [super viewDidLoad];
    
    self.title=self.name1;
    self.page = 1;
    [self getData:@"1"];
    [self createCollectionView];
}
- (void)viewDidLayoutSubviews
{
    __weak SortDetailViewController *weakSelf = self;
    //上下拉刷新
    [self.collectionView addPullToRefreshWithActionHandler:^{
        NSLog(@"下拉了");
        //page值加一后请求数据
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //            [weakSelf.dataSource insertObject:[NSDate date] atIndex:0];
            [weakSelf.dataSource removeAllObjects];
            [weakSelf getData:@"1"];
            [weakSelf.collectionView.pullToRefreshView stopAnimating];
        });
    }];
    
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"上拉了");
        weakSelf.page += 1;
        NSLog(@"%ld",(long)weakSelf.page);
        [weakSelf getData:[NSString stringWithFormat:@"%ld",(long)weakSelf.page]];
        [weakSelf.collectionView.infiniteScrollingView stopAnimating];
    }];
}

-(void)directToPay:(NSDictionary *)dict
{
    ShoppingcartViewController *vc=[[ShoppingcartViewController alloc]init];
    
    vc.is_tabBarHidden=YES;
    vc.is_tuhao=YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];}

-(void)selectBuyTogetherNum:(GoodsModel *)model
{
    NSLog(@"点击了好友合购");
    self.model = model;
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"请选择好友合购份数" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = YES;
    [picker show];
}
#pragma mark - 选择好友合购份数
- (NSAttributedString *)czpickerView:(CZPickerView *)pickerView
               attributedTitleForRow:(NSInteger)row{
    
    NSAttributedString *att = [[NSAttributedString alloc]
                               initWithString:self.fruits[row]
                               attributes:@{
                                            NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:18.0]
                                            }];
    return att;
}

- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    return self.fruits[row];
}

- (UIImage *)czpickerView:(CZPickerView *)pickerView imageForRow:(NSInteger)row {
    if([pickerView isEqual:self.pickerWithImage]) {
        return self.fruitImages[row];
    }
    return nil;
}

- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
    return self.fruits.count;
}

//点击确定后跳转到合购详情页
- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row{
    //NSLog(@"%@ is chosen!", self.fruits[row]);
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"id"]=self.model.lucky_id;
    dic[@"num"]=self.fruits[row];
    [self getDataForCreate_lucky_URL:dic];
}

-(void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemsAtRows:(NSArray *)rows
{
    for(NSNumber *n in rows){
        NSInteger row = [n integerValue];
        NSLog(@"选择了%@份",self.fruits[row]);
    }
}

- (void)czpickerViewDidClickCancelButton:(CZPickerView *)pickerView{
    NSLog(@"Canceled.");
}

-(void)getData:(NSString *)page
{
    [ToolClass getSortDetail:^(NSDictionary *dic) {
        NSArray * marry = [[NSArray alloc]init];
        marry = dic[@"data"];
        if (marry.count == 0&&self.dataSource.count==0) {
            [SVProgressHUD showErrorWithStatus:@"暂无该商品"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        NSLog(@"刷新的数据为%@",dic);
        for (NSDictionary * dict in marry) {
            if ([self.isPG isEqualToString:@"1"]) {
                PG_bid_list * model = [[PG_bid_list alloc]initWithDictionary:dict error:nil];
                [self.dataSource addObject:model];

            }else{
            
                GoodsModel * model = [[GoodsModel alloc]initWithDictionary:dict error:nil];
                [self.dataSource addObject:model];

            }
                   }
        [self.collectionView reloadData];

    } minPrice:self.min_price maxPrice:self.max_price page:page name:self.name category:self.categoryID urlStr:self.urlStr];
}

#pragma mark - 创建collectionview
-(void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    //    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //    CSStickyHeaderFlowLayout *flowLayout=[[CSStickyHeaderFlowLayout alloc] init];
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
    
    //注册cell和ReusableView（相当于头部）
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"FirstCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"FirstCollectionViewCell"];
    UINib *nib1 = [UINib nibWithNibName:@"PGFirstCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib1 forCellWithReuseIdentifier:@"PGFirstCollectionViewCell"];
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
    if ([self.isPG isEqualToString:@"1"]) {
        static NSString *identify = @"PGFirstCollectionViewCell";
        PGFirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell sizeToFit];
       PG_bid_list * model;
        if (self.dataSource.count != 0) {
            model = self.dataSource[indexPath.row];
        }
        cell.model = model;
        [cell setCellWithModel];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;


        
    }else{
    
    static NSString *identify = @"FirstCollectionViewCell";
    FirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    GoodsModel * model;
    if (self.dataSource.count != 0) {
        model = self.dataSource[indexPath.row];
    }
    cell.model = model;
    cell.delegate = self;
    [cell setCellWithModel];
    cell.backgroundColor = [UIColor whiteColor];
        return cell;
    
    }
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
//    GoodsDetailController * detail = [[GoodsDetailController alloc]init];
//    self.hidesBottomBarWhenPushed = YES;
//    [self presentViewController:detail animated:YES completion:nil];
//    self.hidesBottomBarWhenPushed = NO;
    if ([self.isPG isEqualToString:@"1"]) {
        
        
        
        PG_bid_list * model=self.dataSource[indexPath.row];
        GoodsWebViewController *VC=[[GoodsWebViewController alloc]init];
        VC.bid_id=model.bid_id;
        NSDictionary *dic=[[NSMutableDictionary alloc]init];
        
        [dic setValue:model.thumb forKey:@"image"];
        [dic setValue:@"" forKey:@"desc"];
        [dic setValue:[NSString stringWithFormat:@"%@%@",Share_URL,model.bid_id]forKey:@"url"];
        [dic setValue:model.name forKey:@"title"];
        [dic setValue:@"1" forKey:@"share_action"];//action	int	必须	分享类型	1商品详情，2二维码，3活动页
        
        
        //    dic[@"url"]=model;
        //    dic[@"desc"];
        VC.shareDict=dic;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        self.hidesBottomBarWhenPushed = NO;

        
    }else{
    
    
    
    GoodsModel * model;
    model = self.dataSource[indexPath.row];
    //http://zy8.jf-q.com/l/v/[lucky_id]/?uid=[uid]&token=[token]
    NSString * url = [NSString stringWithFormat:@"http://m.zouyun8.com/l/v/%@/?uid=%@&token=%@",model.lucky_id,UID,TOKEN];
    NSLog(@"%@",url);
    GoodsWebViewController * detail = [[GoodsWebViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    detail.urlStr = url;
    [self.navigationController pushViewController:detail animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


-(void)getDataForCreate_lucky_URL:(NSMutableDictionary*)dic
{
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"uid"] = UID;
    parameters[@"token"] = TOKEN;
    parameters[@"id"] = dic[@"id"];
    parameters[@"num"] = dic[@"num"];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:Create_lucky_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSLog(@"最新揭晓列表%@",dict);
         NSLog(@"最新揭晓列表%@",dict[@"errmsg"]);
         
         
         if (dict[@"lucky_id"]!=nil) {
             
             GoodsWebViewController *VC=[[GoodsWebViewController alloc]init];
             VC.lucky_id=[NSString stringWithFormat:@"%@",dict[@"lucky_id"]];
             VC.titleName=@"商品详情";
             self.hidesBottomBarWhenPushed = YES;
             [self.navigationController pushViewController:VC animated:YES];
             self.hidesBottomBarWhenPushed = NO;
             
         }else{
             [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
             
         }
         
         
         
         
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         
     }];
}

@end
