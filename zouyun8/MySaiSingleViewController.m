//
//  MySaiSingleViewController.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/20.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "MySaiSingleViewController.h"
#import "SegmentdedControl.h"
#import "MySaiSingleCell.h"

#import "Evaluate_list.h"
#import "GotosaidanVC.h"
#import "GoodsWebViewController.h"
__weak NSString *weak_type;
@interface MySaiSingleViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
    UITableView *_tableView1;
    
    
    
}

@property (strong, nonatomic) SegmentdedControl *segmentedControl;
@property (strong, nonatomic)NSArray *segmentTitlesArray;
@property(nonatomic,strong)NSMutableArray * dataSource;         //数据
@end

@implementation MySaiSingleViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的晒单";
    self.segmentTitlesArray=[[NSArray alloc]initWithObjects:@"已晒单",@"未晒单", nil];
    [self loadSegmentedControllView];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    dic[@"type"]=@"2";
    self.dataSource=[NSMutableArray array];
    [self getDataForEvaluate_list_URL:dic andPage:@"1" isRefresh:NO];
    [self drawTableView];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(shaidanFinish) name:@"shaidanFinish" object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)shaidanFinish{
   
    [_tableView triggerPullToRefresh];
}

-(void)loadSegmentedControllView{
    
   
    
    self.segmentedControl = [[SegmentdedControl alloc] initWithSectionTitles:self.segmentTitlesArray];
    [self.segmentedControl setFrame:CGRectMake(0,64, WIDTH, 36)];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.segmentedControl];
    
    
}
-(void)segmentedControlChangedValue:(SegmentdedControl *)segmentedController
{
    if (segmentedController.selectedIndex==0) {
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        dic[@"type"]=@"2";
         weak_type=@"2";
        [self.dataSource removeAllObjects];
        [self getDataForEvaluate_list_URL:dic andPage:@"1" isRefresh:NO];
        
    }
    
    if(segmentedController.selectedIndex==1){
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        dic[@"type"]=@"1";
        weak_type=@"1";
        [self.dataSource removeAllObjects];
        [self getDataForEvaluate_list_URL:dic andPage:@"1" isRefresh:NO];

    
    }
   
    
    
}


-(void)drawTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+36, WIDTH, HEIGHT-(64+36)) style:UITableViewStylePlain];
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
    
    Evaluate_list  *  model=self.dataSource[row];
    
    MySaiSingleCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MySaiSingleCell"];
    if (cell==nil) {
        [tableView registerNib:[UINib nibWithNibName:@"MySaiSingleCell" bundle:nil] forCellReuseIdentifier:@"MySaiSingleCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"MySaiSingleCell"];
        
    }
    
   
    
    [cell setProperty:model];
    [cell.saidanBt addTarget:self action:@selector(pp:) forControlEvents:UIControlEventTouchUpInside ];
     cell.saidanBt.tag=indexPath.row;
    
    


    
    return cell;
    
    
    
    
    
    
    
    
    
    
    
    
    
}




-(void)pp:(UIButton *)sender{
    
   Evaluate_list *model=self.dataSource[sender.tag];
    
     GotosaidanVC *VC=[[GotosaidanVC alloc]init];
    
    VC.model=model;
    [self.navigationController pushViewController:VC animated:YES];
    


}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 77;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Evaluate_list   *model=self.dataSource[indexPath.row];
    GoodsWebViewController *VC=[[GoodsWebViewController alloc]init];
    
    if (model.lucky_id.integerValue!=0) {
        VC.lucky_id=model.lucky_id;
    }else{
        
        VC.bid_id=model.bid_id;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)getDataForEvaluate_list_URL:(NSMutableDictionary*)dic andPage:(NSString *)page isRefresh:(BOOL)refresh
{
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"uid"] = UID;
    parameters[@"token"] = TOKEN;
    if (dic[@"type"]!=nil) {
         parameters[@"type"] = dic[@"type"];
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
    
    [manager GET:Evaluate_list_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//         NSLog(@"订单详情%@",dict);
         NSArray *array=dict[@"data"];
         if (refresh) {
             [self.dataSource removeAllObjects];
         }
         
         for (NSDictionary *dic1 in array) {
             Evaluate_list *model = [[Evaluate_list alloc]initWithDictionary:dic1 error:nil];
             
             if (model!=nil) {
                
                 if ([dic[@"type"] integerValue]==1) {
                    model.issaidan=NO;
                 }else{
                 
                    model.issaidan=YES;
                 }
                 
                 
                 [self.dataSource addObject:model];
                 
                 
             }else{
                 
                 
                 
             }
             
             
         }
         
         [_tableView reloadData];
         
         
         
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         
     }];
}


static int page=0;
- (void)viewDidLayoutSubviews
{
    __weak  MySaiSingleViewController *weakSelf = self;
    __weak UITableView *weak_tableView = _tableView;
    
    //下拉操作
    [_tableView addPullToRefreshWithActionHandler:^{
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        dic[@"type"]=weak_type;
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
        dic[@"type"]=weak_type;
        [weakSelf getDataForEvaluate_list_URL:dic andPage:[NSString stringWithFormat:@"%d",++page] isRefresh:NO];
        
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            
            
            
            [weak_tableView.infiniteScrollingView stopAnimating];
        });
        
        
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
