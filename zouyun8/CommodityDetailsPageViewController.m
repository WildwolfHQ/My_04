//
//  CommodityDetailsPageViewController.m
//  zouyun8
//
//  Created by 端正赵 on 16/5/27.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "CommodityDetailsPageViewController.h"

@interface CommodityDetailsPageViewController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    UILabel *pageLableShow;
    CommodityDetailsView3 * commodityDetailsView3;

    NSMutableDictionary *jiagequjian;
    
    UITableView *jiage_tableview;
  
    NSMutableArray *y_array;

}
@property(nonatomic,strong)PGXiangGing  * pgXiangGing_model;         //数据源
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;  //轮播控件
@property(nonatomic,strong)NSMutableArray * AdImages;           //存储轮播图片url数组
@property(nonatomic,strong)NSMutableArray * AdUrls;             //存储轮播商品地址

@end

@implementation CommodityDetailsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];

    self.scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    
    [self.view addSubview:self.scrollView];
    
    

    
    // 隐藏水平滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    
    self.scrollView.contentSize=CGSizeMake(WIDTH, 900);
    self.scrollView.backgroundColor=[UIColor colorWithRed:210/225.0 green:210/225.0 blue:210/225.0 alpha:1];

    

    
    
    
    
//    [self getData];
//    [self GetAdPicture];
    [self createAdScrollView];
  
    [self setBar];
    [self createGouMaiButton];
   // [self createGouMaiButton];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    

}
-(void)viewDidAppear:(BOOL)animated{
    //self.tabBarController.tabBar.hidden=YES;
    
}


#pragma mark - 设置导航栏
-(void)setBar
{
    //左边buttonBarItem
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_fanhuo"] style:UIBarButtonItemStylePlain target:self action:@selector(pushToSort)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;

    //右边rightItems
    UIImage *image1 = [UIImage imageNamed:@"icon_nav_fenxiang"];
    UIBarButtonItem *imageBar1 = [[UIBarButtonItem alloc]initWithImage:image1 style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItems = @[imageBar1];
    
    
    
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.navigationItem.title=@"商品详情";
}





-(void)pushToSort{

    [self.navigationController popViewControllerAnimated:YES];

}
-(void)share{
    
    NSDictionary *dic=[[NSMutableDictionary alloc]init];
    
    [dic setValue:self.pgXiangGing_model.thumb forKey:@"image"];
    [dic setValue:@"" forKey:@"desc"];
     [dic setValue:[NSString stringWithFormat:@"%@%@",Share_URL,self.pgXiangGing_model.bid_id]forKey:@"url"];
    [dic setValue:self.pgXiangGing_model.name forKey:@"title"];
    [dic setValue:@"1" forKey:@"share_action"];
    
    [ToolClass share:dic];

}

#pragma mark - 广告滚动视图
-(void)createAdScrollView
{
    
    
    // 本地加载 --- 创建不带标题的图片轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, 350/*具体宽度根据屏幕高宽比适配*/) shouldInfiniteLoop:YES imageNamesGroup:self.AdImages];
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    //是否自动播放
    self.cycleScrollView.autoScroll=NO;
//    //添加轮播器
    self.cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    //         --- 轮播时间间隔，默认1.0秒，可自定义
//    self.cycleScrollView.autoScrollTimeInterval = 1.0;
    self.cycleScrollView.showPageControl=NO;
    
    
    
    
    pageLableShow=[[UILabel alloc]init];
    
    pageLableShow.frame=CGRectMake(self.cycleScrollView.bounds.size.width/10*8, self.cycleScrollView.bounds.size.height/4*3, 40, 40) ;
    pageLableShow.text=@"1/9";
    pageLableShow.textColor=[UIColor whiteColor];
    pageLableShow.backgroundColor=[UIColor darkGrayColor];
    pageLableShow.textAlignment=NSTextAlignmentCenter;
    
    pageLableShow.layer.cornerRadius=pageLableShow.bounds.size.width/2;
    pageLableShow.clipsToBounds=YES;
    [self.cycleScrollView addSubview:pageLableShow];
    

    
}






#pragma mark - 广告视图代理方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    
//    NSLog(@"%@",self.AdUrls[index]);
//    //跳转到商品详情，实验。
//    GoodsDetailController * detail = [[GoodsDetailController alloc]init];
//    self.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:detail animated:YES];
//    self.hidesBottomBarWhenPushed=NO;
}



/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;{

    long m=index+1;
    pageLableShow.text=[NSString stringWithFormat:@"%@/%@",@(m),@(cycleScrollView.imageURLStringsGroup.count)];
    
}
//#pragma mark - 广告图片
//-(void)GetAdPicture
//{
//    
//    //初始化广告图片数组
//    self.AdImages = [[NSMutableArray alloc]init];
//    self.AdUrls = [[NSMutableArray alloc]init];
//    
//    NSDictionary * parameters = @{@"id":@"3759885702"};
//    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//    securityPolicy.validatesDomainName = NO;
//    securityPolicy.allowInvalidCertificates = YES;
//    manager.securityPolicy = securityPolicy;
//    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager GET:ADURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//         NSArray * array = dict[@"data"];
//         //请求成功,将图片下载完保存到数组中
//         for (NSDictionary * dic in array)
//         {
//             [self.AdImages addObject:[NSURL URLWithString:dic[@"url"]]];
//             [self.AdUrls addObject:[NSURL URLWithString:dic[@"href"]]];
//         }
//       
//         
//        
//     }
//         failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         
//     }];
//}


#pragma mark - 获取商品数据
-(void)getData
{
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    
    parameters[@"bid_id"] = self.bid_id;//int	可选	分类id
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:PGxiangqingPageURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"进来了");
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSLog(@"%@",dict);
         NSDictionary * dict1 = dict[@"data"];
         
         self.pgXiangGing_model= [[PGXiangGing alloc]initWithDictionary:dict1 error:nil];
         
         
         [self createView];
         self.AdImages=[[self.pgXiangGing_model.images componentsSeparatedByString:@","] mutableCopy];
         
         self.cycleScrollView.imageURLStringsGroup = self.AdImages;
         pageLableShow.text=[NSString stringWithFormat:@"1/%@",@(self.cycleScrollView.imageURLStringsGroup.count)];
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
    [self getData];
}








//
-(void)createView{
    
    
    //1
    CommodityDetailsView1 * commodityDetailsView1 = [[NSBundle mainBundle]loadNibNamed:@"CommodityDetailsView1" owner:self
                                               options:nil].firstObject;
    commodityDetailsView1.frame = CGRectMake(0, self.cycleScrollView.bounds.size.height, WIDTH, commodityDetailsView1.bounds.size.height);
  
//    commodityDetailsView1.backgroundColor = [UIColor  colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0,WIDTH, self.cycleScrollView.bounds.size.height+commodityDetailsView1.bounds.size.height)];
    [view1 addSubview:self.cycleScrollView];
    [view1 addSubview:commodityDetailsView1];
    
    [commodityDetailsView1 setProperty:self.pgXiangGing_model and:self];
    [self.scrollView addSubview:view1];
    
    
    
    //2
    CommodityDetailsView2 * commodityDetailsView2 = [[NSBundle mainBundle]loadNibNamed:@"CommodityDetailsView2" owner:self
                                                                               options:nil].firstObject;
    commodityDetailsView2.frame = CGRectMake(0, view1.bounds.size.height, WIDTH, commodityDetailsView2.bounds.size.height);
    [self.scrollView addSubview:commodityDetailsView2];
    
    [commodityDetailsView2 setProperty:self.pgXiangGing_model];
    
    
    
    //3
    
    
    
    
    UIView *view3=[[UIView alloc]init];
    
    UIImageView *view3_1=[[UIImageView alloc]init];
    
    view3_1.frame=CGRectMake(0,0, WIDTH, 150);
    
    
  
   
    NSArray*array=self.pgXiangGing_model.rule;
    
    NSMutableArray *x_array=[[NSMutableArray alloc]init];
    y_array=[[NSMutableArray alloc]init];
    
    for (NSString *str in array) {
        
       
        
        [x_array addObject:[str componentsSeparatedByString:@"|"][0]];
        [y_array addObject:[str componentsSeparatedByString:@"|"][1]];
        
        
        
        
    }
    jiagequjian=[[NSMutableDictionary alloc]initWithObjects:x_array forKeys:y_array];
   
    
//
//    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(10, 0, WIDTH-20, 150) andLineChartType:JHChartLineValueNotForEveryX];
//    
//    /* X轴的刻度值 可以传入NSString或NSNumber类型  并且数据结构随折线图类型变化而变化 详情看文档或其他象限X轴数据源示例*/
//    lineChart.xLineDataArr = x_array;
//
//    
//    lineChart.yLineDataArr = [[y_array reverseObjectEnumerator] allObjects];
//    
//    /* 折线图的不同类型  按照象限划分 不同象限对应不同X轴刻度数据源和不同的值数据源 */
//    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
//    
//    /* 数据源 */
//     lineChart.valueArr = @[y_array];
//    
//    /* 值折线的折线颜色 默认暗黑色*/
//    //    lineChart.valueLineColorArr ;
//    
//    /* 值点的颜色 默认橘黄色*/
//    lineChart.pointColorArr = @[[UIColor lightGrayColor],[UIColor lightGrayColor]];
//    
//    /* X和Y轴的颜色 默认暗黑色 */
//    lineChart.xAndYLineColor = [UIColor lightGrayColor];
//    
//    /* XY轴的刻度颜色 m */
//    lineChart.xAndYNumberColor = [UIColor darkGrayColor];
//    
//    /* 坐标点的虚线颜色 */
//    lineChart.positionLineColorArr = @[[UIColor lightGrayColor],[UIColor lightGrayColor]];
//    lineChart.backgroundColor=[UIColor whiteColor];
//    [view3_1 addSubview:lineChart];
//    [lineChart showAnimation];
    
    

    
    
    
    
     commodityDetailsView3 = [[NSBundle mainBundle]loadNibNamed:@"CommodityDetailsView3" owner:self
                                                                               options:nil].firstObject;
    commodityDetailsView3.frame = CGRectMake(0,view3_1.bounds.size.height, WIDTH, commodityDetailsView3.bounds.size.height);
    
    view3.frame= CGRectMake(0,20+commodityDetailsView2.frame.origin.y+commodityDetailsView2.bounds.size.height, WIDTH, commodityDetailsView3.bounds.size.height+view3_1.bounds.size.height);
    
    view3.backgroundColor=[UIColor whiteColor];
    [view3 addSubview:view3_1];
    [view3 addSubview:commodityDetailsView3];
    
    [commodityDetailsView3 setProperty:self.pgXiangGing_model];
   
    [self.scrollView addSubview:view3];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jiageTable)];
    [self.view addGestureRecognizer:singleTap];
 
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    [commodityDetailsView3.price addGestureRecognizer:singleTap];
    
    
//    //4
//    CommodityDetailsView4 * commodityDetailsView4 = [[NSBundle mainBundle]loadNibNamed:@"CommodityDetailsView4" owner:self
//                                                                               options:nil].firstObject;
//    commodityDetailsView4.frame = CGRectMake(0,20+view3.frame.origin.y+view3.bounds.size.height, WIDTH, commodityDetailsView4.bounds.size.height);
//    [self.scrollView addSubview:commodityDetailsView4];
//    [commodityDetailsView4 setProperty:self.pgXiangGing_model];
    

    
    jiage_tableview=[[UITableView alloc]initWithFrame:CGRectMake(commodityDetailsView3.price.frame.origin.x, commodityDetailsView3.price.frame.origin.y, commodityDetailsView3.price.bounds.size.width, 150) style:UITableViewStylePlain];
    jiage_tableview.dataSource=self;
    jiage_tableview.delegate=self;
    
    [view3 addSubview:jiage_tableview];
    jiage_tableview.hidden=YES;
    

   
    jiage_tableview.layer.cornerRadius=4;
    
    
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return  y_array.count;
   

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
   
    
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    
    }
    cell.textLabel.text=y_array[indexPath.row];
    cell.backgroundColor=[UIColor colorWithRed:204/255.0 green:53/255.0 blue:58/255.0 alpha:1.0];
    cell.textLabel.textColor=[UIColor whiteColor];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor blackColor];
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    commodityDetailsView3.price.text=y_array[indexPath.row];
    [self jiageTable];
}
static bool isChange;
-(void)jiageTable{
    isChange=!isChange;
    if (isChange) {
        jiage_tableview.hidden=NO;
    }else{
      jiage_tableview.hidden=YES;
    }
    
}
-(void)createGouMaiButton{
  UIButton *gouwuche=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height-self.view.bounds.size.width/4*162/291-self.tabBarController.tabBar.bounds.size.height, self.view.bounds.size.width/4, self.view.bounds.size.width/4*162/291)];
    UIButton *goumai=[[UIButton alloc]initWithFrame:CGRectMake(gouwuche.frame.origin.x+gouwuche.bounds.size.width, self.view.bounds.size.height-self.view.bounds.size.width/4*162/291-self.tabBarController.tabBar.bounds.size.height, self.view.bounds.size.width/4, self.view.bounds.size.width/4*162/291)];
    
    [self.view addSubview:gouwuche];
    [self.view addSubview:goumai];
    [gouwuche setImage:[UIImage imageNamed:@"guwuche"] forState:UIControlStateNormal];
    [goumai setImage:[UIImage imageNamed:@"goumai"] forState:UIControlStateNormal];
    goumai.layer.zPosition=1000;
    gouwuche.layer.zPosition=1000;
    gouwuche.contentMode=UIViewContentModeScaleToFill;


    [gouwuche addTarget:self action:@selector(gouwucheButton:) forControlEvents:UIControlEventTouchUpInside ];
     [goumai addTarget:self action:@selector(goumaiButton:) forControlEvents:UIControlEventTouchUpInside ];
    
    

    
}
-(void)gouwucheButton:(UIButton *)sender{
    
    self.pgXiangGing_model.buy_num=commodityDetailsView3.lable.text;
    
    self.pgXiangGing_model.price_level= jiagequjian[commodityDetailsView3.price.text];
    //将cell属性里面的商品id加入到购物车数据库
    FMDatabase *db = [FMDatabase databaseWithPath:DBFATH];
    // 打开数据库
    [db open];
    //当前程序数据库是否有数据
    NSUInteger count = [db intForQuery:@"select count(*) from t_contact"];
    //插入购物车所需的cell数据到数据库
    NSLog(@"当前的token%@",TOKEN);
    if(TOKEN)
    {
        
        
        if(count == 0)
        {
            UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:3];
            item.badgeValue = [NSString stringWithFormat:@"%ld",[item.badgeValue integerValue] + 1];
            NSLog(@"增加当前cell数据");
            [db executeUpdate:@"insert into t_contact (buy_num,goods_id,lucky_id,money,name,price,thumb,times,total_num,type,user_id,num,bid_id,buy_user_num,start_time,end_time,price_level) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",self.pgXiangGing_model.buy_num,self.pgXiangGing_model.goods_id,self.pgXiangGing_model.lucky_id,self.pgXiangGing_model.money,self.pgXiangGing_model.name,self.pgXiangGing_model.price,self.pgXiangGing_model.thumb,self.pgXiangGing_model.times,self.pgXiangGing_model.total_num,self.pgXiangGing_model.type,self.pgXiangGing_model.user_id,self.pgXiangGing_model.buy_num,self.pgXiangGing_model.bid_id,self.pgXiangGing_model.buy_user_num,self.pgXiangGing_model.start_time,self.pgXiangGing_model.end_time,self.pgXiangGing_model.price_level];
        }
        else
        {
            //            FMResultSet *result =  [db executeQuery:@"select * from t_contact where goods_id=? and bid_id＝?;",self.pgXiangGing_model.goods_id,self.pgXiangGing_model.bid_id];
            
            FMResultSet *result =  [db executeQuery:@"select * from t_contact"];
            BOOL flag = NO;
            
            while ([result next])
            {
                
                
                
                
                if([[result stringForColumn:@"bid_id"] isEqualToString:self.pgXiangGing_model.bid_id] && [[result stringForColumn:@"goods_id"] isEqualToString:self.pgXiangGing_model.goods_id ])
                {
                    NSLog(@"商品重复了");
                    NSString * num = [result stringForColumn:@"num"];
                    
                    NSInteger count = [num integerValue];
                    
                    
                    count = count + self.pgXiangGing_model.buy_num.integerValue;
                    
                    
                    [db executeUpdate:@"UPDATE t_contact SET num = ? where goods_id = ? and bid_id = ?;", [NSString stringWithFormat:@"%ld",(long)count], self.pgXiangGing_model.goods_id,self.pgXiangGing_model.bid_id];
                    
                    
                    
                    
                    
                    flag = YES;
                    
                    
                }
                
                
                
            }
            
            
            
            if(flag == NO)
                
            {
                UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:3];
                item.badgeValue = [NSString stringWithFormat:@"%ld",[item.badgeValue integerValue] + 1];
                NSLog(@"还没有");
                [db executeUpdate:@"insert into t_contact (buy_num,goods_id,lucky_id,money,name,price,thumb,times,total_num,type,user_id,num,bid_id,buy_user_num,start_time,end_time,price_level) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",self.pgXiangGing_model.buy_num,self.pgXiangGing_model.goods_id,self.pgXiangGing_model.lucky_id,self.pgXiangGing_model.money,self.pgXiangGing_model.name,self.pgXiangGing_model.price,self.pgXiangGing_model.thumb,self.pgXiangGing_model.times,self.pgXiangGing_model.total_num,self.pgXiangGing_model.type,self.pgXiangGing_model.user_id,self.pgXiangGing_model.buy_num,self.pgXiangGing_model.bid_id,self.pgXiangGing_model.buy_user_num,self.pgXiangGing_model.start_time,self.pgXiangGing_model.end_time,self.pgXiangGing_model.price_level];
                
            }
        }
        
        [SVProgressHUD showSuccessWithStatus:@"商品已加入购物车"];
       
        
        
    }else{
        
        //TIPS;
        if (TOKEN==nil) {
             [[NSNotificationCenter defaultCenter]postNotificationName:@"directLogin" object:nil];
          
        }
        
        
    }



}
-(void)goumaiButton:(UIButton *)sender{
    
    
    self.pgXiangGing_model.buy_num=commodityDetailsView3.lable.text;
    
    self.pgXiangGing_model.price_level= jiagequjian[commodityDetailsView3.price.text];
    //将cell属性里面的商品id加入到购物车数据库
    FMDatabase *db = [FMDatabase databaseWithPath:DBFATH];
    // 打开数据库
    [db open];
    //当前程序数据库是否有数据
    NSUInteger count = [db intForQuery:@"select count(*) from t_contact"];
    //插入购物车所需的cell数据到数据库
    NSLog(@"当前的token%@",TOKEN);
    if(TOKEN)
    {
        if(count == 0)
        {
            UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:3];
            item.badgeValue = [NSString stringWithFormat:@"%ld",[item.badgeValue integerValue] + 1];
            NSLog(@"增加当前cell数据");
            [db executeUpdate:@"insert into t_contact (buy_num,goods_id,lucky_id,money,name,price,thumb,times,total_num,type,user_id,num,bid_id,buy_user_num,start_time,end_time,price_level) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",self.pgXiangGing_model.buy_num,self.pgXiangGing_model.goods_id,self.pgXiangGing_model.lucky_id,self.pgXiangGing_model.money,self.pgXiangGing_model.name,self.pgXiangGing_model.price,self.pgXiangGing_model.thumb,self.pgXiangGing_model.times,self.pgXiangGing_model.total_num,self.pgXiangGing_model.type,self.pgXiangGing_model.user_id,self.pgXiangGing_model.buy_num,self.pgXiangGing_model.bid_id,self.pgXiangGing_model.buy_user_num,self.pgXiangGing_model.start_time,self.pgXiangGing_model.end_time,self.pgXiangGing_model.price_level];
        }
        else
        {
//            FMResultSet *result =  [db executeQuery:@"select * from t_contact where goods_id=? and bid_id＝?;",self.pgXiangGing_model.goods_id,self.pgXiangGing_model.bid_id];
            
            FMResultSet *result =  [db executeQuery:@"select * from t_contact"];
            BOOL flag = NO;
        
            while ([result next])
            {
             
              
            
            
                if([[result stringForColumn:@"bid_id"] isEqualToString:self.pgXiangGing_model.bid_id] && [[result stringForColumn:@"goods_id"] isEqualToString:self.pgXiangGing_model.goods_id ])
                {
                    NSLog(@"商品重复了");
                    NSString * num = [result stringForColumn:@"num"];
                    
                    NSInteger count = [num integerValue];
                    
                    
                    count = count + self.pgXiangGing_model.buy_num.integerValue;
                    
                    
                    [db executeUpdate:@"UPDATE t_contact SET num = ? where goods_id = ? and bid_id = ?;", [NSString stringWithFormat:@"%ld",(long)count], self.pgXiangGing_model.goods_id,self.pgXiangGing_model.bid_id];
                    
                    

                    
                    
                    flag = YES;

                
                }

                
            
            }
            
            
            
            if(flag == NO)
            {
                UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:3];
                item.badgeValue = [NSString stringWithFormat:@"%ld",[item.badgeValue integerValue] + 1];
                NSLog(@"还没有");
                [db executeUpdate:@"insert into t_contact (buy_num,goods_id,lucky_id,money,name,price,thumb,times,total_num,type,user_id,num,bid_id,buy_user_num,start_time,end_time,price_level) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",self.pgXiangGing_model.buy_num,self.pgXiangGing_model.goods_id,self.pgXiangGing_model.lucky_id,self.pgXiangGing_model.money,self.pgXiangGing_model.name,self.pgXiangGing_model.price,self.pgXiangGing_model.thumb,self.pgXiangGing_model.times,self.pgXiangGing_model.total_num,self.pgXiangGing_model.type,self.pgXiangGing_model.user_id,self.pgXiangGing_model.buy_num,self.pgXiangGing_model.bid_id,self.pgXiangGing_model.buy_user_num,self.pgXiangGing_model.start_time,self.pgXiangGing_model.end_time,self.pgXiangGing_model.price_level];
                
            }
        }
        
        
        
        ShoppingcartViewController *vc=[[ShoppingcartViewController alloc]init];
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        self.hidesBottomBarWhenPushed = YES;
        
    }else{
        
//        self.tabBarController.selectedIndex=3;
//        self.navigationController p
        if (TOKEN==nil) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"directLogin" object:nil];
            
        }

    
    }
   
    
}

-(void)pushtotuwenxiangqing{

    GraphicDetailsViewController * detail = [[GraphicDetailsViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    //    [self presentViewController:detail animated:YES completion:nil];
    [detail setValue:self.pgXiangGing_model forKey:@"pgXiangGingmodel"];
    [self.navigationController pushViewController:detail animated:YES];
}


@end
