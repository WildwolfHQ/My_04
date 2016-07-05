#import "NetShareViewController.h"
#import "NetShareCell.h"
#import "NetShareModel.h"
#import "BigImageViewController.h"
#import "GoodsWebViewController.h"
@interface NetShareViewController ()<NetShareCellDelegate>

@end

@implementation NetShareViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLayoutSubviews
{
    __weak NetShareViewController * weakSelf = self;
    //下拉操作
    [self.tableView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            weakSelf.page = 1;
//            [weakSelf getdata];
            [weakSelf.tableView.pullToRefreshView stopAnimating];
        });
    }];
    //上拉操作
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        weakSelf.page += 1;
        [weakSelf getdata];
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    }];
}


-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
-(NSMutableArray *)counts
{
    if (_counts == nil) {
        _counts = [[NSMutableArray alloc]init];
    }
    return _counts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.title = @"晒单";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor redColor],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:64/255.0 blue:64/255.0 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"NetShareCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self getdata];
}

-(void)showBigImage:(NSMutableArray *)images andCount:(NSInteger)count
{
    BigImageViewController * bigImage = [[BigImageViewController alloc]init];
    bigImage.images = images;
    bigImage.count = count;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bigImage animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}

-(void)getdata
{
    [ToolClass getEvaluate_all_list:^(NSDictionary *dic) {
        NSLog(@"获取到的晒单%@",dic);
        NSArray * array = [[NSArray alloc]init];
        array = dic[@"data"];
        for (NSDictionary * dict in array) {
            NetShareModel * model = [[NetShareModel alloc]initWithDictionary:dict error:nil];
            
            //根据文字和图片约束的高度设置model.height的值
            CGFloat height = [self heightForString:model.name fontSize:12 andWidth:WIDTH - 89] + [self heightForString:model.title fontSize:12 andWidth:WIDTH - 89];
            model.height = height;
            [self.dataSource addObject:model];
            
            NSData * data = [model.images dataUsingEncoding:NSASCIIStringEncoding];
            NSMutableArray * array = [self toArrayOrNSDictionary:data];
            [self.counts addObject:[NSNumber numberWithInteger:array.count]];
        }
//        NetShareModel * model = self.dataSource[6];
//        NSLog(@"第六个%@",model.images);
        [self.tableView reloadData];
    } page:[NSString stringWithFormat:@"%ld",self.page] andID:self.ID];
}
/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result float 返回的高度
 */
-(float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}
#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NetShareModel * model = self.dataSource[indexPath.row];
    //跳转到商品详情页面
    
    GoodsWebViewController *VC=[[GoodsWebViewController alloc]init];
     NSDictionary *dic=[[NSMutableDictionary alloc]init];
    if (model.lucky_id.length>1) {
          VC.lucky_id=model.lucky_id;
        [dic setValue:[NSString stringWithFormat:@"%@%@",Share_URL,model.lucky_id]forKey:@"url"];
    }else{
    
        VC.bid_id=model.bid_id;
        [dic setValue:[NSString stringWithFormat:@"%@%@",Share_URL,model.bid_id]forKey:@"url"];
    }
  
   
    
    [dic setValue:model.thumb forKey:@"image"];
    [dic setValue:@"" forKey:@"desc"];
    
    [dic setValue:model.name forKey:@"title"];
    [dic setValue:@"1" forKey:@"share_action"];//action	int	必须	分享类型	1商品详情，2二维码，3活动页
    
    
    //    dic[@"url"]=model;
    //    dic[@"desc"];
    VC.shareDict=dic;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    self.hidesBottomBarWhenPushed = NO;

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NetShareModel * model = self.dataSource[indexPath.row];
    NSLog(@"%f",model.height);
    return model.height + 8 + 19 + 5.5 + 18.5 + (WIDTH - 120)/5 + 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NetShareCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (cell.imagesArray.count != 0) {
//        [cell.imagesArray removeAllObjects];
//    }

    cell.delegate = self;
    NetShareModel * model = self.dataSource[indexPath.row];
    
    NSInteger count = [self.counts[indexPath.row] integerValue];
    cell.count = count;
    
    NSData * data = [model.images dataUsingEncoding:NSASCIIStringEncoding];
    NSMutableArray * array = [self toArrayOrNSDictionary:data];
    cell.imagesArray = array;
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellWithModel:model];
    return cell;
}
- (id)toArrayOrNSDictionary:(NSData *)jsonData
{
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    if (jsonObject != nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}
@end
