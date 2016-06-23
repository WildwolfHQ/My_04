//
//  PGViewController.m
//  zouyun8
//
//  Created by 端正赵 on 16/5/25.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "PGViewController.h"
#import "GoodsWebViewController.h"
#import "PGSearchViewController.h"

@interface PGViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate,UISearchBarDelegate,UIActionSheetDelegate>{

    PGViwe5 * _view5;
    
    BOOL istishi;
}

@property(nonatomic,strong)NSMutableArray * dataSource;         //数据源
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;  //轮播控件
@property(nonatomic,strong)NSMutableArray * AdImages;           //存储轮播图片url数组
@property(nonatomic,strong)NSMutableArray * AdUrls;             //存储轮播商品地址
@property(nonatomic,strong)UIView * headView;// 第二个section的HeadView
@property(nonatomic,strong)UIImageView * imageView;//走运网-LOGO
@end

@implementation PGViewController
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
    [self getData:nil page:nil :NO];
    
    
    [self GetAdPicture];
   
    [self createAdScrollView];
    
    
    [self createHeadView];
    [self createCollectionView];
    
    self.view.backgroundColor=[UIColor grayColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    
    for (UIImageView * view in self.navigationController.navigationBar.subviews) {
        
        
        if (view.tag == 10) {
            [view removeFromSuperview];
        }
    }
}
-(void)viewDidAppear:(BOOL)animated{

 //self.tabBarController.tabBar.hidden=NO;
}
#pragma mark - 设置导航栏
-(void)setBar
{


//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
//                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    UIBarButtonItem *fixBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixBar.width = -20;
    UIBarButtonItem *fixBar1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:
UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixBar1.width = 35;
    //左边buttonBarItem
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_xiaoxi"] style:UIBarButtonItemStylePlain target:self action:@selector(MyMessage)];
    self.navigationItem.leftBarButtonItems = @[fixBar,leftButtonItem];

    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH/2, 28)];
//    UIImageView *sousuoImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_nav_fangdajing"]];
//    sousuoImageView.frame=CGRectMake(searchBar.bounds.size.width-sousuoImageView.bounds.size.width-8, 14, sousuoImageView.bounds.size.width, sousuoImageView.bounds.size.height);
//    
//
//
//    [searchBar addSubview:sousuoImageView];
    
    searchBar.searchBarStyle=UISearchBarStyleMinimal;

    searchBar.placeholder = @"美的冰箱";
    [searchBar setContentMode:UIViewContentModeLeft];
    
    searchBar.delegate = self;
   

    
    
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithCustomView:searchBar];

    
    //右边rightItems
    UIImage *image1 = [UIImage imageNamed:@"分类"];
    UIBarButtonItem *imageBar1 = [[UIBarButtonItem alloc]initWithImage:image1 style:UIBarButtonItemStylePlain target:self action:@selector(pushToSort1)];
   
    
       self.navigationItem.rightBarButtonItems = @[imageBar1,fixBar1,searchButton];
    
    
    
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}
//分类
-(void)pushToSort1
{
    
    SortTableViewController *VC=[[SortTableViewController alloc]init];
    
     VC.pgFenlei=[NSString stringWithFormat:@"https://m.zouyun8.com/api/category_list/?type=2"];
     //VC.type=@"2";//category_list   分类接口 加一个 type 参数  值为1时 取合购  2取拼购分类
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark - 创建collectionView的第2个section的顶部视图（HeadView）
-(void)createHeadView
{
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    
    
     _view5 = [[NSBundle mainBundle]loadNibNamed:@"PGView5" owner:self
                                               options:nil].firstObject;
    _view5.frame = CGRectMake(0, 0, WIDTH, 40);
//    view5.willAnnounce.selected = YES;
    _view5.backgroundColor = [UIColor  colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
    
    [_view5.paixuButton addTarget:self action:@selector(paixuAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.headView addSubview:_view5];
}

-(void)paixuAction:(UIButton *)sender{
    

    
    UIActionSheet* alert = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"购买量",@"价格倒序",@"价格正序",@"即将开启",@"即将结束",@"智能排序",nil];
    [alert showInView:[self view]];
   


}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==6) {
        return;
    }
    
    NSString *str=[NSString stringWithFormat:@"%ld",buttonIndex+1];
    [self getPaixuData:str];
    [_view5.paixuButton setTitle:[actionSheet buttonTitleAtIndex:buttonIndex]
                         forState:UIControlStateNormal] ;





    
}

#pragma mark - 创建collectionView的第1个section的第1个cell里的view
-(UIView *)createSection0
{
    PGView2 * view2 = [[NSBundle mainBundle]loadNibNamed:@"PGView2" owner:self options:nil].firstObject;
//    view2.backgroundColor=[UIColor greenColor];
    UIView * section0View = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, view2.bounds.size.height+self.cycleScrollView.bounds.size.height)];
    section0View.backgroundColor=[UIColor whiteColor];
//    //添加约束
//    
//    //logoImageView左侧与父视图左侧对齐
//    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:section0View attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
//    
//    //logoImageView右侧与父视图右侧对齐
//    NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:section0View attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
//    
//    //logoImageView右侧与父视图右侧对齐
//    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:section0View attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
//    
//    //logoImageView右侧与父视图右侧对齐
//    NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:section0View attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:130.0f];
//
//    
//    //iOS 8.0以后设置active属性值
//    leftConstraint.active = YES;
//    rightConstraint.active = YES;
//    topConstraint.active=YES;
//    bottomConstraint.active=YES;
    view2.frame = CGRectMake(self.view.bounds.origin.x, 130, self.view.bounds.size.width, 130);
    view2.backgroundColor = [UIColor  colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1.0];
    
    [section0View addSubview:self.cycleScrollView];
    [section0View addSubview:view2];
    [view2.hegou addTarget:self action:@selector(pushTohegou:) forControlEvents:UIControlEventTouchUpInside ];
    [view2.jinxuan addTarget:self action:@selector(pushTohuodong1:) forControlEvents:UIControlEventTouchUpInside ];
    [view2.yiyuanzu addTarget:self action:@selector(pushTohuodong2:) forControlEvents:UIControlEventTouchUpInside ];
    [view2.jindong addTarget:self action:@selector(pushTohuodong3:) forControlEvents:UIControlEventTouchUpInside ];
    
    return section0View;
    
}

-(void)pushTohegou:(UIButton *)sender{
 FirstViewController *Fvc = [[FirstViewController alloc]init];
    
 [self.navigationController pushViewController:Fvc animated:YES];

}

-(void)pushTohuodong1:(UIButton *)sender{
    
    GoodsWebViewController *VC=[[GoodsWebViewController alloc]init];
    
    VC.urlStr=[NSString stringWithFormat:@"http://zy8.jf-q.com/b/cate/jingxuan/"];
    VC.titleName=@"每日精选";
    [self.navigationController pushViewController:VC animated:YES];

}
-(void)pushTohuodong2:(UIButton *)sender{
      GoodsWebViewController *VC=[[GoodsWebViewController alloc]init];
    VC.urlStr=[NSString stringWithFormat:@"http://zy8.jf-q.com/a/zhuanpan/?uid=%@&token=%@",UID,TOKEN];
    VC.titleName=@"抽奖";
    [self.navigationController pushViewController:VC animated:YES];
    
}

-(void)pushTohuodong3:(UIButton *)sender{
    GoodsWebViewController *VC=[[GoodsWebViewController alloc]init];
    
    VC.urlStr=[NSString stringWithFormat:@"http://zy8.jf-q.com/a/cate/3818663455/"];
    VC.titleName=@"帮助";
    [self.navigationController pushViewController:VC animated:YES];

}



#pragma mark - 创建collectionview
-(void)createCollectionView
{
   

    CSStickyHeaderFlowLayout *flowLayout=[[CSStickyHeaderFlowLayout alloc] init];
    

    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-49) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    //注册cell和ReusableView（相当于头部）
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"PGFirstCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"PGFirstCollectionViewCell"];
    
    [self.collectionView registerClass:[FirstCollectionViewCell1 class] forCellWithReuseIdentifier:@"FirstCollectionViewCell1"];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];

}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count=0;
    if (section==0) {
        count= 1;
        
    }else {
        if (self.dataSource.count!=0) {
            return self.dataSource.count+1;
        }else{
            
            return self.dataSource.count;
        }
    }
    return count;
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *identify = @"FirstCollectionViewCell1";
        
        
        
        FirstCollectionViewCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell sizeToFit];
        [cell addSubview:[self createSection0]];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
        
        
    }else{
        
        
        if (indexPath.row==self.dataSource.count+1-1) {
            UINib *nib = [UINib nibWithNibName:@"FooterCollectionViewCell" bundle:nil];
            [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"FooterCollectionViewCell"];
            
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FooterCollectionViewCell" forIndexPath:indexPath];
            
            
            
            
            
            return cell;
            
        }else{
            PG_bid_list * model = self.dataSource[indexPath.row];
            
            
            static NSString *identify = @"PGFirstCollectionViewCell";
            PGFirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
            [cell sizeToFit];
            
            cell.model = model;
            [cell setCellWithModel];
            cell.backgroundColor = [UIColor whiteColor];
            
            
            return cell;

        
        }
        
       
        
        
        
        
    }
    
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    
    if (indexPath.section==0) {
        return CGSizeMake(WIDTH, 260);
        
    }else{
        
        
        
        if (indexPath.row==self.dataSource.count+1-1) {
           
           return CGSizeMake(WIDTH, 50);
            
           
        }else{

        
            return CGSizeMake((WIDTH/2)-15, (191*(WIDTH/2-6))/160);
        }
    }
    
}
//定义每个cell的缩进
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    if (section==0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        return;
    }
    
    //            NSDictionary * dict;
    //            dict= @{@"id":self.hg_XiangGing.lucky_id,@"type":@"1",@"num":@"1"};
    
 
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
////    GoodsDetailController * detail = [[GoodsDetailController alloc]init];
//     CommodityDetailsPageViewController * detail = [[CommodityDetailsPageViewController alloc]init];
//    //self.hidesBottomBarWhenPushed = YES;
////    [self presentViewController:detail animated:YES completion:nil];
//    
//   [ detail setValue:[self.dataSource[indexPath.row] bid_id ]forKey:@"bid_id"];
   
    //self.hidesBottomBarWhenPushed = NO;
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//组视图大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    if (section==0) {
        return CGSizeMake(WIDTH, 0);
        
    }else{
        return CGSizeMake(WIDTH, 40);
        
    }
}

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    
//    if (section==0) {
//        return CGSizeMake(WIDTH, 0);
//        
//    }else{
//        return CGSizeMake(WIDTH, 50);
//    }
//}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        [headerView addSubview:self.headView];
        
        
        if (indexPath.section==0) {
            headerView.hidden=YES;
        }else{
            
            
            
            //    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
            //    [headerView addSubview:self.headView];
            //
            //
            //
            //        return headerView;
        }
        
        return headerView;
        
    }else{
//         UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"footerview" forIndexPath:indexPath];
//        FooterView * footerview1 = [[NSBundle mainBundle]loadNibNamed:@"FooterView" owner:self
//                                                          options:nil].firstObject;
//        footerview1.frame = CGRectMake(0, 0, WIDTH, 50);
//        
//        
//        
//        [footerview addSubview:footerview1];
//        if (indexPath.section==0) {
//            
//           
//            footerview.hidden=YES;
//
//            
//        }else{
//            
//        
//        }
//    
//        return  footerview;
    
    
        return nil;
    }
    
    
    
    
    
}
#pragma mark - 广告滚动视图
-(void)createAdScrollView
{
 
    // 本地加载 --- 创建不带标题的图片轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, 130/*具体宽度根据屏幕高宽比适配*/)  imageURLStringsGroup:self.AdImages];
    
    self.cycleScrollView.infiniteLoop=YES;
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView.showPageControl=YES;
    //添加轮播器
    self.cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //         --- 轮播时间间隔，默认1.0秒，可自定义
    self.cycleScrollView.autoScrollTimeInterval = 2.0;
    self.cycleScrollView.backgroundColor=[UIColor whiteColor];
}

#pragma mark - 广告视图代理方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //NSLog(@"%@",self.AdUrls[index]);
    //跳转到商品详情，实验。
    NSString * urlStr=self.AdUrls[index];
    GoodsWebViewController *VC=[[GoodsWebViewController alloc]init];
    VC.urlStr=urlStr;
    VC.guanggao=@"1";
    [self.navigationController pushViewController:VC animated:YES];

}
#pragma mark - 广告图片
-(void)GetAdPicture
{
    
    //初始化广告图片数组
    self.AdImages = [NSMutableArray array];
    self.AdUrls=[NSMutableArray array];
    
    NSDictionary * parameters = @{@"id":@"4020930396"};
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:ADURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSArray * array = dict[@"data"];
         
         //请求成功,将图片下载完保存到数组中
         for (NSDictionary * dic in array)
         {
             [self.AdImages addObject:dic[@"url"]];
             [self.AdUrls addObject:dic[@"href"]];
             
         }
         

         self.cycleScrollView.imageURLStringsGroup = self.AdImages;
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
}




#pragma mark - 获取商品数据
-(void)getData:(NSString *)name page:(NSString *)page :(BOOL)isRash
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
         if (isRash) {
             [self.dataSource removeAllObjects];
         }
         
         for (NSDictionary * dic in array)
         {
             
             
             
             PG_bid_list * model = [[PG_bid_list alloc]initWithDictionary:dic error:nil];
             
             if (model!=nil) {
                 [self.dataSource addObject:model];
             }
             
         }
         
         [self.collectionView reloadData];
         
         //[self.collectionView.infiniteScrollingView stopAnimating];
         //[self.collectionView.pullToRefreshView stopAnimating];
        
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         
       
         [self.collectionView.infiniteScrollingView stopAnimating];
         [self.collectionView.pullToRefreshView stopAnimating];
         
         
     }];
}


-(void)getPaixuData:(NSString *)
top{
    
    NSString *url=@"";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"category"] = @"";//int	可选	分类id
    if (![top isEqualToString:@"6"]) {
           if (top!=nil) {
               params[@"top"] = top;//string	可选	商品名称，可模糊搜索
           }

        url=Bid_list;
        
    }else{
        url=PGFirstPageURL;
    
    }
    //    params[@"page"] = @"";//int	可选	分页页码，默认为第一页
    
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSLog(@"进来了");
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         
         NSLog(@"%@",dict);
         NSArray * array = dict[@"data"];
         //请求成功,将图片下载完保存到数组中
         if (array.count!=0) {
             [self.dataSource removeAllObjects];
         }
         
         for (NSDictionary * dic in array)
         {
             PG_bid_list * model = [[PG_bid_list alloc]initWithDictionary:dic error:nil];
             
             if (model!=nil) {
                 [self.dataSource addObject:model];
             }
             
         }
         [self.collectionView reloadData];
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];


}
-(void)refresh
{
    //    只刷新所有cell数据
    //    NSMutableArray * marray = [[NSMutableArray alloc]init];
    //    for (int i = 0; i < self.dataSource.count; i++) {
    //        NSLog(@"执行了");
    //        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    //        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    //    }
    //    [self.collectionView setContentOffset:CGPointMake(0,-50)animated:YES];
    
}


#pragma mark - searchBar代理


/*键盘搜索按钮*/
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    [searchBar resignFirstResponder];
//    [self doSearch:searchBar];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    PGSearchViewController * VC = [[PGSearchViewController alloc]init];
    //[VC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];

    [self.navigationController pushViewController:VC animated:YES];

    return NO;
}



/*搜索*/
- (void)doSearch:(UISearchBar *)searchBar{
    
    [self.dataSource removeAllObjects];
    [self getData:searchBar.text page:nil :NO];
    //. ...
}


-(void)MyMessage
{
    MyMessageViewController * msg = [[MyMessageViewController alloc]init];
    [self.navigationController pushViewController:msg animated:YES];
}


//UISearchBar上按钮的默认文字为Cancel，如果想改为其他文字请调用一下代码

//for(id cc in [searchtext subviews]){
//if([cc isKindOfClass:[UIButton class]]){
//        　　 UIButton *btn = (UIButton *)cc;
//         [btn setTitle:@"取消" forState:UIControlStateNormal];
//        　　 }
//}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//刷新操作
static int page=0;
- (void)viewDidLayoutSubviews
{
    __weak PGViewController *weakSelf = self;
    //下拉操作
    [self.collectionView addPullToRefreshWithActionHandler:^{
        
        
        
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf getData:nil page:nil :YES];
            
            [weakSelf.collectionView.pullToRefreshView stopAnimating];
        });
    }];
    
    //上拉操作
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        
        [weakSelf getData:nil page:[NSString stringWithFormat:@"%d",++page] :NO];
        
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            
            
            
            [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        });

        
    }];
}

@end
