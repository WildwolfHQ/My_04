#import "SearchViewController.h"
#import "SortDetailViewController.h"

#define NUM self.titles.count

@interface SearchViewController ()<UISearchBarDelegate>

@property(nonatomic,strong)UISearchBar * searchBar;
@property(nonatomic,strong)NSMutableArray * titles;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    //去掉返回按钮后面的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [self createSearchBar];
    [self.searchBar becomeFirstResponder];
    [self getData];
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
    UIView * tagView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, WIDTH, HEIGHT)];
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
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(size.width, size.height-30, keyWorldWidth, 20)];
        button.titleLabel.numberOfLines = 0;
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 3.0;
        button.layer.masksToBounds = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [tagView addSubview:button];
        button.tag = i;
        [button addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        //起点 增加
        size.width += keyWorldWidth+padding;
    }
    [self.view addSubview:tagView];
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
@end
