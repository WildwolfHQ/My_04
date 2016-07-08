#import "ViewController.h"
#import "SearchViewController.h"
#import "RedPacketViewController.h"
#import "ADViewController.h"
#import "LimitViewController.h"
#import "CZPicker.h"
#import "DirectSettleViewController.h"
#import "BuyTogetherController.h"
#import "GoodsWebViewController.h"
#import "HgGoodsDetailController.h"
#import "JKAlertDialog.h"
#import "AlertDialogSubView.h"
@interface FirstViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate,FirstCollectionViewCellDelegate,UIPickerViewDelegate,view2Delegate,UITextFieldDelegate,CZPickerViewDataSource, CZPickerViewDelegate,view4Delegate>{

    NSString *_hgID;
    NSString *_hgNum;
    BOOL istishi;
    view3 * _view31;
    NSMutableArray *_array3;
    JKAlertDialog *alert;
    AlertDialogSubView * alertDialogSubView;
    BOOL _is_Refresh;
    BOOL _isjishu;
}

@property(nonatomic,strong)NSMutableArray * dataSource;         //数据源
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;  //轮播控件
@property(nonatomic,strong)NSMutableArray * AdImages;           //存储轮播图片url数组
@property(nonatomic,strong)NSMutableArray * AdUrls;             //存储轮播商品地址
@property(nonatomic,strong)UIView * headView;
@property(nonatomic,strong)view4 * view4;

@property(nonatomic,strong)UIImageView * imageView;

@property(nonatomic,strong)NSString * imageUrl1;//保存最新揭晓图片地址
@property(nonatomic,strong)NSString * imageUrl2;
@property(nonatomic,strong)NSString * imageUrl3;

@property(nonatomic,strong)NSMutableArray * names;//保存喇叭通知的姓名
@property(nonatomic,strong)NSMutableArray * prizes;//保存喇叭通知的奖品名称

@property(nonatomic,assign)NSInteger page;
@property(nonatomic,copy)NSString * top;
@property(nonatomic,assign)BOOL is_announce;

@property(nonatomic,strong)GoodsModel * model;
@property(nonatomic,strong)UIPickerView * pickView;
@property(nonatomic,strong)UITextField * NumTextField;

@property NSMutableArray *fruits;
@property NSMutableArray *fruitImages;
@property CZPickerView *pickerWithImage;

@property(nonatomic,copy)NSString * price1;
@property(nonatomic,copy)NSString * price2;
@property(nonatomic,copy)NSString * price3;
@property(nonatomic,copy)NSString * last1;
@property(nonatomic,copy)NSString * last2;
@property(nonatomic,copy)NSString * last3;
@property(nonatomic,strong)NSArray * GoodsArray;
@end

@implementation FirstViewController


#pragma mark - 懒加载dataSource
-(NSMutableArray *)dataSource
{
    if (_dataSource == nil)
    {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setBar];
    

}
-(void)pushToSort
{
    SortTableViewController * sort = [[SortTableViewController alloc]init];
     self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sort animated:YES];
     self.hidesBottomBarWhenPushed = NO;
}

-(void)pushToSearch
{
    SearchViewController * search = [[SearchViewController alloc]init];
     self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
     self.hidesBottomBarWhenPushed = NO;
}

-(void)MyMessage
{
    MyMessageViewController * msg = [[MyMessageViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:msg animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//我是土豪
-(void)directToPay:(NSDictionary *)dict
{
    
    
    
    ShoppingcartViewController *vc=[[ShoppingcartViewController alloc]init];
    
    vc.is_tabBarHidden=YES;
    vc.is_tuhao=YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

    self.hidesBottomBarWhenPushed = NO;
    
//    NSString * type = TYPE;
//    if ([type integerValue] == 2) {
//    
//        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"尊敬的试购员，您只能发起合购并邀请好友参与，不能参与他人的合购！" preferredStyle:UIAlertControllerStyleAlert];
//        
//        
//        
//        
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            
//            
//            
//        }];
//        
//        
//        
//        
//        
//        [alertController addAction:okAction];
//       
//        
//        //膜态时一定要判断你膜态的ViewController是不是空 ，空才能去膜态 、非空不能。
//        if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController == nil)
//            
//        {
//            
//            
//            [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:alertController  animated: YES completion:nil];
//            
//            
//        }
//
//        
//        
//        
//    }else{
        //跳到购物车
        
//        GoodsModel *pgXiangGing_model= [[GoodsModel alloc]initWithDictionary:dict error:nil];
//        
//        pgXiangGing_model.buy_num=@"1";
//        FMDatabase *db = [FMDatabase databaseWithPath:DBFATH];
//        // 打开数据库
//        [db open];
//        //当前程序数据库是否有数据
//        NSUInteger count = [db intForQuery:@"select count(*) from t_contact"];
//        //插入购物车所需的cell数据到数据库
//        NSLog(@"当前的token%@",TOKEN);
//        if(TOKEN)
//        {
//            
//            
//            if(count == 0)
//            {
//                UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:2];
//                
//                item.badgeValue = [NSString stringWithFormat:@"%d",1];
//                
//                NSLog(@"增加当前cell数据");
//                [db executeUpdate:@"insert into t_contact (buy_num,goods_id,lucky_id,money,name,price,thumb,times,total_num,type,user_id,num,bid_id,buy_user_num,start_time,end_time,price_level) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",pgXiangGing_model.buy_num,pgXiangGing_model.goods_id,pgXiangGing_model.lucky_id,pgXiangGing_model.money,pgXiangGing_model.name,nil,pgXiangGing_model.thumb,pgXiangGing_model.times,pgXiangGing_model.total_num,pgXiangGing_model.type,pgXiangGing_model.user_id,pgXiangGing_model.buy_num,nil,pgXiangGing_model.buy_user_num,pgXiangGing_model.start_time,pgXiangGing_model.end_time,pgXiangGing_model.price_level];
//            }
//            else
//            {
//                //            FMResultSet *result =  [db executeQuery:@"select * from t_contact where goods_id=? and bid_id＝?;",self.pgXiangGing_model.goods_id,self.pgXiangGing_model.bid_id];
//                
//                FMResultSet *result =  [db executeQuery:@"select * from t_contact"];
//                BOOL flag = NO;
//                
//                while ([result next])
//                {
//                    
//                    
//                    
//                    
//                    if([[result stringForColumn:@"lucky_id"] isEqualToString:pgXiangGing_model.lucky_id] && [[result stringForColumn:@"goods_id"] isEqualToString:pgXiangGing_model.goods_id ])
//                    {
//                        NSLog(@"商品重复了");
//                        NSString * num = [result stringForColumn:@"num"];
//                        
//                        NSInteger count = [num integerValue];
//                        
//                        
//                        count = count + pgXiangGing_model.buy_num.integerValue;
//                        
//                        
//                        [db executeUpdate:@"UPDATE t_contact SET num = ? where goods_id = ? and lucky_id = ?;", [NSString stringWithFormat:@"%ld",(long)count], pgXiangGing_model.goods_id,pgXiangGing_model.lucky_id];
//                        
//                        
//                        
//                        
//                        
//                        flag = YES;
//                        
//                        
//                    }
//                    
//                    
//                    
//                }
//                
//                
//                
//                if(flag == NO)
//                    
//                {
//                    UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:2];
//                    item.badgeValue = [NSString stringWithFormat:@"%ld",[item.badgeValue integerValue] + 1];
//                    NSLog(@"还没有");
//                    [db executeUpdate:@"insert into t_contact (buy_num,goods_id,lucky_id,money,name,price,thumb,times,total_num,type,user_id,num,bid_id,buy_user_num,start_time,end_time,price_level) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",pgXiangGing_model.buy_num,pgXiangGing_model.goods_id,pgXiangGing_model.lucky_id,pgXiangGing_model.money,pgXiangGing_model.name,nil,pgXiangGing_model.thumb,pgXiangGing_model.times,pgXiangGing_model.total_num,pgXiangGing_model.type,pgXiangGing_model.user_id,pgXiangGing_model.buy_num,pgXiangGing_model.bid_id,pgXiangGing_model.buy_user_num,pgXiangGing_model.start_time,pgXiangGing_model.end_time,pgXiangGing_model.price_level];
//                    
//                }
//            }
//            
////            //停止加载不然跳转时可能会线程死掉
////            self.webView.delegate = nil;
////            [self.webView stopLoading];
//            
//            
//            
//            ShoppingcartViewController *vc=[[ShoppingcartViewController alloc]init];
//            
//            vc.is_tabBarHidden=YES;
//            self.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//            
//            
//            
//            
//            
//        }else{
//            
//            //TIPS;
//            if (TOKEN==nil) {
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"directLogin" object:nil];
//            }
//        }
//        
        

        
        
        
        
//    DirectSettleViewController * direct = [[DirectSettleViewController alloc]init];
//    direct.dic = dict;
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:direct animated:YES];
//        self.hidesBottomBarWhenPushed = NO;
//    }
}
//公开专区
-(void)OpenHeGouDetail:(NSDictionary *)dict
{
    //http://zy8.jf-q.com/l/v/[lucky_id]/?uid=[uid]&token=[token]  实际链接中没有中括号
    NSString * url = [NSString stringWithFormat:@"http://m.zouyun8.com/l/v/%@/?uid=%@&token=%@",dict[@"id"],UID,TOKEN];
    GoodsWebViewController * VC = [[GoodsWebViewController alloc]init];
    
    VC.urlStr = url;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//公开列表
-(void)OpenHeGou
{
    BuyTogetherController * buy = [[BuyTogetherController alloc]init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:buy animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

#pragma mark - 设置导航栏
-(void)setBar
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    //标题视图
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,90,30)];
  
    _imageView.center = CGPointMake(WIDTH/2,22);
    _imageView.image = [UIImage imageNamed:@"走运网-LOGO.png"];
    _imageView.tag = 10;
    [self.navigationController.navigationBar addSubview:_imageView];
    
    UIBarButtonItem *fixBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixBar.width = -20;
    
    UIImage *image1 = [UIImage imageNamed:@"分类.png"];
    UIBarButtonItem *imageBar1 = [[UIBarButtonItem alloc]initWithImage:image1 style:UIBarButtonItemStylePlain target:self action:@selector(pushToSort)];
    UIImage *image2 = [UIImage imageNamed:@"搜索.png"];
    UIBarButtonItem *imageBar2 = [[UIBarButtonItem alloc]initWithImage:image2 style:UIBarButtonItemStylePlain target:self action:@selector(pushToSearch)];
    imageBar2.tag = 100;
    imageBar2.tintColor = [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1];
    //imageBar2.imageInsets = UIEdgeInsetsMake(0, 20, 0, -20);
    self.navigationItem.leftBarButtonItem=imageBar2;
    
    self.navigationItem.rightBarButtonItem=imageBar1;
    //左边buttonBarItem
//    UIBarButtonItem *fixBar2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    fixBar2.width = -20;
    
//    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分类"] style:UIBarButtonItemStylePlain target:self action:@selector(pushToSort)];
    
//     leftButtonItem.imageInsets = UIEdgeInsetsMake(0,-20, 0, 20);
    
//     UIBarButtonItem *leftButtonItem1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_fanhuo"] style:UIBarButtonItemStylePlain target:self action:@selector(pushToback)];
////    leftButtonItem1.imageInsets = UIEdgeInsetsMake(0,0, 0, -20);
//
//    self.navigationItem.leftBarButtonItems = @[fixBar,leftButtonItem1];
//    
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1];
//     leftButtonItem1.tintColor = [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1];
//       leftButtonItem.tintColor = [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1];
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1];
}
-(void)pushToback{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 创建collectionView的顶部视图
-(void)createHeadView
{
    view2 * view2 = [[NSBundle mainBundle]loadNibNamed:@"view2" owner:self options:nil].firstObject;
    view2.delegate = self;
    view2.frame = CGRectMake(0, 130, WIDTH, 67);
    view2.backgroundColor = [UIColor whiteColor];
    
    _view31 = [[NSBundle mainBundle]loadNibNamed:@"view3" owner:self options:nil].firstObject;
    _view31.frame = CGRectMake(0, CGRectGetMaxY(view2.frame), WIDTH, 30);
    _view31.backgroundColor = [UIColor whiteColor];
    
    
    self.view4 = [[NSBundle mainBundle]loadNibNamed:@"view4" owner:self options:nil].firstObject;
    self.view4.delegate = self;
    
    if (iPhone6_plus) {
        self.view4.frame = CGRectMake(0, CGRectGetMaxY(_view31.frame), WIDTH, 173);
    }
    else
    self.view4.frame = CGRectMake(0, CGRectGetMaxY(_view31.frame), WIDTH, 153);
    
    
    
    view5 * view5 = [[NSBundle mainBundle]loadNibNamed:@"view5" owner:self
                                              options:nil].firstObject;
    view5.frame = CGRectMake(0, CGRectGetMaxY(self.view4.frame), WIDTH, 40);
    view5.willAnnounce.selected = YES;
    view5.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, CGRectGetMaxY(view5.frame))];
    [self.headView addSubview:self.cycleScrollView];
    [self.headView addSubview:view2];
    [self.headView addSubview:_view31];
    [self.headView addSubview:self.view4];
    [self.headView addSubview:view5];
}

#pragma mark - 红包 抽奖等
-(void)pushToType:(NSInteger)type
{
    if (type == 1) {
        RedPacketViewController * red = [[RedPacketViewController alloc]init];
        [self.navigationController pushViewController:red animated:YES];
    }
    if (type == 2)
    {
        if (TOKEN == nil) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"directLogin" object:nil];
//            LoginViewController * login = [[LoginViewController alloc]init];
//            [self.navigationController pushViewController:login animated:YES];
//            UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:login];
//            self.tabBarController.rootViewController = nvc;
        }
        else
        {
        ADViewController * ad = [[ADViewController alloc]init];
        ad.url = [NSString stringWithFormat:@"http://m.zouyun8.com/a/zhuanpan/?uid=%@&token=%@",UID,TOKEN];
            self.hidesBottomBarWhenPushed = YES;
            ad.tip = @"幸运抽奖";
        [self.navigationController pushViewController:ad animated:YES];
            self.hidesBottomBarWhenPushed = NO;

        }
    }
    if (type == 3) {
        //跳转到揭晓
        NSLog(@"跳转到揭晓");
        AnnounceViewController * announce = [[AnnounceViewController alloc]init];
        [self.navigationController pushViewController:announce animated:YES];
//        LimitViewController * limit = [[LimitViewController alloc]init];
//        [self.navigationController pushViewController:limit animated:YES];
    }
    if (type == 4) {
        //跳转到帮助
        ADViewController * ad = [[ADViewController alloc]init];
        ad.url = HEGOU_HELP;
        ad.tip=@"帮助";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ad animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

- (void)viewDidLayoutSubviews
{
    __weak FirstViewController *weakSelf = self;
    //下拉操作
    [self.collectionView addPullToRefreshWithActionHandler:^{
        
        int64_t delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            _is_Refresh=YES;
            _isjishu=NO;
             weakSelf.page = 1;
            [weakSelf getData];
            [weakSelf getPub_lucky];
            [weakSelf GetAdPicture];
            [weakSelf.collectionView.pullToRefreshView stopAnimating];
        });
    }];
    
    //上拉操作
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
         _is_Refresh=NO;
        if (self.is_announce == YES) {
            weakSelf.page += 1;
            [weakSelf getData];
            [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        }
        else
        {
            weakSelf.page += 1;
            [weakSelf refresh];
            [weakSelf.collectionView.infiniteScrollingView stopAnimating];
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _array3=[[NSMutableArray alloc]init];
    self.page = 1;
    //默认打开时为yes
    self.is_announce = YES;
    
    //接受刷新CollectionView通知（点击了 最火，最新，价格 等按钮后）
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh:) name:@"refresh" object:nil];
    //接受刷新CollectionView通知（点击最新揭晓按钮后）
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAnnounce) name:@"getData" object:nil];
    
    [self getPub_lucky];
    [self GetAdPicture];
    [self createAdScrollView];
    [self createHeadView];
    [self createCollectionView];
}

-(void)testClerk{
   
//    NSMutableArray * array = [[NSMutableArray alloc]init];
//    NSString * type = TYPE;
//    if ([type integerValue] == 2) {
//        for (int i = 5; i <= 500; i ++) {
//            [array addObject:[NSString stringWithFormat:@"%d",i]];
//        }
//    }
//    else
//    {
//        for (int i = 2; i <= 500; i ++) {
//            [array addObject:[NSString stringWithFormat:@"%d",i]];
//        }
//    }
//    self.fruits = array;

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

#pragma mark - 获取最新中奖消息
-(void)getPub_lucky
{
    [SVProgressHUD showWithStatus:@"正在加载"];
    [ToolClass getPub_lucky:^(NSDictionary *dic) {
        NSLog(@"合购公开%@",dic);
        NSArray* array = dic[@"data"];
        //最新公开的合购商品图片地址
        if (array.count != 0) {
            self.view4.hidden=NO;
            
           
            
            
            if (array.count>0) {
              self.imageUrl1 = array[0][@"thumb"];
                self.price1 = array[0][@"money"];
                self.last1 = array[0][@"left_num"];
            }else{
                
                self.price1=@"";
                self.imageUrl1=nil;
                self.last1=@"";
            
            }
            if (array.count>1) {
                 self.imageUrl2 = array[1][@"thumb"];
                self.price2 = array[1][@"money"];
                self.last2 = array[1][@"left_num"];
            }else{
            
                self.price2=@"";
                self.imageUrl2=nil;
                self.last2=@"";

            }
            if (array.count>2) {
                self.imageUrl3 = array[2][@"thumb"];
                self.price3 = array[2][@"money"];
                self.last3 = array[2][@"left_num"];
            }else{
               self.price3=@"";
                self.imageUrl3=nil;
                self.last3=@"";

            
            }
          
            [self.view4.imageView1 sd_setImageWithURL:[NSURL URLWithString:self.imageUrl1] placeholderImage:nil completed:nil];
            [self.view4.imageView2 sd_setImageWithURL:[NSURL URLWithString:self.imageUrl2] placeholderImage:nil completed:nil];
            [self.view4.imageView3 sd_setImageWithURL:[NSURL URLWithString:self.imageUrl3] placeholderImage:nil completed:nil];
            self.view4.price1.text = [NSString stringWithFormat:@"%@",self.price1];
            self.view4.price2.text = [NSString stringWithFormat:@"%@",self.price2];
            self.view4.price3.text = [NSString stringWithFormat:@"%@",self.price3];
            self.view4.last1.text = [NSString stringWithFormat:@"%@",self.last1];
            self.view4.last2.text = [NSString stringWithFormat:@"%@",self.last2];
            self.view4.last3.text = [NSString stringWithFormat:@"%@",self.last3];
            
            self.GoodsArray = array;
            //获取已开奖信息
            self.view4.GoodsArray = self.GoodsArray;
            
            
        }else{
            
        
            self.view4.hidden=YES;
           
        //[self createHeadView];
        }
        [self getAlreadyNotice];
       
    } page:@"1" andTop:nil];
    
//    [ToolClass getLucky_notice:^(NSDictionary *dic) {
//        NSArray* array = dic[@"data"];
//        for (NSDictionary * dict in array) {
//            NSLog(@"中奖时间为-------%@",dict[@"run_time"]);
//        }
//        //最新揭晓商品图片地址
//        self.imageUrl1 = array[0][@"thumb"];
//        self.imageUrl2 = array[1][@"thumb"];
//        self.imageUrl3 = array[2][@"thumb"];
//        //获取已开奖信息
//        [self getAlreadyNotice];
//    }];
}
#pragma mark - 获取已开奖信息
-(void)getAlreadyNotice
{
    [ToolClass getAlreadyNotice:^(NSDictionary *dic) {
        NSArray * array = [[NSArray alloc]init];
        self.names = [[NSMutableArray alloc]init];
        self.prizes = [[NSMutableArray alloc]init];
        array = dic[@"data"];
        for (NSDictionary * dict in array) {
            [self.names addObject:dict[@"lucky_username"]];
            [self.prizes addObject:dict[@"name"]];
        }
        NSLog(@"%@",self.names);
        NSLog(@"%@",self.prizes);
        //创建组头视图
        [_view31 setData:self.names andPrizes:self.prizes and:_array3];
        [SVProgressHUD dismiss];
        [self getData];
    }];
}
#pragma mark - 创建collectionview
-(void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//    CSStickyHeaderFlowLayout *flowLayout=[[CSStickyHeaderFlowLayout alloc] init];
//    flowLayout.minimumInteritemSpacing = 1;
//    flowLayout.minimumLineSpacing = 1;
//    CGFloat wid = WIDTH / 3 - 10;
//    flowLayout.itemSize = CGSizeMake(wid, WIDTH/2);

    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-49) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    //注册cell和ReusableView（相当于头部）
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"FirstCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"FirstCollectionViewCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataSource.count!=0) {
         return self.dataSource.count+1;
    }else{
    
        return self.dataSource.count;
    }
   
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==self.dataSource.count+1-1) {
        UINib *nib = [UINib nibWithNibName:@"FooterCollectionViewCell" bundle:nil];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"FooterCollectionViewCell"];
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FooterCollectionViewCell" forIndexPath:indexPath];
        
        
        
        
        
        return cell;

    }else{
   
    
    static NSString *identify = @"FirstCollectionViewCell";
    FirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.delegate = self;
        GoodsModel * model = self.dataSource[indexPath.row];
//    [cell sizeToFit];
    if (self.dataSource.count != 0) {
       
        cell.model = model;
        
     
        
        
        [cell setCellWithModel];
        cell.backgroundColor = [UIColor whiteColor];
       
    }
        
        
        if (_isjishu) {
            
            if (indexPath.row+1==self.dataSource.count) {
                
                cell.userInteractionEnabled=NO;
                
                NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
                for (UIView *subview in subviews) {
                    subview.hidden=YES;
                }
                
            }else{
            
                
                cell.userInteractionEnabled=YES;
                
                NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
                for (UIView *subview in subviews) {
                    subview.hidden=NO;
                }

               
            }
        }

        return cell;
        
        
    }
}

-(void)changeCornerMark
{
    NSLog(@"改变角标");
    UITabBarItem * item = [self.tabBarController.tabBar.items objectAtIndex:3];
    item.badgeValue = [NSString stringWithFormat:@"%ld",[item.badgeValue integerValue] + 1];
}

-(void)selectBuyTogetherNum:(GoodsModel *)model
{
//    NSLog(@"点击了好友合购");
//    self.model = model;
//    NSInteger count;
//    if (self.model.money.integerValue>=5000) {
//         count=5000;
//
//    }else{
//    
//         count=[self.model.money integerValue];
//    }
//    
//    NSMutableArray * array = [[NSMutableArray alloc]init];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testClerk) name:@"TestClerk" object:nil];
//    
//  
//    if ([type integerValue] == count) {
//        for (int i = 5; i <= count; i ++) {
//            [array addObject:[NSString stringWithFormat:@"%d",i]];
//        }
//    }
//    else
//    {
//        for (int i = 2; i <= count; i ++) {
//            [array addObject:[NSString stringWithFormat:@"%d",i]];
//        }
//    }
//    self.fruits = array;
    self.model = model;
    NSString * type = TYPE;//0普通会员 1 代理 2 试购员
    int k=[self.model.money intValue];
    int l=0;
    
    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSMutableArray *array1=[[NSMutableArray alloc]init];
    if (type.integerValue==2) {
        
        for (int  i=5; i<=k; i++) {
            if (k%i==0) {
                l=l+1;
                [array addObject:[NSString stringWithFormat:@"%d",i]];
                
            }
            
        }

        if (array.count<5) {
            [array removeAllObjects];
       
            for (int a=5; a<10; a++) {
               
                if (a==9) {
                    if (k>a) {
                     [array addObject:[NSString stringWithFormat:@"%d",k]];
                    }else{
                     [array addObject:[NSString stringWithFormat:@"%d",a]];
                    }
                    
                     [array1 addObject:[NSString stringWithFormat:@"%d",1]];
                }else{
                    
                    [array addObject:[NSString stringWithFormat:@"%d",a]];
                    int m;
                    if (k%a!=0) {
                       m= k/a + 1;
                    }else{
                    
                       m= k/a ;
                    }
                    
                    
                    

                    [array1 addObject:[NSString stringWithFormat:@"%d",m]];
                }
            }
            

        }
        
        
        
      

            
        
        
       
        
    }else{
        
        for (int  i=2; i<=k; i++) {
            if (k%i==0) {
                l=l+1;
                [array addObject:[NSString stringWithFormat:@"%d",i]];
                
            }
            
        }
        
        if (array.count<5) {
            [array removeAllObjects];
            for (int a=2; a<7; a++) {
                
                if (a==6) {
                    if (k>a) {
                        [array addObject:[NSString stringWithFormat:@"%d",k]];
                    }else{
                        [array addObject:[NSString stringWithFormat:@"%d",a]];
                    }
                    
                    [array1 addObject:[NSString stringWithFormat:@"%d",1]];
                }else{
                    
                    [array addObject:[NSString stringWithFormat:@"%d",a]];
                    
                    int m;
                    if (k%a!=0) {
                        m= k/a + 1;
                    }else{
                        
                        m= k/a ;
                    }

                    
                    [array1 addObject:[NSString stringWithFormat:@"%d",m]];
                }
            }
            
            
        }
        


       
    }
    
   

     alertDialogSubView = [[NSBundle mainBundle]loadNibNamed:@"AlertDialogSubView" owner:self options:nil].firstObject;
     alertDialogSubView.shuruTf.delegate=alertDialogSubView;

    if (iPhone4||iPhone5) {
         alertDialogSubView.frame=CGRectMake(0, 0, 280, 434);
        alertDialogSubView.tishi1.font=[UIFont systemFontOfSize:11];
        alertDialogSubView.tishi2.font=[UIFont systemFontOfSize:11];
        
    }else if(iPhone6){
         alertDialogSubView.frame=CGRectMake(0, 0, 300, 434);
    }else{
    
        alertDialogSubView.frame=CGRectMake(0, 0, 280, 434);
        alertDialogSubView.tishi1.font=[UIFont systemFontOfSize:11];
        alertDialogSubView.tishi2.font=[UIFont systemFontOfSize:11];
    
    }
    [alertDialogSubView setdata:array addPrice:self.model.money addArray1:array1];
    
    
    alert = [[JKAlertDialog alloc]init];
    [self.view addSubview:alert];
    alert.contentView =  alertDialogSubView;
    alert.contentViewSize=alertDialogSubView.frame.size;
    
    
    [alert show];
    
    [alertDialogSubView.faqihegouBt addTarget:self action:@selector(faqidehegou1) forControlEvents:UIControlEventTouchUpInside ];
    
    [alertDialogSubView.canyugongkaihegouBt addTarget:self action:@selector(canyugongkaihegou1) forControlEvents:UIControlEventTouchUpInside ];
    
    [alertDialogSubView.dismissAlertBt addTarget:self action:@selector(dismissAlertBt1) forControlEvents:UIControlEventTouchUpInside ];

   

    
//    
//    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"请选择好友合购份数" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定"];
//    picker.delegate = self;
//    picker.dataSource = self;
//    picker.needFooterView = YES;
////    picker.pickerWidth=100;
//    //picker.headerTitleFont=[UIFont systemFontOfSize:14];
//
//
//    [picker show];
}
-(void)faqidehegou1{
    
    if (alertDialogSubView.selectedNumber.length==0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"你还没输选择合购人数！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
           
            
            
        }];
        
        
        

        
        [alertController addAction:okAction];
      
        
        //膜态时一定要判断你膜态的ViewController是不是空 ，空才能去膜态 、非空不能。
        if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController == nil)
            
        {
            
            
            [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:alertController  animated: YES completion:nil];
            
            
        }
        

        //[SVProgressHUD showErrorWithStatus:@"你还没输选择合购人数"];
        return;
    }
    
    [alert dismiss];
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"id"]=self.model.lucky_id;
    dic[@"num"]=alertDialogSubView.selectedNumber;
    [self getDataForCreate_lucky_URL:dic];
    

}
-(void)canyugongkaihegou1{
    [alert dismiss];
    
    [self OpenHeGou];
    
    
}
-(void)dismissAlertBt1{
     [alert dismiss];

}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    
    if (indexPath.row==self.dataSource.count+1-1) {
        
        return CGSizeMake(WIDTH, 50);
        
        
    }

    
    
    
    
    
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
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsModel * model=self.dataSource[indexPath.row];
    //PG_bid_list * model=self.dataSource[indexPath.row];
    GoodsWebViewController *VC=[[GoodsWebViewController alloc]init];
    VC.lucky_id = model.lucky_id;
    NSDictionary *dic=[[NSMutableDictionary alloc]init];
    
    [dic setValue:model.thumb forKey:@"image"];
    [dic setValue:@"" forKey:@"desc"];
    [dic setValue:[NSString stringWithFormat:@"%@%@",Share_URL,model.lucky_id]forKey:@"url"];
    [dic setValue:model.name forKey:@"title"];
    [dic setValue:@"1" forKey:@"share_action"];//action	int	必须	分享类型	1商品详情，2二维码，3活动页
    VC.shareDict=dic;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//组视图大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(WIDTH, 420);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    [headerView addSubview:self.headView];
    return headerView;
}
#pragma mark - 广告滚动视图
-(void)createAdScrollView
{
    // 本地加载 --- 创建不带标题的图片轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, 130/*具体宽度根据屏幕高宽比适配*/) shouldInfiniteLoop:YES imageNamesGroup:self.AdImages];
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    
    //添加轮播器
    self.cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //         --- 轮播时间间隔，默认1.0秒，可自定义
    self.cycleScrollView.autoScrollTimeInterval = 3.0;
}

#pragma mark - 广告视图代理方法
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"%@",self.AdUrls[index]);
    //跳转到商品详情，实验。
    ADViewController * ad = [[ADViewController alloc]init];
    ad.url = self.AdUrls[index];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ad animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark - 广告图片
-(void)GetAdPicture
{
    //初始化广告图片数组
    self.AdImages = [[NSMutableArray alloc]init];
    self.AdUrls = [[NSMutableArray alloc]init];
    
    NSDictionary * parameters = @{@"id":@"3759885702"};
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:ADURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSArray * array = dict[@"data"];
        //请求成功,将图片下载完保存到数组中
        for (NSDictionary * dic in array)
        {
            [self.AdImages addObject:[NSURL URLWithString:dic[@"url"]]];
            [self.AdUrls addObject:[NSURL URLWithString:dic[@"href"]]];
        }
        self.cycleScrollView.imageURLStringsGroup = self.AdImages;
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            
        }];
}

#pragma mark - 刷新即将揭晓数据
-(void)getAnnounce
{
    [self.dataSource removeAllObjects];
    [self getData];
}



-(void)getData
{
    if (self.page ==1) {
        _isjishu=NO;
    }
    self.is_announce == YES;
     NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
     parameters[@"page"] = [NSString stringWithFormat:@"%ld",(long)self.page];
     parameters[@"top"] = @"1";
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:LUCKY_LIST parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSLog(@"最新揭晓列表%@",dict);
         NSArray * array = dict[@"data"];
        
         if (_is_Refresh) {
             [self.dataSource removeAllObjects];
         }
         
         //请求成功,将图片下载完保存到数组中
         for (NSDictionary * dic in array)
         {
             GoodsModel * model = [[GoodsModel alloc]initWithDictionary:dic error:nil];
             [self.dataSource addObject:model];
         }
        // NSL
         if(self.dataSource.count%2==0){
         
            
         
         }else{
             _isjishu=YES;
          //GoodsModel * model = [[GoodsModel alloc]init];
          [self.dataSource addObject:[self.dataSource lastObject]];
         }
         
         NSLog(@"时候%d",self.dataSource.count);
         [self.collectionView reloadData];
         self.cycleScrollView.imageURLStringsGroup = self.AdImages;
         
       
         
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         
     }];
}
-(void)refresh:(NSNotification *)info
{
    self.is_announce = NO;
    self.page = 1;
    self.top = info.userInfo[@"top"];
    if (self.page ==1) {
        _isjishu=NO;
    }
    [self.dataSource removeAllObjects];
    
    [ToolClass getRank:^(NSDictionary *dic) {
        NSArray * array = dic[@"data"];
        NSLog(@"获取到的商品个数为%@",dic);
        if (_is_Refresh) {
            [self.dataSource removeAllObjects];
        }

    
        for (NSDictionary * dic in array)
        {
            GoodsModel * model = [[GoodsModel alloc]initWithDictionary:dic error:nil];
            [self.dataSource addObject:model];
        }
        if(self.dataSource.count%2==0){
            
            
            
        }else{
            _isjishu=YES;
            //GoodsModel * model = [[GoodsModel alloc]init];
            [self.dataSource addObject:[self.dataSource lastObject]];
        }

       
            [self.collectionView reloadData];
        
        
    } minPrice:nil maxPrice:nil page:[NSString stringWithFormat:@"%ld",self.page] name:nil category:nil top:info.userInfo[@"top"] type:nil];
//    只刷新所有cell数据
//    NSMutableArray * marray = [[NSMutableArray alloc]init];
//    for (int i = 0; i < self.dataSource.count; i++) {
//        NSLog(@"执行了");
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
//    }
//    [self.collectionView setContentOffset:CGPointMake(0,-50)animated:YES];
}
-(void)refresh
{
    if (self.page ==1) {
        _isjishu=NO;
    }
    [ToolClass getRank:^(NSDictionary *dic)
    {
        NSArray * array = dic[@"data"];
        if (_is_Refresh) {
            [self.dataSource removeAllObjects];
        }

        for (NSDictionary * dic in array)
        {
            GoodsModel * model = [[GoodsModel alloc]initWithDictionary:dic error:nil];
            [self.dataSource addObject:model];
        }
        if(self.dataSource.count%2==0){
            
            
            
        }else{
            _isjishu=YES;
            //GoodsModel * model = [[GoodsModel alloc]init];
            [self.dataSource addObject:[self.dataSource lastObject]];
        }

        [self.collectionView reloadData];
        
    } minPrice:nil maxPrice:nil page:[NSString stringWithFormat:@"%ld",self.page] name:nil category:nil top:self.top type:nil];
    //    只刷新所有cell数据
    //    NSMutableArray * marray = [[NSMutableArray alloc]init];
    //    for (int i = 0; i < self.dataSource.count; i++) {
    //        NSLog(@"执行了");
    //        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    //        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    //    }
    //    [self.collectionView setContentOffset:CGPointMake(0,-50)animated:YES];
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
