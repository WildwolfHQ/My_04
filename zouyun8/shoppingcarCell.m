#import "shoppingcarCell.h"

@interface shoppingcarCell()<UITextFieldDelegate>

@end

@implementation shoppingcarCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.buyTextField.delegate = self;
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setCellWithModel:(BOOL)is_tuhao
{
    
    
    
    if (self.model.bid_id.length != 0) {
        self.lastLabel.hidden = YES;
        self.last.hidden = YES;
        self.num.hidden = YES;
        self.needAll.text = @"单价:";
        self.totalLabel.text = self.model.price;
    }
    if(self.model.lucky_id.length != 0)
    {
        
        if (self.model.lucky_type.integerValue==1) {
             self.last.hidden = YES;
             self.num.hidden = YES;
             self.lastLabel.hidden=YES;
             self.needAll.text = @"价格";
        
            self.totalLabel.text = self.model.money;
            self.canyurenci.text=@"购买份数";
            
        }else{
            
            self.lastLabel.hidden = NO;
            self.last.hidden = NO;
            self.num.hidden = NO;
            self.needAll.text = @"总需:";
            self.totalLabel.text = self.model.total_num;
            self.lastLabel.text = [NSString stringWithFormat:@"%ld",[self.model.total_num integerValue] - [self.model.buy_num integerValue]];

        }

    }
    [self.iamgeview sd_setImageWithURL:[NSURL URLWithString:self.model.thumb]];
    self.titleLabel.text = self.model.name;
}

- (IBAction)cutNumberBtn:(id)sender
{
    if ([self.buyTextField.text integerValue] > 1)
    {
        //按照单价递减
        self.buyTextField.text = [NSString stringWithFormat:@"%ld",[self.buyTextField.text integerValue] - 1];
        
        /*保存减后的数据到数据库 并 调用cell代理方法改变购买数量*/
        FMDatabase *db = [FMDatabase databaseWithPath:DBFATH];
        // 打开数据库
        [db open];
        FMResultSet *result =  [db executeQuery:@"select * from t_contact"];
        while ([result next])
        {
            
            //判断：根据当前cell的商品标题获取到该行字段 并改变改行字段属性的值
            if([[result stringForColumn:@"lucky_id"] isEqualToString:self.model.lucky_id] && [[result stringForColumn:@"type"] isEqualToString:self.model.type ])
            {
                NSLog(@"减一下");
                [db executeUpdate:@"UPDATE t_contact SET num = ? WHERE lucky_id = ? and type = ?;", self.buyTextField.text, self.model.lucky_id,self.model.type];
            }
            if ([[result stringForColumn:@"bid_id"] isEqualToString:self.model.bid_id])
            {
                NSLog(@"减一下");
                [db executeUpdate:@"UPDATE t_contact SET num = ? WHERE bid_id = ?;", self.buyTextField.text, self.model.bid_id];
            }
                //发送通知告诉tableView重新从数据库获取数据源并刷新列表
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshTableView" object:nil];
        }
        if ([self.delegate respondsToSelector:@selector(changeBuyNumber:)])
        {
            [self.delegate changeBuyNumber:[self getIndexPath]];
        }
    }
    
}

- (IBAction)addNumberBtn:(id)sender
{
    NSLog(@"点击了加号");
    //
    if (!([self.lastLabel.text integerValue] < [self.buyTextField.text integerValue] || [self.lastLabel.text integerValue] == [self.buyTextField.text integerValue])) {
        self.buyTextField.text = [NSString stringWithFormat:@"%ld",[self.buyTextField.text integerValue] + 1];
        /*保存减后的数据到数据库 并 调用cell代理方法改变购买数量*/
        FMDatabase *db = [FMDatabase databaseWithPath:DBFATH];
        // 打开数据库
        [db open];
        FMResultSet *result =  [db executeQuery:@"select * from t_contact"];
        while ([result next])
        {
            //判断：根据当前cell的商品标题获取到该行字段 并改变改行字段属性的值
            if([[result stringForColumn:@"lucky_id"] isEqualToString:self.model.lucky_id] && [[result stringForColumn:@"type"] isEqualToString:self.model.type ])
            {
                NSLog(@"加一下");
                [db executeUpdate:@"UPDATE t_contact SET num = ? WHERE lucky_id = ? and type = ?;", self.buyTextField.text, self.model.lucky_id,self.model.type];
            }
            if ([[result stringForColumn:@"bid_id"] isEqualToString:self.model.bid_id])
            {
                NSLog(@"加一下");
                [db executeUpdate:@"UPDATE t_contact SET num = ? WHERE bid_id = ?;", self.buyTextField.text, self.model.bid_id];
            }
        }
        if ([self.delegate respondsToSelector:@selector(changeBuyNumber:)])
        {
            [self.delegate changeBuyNumber:[self getIndexPath]];
        }
    }
}

- (IBAction)clearBtn:(id)sender {
    /*
     1.根据name从数据库中清除该商品，
     2.发送通知给tableView刷新数据
     */
    FMDatabase *db = [FMDatabase databaseWithPath:DBFATH];
    // 打开数据库
    [db open];
    FMResultSet *result =  [db executeQuery:@"select * from t_contact"];
    while ([result next])
    {
        //判断：如果当前cell的商品标题在数据库中已存在 则删除该行字段
        if([[result stringForColumn:@"lucky_id"] isEqualToString:self.model.lucky_id] && [[result stringForColumn:@"type"] isEqualToString:self.model.type ])
        {
            
            NSString *deleteSql = [NSString stringWithFormat:
                                   @"delete from t_contact where lucky_id = '%@' and type = '%@'",
                                    self.model.lucky_id,self.model.type];
            [db executeUpdate:deleteSql];
            //发送通知告诉tableView重新从数据库获取数据源并刷新列表
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshTableView" object:nil];
            //代理方法让tableView移除要删除的商品
        }
        if ([[result stringForColumn:@"bid_id"] isEqualToString:self.model.bid_id])
        {
            NSString *deleteSql = [NSString stringWithFormat:
                                   @"delete from t_contact where bid_id = '%@'",
                                   self.model.bid_id];
            [db executeUpdate:deleteSql];
        }
    }
    if ([self.delegate respondsToSelector:@selector(removeGoods:)])
    {
        [self.delegate removeGoods:[self getIndexPath]];
    }
}

- (NSIndexPath *)getIndexPath
{
    //IOS7 OR LATER AVALIABLE
    UITableView *tableView = (UITableView *)self.superview.superview;
    return [tableView indexPathForCell:self];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"触摸了");
    [(UITableView *)self.superview.superview endEditing:YES];
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSLog(@"键盘退出了");
    NSLog(@"%@",self.buyTextField.text);
    //如果键盘隐藏时选择的数量大于剩余数量，则等于剩余数量
//    if ([self.buyTextField.text integerValue] > [self.lastLabel.text integerValue]) {
//        self.buyTextField.text = self.lastLabel.text;
//    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textField.text is %@",textField.text);
    if ([self.buyTextField.text isEqualToString:@"0"]) {
        self.buyTextField.text = @"1";
    }
    else
    {
    //将改变后的商品价格保存到数据库
        FMDatabase *db = [FMDatabase databaseWithPath:DBFATH];
        // 打开数据库
        [db open];
        FMResultSet *result =  [db executeQuery:@"select * from t_contact"];
        while ([result next])
        {
            //判断：根据当前cell的商品标题获取到该行字段 并改变改行字段属性的值
            if([[result stringForColumn:@"lucky_id"] isEqualToString:self.model.lucky_id] && [[result stringForColumn:@"type"] isEqualToString:self.model.type ])
            {
                [db executeUpdate:@"UPDATE t_contact SET num = ? WHERE lucky_id = ? and type = ?;", self.buyTextField.text, self.model.lucky_id,self.model.type];
            }
            if([[result stringForColumn:@"bid_id"] isEqualToString:self.model.bid_id])
            {
                [db executeUpdate:@"UPDATE t_contact SET num = ? WHERE bid_id = ?;", self.buyTextField.text, self.model.bid_id];
            }
        }
    }
    //重新设置底部总价
    [self.delegate refreshTotalPrice];
}

@end












