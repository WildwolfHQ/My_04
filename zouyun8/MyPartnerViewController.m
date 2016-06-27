//
//  MyPartnerViewController.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/21.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "MyPartnerViewController.h"
#import "SegmentdedControl.h"
#import "MyPartnerCell.h"
__weak NSString *weak_type1;
@interface MyPartnerViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
   
    
    
    
}

@property (strong, nonatomic) SegmentdedControl *segmentedControl;
@property (strong, nonatomic)NSArray *segmentTitlesArray;
@property(nonatomic,strong)NSMutableArray * dataSource;         //数据
@end

@implementation MyPartnerViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的合伙人";
    self.segmentTitlesArray=[[NSArray alloc]initWithObjects:@"一级会员",@"二级会员", nil];
    [self loadSegmentedControllView];
    [self drawTableView];
     NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
     dic[@"type"]=@"1";
    weak_type1=@"1";
    self.dataSource=[NSMutableArray array];
    [self getDataForEvaluate_list_URL:dic andPage:@"1" isRefresh:NO];
    
    

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadSegmentedControllView{
    
    
    
     self.segmentedControl = [[SegmentdedControl alloc] initWithSectionTitles:self.segmentTitlesArray];
    [self.segmentedControl setFrame:CGRectMake(0,self.view1.frame.origin.y+self.view1.frame.size.height+1, WIDTH, 36)];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.segmentedControl];
    
    
}
-(void)segmentedControlChangedValue:(SegmentdedControl *)segmentedController
{
    if (segmentedController.selectedIndex==0) {
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        dic[@"type"]=@"1";
        weak_type1=@"1";
        [self.dataSource removeAllObjects];
        [self getDataForEvaluate_list_URL:dic andPage:@"1" isRefresh:NO];
        
    }
    
    if(segmentedController.selectedIndex==1){
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        dic[@"type"]=@"2";
        weak_type1=@"2";
        [self.dataSource removeAllObjects];
        [self getDataForEvaluate_list_URL:dic andPage:@"1" isRefresh:NO];
        
        
    }
    
    
    
}


-(void)drawTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.segmentedControl.frame.origin.y+self.segmentedControl.frame.size.height, WIDTH, HEIGHT-(self.segmentedControl.frame.origin.y+self.segmentedControl.frame.size.height)) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    
    
    
    
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;
    
    Junior  *  model=self.dataSource[row];
    
    MyPartnerCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MyPartnerCell"];
    if (cell==nil) {
        [tableView registerNib:[UINib nibWithNibName:@"MyPartnerCell" bundle:nil] forCellReuseIdentifier:@"MyPartnerCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"MyPartnerCell"];
        
    }
    
    
    
    [cell setProperty:model];
 
    
    
    
    return cell;
    
    
    
    
    
    
    
    
    
    
    
    
    
}






- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    Evaluate_list   *model=self.dataSource[indexPath.row];
//    GoodsWebViewController *VC=[[GoodsWebViewController alloc]init];
//    
//    if (model.lucky_id.integerValue!=0) {
//        VC.lucky_id=model.lucky_id;
//    }else{
//        
//        VC.bid_id=model.bid_id;
//    }
//    
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:VC animated:YES];
}

-(void)getDataForEvaluate_list_URL:(NSMutableDictionary*)dic andPage:(NSString *)page isRefresh:(BOOL)refresh
{
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"uid"] = UID;
    parameters[@"token"] = TOKEN;
    if (dic[@"type"]!=nil) {
        parameters[@"level"] = dic[@"type"];
    }
    
    if (page!=nil) {
        parameters[@"page"] = page;
    }
    
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:Junior_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         //         NSLog(@"订单详情%@",dict);
         NSArray *array=dict[@"data"];
         if (refresh) {
             [self.dataSource removeAllObjects];
         }
         
         for (NSDictionary *dic1 in array) {
             Junior *model = [[Junior alloc]initWithDictionary:dic1 error:nil];
             
             if (model!=nil) {
                 
                 
                 [self.dataSource addObject:model];
                 
                 
             }else{
                 
                 
                 
             }
             
             
         }
         
         @try {
             if (dict[@"total_user"]!=nil) {
                 self.nuber.text=[NSString stringWithFormat:@"%@",dict[@"total_user"]];
             }
             if (dict[@"total_comm"]!=nil) {
                 self.money.text=[NSString stringWithFormat:@"%@",dict[@"total_comm"]];
             }

         } @catch (NSException *exception) {
             
         } @finally {
             
         }
         [_tableView reloadData];
         
         //2.0
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         
     }];
}


static int page=0;
- (void)viewDidLayoutSubviews
{
    __weak  MyPartnerViewController *weakSelf = self;
    __weak UITableView *weak_tableView = _tableView;
    
    //下拉操作
    [_tableView addPullToRefreshWithActionHandler:^{
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        dic[@"type"]=weak_type1;
        [weakSelf getDataForEvaluate_list_URL:dic andPage:nil isRefresh:YES];
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            
            [weak_tableView.pullToRefreshView stopAnimating];
        });
    }];
    
    //上拉操作
    [_tableView addInfiniteScrollingWithActionHandler:^{
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        dic[@"type"]=weak_type1;
        [weakSelf getDataForEvaluate_list_URL:dic andPage:[NSString stringWithFormat:@"%d",++page] isRefresh:NO];
        
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            
            
            
            [weak_tableView.infiniteScrollingView stopAnimating];
        });
        
        
    }];
}



@end
