#import "GoodsDetailController.h"
#import "PastAnnouncedTableViewController.h"
#import "DirectSettleViewController.h"
@interface GoodsDetailController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;  //轮播控件
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UIView * stateView;
@property(nonatomic,strong)DetailView * detailView;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIView * headerView;
@property(nonatomic,strong)UIView * cunstomBarView;
@property(strong,nonatomic)HG_XiangGing *hg_XiangGing;
@property(nonatomic,strong)NSMutableArray * AdImages;           //存储轮播图片url数组
@property(nonatomic,strong) HGDetaliView1 * hgDetaliView1;
@property(nonatomic,strong) HGDetaliView2 * hgDetaliView2;
@property(strong,nonatomic) UITableView *pop_tableview;
@end

@implementation GoodsDetailController

#pragma mark - 设置导航栏
-(void)setBar
{
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1];
    //去掉返回按钮后面的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    //删除上一视图的标题view
//    for (UIImageView * view in self.navigationController.navigationBar.subviews)
//    {
//        if (view.tag == 10) {
//            [view removeFromSuperview];
//        }
//    }
    //隐藏系统导航栏
   // self.navigationController.navigationBar.hidden = YES;
    //创建自定义导航栏
    //self.cunstomBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    //self.cunstomBarView.backgroundColor = [UIColor clearColor];
    //[self.view addSubview:self.cunstomBarView];
    
//    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(20, 5,28, 28);//button的frame
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:backBtn];
//    
//    UIButton * cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cartBtn.frame = CGRectMake(WIDTH - 20 - 28, 5,28, 28);//button的frame
//    [cartBtn setBackgroundImage:[UIImage imageNamed:@"ic_cart_black"] forState:UIControlStateNormal];
//    [cartBtn addTarget:self action:@selector(cart) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:cartBtn];
//    
//    UIButton * homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    homeBtn.frame = CGRectMake(CGRectGetMinX(cartBtn.frame) - 10 - 28,5,28, 28);
//    [homeBtn setBackgroundImage:[UIImage imageNamed:@"ic_home_black2"] forState:UIControlStateNormal];
//    [homeBtn addTarget:self action:@selector(home) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:homeBtn];
//    
//    UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    shareBtn.frame = CGRectMake(CGRectGetMinX(homeBtn.frame) - 10 - 28, 5,28, 28);
//    [shareBtn setBackgroundImage:[UIImage imageNamed:@"ic_gooddetail_share"] forState:UIControlStateNormal];
//    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationController.navigationBar addSubview:shareBtn];
    
    //[self.view insertSubview:self.cunstomBarView atIndex:self.view.subviews.count-1];
}
//-(void)back
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
-(void)viewWillAppear:(BOOL)animated
{
    
    
}
//- (BOOL)prefersStatusBarHidden
//{
//    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//    return NO;
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self getData];
    [self createScrollView];
    
    [self setBar];
    
    //[self createFooterView];
}
#pragma mark - 表头视图
-(void)createHeaderView
{
    
    if (self.hg_XiangGing.type.integerValue==2) {
        self.hgDetaliView1 = [[NSBundle mainBundle]loadNibNamed:@"HGDetaliView1" owner:self
                                                        options:nil].firstObject;
        
        
        self.hgDetaliView1.frame = CGRectMake(0, self.cycleScrollView.bounds.size.height, WIDTH, self.hgDetaliView1.bounds.size.height);
        
        self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, CGRectGetHeight(self.cycleScrollView.frame)+CGRectGetHeight(self.hgDetaliView1.frame))];
        
        
        [self.headerView addSubview:self.cycleScrollView];
        
        [self.headerView addSubview:self.hgDetaliView1];
        
        self.headerView.backgroundColor = [UIColor whiteColor];
        
        [self.hgDetaliView1 setProperty:self.hg_XiangGing];
        
        if (self.hg_XiangGing.num.integerValue==0) {
            self.hgDetaliView1.hegouma.hidden=YES;
            
        }
        [self.hgDetaliView1.hegouma addTarget:self action:@selector(createPopView:) forControlEvents:UIControlEventTouchUpInside ];
        [self.hgDetaliView1.tuwenxiangqing addTarget:self action:@selector(pushtotuwenxiangqing) forControlEvents:UIControlEventTouchUpInside];
        [self.hgDetaliView1.wangqijiexiao addTarget:self action:@selector(pushtowangqijiexiao) forControlEvents:UIControlEventTouchUpInside];


    }else{
    
        self.hgDetaliView2 = [[NSBundle mainBundle]loadNibNamed:@"HGDetaliView2" owner:self
                                                        options:nil].firstObject;
        
        
        self.hgDetaliView2.frame = CGRectMake(0, self.cycleScrollView.bounds.size.height, WIDTH, self.hgDetaliView2.bounds.size.height);
        
        self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, CGRectGetHeight(self.cycleScrollView.frame)+CGRectGetHeight(self.hgDetaliView2.frame))];
        
        
        [self.headerView addSubview:self.cycleScrollView];
        
        [self.headerView addSubview:self.hgDetaliView2];
        
        self.headerView.backgroundColor = [UIColor whiteColor];
        
        [self.hgDetaliView2 setProperty:self.hg_XiangGing];
        

        [self.hgDetaliView2.tuwenxiangqing addTarget:self action:@selector(pushtotuwenxiangqing) forControlEvents:UIControlEventTouchUpInside];
        [self.hgDetaliView2.wangqijiexiao addTarget:self action:@selector(pushtowangqijiexiao) forControlEvents:UIControlEventTouchUpInside];


    
    }
    
  }

-(void)createPopView:(id)sender{
    UIView *view=(UIView *)sender;
   
    
    //NSArray *titles = self.hg_XiangGing.codes;
    NSArray *titles;
    if (self.hg_XiangGing.codes.count==0) {
        titles = @[@"无合购码", @"", @""];
    }else{
    
        titles = self.hg_XiangGing.codes;
    }
    
    
    
    self.pop_tableview=[[UITableView alloc]init];
    self.pop_tableview.frame = CGRectMake(0, 0, 150, 200);
    
    self.pop_tableview.dataSource=self;
    self.pop_tableview.delegate=self;
    
    //[self.hgDetaliView1 addSubview:self.pop_tableview];
    
    
    
    
    self.pop_tableview.layer.cornerRadius=4;

    
    
    DXPopover *popover = [DXPopover popover];

    CGPoint startPoint = CGPointMake(CGRectGetMidX(view.frame), CGRectGetMaxY(view.frame));
    
    [popover showAtPoint:startPoint popoverPostion:DXPopoverPositionUp withContentView:self.pop_tableview inView:view.superview];
    __weak typeof(self)weakSelf = self;
   
    popover.didDismissHandler = ^{
        [weakSelf bounceTargetView:view];
    };

   

}

- (void)bounceTargetView:(UIView *)targetView
{
    [UIView animateWithDuration:0.1 animations:^{
        targetView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            targetView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                targetView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}
#pragma mark - 广告滚动视图
-(void)createScrollView
{
    // 本地加载 --- 创建不带标题的图片轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, 360/*具体宽度根据屏幕高宽比适配*/)  imageURLStringsGroup:self.AdImages];
    
    self.cycleScrollView.infiniteLoop=YES;
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView.showPageControl=YES;
        //添加轮播器
    self.cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //         --- 轮播时间间隔，默认1.0秒，可自定义
    self.cycleScrollView.autoScrollTimeInterval = 2.0;
}
//#pragma mark - 商品标题
//-(void)createTitle
//{
//    //准备工作
//   self.titleLabel = [[UILabel alloc] init];
//   self.titleLabel.font = [UIFont systemFontOfSize:13];
//   NSString *str = @"啊哈那个光头我哀毁骨立啥耳机后宫IE爱国好久了及那时候就拿回家了韩国看那个和蔼搜狗IE啊格力高会偶尔傻化工我安社会共我过后嗯好建设";
//   self.titleLabel.text = str;
//   self.titleLabel.backgroundColor = [UIColor whiteColor];
//   self.titleLabel.numberOfLines = 0;//根据最大行数需求来设置
//   self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    CGSize maximumLabelSize = CGSizeMake(WIDTH, 9999);//labelsize的最大值
//    //关键语句
//    CGSize expectSize = [self.titleLabel sizeThatFits:maximumLabelSize];
//    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
//    self.titleLabel.frame = CGRectMake(10, CGRectGetMaxY(self.cycleScrollView.frame), expectSize.width, expectSize.height);
//}
//#pragma mark - 开奖状态
//-(void)createStateView
//{
//    self.stateView = [[NSBundle mainBundle]loadNibNamed:@"StateView1" owner:self options:nil].firstObject;
//    self.stateView.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), WIDTH, 94);
//}
//#pragma mark - 图文，往期，晒单视图
//-(void)createDetailView
//{
//    self.detailView = [[NSBundle mainBundle]loadNibNamed:@"DetailView" owner:self options:nil].firstObject;
//    self.detailView.frame = CGRectMake(0, CGRectGetMaxY(self.stateView.frame), WIDTH, 132);
//}
#pragma mark - 参与记录表
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView registerNib:[UINib nibWithNibName:@"JoinRecordCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

//#pragma mark - 底部sh
//-(void)createFooterView
//{
//    UIView * view = [[NSBundle mainBundle]loadNibNamed:@"DetailFooterView" owner:self options:nil].firstObject;
//    view.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), WIDTH, 44);
//    [self.view addSubview:view];
//}
#pragma mark - 表格数据源

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.datasource.count;
    if (tableView==self.pop_tableview) {
        return  self.hg_XiangGing.codes.count;
    }else{
        if (self.hg_XiangGing.type.integerValue!=2){
            
         return 0;
            
        }else{
         return self.hg_XiangGing.buy_info.count;
        }
        
       
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.pop_tableview==tableView) {
        static NSString *cellId = @"cellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        NSNumber *tt=self.hg_XiangGing.codes[indexPath.row];
        NSString *textstr=[NSString stringWithFormat:@"%@",tt];
        cell.textLabel.text =textstr;
        
        
        cell.backgroundColor=[UIColor colorWithRed:204/255.0 green:53/255.0 blue:58/255.0 alpha:1.0];
        cell.textLabel.textColor=[UIColor whiteColor];
        
       
  
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;

    }else{
      JoinRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        NSDictionary *dic=self.hg_XiangGing.buy_info[indexPath.row];
        [cell setProperty:dic];
        return cell;
    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
//#pragma mark - 自定义导航栏渐变
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    UIColor * color = [UIColor whiteColor];
//    CGFloat offset=scrollView.contentOffset.y;
//    if (offset<0) {
//        self.cunstomBarView.backgroundColor = [color colorWithAlphaComponent:0];
//    }else {
//        CGFloat alpha=1-((136-offset)/136);
//        self.cunstomBarView.backgroundColor=[color colorWithAlphaComponent:alpha];
//    }
//}


#pragma mark - 获取商品数据
-(void)getData
{
    self.AdImages=[NSMutableArray array];
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    
    parameters[@"lucky_id"] = self.lucky_id;//int	可选	分类id
//    parameters[@"uid"] = UID;//int	可选	分类id
//    parameters[@"token"] = TOKEN;//int	可选	分类id
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:Lucky_view_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"进来了");
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSLog(@"%@",dict);
         NSDictionary * dict1 = dict[@"data"];
         
         self.hg_XiangGing= [[HG_XiangGing alloc]initWithDictionary:dict1 error:nil];
         
   
         self.AdImages=[[self.hg_XiangGing.images componentsSeparatedByString:@","] mutableCopy];
         
         self.cycleScrollView.imageURLStringsGroup = self.AdImages;
         
         
         [self createHeaderView];
         [self createTableView];
         [self createGouMaiButton];
        
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         
     }];
    
    
    //查询是否购买合购
    
    
    
    
    
    
}


-(void)pushtotuwenxiangqing{
    
    GraphicDetailsViewController * detail = [[GraphicDetailsViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    //    [self presentViewController:detail animated:YES completion:nil];
    [detail setValue:self.hg_XiangGing forKey:@"hg_XiangGingmodel"];
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)pushtowangqijiexiao{
    
  PastAnnouncedTableViewController *VC = [[PastAnnouncedTableViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    VC.goods_id=self.hg_XiangGing.goods_id;
    //    [self presentViewController:detail animated:YES completion:nil];
    //[detail setValue:self.pgXiangGing_model forKey:@"pgXiangGingmodel"];
    [self.navigationController pushViewController:VC animated:YES];
}



-(void)createGouMaiButton{
    UIButton *gouwuche=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height-self.view.bounds.size.width/4*162/291, self.view.bounds.size.width/4, self.view.bounds.size.width/4*162/291)];
    UIButton *goumai=[[UIButton alloc]initWithFrame:CGRectMake(gouwuche.frame.origin.x+gouwuche.bounds.size.width, self.view.bounds.size.height-self.view.bounds.size.width/4*162/291, self.view.bounds.size.width/4, self.view.bounds.size.width/4*162/291)];
    
    [self.view addSubview:gouwuche];
    [self.view addSubview:goumai];
    [gouwuche setImage:[UIImage imageNamed:@"guwuche"] forState:UIControlStateNormal];
    [goumai setImage:[UIImage imageNamed:@"goumai"] forState:UIControlStateNormal];
    goumai.layer.zPosition=1000;
    gouwuche.layer.zPosition=1000;
    gouwuche.contentMode=UIViewContentModeScaleToFill;
    
    
    [gouwuche addTarget:self action:@selector(gouwucheButton1:) forControlEvents:UIControlEventTouchUpInside ];
    [goumai addTarget:self action:@selector(goumaiButton1:) forControlEvents:UIControlEventTouchUpInside ];
    //self.view.userInteractionEnabled=YES;
    goumai.enabled=YES;
    gouwuche.enabled=YES;
    
    
    
    
}
-(void)gouwucheButton1:(UIButton *)sender{
    
    self.hg_XiangGing.need_buy_num=@"1";
    
    //self.hg_XiangGing.price_level= jiagequjian[commodityDetailsView3.price.text];
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
            [db executeUpdate:@"insert into t_contact (buy_num,goods_id,lucky_id,money,name,price,thumb,times,total_num,type,user_id,num,start_time) values (?,?,?,?,?,?,?,?,?,?,?,?,?)",self.hg_XiangGing.buy_num,self.hg_XiangGing.goods_id,self.hg_XiangGing.lucky_id,self.hg_XiangGing.money,self.hg_XiangGing.name,self.hg_XiangGing.price,self.hg_XiangGing.thumb,self.hg_XiangGing.times,self.hg_XiangGing.total_num,self.hg_XiangGing.type,self.hg_XiangGing.user_id,self.hg_XiangGing.need_buy_num,self.hg_XiangGing.start_time];
        }
        else
        {
            //            FMResultSet *result =  [db executeQuery:@"select * from t_contact where goods_id=? and bid_id＝?;",self.pgXiangGing_model.goods_id,self.pgXiangGing_model.bid_id];
            
            FMResultSet *result =  [db executeQuery:@"select * from t_contact"];
            BOOL flag = NO;
            
            while ([result next])
            {
                
                
                
                
                if([[result stringForColumn:@"lucky_id"] isEqualToString:self.hg_XiangGing.lucky_id] && [[result stringForColumn:@"goods_id"] isEqualToString:self.hg_XiangGing.goods_id ])
                {
                    NSLog(@"商品重复了");
                    NSString * num = [result stringForColumn:@"num"];
                    
                    NSInteger count = [num integerValue];
                    
                    
                    count = count + self.hg_XiangGing.need_buy_num.integerValue;
                    
                    
                    [db executeUpdate:@"UPDATE t_contact SET num = ? where goods_id = ? and lucky_id = ?;", [NSString stringWithFormat:@"%ld",(long)count], self.hg_XiangGing.goods_id,self.hg_XiangGing.lucky_id];
                    
                    
                    
                    
                    
                    flag = YES;
                    
                    
                }
                
                
                
            }
            
            
            
            if(flag == NO)
                
            {
                UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:3];
                item.badgeValue = [NSString stringWithFormat:@"%ld",[item.badgeValue integerValue] + 1];
                NSLog(@"还没有");
                [db executeUpdate:@"insert into t_contact (buy_num,goods_id,lucky_id,money,name,price,thumb,times,total_num,type,user_id,num,start_time) values (?,?,?,?,?,?,?,?,?,?,?,?,?)",self.hg_XiangGing.buy_num,self.hg_XiangGing.goods_id,self.hg_XiangGing.lucky_id,self.hg_XiangGing.money,self.hg_XiangGing.name,self.hg_XiangGing.price,self.hg_XiangGing.thumb,self.hg_XiangGing.times,self.hg_XiangGing.total_num,self.hg_XiangGing.type,self.hg_XiangGing.user_id,self.hg_XiangGing.need_buy_num,self.hg_XiangGing.start_time];
                
            }
        }
        
        [SVProgressHUD showSuccessWithStatus:@"商品已加入购物车"];
        
        
    }else{
        
        TIPS;
        
    }
    
    
    
}
-(void)goumaiButton1:(UIButton *)sender{
    
    

    
    
    
    if(TOKEN)
    {
        //跳转到结算界面选择支付方式
        NSDictionary * dict;
        dict= @{@"id":self.hg_XiangGing.lucky_id,@"type":@"1",@"num":@"1"};
    
        DirectSettleViewController * direct = [[DirectSettleViewController alloc]init];
        
       
       
       direct.dic =dict;
      self.hidesBottomBarWhenPushed = YES;
      [self.navigationController pushViewController:direct animated:YES];
       self.hidesBottomBarWhenPushed = YES;

    }
    else
    {
        TIPS;
       
    }

    
    
    
}





@end
