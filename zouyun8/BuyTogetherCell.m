//
//  BuyTogetherCell.m
//  zouyun8
//
//  Created by 郑浩 on 16/6/8.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "BuyTogetherCell.h"

@implementation BuyTogetherCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setCellWithModel:(BuyTogetherModel *)model
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    self.title.text = model.name;
    self.name.text = model.username;
    self.price.text = model.price;
    self.buy.text = model.lucky_num;
    self.last.text = model.left_num;
}
- (IBAction)立即购买:(id)sender {
    
    NSString * type = TYPE;
    if ([type integerValue] == 2) {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"尊敬的试购员，您只能发起合购并邀请好友参与，不能参与他人的合购！" preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            
            
        }];
        
        
        
        
        
        [alertController addAction:okAction];
        
        
        //膜态时一定要判断你膜态的ViewController是不是空 ，空才能去膜态 、非空不能。
        if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController == nil)
            
        {
            
            
            [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:alertController  animated: YES completion:nil];
            
            
        }
        
        
        
        
    }else{
        
        //将cell属性里面的商品id加入到购物车数据库
        FMDatabase *db = [FMDatabase databaseWithPath:DBFATH];
        // 打开数据库
        [db open];
        //当前程序数据库是否有数据
        NSUInteger count = [db intForQuery:@"select count(*) from t_contact"];
        //插入购物车所需的cell数据到数据库
        NSLog(@"当前的token%@",TOKEN);
        if(TOKEN)
        {
            if(count == 0)
            {
//                NSLog(@"增加当前cell数据");
//                if([self.delegate respondsToSelector:@selector(changeCornerMark)])
//                {
//                    [self.delegate changeCornerMark];
//                }
                if(  [db executeUpdate:@"insert into t_contact (buy_num,goods_id,lucky_id,money,name,price,thumb,times,total_num,type,user_id,num,bid_id,buy_user_num,start_time,end_time,price_level) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",self.model.buy_num,self.model.goods_id,self.model.ID,self.model.money,self.model.name,self.model.price,self.model.thumb,nil,self.model.total_num,self.model.type,nil,@"1",nil,nil,nil,nil,nil]){
                    
                    if([self.delegate respondsToSelector:@selector(directToPay:)])
                    {
                        [self.delegate directToPay:nil];
                    }
                    
                }
            }
            else
            {
                //        NSLog(@"好的%@",self.model.goods_id);
                //        NSLog(@"%@",self.model.lucky_id);
                //        NSLog(@"%@",self.model.type);
                
                FMResultSet *result =  [db executeQuery:@"select * from t_contact"];
                BOOL flag = NO;
                while ([result next])
                {
                    NSLog(@"进来了");
                    //判断：如果当前cell的商品标题在数据库中已存在 则 只将该一行表格的num+1
                    if([[result stringForColumn:@"lucky_id"] isEqualToString:self.model.ID] && [[result stringForColumn:@"goods_id"] isEqualToString:self.model.goods_id ])
                    {
                        NSLog(@"商品名称重复了");
                        NSString * num = [result stringForColumn:@"num"];
                       // NSString * price = [result stringForColumn:@"price"];
                        NSInteger count = [num integerValue];
                        // NSLog(@"数字count1 = %d",count);
                        
                        count = count + 1;
                        
                        //NSLog(@"数字count2 = %d",count);
                        if( [db executeUpdate:@"UPDATE t_contact SET num = ? WHERE lucky_id = ? and goods_id = ?;", [NSString stringWithFormat:@"%ld",(long)count], self.model.ID,self.model.goods_id]){
                            
                            if([self.delegate respondsToSelector:@selector(directToPay:)])
                            {
                                [self.delegate directToPay:nil];
                            }
                            
                        }
                        
                        // NSLog(@"%@",[result stringForColumn:@"num"]);
                        flag = YES;
                    }
                }
                if(flag == NO)
                {    NSLog(@"还没有");
                    BOOL success =  [db executeUpdate:@"DELETE FROM t_contact"];
                    
                    if(success){
                        //             if([self.delegate respondsToSelector:@selector(changeCornerMark)])
                        //             {
                        //                [self.delegate changeCornerMark];
                        //             }
                        if( [db executeUpdate:@"insert into t_contact (buy_num,goods_id,lucky_id,money,name,price,thumb,times,total_num,type,user_id,num,bid_id,buy_user_num,start_time,end_time,price_level) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",self.model.buy_num,self.model.goods_id,self.model.ID,self.model.money,self.model.name,self.model.price,self.model.thumb,nil,self.model.total_num,self.model.type,nil,@"1",nil,nil,nil,nil,nil]){
                            
                            if([self.delegate respondsToSelector:@selector(directToPay:)])
                            {
                                [self.delegate directToPay:nil];
                            }
                            
                            
                        }
                        
                    }
                }
                
                
                
                
                
                
                
                
            }
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"directLogin" object:nil];
            
            
        }
        
        
    }

    
    
//    NSDictionary * dic;
//    dic= @{@"id":self.model.ID,@"type":@"1",@"num":@"1"};
//    
//    if([self.delegate respondsToSelector:@selector(directToPay:)])
//    {
//        [self.delegate directToPay:dic];
//    }
}

@end
