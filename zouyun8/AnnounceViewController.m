#import "AnnounceViewController.h"
//#import "AnnounceTableViewCell.h"
//#import "AnnounceTableViewCell2.h"

#import "CommonMacro.h"
//#import "TimeCell.h"
#import "TimeModel.h"
//#import "BaseTableViewCell.h"
#import "GoodsWebViewController.h"
@interface AnnounceViewController (){
    //NSIndexPath *indexPath;
    BOOL istishi;
}
@property(nonatomic,strong)NSMutableArray * dataSource;         //数据源
@property(nonatomic,strong)NSMutableArray * countDownTimes;
//@property (nonatomic, strong) NSMutableArray *m_dataArray;
@property (nonatomic, strong) NSTimer        *m_timer;
@end

@implementation AnnounceViewController

-(void)dealloc
{
    
}
-(void)viewWillAppear:(BOOL)animated{
    for (UIImageView * view in self.navigationController.navigationBar.subviews)
    {
        if (view.tag == 10)
        {
            [view removeFromSuperview];
        }
    }

}
-(void)viewDidDisappear:(BOOL)animated{

    
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self.title = @"揭晓";
    self.navigationController.navigationBar.titleTextAttributes= @{NSForegroundColorAttributeName: [UIColor redColor],
                                                                   NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    
    UIBarButtonItem *fixBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixBar.width = -20;
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_fanhuo"] style:UIBarButtonItemStylePlain target:self action:@selector(popaction)];
    //self.navigationItem.leftBarButtonItem = leftButtonItem;
    self.navigationItem.leftBarButtonItems = @[fixBar,leftButtonItem];
      self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:217/255.0 green:43/255.0 blue:73/255.0 alpha:1];
   
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"AnnounceTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"AnnounceTableViewCell2" bundle:nil] forCellReuseIdentifier:@"cell2"];
  
    
    
    self.dataSource=[NSMutableArray array];
    //self.m_dataArray = [NSMutableArray array];
    
    self.tableView.bounds=CGRectMake(self.tableView.bounds.origin.x, self.tableView.bounds.origin.y, WIDTH,self.tableView.bounds.size.height);
    [self getData:nil :NO];
    [self  createTimer];
}

-(void)popaction{
    
    //[self.dataSource removeAllObjects];
    
    for (  Lucky_noticeModel * model in self.dataSource) {
        [model.timer invalidate];
         model.timer=nil;
        
    }
    
    [self.m_timer invalidate];
     self.m_timer=nil;

    [self.navigationController popViewControllerAnimated:YES];
    

}
- (void)createTimer {
    
    
    
    self.m_timer = [NSTimer timerWithTimeInterval:15.0 target:self selector:@selector(update1) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.m_timer forMode:NSRunLoopCommonModes];
}
- (void)timerEvent:(NSTimer *)timer {
   
    TimeModel *model = timer.userInfo;
    [model countDown];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_CELL object:timer];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
    
    if (indexPath.row==self.dataSource.count) {
        UITableViewCell*cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        FooterView * footerview1 = [[NSBundle mainBundle]loadNibNamed:@"FooterView" owner:self
                                                              options:nil].firstObject;
        footerview1.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
        
        [cell addSubview:footerview1];
        cell.userInteractionEnabled=NO;
        
        return cell;
        
    }else{
    
    Lucky_noticeModel * model=self.dataSource[indexPath.row];
    //已经开奖
    if(model.lucky_userid.integerValue!=0){
        
        
        
        
        
        AnnounceTableViewCell3 * cell3 = [tableView dequeueReusableCellWithIdentifier:@"AnnounceTableViewCell3"];
        if (!cell3)
        {
            [tableView registerNib:[UINib nibWithNibName:@"AnnounceTableViewCell3" bundle:nil] forCellReuseIdentifier:@"AnnounceTableViewCell3"];
            cell3 = [tableView dequeueReusableCellWithIdentifier:@"AnnounceTableViewCell3"];
        }
        [cell3 setProperty:model];
        
        return cell3;
        
        
        
    }else{
        
        AnnounceTableViewCell1 * cell1 = [tableView dequeueReusableCellWithIdentifier:@"AnnounceTableViewCell1"];
        if (!cell1)
        {
            [tableView registerNib:[UINib nibWithNibName:@"AnnounceTableViewCell1" bundle:nil] forCellReuseIdentifier:@"AnnounceTableViewCell1"];
            cell1 = [tableView dequeueReusableCellWithIdentifier:@"AnnounceTableViewCell1"];
        }
        
        
       
        
       
        
        
        
        [cell1 loadData:nil indexPath:indexPath m_dataArray:self.dataSource :model.timer];
        cell1.m_isDisplayed=YES;
        [cell1 setProperty:model];
        return cell1;

        
    }
 }


//else{
//        AnnounceTableViewCell4 * cell4 = [tableView dequeueReusableCellWithIdentifier:@"AnnounceTableViewCell4"];
//        if (!cell4)
//        {
//            [tableView registerNib:[UINib nibWithNibName:@"AnnounceTableViewCell4" bundle:nil] forCellReuseIdentifier:@"AnnounceTableViewCell4"];
//            cell4 = [tableView dequeueReusableCellWithIdentifier:@"AnnounceTableViewCell4"];
//        }
//        return cell4;
//        
//    
//    
//    }

    
    
    
    
   

    
    
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row==self.dataSource.count) {
        return 50;
    }
    return 150;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    Lucky_noticeModel * model=self.dataSource[indexPath.row];
    
    
    //PG_bid_list * model=self.dataSource[indexPath.row];
     GoodsWebViewController *VC=[[GoodsWebViewController alloc]init];
     VC.lucky_id=model.hg_id;
    
    NSDictionary *dic=[[NSMutableDictionary alloc]init];
    
    [dic setValue:model.thumb forKey:@"image"];
    [dic setValue:@"" forKey:@"desc"];
    [dic setValue:[NSString stringWithFormat:@"%@%@",Share_URL,model.hg_id]forKey:@"url"];
    [dic setValue:model.name forKey:@"title"];
    [dic setValue:@"1" forKey:@"share_action"];//action	int	必须	分享类型	1商品详情，2二维码，3活动页
    
    
    //    dic[@"url"]=model;
    //    dic[@"desc"];
    VC.shareDict=dic;

    
     self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
     self.hidesBottomBarWhenPushed = NO;
    
    
//    GoodsDetailController *VC=[[GoodsDetailController alloc]init];
//    [VC setValue:model.hg_id forKey:@"lucky_id"];
//     self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:VC animated:YES];
//     self.hidesBottomBarWhenPushed = NO;

}

#pragma mark - 获取商品数据
-(void)getData:(NSString *)time :(BOOL)isrash
{
    
    
    NSString *nowTimeInterval=[NSString stringWithFormat:@"%f",[self getNowTimeInterval]+3600];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
   
    if (time==nil) {
         params[@"time"] =nowTimeInterval;
    }else{
         params[@"time"] =time;
    
    }
     params[@"uid"] = UID;
     params[@"token"] = TOKEN;
    
   
    
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:Lucky_notice_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"进来了");
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         
         NSLog(@"%@",dict);
         NSArray * array = dict[@"data"];
         //请求成功,将图片下载完保存到数组中
         
         if (isrash) {
             [self.dataSource removeAllObjects];
         }
         if(array.count==0){
             if (istishi) {
                 
             }else{
                 Lucky_noticeModel * model=[[Lucky_noticeModel alloc]init];
                 model.tishi=@"特别说明：苹果公司不是走运网赞助商，并且苹果公司也不会以任何形式参与其中！";
                 [self.dataSource addObject:model];
                 istishi=YES;
             }
         }else{
         for (NSDictionary * dic in array)
         {
             Lucky_noticeModel * model = [[Lucky_noticeModel alloc]initWithDictionary:dic error:nil];
             
             if (model!=nil) {
                  //model.lucky_userid=@"0";
                 
                 
                     if (model.lucky_userid.integerValue==0) {
                         
                        int time=model.run_time.intValue-(int)[self getNowTimeInterval];
                         TimeModel * model1 = [TimeModel timeModelWithTime:time*1000];
                         
                         NSTimer *timer=[NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(timerEvent:) userInfo:model1 repeats:YES];
                         [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                         model.timer=timer;
                     }
                     
                     
                
                
                 [self.dataSource addObject:model];
                 
                 
                 
                
                 //[self.m_dataArray addObject:[TimeModel timeModelWithTime:time*1000]];
             }
           }
             [self.tableView reloadData];
             
         }
         
         
         
         
         //[self createTimer];
         
         
         [self.tableView.infiniteScrollingView stopAnimating];
         [self.tableView.pullToRefreshView stopAnimating];
         
         
     }
     
     
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [self.tableView.infiniteScrollingView stopAnimating];
         [self.tableView.pullToRefreshView stopAnimating];
         
         
     }];
}


//static int page=0;
- (void)viewDidLayoutSubviews
{
    __weak AnnounceViewController *weakSelf = self;
    //下拉操作
    [self.tableView addPullToRefreshWithActionHandler:^{
        
        for (  Lucky_noticeModel * model in weakSelf.dataSource) {
            [model.timer invalidate];
            model.timer=nil;
            
        }
        [weakSelf getData:nil:YES];
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            

            
            
            
            [weakSelf.tableView.pullToRefreshView stopAnimating];
        });
    }];
    
    //上拉操作
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        Lucky_noticeModel * model=  [weakSelf.dataSource lastObject];
        [weakSelf getData:model.run_time:NO];
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
           
            
            
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        });
        
        
    }];
}




//得到系统现在的时间戳
- (NSTimeInterval)getNowTimeInterval
{
    
    NSDate* dat = [NSDate date];
    
    //dat=[self getNowDateFromatAnDate:dat];
    
    NSTimeInterval nowTimeInterval=[dat timeIntervalSince1970]*1;
    
   
    
    
    
    return nowTimeInterval;
}


- (NSString *)getNowDateStr
{
    
    NSDate* dat = [NSDate date];
    
    dat=[self getNowDateFromatAnDate:dat];
    
   
    NSString *nowDateStr=[self dateToString:dat];
    
    
    
    
    return nowDateStr;
}
// 世界标准时间UTC /GMT  转为  当前系统时区对应的时间
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}
//NSDate 2 NSString
- (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

-(void)update1{
    for (Lucky_noticeModel * model in self.dataSource) {
        [model.timer invalidate];
         model.timer=nil;
        
    }
    [self getData:nil:YES];
    
}
@end
