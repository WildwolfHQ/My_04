#import "SearchViewController.h"
#import "SortDetailViewController.h"
#import "OTPageView.h"
#import "BuyTogetherModel.h"
#import "GoodsWebViewController.h"
#define NUM self.titles.count

@interface SearchViewController ()<UISearchBarDelegate,OTPageScrollViewDataSource,OTPageScrollViewDelegate>

@property(nonatomic,strong)UISearchBar * searchBar;
@property(nonatomic,strong)NSMutableArray * titles;
@property(nonatomic,strong)NSMutableArray * otdataSource;
@property(nonatomic,strong)OTPageView *PScrollView;
@end

@implementation SearchViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searchBar endEditing:YES];
}

-(NSMutableArray *)titles
{
    if (_titles == nil) {
        _titles = [[NSMutableArray alloc]init];
    }
    return _titles;
}

-(NSMutableArray *)otdataSource
{
    if (_otdataSource == nil) {
        _otdataSource = [[NSMutableArray alloc]init];
    }
    return _otdataSource;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
     self.view1.frame=CGRectMake(0, 0, WIDTH, HEIGHT-200);
     self.view1.multipleTouchEnabled=YES;
   
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap1)];
    [self.view1 addGestureRecognizer:tap];
     [self loadOT];
    [self.view addSubview:self.view1];
    //去掉返回按钮后面的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [self createSearchBar];
    //[self.searchBar becomeFirstResponder];
    
    [self getData];
    
    
}

-(void)tap1{
 [self.searchBar endEditing:YES];

}

-(void)loadOT{
    [self getData:nil andTop:nil];

    self.PScrollView = [[OTPageView alloc] initWithFrame:CGRectMake(0, HEIGHT-(155), WIDTH, 155)];

    UILabel *titlelable=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
    
    titlelable.text=@"猜你喜欢";
    [self.PScrollView addSubview:titlelable];

    self.PScrollView.pageScrollView.dataSource = self;
    self.PScrollView.pageScrollView.delegate = self;
    self.PScrollView.pageScrollView.padding =0;
    self.PScrollView.pageScrollView.leftRightOffset = 0;
    self.PScrollView.pageScrollView.frame = CGRectMake(0, titlelable.frame.origin.y+titlelable.frame.size.height-55, 100, 100);
    self.PScrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.PScrollView];
    
    
   
    
}

-(void)getData
{
    
    NSMutableDictionary *parameter=[[NSMutableDictionary alloc]init];
    parameter[@"type"]=@"1";
    //__block NSDictionary * dict;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:@"https://m.zouyun8.com/api/hot_search" parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
       
         NSDictionary *  dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSString * errcode = dict[@"errcode"];
         if ([errcode integerValue])
         {
             [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
         }
         else
         {
             NSLog(@"获取关键字成功%@",dict);
             NSArray * array = [[NSArray alloc]init];
             array = dict[@"data"];
             for (NSString * title in array) {
                 [self.titles addObject:title];
             }
             [self createButton];
              //
             
         }
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
}

-(void)createSearchBar
{
    for (UIImageView * view in self.navigationController.navigationBar.subviews) {
        if (view.tag == 10) {
            [view removeFromSuperview];
        }
    }
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:64/255.0 blue:64/255.0 alpha:1];
    //加上搜索栏
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH*0.6, 35)];
    
    
    self.searchBar = [[UISearchBar alloc] init];
    _searchBar.searchBarStyle=UISearchBarStyleMinimal;
    self.searchBar.delegate = self;
    self.searchBar.frame = CGRectMake(0, 0, WIDTH*0.6, 35);
    
    self.searchBar.placeholder = @"搜索宝贝";
    [titleView addSubview:self.searchBar];
    
    //Set to titleView
    [self.navigationItem.titleView sizeToFit];
    self.navigationItem.titleView = titleView;
}

#pragma mark - searchBar代理方法

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar endEditing:YES];
    [self pushToSortDetail:self.searchBar.text];
}

-(void)pushToSortDetail:(NSString * )name
{
    SortDetailViewController * sortDetail = [[SortDetailViewController alloc]init];
    sortDetail.name1 = name;
    sortDetail.name = name;
    sortDetail.urlStr = LUCKY_LIST;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sortDetail animated:YES];
}

-(void)createButton
{
    //UIView * tagView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, WIDTH, HEIGHT)];
    //第一个 label的起点
    CGSize size = CGSizeMake(5, 30);
    
    //间距
    CGFloat padding = 5.0;
    
    CGFloat width = WIDTH;
    
    NSArray *titleArr = self.titles;
    for (int i = 0; i < titleArr.count; i ++) {
        CGFloat keyWorldWidth = [self getSizeByString:titleArr[i] AndFontSize:14].width;
        if (keyWorldWidth > width) {
            keyWorldWidth = width;
        }
        if (width - size.width < keyWorldWidth) {
            size.height += 30.0;
            size.width = 5.0;
        }
        //创建 label点击事件
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(size.width, size.height-30 +120, keyWorldWidth, 20)];
        button.titleLabel.numberOfLines = 0;
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 3.0;
        button.layer.masksToBounds = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [self.view addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        //起点 增加
        size.width += keyWorldWidth+padding;
    }
    //[self.view addSubview:tagView];
}

- (void)tagButtonClick:(UIButton *)button
{
    [self.searchBar endEditing:YES];
    [self pushToSortDetail:button.titleLabel.text];
}

//计算文字所占大小
- (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    size.width += 5;
    return size;
}



#pragma mark - 猜你喜欢view的代理
- (NSInteger)numberOfPageInPageScrollView:(OTPageScrollView*)pageScrollView{
    return [self.otdataSource count];
}

- (UIView*)pageScrollView:(OTPageScrollView*)pageScrollView viewForRowAtIndex:(int)index{
    
    BuyTogetherModel * model=self.otdataSource[index];
    UIImageView *cell = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    [cell sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    return cell;
}

- (CGSize)sizeCellForPageScrollView:(OTPageScrollView*)pageScrollView
{
    return CGSizeMake(100, 100);
}
- (void)pageScrollView:(OTPageScrollView *)pageScrollView didTapPageAtIndex:(NSInteger)index{
    
    BuyTogetherModel * model=self.otdataSource[index];
    NSString * url = [NSString stringWithFormat:@"http://m.zouyun8.com/l/v/%@/?uid=%@&token=%@",model.ID,UID,TOKEN];
    
      GoodsWebViewController * VC = [[GoodsWebViewController alloc]init];
    
        VC.urlStr = url;
    
    
    
         self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
        

        
   

    
    
    
    
}


-(void)getData:(NSString *)page andTop:(NSString *)top
{
    page=@"1";
    top=@"1";
    [ToolClass getPub_lucky:^(NSDictionary *dic) {
        
        
        
        NSArray *  array = dic[@"data"];
        
        for (NSDictionary * dict in array) {
            BuyTogetherModel * model = [[BuyTogetherModel alloc]initWithDictionary:dict error:nil];
            
            [self.otdataSource addObject:model];
        }
        [self.PScrollView.pageScrollView reloadData];
    } page:page andTop:top];
}

@end
