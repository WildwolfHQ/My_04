//
//  PGSearchViewController.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/8.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "PGSearchViewController.h"
#import "SerchView1.h"
#import "GoodsWebViewController.h"
#import "SearchHDView2.h"
@interface PGSearchViewController ()<UISearchBarDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)NSMutableArray * dataSource;         //数据源
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UISearchBar *searchBar;
@property (nonatomic,strong) SerchView1 * serchView1;
@end

@implementation PGSearchViewController
#pragma mark - 懒加载dataSource
-(NSMutableArray *)dataSource
{
    if (_dataSource == nil)
    {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self setBar];
    
    
    self.serchView1 = [[NSBundle mainBundle]loadNibNamed:@"SerchView1" owner:self
                                                 options:nil].firstObject;
    self.serchView1.frame = CGRectMake(0, self.navigationController.navigationBar.frame.origin.y+CGRectGetHeight(self.navigationController.navigationBar.frame), WIDTH, HEIGHT);
    [self.view addSubview:self.serchView1];
    
    [self getData1];
   
    
    
    [self  createCollectionView];
    
    
    // Do any additional setup after loading the view.
}

-(void)createremensousuo:(NSArray *)array{
    
     NSInteger count = array.count/5;

   
    
    
    
    for (int k=0; k<=count; k++) {
        
         int m=5;
         if (k==count) {
            m=array.count%5;
          }
        CGFloat nameWK=0;
        for (int i=0;i<m;i++) {
        
         NSString *name=array[i+5*k];
        
         //UILabel *l1=[[UILabel alloc]init];
         //UIFont *fnt1 = [UIFont fontWithName:@"HelveticaNeue" size:24.0f];
         UIFont *fnt = [UIFont fontWithName:@"Heiti SC" size:13.0f];
         //l1.font =fnt;
         // 根据字体得到NSString的尺寸
         CGSize size = [name sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
         // 名字的H
         CGFloat nameH = size.height;
         // 名字的W
         CGFloat nameW = size.width;
         

         UIButton *b1=[[UIButton alloc]initWithFrame:CGRectMake(20+nameWK, 75+k*(nameH+27), nameW, nameH)];
            nameWK=b1.frame.origin.x+CGRectGetWidth(b1.frame)+10;
         [self.serchView1 addSubview:b1];
            
        [b1 setTitle:name forState:UIControlStateNormal];
            
        [b1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [b1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        
        b1.enabled=YES;
    
        b1.titleLabel.font=fnt;
        //b1.tag=i+5*k;
        [b1 addTarget:self action:@selector(action1:) forControlEvents:UIControlEventTouchUpInside];
            
        
        
       
        
        }
    }
    

    


}

-(void)action1:(UIButton *)sender{
    self.searchBar.text=sender.titleLabel.text;
    [self.dataSource removeAllObjects];
    [self getData:sender.titleLabel.text page:nil];
    

}

#pragma mark - 设置导航栏
-(void)setBar
{
    
    

    
    UIBarButtonItem *fixBar1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixBar1.width = 35;
   
    
   
    
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH/4*3, 28)];
    self.searchBar.searchBarStyle=UISearchBarStyleMinimal;
    
    self.searchBar.placeholder = @"请输入你要搜索商品名";
    [self.searchBar setContentMode:UIViewContentModeLeft];
    
    self.searchBar.delegate = self;
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithCustomView:self.searchBar];
    
    self.navigationItem.rightBarButtonItems = @[fixBar1,searchButton];
    
    

    
   
}



#pragma mark - searchBar代理


/*键盘搜索按钮*/
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
        [searchBar resignFirstResponder];
        [self doSearch:searchBar];
}



- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
   
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    if (searchText.length==0) {
        
        self.collectionView.hidden=YES;
        
    }

}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{


}


- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{

}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{


}
/*搜索*/
- (void)doSearch:(UISearchBar *)searchBar{
    
    [self.dataSource removeAllObjects];
    [self getData:searchBar.text page:nil];
    //. ...
}




#pragma mark - 获取商品数据
-(void)getData:(NSString *)name page:(NSString *)page
{
    
    
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"category"] = @"";//int	可选	分类id
    if (name!=nil) {
        params[@"name"] = name;//string	可选	商品名称，可模糊搜索
    }
    if (page!=nil) {
        params[@"page"] = page;//string	可选	商品名称，可模糊搜索
    }
    
    //    params[@"page"] = @"";//int	可选	分页页码，默认为第一页
    
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:PGFirstPageURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"进来了");
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         
         NSLog(@"%@",dict);
         NSArray * array = dict[@"data"];
         //请求成功,将图片下载完保存到数组中
         for (NSDictionary * dic in array)
         {
             
             
             
             PG_bid_list * model = [[PG_bid_list alloc]initWithDictionary:dic error:nil];
             
             if (model!=nil) {
                 [self.dataSource addObject:model];
             }
             
         }
         
          self.collectionView.hidden=NO;
         [self.collectionView reloadData];
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
}


#define Hot_searchURL @"https://m.zouyun8.com/api/hot_search"//
#pragma mark - 获取商品数据
-(void)getData1
{
    
    
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"category"] = @"";//int	可选	分类id
   
    params[@"type"] = @"2";//string	可选	商品名称，可模糊搜索
   


    
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
   
    [manager GET:Hot_searchURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"进来了");
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         
          NSLog(@"%@",dict);
        
          NSArray * array = dict[@"data"];
         if (array.count!=0) {
              [self createremensousuo:array];
         }
         
         
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
}



#pragma mark - 创建collectionview
-(void)createCollectionView
{
    
    
    CSStickyHeaderFlowLayout *flowLayout=[[CSStickyHeaderFlowLayout alloc] init];
    
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-49) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.showsHorizontalScrollIndicator=NO;
    
    //注册cell和ReusableView（相当于头部）
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"PGFirstCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"PGFirstCollectionViewCell"];
    
    //[self.collectionView registerClass:[FirstCollectionViewCell1 class] forCellWithReuseIdentifier:@"FirstCollectionViewCell1"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchHDView2"];
    
    self.collectionView.hidden=YES;
}




#pragma mark -- UICollectionViewDataSource

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

   
    
    return self.dataSource.count;
    
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

        
        static NSString *identify = @"PGFirstCollectionViewCell";
        PGFirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell sizeToFit];
        PG_bid_list * model = self.dataSource[indexPath.row];
        cell.model = model;
    
    
        [cell setCellWithModel];
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
        
        
   
    
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return CGSizeMake((WIDTH/2)-15, (191*(WIDTH/2-6))/160);
}
//定义每个cell的缩进
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
   return UIEdgeInsetsMake(0, 10, 0, 10);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    
    PG_bid_list * model=self.dataSource[indexPath.row];
    GoodsWebViewController *VC=[[GoodsWebViewController alloc]init];
    VC.bid_id=model.bid_id;
    [self.navigationController pushViewController:VC animated:YES];
    
    }
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//组视图大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(WIDTH, 40);
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
   
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchHDView2" forIndexPath:indexPath];
   
    SearchHDView2 * searchHDView2 = [[NSBundle mainBundle]loadNibNamed:@"SearchHDView2" owner:self
                                                 options:nil].firstObject;
    
    [headerView addSubview:searchHDView2];
    
    if (self.dataSource.count==0) {
       searchHDView2.text.text=@"没有该字段的商品";
    }else{
        searchHDView2.text.text=[NSString stringWithFormat:@"%@,共%@件商品",self.searchBar.text,@(self.dataSource.count)];
        
    
    }
    
//    searchHDView2.layer.borderWidth = 0.8;
//    searchHDView2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    //加阴影
    [[headerView layer] setShadowOffset:CGSizeMake(1, 1)];
    [[headerView layer] setShadowRadius:1];
    [[headerView layer] setShadowOpacity:1];
    [[headerView layer] setShadowColor:[UIColor lightGrayColor].CGColor];
    return headerView;
    
    
    
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.searchBar endEditing:YES];
    
}



@end
