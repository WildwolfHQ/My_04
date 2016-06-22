#import "FirstCollectionViewCell.h"
#import "DirectSettleViewController.h"

@implementation FirstCollectionViewCell
- (IBAction)好友合购:(id)sender {
    if (TOKEN == nil)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"directLogin" object:nil];
    }
    else
    {
    if([self.delegate respondsToSelector:@selector(selectBuyTogetherNum:)])
        {
            [self.delegate selectBuyTogetherNum:self.model];
        }
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (IBAction)购买方式:(id)sender
{
//    //将cell属性里面的商品id加入到购物车数据库
//    FMDatabase *db = [FMDatabase databaseWithPath:DBFATH];
//    // 打开数据库
//    [db open];
//    //当前程序数据库是否有数据
//    NSUInteger count = [db intForQuery:@"select count(*) from t_contact"];
//    //插入购物车所需的cell数据到数据库
//    NSLog(@"当前的token%@",TOKEN);
//    if(TOKEN)
//    {
//    if(count == 0)
//    {
//        NSLog(@"增加当前cell数据");
//        if([self.delegate respondsToSelector:@selector(changeCornerMark)])
//        {
//            [self.delegate changeCornerMark];
//        }
//        [db executeUpdate:@"insert into t_contact (buy_num,goods_id,lucky_id,money,name,price,thumb,times,total_num,type,user_id,num,bid_id,buy_user_num,start_time,end_time,price_level) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",self.model.buy_num,self.model.goods_id,self.model.lucky_id,self.model.money,self.model.name,self.model.price,self.model.thumb,self.model.times,self.model.total_num,self.model.type,self.model.user_id,@"1",self.model.bid_id,self.model.buy_user_num,self.model.start_time,self.model.end_time,self.model.price_level];
//    }
//    else
//    {
//        NSLog(@"好的%@",self.model.goods_id);
//        NSLog(@"%@",self.model.lucky_id);
//        NSLog(@"%@",self.model.type);
//        
//        FMResultSet *result =  [db executeQuery:@"select * from t_contact"];
//        BOOL flag = NO;
//        while ([result next])
//        {
//            NSLog(@"进来了");
//            //判断：如果当前cell的商品标题在数据库中已存在 则 只将该一行表格的num+1
//            if([[result stringForColumn:@"lucky_id"] isEqualToString:self.model.lucky_id] && [[result stringForColumn:@"type"] isEqualToString:self.model.type ])
//            {
//            NSLog(@"商品名称重复了");
//                NSString * num = [result stringForColumn:@"num"];
//                NSString * price = [result stringForColumn:@"price"];
//                NSInteger count = [num integerValue];
//                NSLog(@"数字count1 = %d",count);
//                
//                count = count + [price integerValue];
//                
//                NSLog(@"数字count2 = %d",count);
//                [db executeUpdate:@"UPDATE t_contact SET num = ? WHERE lucky_id = ? and type = ?;", [NSString stringWithFormat:@"%ld",(long)count], self.model.lucky_id,self.model.type];
//                
//                NSLog(@"%@",[result stringForColumn:@"num"]);
//                flag = YES;
//            }
//        }
//        if(flag == NO)
//        {
//            NSLog(@"还没有");
//            if([self.delegate respondsToSelector:@selector(changeCornerMark)])
//            {
//                [self.delegate changeCornerMark];
//            }
//            [db executeUpdate:@"insert into t_contact (buy_num,goods_id,lucky_id,money,name,price,thumb,times,total_num,type,user_id,num,bid_id,buy_user_num,start_time,end_time,price_level) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",self.model.buy_num,self.model.goods_id,self.model.lucky_id,self.model.money,self.model.name,self.model.price,self.model.thumb,self.model.times,self.model.total_num,self.model.type,self.model.user_id,self.model.price,self.model.bid_id,self.model.buy_user_num,self.model.start_time,self.model.end_time,self.model.price_level];
//        }
//    }
//    }
    
    if(TOKEN)
    {
        //跳转到结算界面选择支付方式
        NSDictionary * dic;
        dic= @{@"id":self.model.lucky_id,@"type":self.model.type,@"num":@"1"};
        if([self.delegate respondsToSelector:@selector(directToPay:)])
        {
            [self.delegate directToPay:dic];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"directLogin" object:nil];
    }
}

-(void)setCellWithModel
{
    self.titleLabel.text = self.model.name;
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/400/h/400",self.model.thumb]] placeholderImage:nil];
    self.singlePrice.text = self.model.money;
    self.buyLabel.text = self.model.lucky_num;
}

@end
