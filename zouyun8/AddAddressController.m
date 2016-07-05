#import "AddAddressController.h"

@interface AddAddressController ()<UITableViewDelegate,UITableViewDataSource,AddrListTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *AddAddressTableView;
@property (nonatomic,strong) NSMutableArray *addrDataSrc;
@property (nonatomic) NSInteger curEditIndex;
@end

@implementation AddAddressController

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
    NSLog(@"出现了%d",self.dataSource.count);
    self.navigationController.navigationBar.hidden = NO;
    [self getdata];
    [self.AddAddressTableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self getdata];
}
-(void)setBar
{
    self.AddAddressTableView.delegate = self;
    self.AddAddressTableView.dataSource = self;
//    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewAdd:)];
//    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark - 实现addrdetail 的代理

-(void)getdata
{
    //清空数组
    self.dataSource = nil;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = TOKEN;
    params[@"uid"] = UID;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:ADDRESS_LISTURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSArray * array = dict[@"data"];
         //请求成功,将图片下载完保存到数组中
         for (NSDictionary * dic in array)
         {
             AddrDataModel * model = [[AddrDataModel alloc]initWithDictionary:dic error:nil];
             [self.dataSource addObject:model];
         }
         [self.AddAddressTableView reloadData];
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
}

- (void)viewDidLoad
{
    self.title = @"地址管理";
    [super viewDidLoad];
    [self setBar];
    [self setAddAddressTableView];
    self.xinjiandizhiBt.layer.cornerRadius=4;
}
- (IBAction)addNewAdd:(id)sender {
    NSLog(@"进入添加新地址页面");
    AddDetailAddressController * add = [[AddDetailAddressController alloc]init];
    add.editOrAdd = @"新建地址";
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:add animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
}

-(void)setAddAddressTableView
{
    [self.AddAddressTableView registerNib:[UINib nibWithNibName:@"AddrListTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddrListTableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    //可变
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"进入添加新地址页面");
    //弹出窗口选择设置为 默认 或者 删除该地址
//    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                  message:nil
//                                                 delegate:self
//                                        cancelButtonTitle:@"取消"
//                                        otherButtonTitles:@"按钮一", @"按钮二", @"按钮三",nil];
//    [alert show];
    
//    AddrDataModel * model = self.dataSource[indexPath.row];
//    AddDetailAddressController * add = [[AddDetailAddressController alloc]init];
//    add.editOrAdd = @"编辑联系人";
//    add.addressID = model.ID;
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:add animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddrListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddrListTableViewCell"];
    cell.switchBtn.on = NO;
    cell.delegate = self;
    AddrDataModel * model = self.dataSource[indexPath.row];
    cell.nameLabel.text = model.name;
    cell.detaillabel.text = [NSString stringWithFormat:@"%@%@%@%@", model.province,model.city, model.town,model.detail]; ;
    cell.mobileLabel.text = model.phone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSLog(@"%@",model.default1);
    if (model.default1.integerValue==1) {
         cell.is_default.hidden = NO;
         cell.switchBtn.on = YES;
         cell.switchBtn.enabled = NO;

    }else{
    
         cell.is_default.hidden = YES;
    }
    
//    if (indexPath.row == 0) {
//           }
//    else
    
    return cell;
}

-(void)deleteAddress:(NSIndexPath *)index
{
    //删除地址
    AddrDataModel * model = self.dataSource[index.row];
    //从列表删除
    //重新从数据库获取数据 并 单独刷新这一行
    [self.dataSource removeObjectAtIndex:index.row];
    [self.AddAddressTableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationRight];
    [self.AddAddressTableView reloadData];
    //从网络删除
    [ToolClass DelegateAddress_del:^(NSDictionary *dic) {
        NSLog(@"删除地址后返回%@",dic);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDefaultDitali" object:nil];

    } ID:model.ID];
}
-(void)setDefaultAddress:(NSIndexPath *)index
{

    //从网络设置默认地址
    AddrDataModel * model = self.dataSource[index.row];
    [ToolClass SetDefaultAddress:^(NSDictionary *dic) {
        //NSLog(@"%@",dic[@"errmsg"]);
        //刷新表格
        NSString * errcode = dic[@"errcode"];
        if ([errcode integerValue]==0)
        {
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDefaultDitali" object:nil];
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:@"设置失败"];
            
            
       
            //            [SVProgressHUD showSuccessWithStatus:@"获取用户信息成功"];
            //保存用户token等用户信息,并同步
            //            [ToolClass saveUserInfo:dict];
            //跳转到根视图,并加载个人信息
            
        }
        
        
        
        [self getdata];
    } addressModel:model];
}
@end
