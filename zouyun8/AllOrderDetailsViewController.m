//
//  AllOrderDetailsViewController.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/16.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "AllOrderDetailsViewController.h"
#import "AllOrderTableViewCell1.h"
#import "AllOrderTableViewCell2.h"
#import "AllOrderTableViewCell3.h"
#import "AllOrderTableViewCell4.h"
#import "AllOrderTableViewCell5.h"
#import "Bill_View.h"
#import "GoodsWebViewController.h"
@interface AllOrderDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>{

    UITableView *_tableView;
    Bill_View *_model;
}

@end

@implementation AllOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"订单详情";
    
     NSMutableDictionary *dic=[NSMutableDictionary dictionary];
     dic[@"id"]=self.orderID;
    [self getDataForBill_view_URL:dic];
    [self drawTableView];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)drawTableView{
   _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        return 88;
    }
    
    
    if (indexPath.section == 2) {
        if (indexPath.row==0) {
            return 44;
        }
        return 88;
    }
    
    if (indexPath.section == 4) {
      
        return 88;
    }
    if (indexPath.section == 5) {
        if (indexPath.row==0) {
            return 64;
        }
        return 88;
    }


    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        NSInteger row;
        if (_model!=nil) {
          row= _model.goods_info.count+1;
        }else{
            row=1;
        
        }
     
        return  row;
    }
    if (section == 3) {
        return 1;
    }
    if (section == 4) {
        return 1;
    }

   
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    
    if (section==0) {
        
      AllOrderTableViewCell1  *cell= [tableView dequeueReusableCellWithIdentifier:@"AllOrderTableViewCell1"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"AllOrderTableViewCell1" bundle:nil] forCellReuseIdentifier:@"AllOrderTableViewCell1"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"AllOrderTableViewCell1"];
            
        }
        
       [cell setProperty:_model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
    
    if (section==1) {
        
      AllOrderTableViewCell2  *cell = [tableView dequeueReusableCellWithIdentifier:@"AllOrderTableViewCell2"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"AllOrderTableViewCell2" bundle:nil] forCellReuseIdentifier:@"AllOrderTableViewCell2"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"AllOrderTableViewCell2"];
        }
        
         [cell setProperty:_model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }

    
    
    if (section==2) {
        
        if (row==0) {
          UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.textLabel.text =  @"商品";
            cell.textLabel.textColor=[UIColor darkGrayColor];
            cell.textLabel.font=[UIFont systemFontOfSize:13];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
             return cell;
        }
        AllOrderTableViewCell3  *cell = [tableView dequeueReusableCellWithIdentifier:@"AllOrderTableViewCell3"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"AllOrderTableViewCell3" bundle:nil] forCellReuseIdentifier:@"AllOrderTableViewCell3"];
            cell= [tableView dequeueReusableCellWithIdentifier:@"AllOrderTableViewCell3"];
        }
        
        
        
        [cell setProperty:_model.goods_info[row-1]];
        
        return cell;

        
        

        
       
        
    }

    
    
    if (section==3) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, WIDTH, cell.frame.size.height);
        cell.textLabel.text =  @"支付方式";
        cell.textLabel.font=[UIFont systemFontOfSize:13];
        cell.textLabel.textColor=[UIColor darkGrayColor];
        
       UILabel * lable=[[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width-(8+80),9, 80, 30)];
        [cell addSubview:lable];
        if (_model.pay_type.integerValue==1) {
            lable.text=@"走运币支付";
        }else if (_model.pay_type.integerValue==2){
            lable.text=@"微信支付";
        }else if(_model.pay_type.integerValue==3){
        
             lable.text=@"银联支付";
        }else{
        
             lable.text=@"未知";
        }
         // payID 1走运币 2微信 3银联
        lable.font=[UIFont systemFontOfSize:13];
        lable.textColor=[UIColor greenColor];
        
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }

    
    if (section==4) {
        
       AllOrderTableViewCell5 *cell = [tableView dequeueReusableCellWithIdentifier:@"AllOrderTableViewCell5"];
        if (!cell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"AllOrderTableViewCell5" bundle:nil] forCellReuseIdentifier:@"AllOrderTableViewCell5"];
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"AllOrderTableViewCell5"];
        }
        [cell setProperty:_model];
        [cell.chakanwuliuBt addTarget:self action:@selector(action1) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }

    
    if (section==5) {
        
        if(row == 0)
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, WIDTH, cell.frame.size.height);
            
            UILabel  *lable1=[[UILabel alloc]initWithFrame:CGRectMake(16,9, 80, 30)];
            [cell addSubview:lable1];
            lable1.text=@"商品总额";
            lable1.textColor=[UIColor darkGrayColor];
            lable1.font=[UIFont systemFontOfSize:13];
            
            
            UILabel  *lable3=[[UILabel alloc]initWithFrame:CGRectMake(16,37, 80, 30)];
            [cell addSubview:lable3];
            lable3.text=@"抵扣奖金";
            lable3.textColor=[UIColor darkGrayColor];
            lable3.font=[UIFont systemFontOfSize:11];
            
            
            
            UILabel  *lable2=[[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width-(8+80),37, 80, 30)];
            [cell addSubview:lable2];
            lable2.text=[NSString stringWithFormat:@"¥%@",_model.cost_score];
            lable2.textColor=[UIColor redColor];
            lable2.textAlignment=NSTextAlignmentRight;
            lable2.font=[UIFont systemFontOfSize:11];
            
            
            UILabel  *lable=[[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width-(8+80),9, 80, 30)];
            [cell addSubview:lable];
            lable.text=[NSString stringWithFormat:@"¥%@",_model.money];
            lable.textColor=[UIColor redColor];
            lable.textAlignment=NSTextAlignmentRight;
            lable.font=[UIFont systemFontOfSize:13];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
            
        }else{
            
            AllOrderTableViewCell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"AllOrderTableViewCell4"];
            if (!cell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"AllOrderTableViewCell4" bundle:nil] forCellReuseIdentifier:@"AllOrderTableViewCell4"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"AllOrderTableViewCell4"];
            }
            [cell setProperty:_model];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        
    }
    
  
      return nil;
    
    
   
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        if (indexPath.row!=0) {
            
            GoodsWebViewController *VC=[[GoodsWebViewController alloc]init];
            
            if ([_model.goods_info[indexPath.row-1][@"is_lucky"] integerValue]==1) {
                VC.lucky_id=_model.goods_info[indexPath.row-1][@"id"];
            }else if ([_model.goods_info[indexPath.row-1][@"is_lucky"] integerValue]==0){
            
                VC.bid_id=_model.goods_info[indexPath.row-1][@"id"];
            }
            
            //VC.titleName=@"物流信息";
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
        }
    }

}

- ( CGFloat )tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section

{
    
    return 0.01 ;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 10.0 ;

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)getDataForBill_view_URL:(NSMutableDictionary*)dic
{
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"uid"] = UID;
    parameters[@"token"] = TOKEN;
    parameters[@"id"] = dic[@"id"];
   
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:Bill_view_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         NSLog(@"订单详情%@",dict);
         NSDictionary *dic=dict[@"data"];
         
         
         
         _model = [[Bill_View alloc]initWithDictionary:dic error:nil];
         
         if (_model!=nil) {
             [_tableView reloadData];
         }else{
         
            
             
         }
         
         
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         
     }];
}

-(void)action1{

    GoodsWebViewController *VC=[[GoodsWebViewController alloc]init];
    VC.urlStr=_model.track_info[@"url"];
    VC.titleName=@"物流信息";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    
    

}


@end
