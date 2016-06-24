#import "AddDetailAddressController.h"

@interface AddDetailAddressController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSInteger _provinceIndex;   // 省份选择 记录
    NSInteger _cityIndex;       // 市选择 记录
    NSInteger _districtIndex;   // 区选择 记录
    
    NSString * _provinceStr;
    NSString * _cityStr;
    NSString * _districtStr;
}
@property (weak, nonatomic) IBOutlet MyTableView *AddDetailAddressTableView;
@property (nonatomic,copy) NSString* navTitle;
@property (nonatomic,strong)UITextField * areaTextField;
@property (nonatomic,copy)NSString * is_default;
@property (nonatomic,copy)NSString * name;
@property (nonatomic,copy)NSString * detail;
@property (nonatomic,copy)NSString * mobile;

@end

@implementation AddDetailAddressController

-(void)viewWillDisappear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}
-(void)initData
{
    _provinceIndex = _cityIndex = _districtIndex = 0;
}

#pragma mark - Load DataSource

// 读取本地Plist加载数据源
-(NSArray *)arrayDS
{
    if(!_arrayDS){
        NSString * path = [[NSBundle mainBundle] pathForResource:@"Province" ofType:@"plist"];
        _arrayDS = [[NSArray alloc] initWithContentsOfFile:path];
    }
    
    
    return _arrayDS;
}

// 懒加载方式
-(UIPickerView *)pickerView
{
    if(!_pickerView){
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, HEIGHT - PICKER_HEIGHT, WIDTH, PICKER_HEIGHT)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

-(void)resetPickerSelectRow
{
    
    
    [self.pickerView selectRow:_provinceIndex inComponent:0 animated:YES];
    [self.pickerView selectRow:_cityIndex inComponent:1 animated:YES];
    [self.pickerView selectRow:_districtIndex inComponent:2 animated:YES];
}
#pragma mark - PickerView Delegate

// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// 每列有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0){
        return self.arrayDS.count;
    }
    else if (component == 1){
        return [self.arrayDS[_provinceIndex][@"citys"] count];
    }
    else{
        return [self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"districts"] count];
    }
}

// 返回每一行的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0){
        return self.arrayDS[row][@"province"];
    }
    else if (component == 1){
        return self.arrayDS[_provinceIndex][@"citys"][row][@"city"];
    }
    else{
        return self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"districts"][row];
    }
}

// 滑动或点击选择，确认pickerView选中结果
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if(component == 0){
        _provinceIndex = row;
        _cityIndex = 0;
        _districtIndex = 0;
        NSString * address = [NSString stringWithFormat:@"%@-%@-%@", self.arrayDS[_provinceIndex][@"province"], self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"city"], self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"districts"][_districtIndex]];
        _provinceStr = self.arrayDS[_provinceIndex][@"province"];
        _cityStr = self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"city"];
        _districtStr = self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"districts"][_districtIndex];
        self.areaTextField.text = address;
        [self.pickerView reloadComponent:1];
        [self.pickerView reloadComponent:2];
    }
    else if (component == 1){
        _cityIndex = row;
        _districtIndex = 0;
        NSString * address = [NSString stringWithFormat:@"%@-%@-%@", self.arrayDS[_provinceIndex][@"province"], self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"city"], self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"districts"][_districtIndex]];
        _provinceStr = self.arrayDS[_provinceIndex][@"province"];
        _cityStr = self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"city"];
        _districtStr = self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"districts"][_districtIndex];
        self.areaTextField.text = address;
        [self.pickerView reloadComponent:2];
    }
    else{
        _districtIndex = row;
        NSString * address = [NSString stringWithFormat:@"%@-%@-%@", self.arrayDS[_provinceIndex][@"province"], self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"city"], self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"districts"][_districtIndex]];
        _provinceStr = self.arrayDS[_provinceIndex][@"province"];
        _cityStr = self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"city"];
        _districtStr = self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"districts"][_districtIndex];
        self.areaTextField.text = address;
    }
    
    // 重置当前选中项
    [self resetPickerSelectRow];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSString * address = [NSString stringWithFormat:@"%@-%@-%@", self.arrayDS[_provinceIndex][@"province"], self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"city"], self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"districts"][_districtIndex]];
    self.areaTextField.text = address;
    _provinceStr = self.arrayDS[_provinceIndex][@"province"];
    _cityStr = self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"city"];
    _districtStr = self.arrayDS[_provinceIndex][@"citys"][_cityIndex][@"districts"][_districtIndex];


}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
       [self.areaTextField resignFirstResponder];
}

- (void)viewDidLoad {
    self.title = self.editOrAdd;
    self.is_default = @"0";
    [super viewDidLoad];
//    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAdd:)];
//    self.navigationItem.rightBarButtonItem = rightItem;
    [self createAddDetailAddressTableView];
    [self initData];
    // 默认Picker状态
    [self.pickerView selectRow:1  inComponent:1  animated:YES];
    
  
}
-(void)createAddDetailAddressTableView
{
    [self.AddDetailAddressTableView registerNib:[UINib nibWithNibName:@"LblTxtTableViewCell" bundle:nil] forCellReuseIdentifier:@"LblTxtTableViewCell"];
}
- (IBAction)saveAdd:(id)sender
{
    NSLog(@"点击了保存地址");
    NSLog(@"%@",self.detail);
    NSLog(@"%@",self.name);
    NSLog(@"%@",self.mobile);
    if (1) {
        
        
        if (self.areaTextField.text.length==0) {
            [SVProgressHUD showErrorWithStatus:@"请选择所在区域"];
            return;
        }
        
        if (self.name.length==0) {
            [SVProgressHUD showErrorWithStatus:@"请编辑联系人"];
            return;
        }
        
        if (self.mobile.length==0) {
            [SVProgressHUD showErrorWithStatus:@"请编辑联系方式"];
            return;
        }

        if (self.detail.length==0) {
            [SVProgressHUD showErrorWithStatus:@"请编辑详细地址"];
            return;
        }

        
//        if (self.delegate) {
//            [self.delegate fetchNewAddr:self.dataModel];
//        }
        //如果信息完整则提交到服务器
        //post请求
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"token"] = TOKEN;
        params[@"uid"] = UID;
        params[@"mobile"] = self.mobile;
        params[@"name"] = self.name;
        params[@"province"] = _provinceStr;
        params[@"city"] = _cityStr;
        params[@"town"] = _districtStr;
        params[@"detail"] = self.detail;
        params[@"default"] = self.is_default;
        NSString * currentUrl = [[NSString alloc]init];
        if ([self.editOrAdd isEqualToString:@"编辑联系人"]) {
            currentUrl = ADDRESS_EDITURL;
            params[@"id"] = self.addressID;
        }
        else
        {
            currentUrl = ADDRESS_ADD;
        }
        [HttpRequest postWithURLString:currentUrl parameters:params success:^(id responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            NSString * errcode = dict[@"errcode"];
            NSLog(@"%@",errcode);
            
            if ([errcode integerValue])
            {
                [SVProgressHUD showErrorWithStatus:dict[@"errmsg"]];
            }
            else
            {
                //地址添加成功
                [SVProgressHUD showSuccessWithStatus:@"地址添加成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDefaultDitali" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            NSLog(@"--------------------%@",dict);
            
        } failure:^(NSError *error) {
            NSLog(@"--------------------请求失败");
        }];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        //提示输入完整信息
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入完整信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:TRUE completion:nil];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.areaTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 7, WIDTH - 20, 30)];
    self.areaTextField.delegate = self;
    self.areaTextField.placeholder = @"选择所在区域";
    self.areaTextField.inputView = self.pickerView;
    self.areaTextField.textAlignment = NSTextAlignmentCenter;
    return self.areaTextField;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        LblTxtTableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"LblTxtTableViewCell"];
        cell1.label.text = @"收件人:";
        cell1.textField.placeholder = @"姓名";
        cell1.textField.delegate = self;
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell1.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        return cell1;
    }
    else if (indexPath.row == 1)
    {
        LblTxtTableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"LblTxtTableViewCell"];
        cell1.label.text = @"联系方式:";
        cell1.textField.placeholder = @"电话号码";
        cell1.textField.delegate = self;
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell1.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        return cell1;
    }
    else if (indexPath.row == 2)
    {
        LblTxtTableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"LblTxtTableViewCell"];
        cell1.label.text = @"详细地址:";
        cell1.textField.placeholder = @"街道，楼牌号等";
        cell1.textField.delegate = self;
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell1.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        return cell1;
    }
    else
    {
        LblTxtTableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:@"LblTxtTableViewCell"];
        cell1.label.text = @"设为默认地址";
        UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(50, 100, 20, 10)];
        [switchButton setOn:NO];
        [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell1.textField removeFromSuperview];
        cell1.accessoryView = switchButton;
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell1;
    }
//    else
//    {
//        LblLblTableViewCell * cell2 = [[NSBundle mainBundle]loadNibNamed:@"LblLblTableViewCell" owner:self options:nil].firstObject;
//        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell2.tag = 100;
//        return cell2;
//    }
}

#pragma mark - 默认地址按钮改变
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        self.is_default = @"1";
    }else {
        self.is_default = @"0";
    }
}

#pragma mark - 3个输入框任何一个输入框结束了编辑都保存信息
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField.placeholder  isEqualToString: @"姓名"]) {
        self.name = textField.text;
    }else if([textField.placeholder  isEqualToString: @"电话号码"]){
        
        self.mobile = textField.text;
    }else if([textField.placeholder isEqualToString:@"街道，楼牌号等"]){
        self.detail = textField.text;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    //用户结束输入
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string // return NO to not change text
{
    //判断是否超过 ACCOUNT_MAX_CHARS 个字符,注意要判断当string.leng>0
    //的情况才行，如果是删除的时候，string.length==0
    int length = textField.text.length;
    if (length >= 11 && string.length >0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void) textFieldDidChange:(UITextField *) textField
{
    NSLog(@"改变了");
    if ([textField.placeholder  isEqualToString: @"姓名"]) {
        self.name = textField.text;
    }else if([textField.placeholder  isEqualToString: @"电话号码"]){
        self.mobile = textField.text;
    }else if([textField.placeholder isEqualToString:@"街道，楼牌号等"]){
        self.detail = textField.text;
    }
}

@end
