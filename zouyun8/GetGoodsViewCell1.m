//
//  GetGoodsViewCell1.m
//  zouyun8
//
//  Created by 端正赵 on 16/7/4.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "GetGoodsViewCell1.h"
#import "GoodsWebViewController.h"
@implementation GetGoodsViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    self.querenshouhuoBt.layer.cornerRadius=4;
    self.chakanwuliuBt.layer.cornerRadius=4;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) setProperty:(Mylucky *)model and:(GetGoodsViewController *)getGoodsViewController{
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    
    self.name.text=model.name;
    self.price.text=[NSString stringWithFormat:@"价格:%@",model.money];
    self.times.text=[NSString stringWithFormat:@"获得的时间:%@",model.create_time];
    self.statas.text=[NSString stringWithFormat:@"状态:%@",model.status];
    self.wuliuname.text=[NSString stringWithFormat:@"物流公司:%@",model.track_name];
    self.wuliudanhao.text=[NSString stringWithFormat:@"物流号:%@",model.track_num];
 
    if ([model.status isEqualToString:@"已发货"]) {
         self.querenshouhuoBt.hidden=NO;
    }else{
       self.querenshouhuoBt.hidden=YES;
    }
   
    self.model=model;
    self.getGoodsViewController=getGoodsViewController;
  
    
}

- (IBAction)querenshouhuoBt:(UIButton *)sender {
    
    
    [self getDataForConfirm_bill_URL:self.model.ID andButton:sender];
}

- (IBAction)chakanwuliuBt:(UIButton *)sender {
    
    GoodsWebViewController *VC=[[GoodsWebViewController alloc]init];
    VC.urlStr=self.model.track_url;
    VC.titleName=@"物流信息";
    self.getGoodsViewController.hidesBottomBarWhenPushed = YES;
    [self.getGoodsViewController.navigationController pushViewController:VC animated:YES];
}

-(void)getDataForConfirm_bill_URL:(NSString*)ID andButton:(UIButton *)sender;
{
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
    parameters[@"uid"] = UID;
    parameters[@"token"] = TOKEN;
    parameters[@"id"] = ID;
    
    
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    //__weak  GetGoodsViewController *weakSelf =self.getGoodsViewController;
    [manager GET:@"https://m.zouyun8.com/api/confirm_bill" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
  
         NSNumber *errcode=dict[@"errcode"];
         if (errcode.integerValue==0) {
             sender.hidden=YES;
             self.model.status=@"已完成";
             self.statas.text=[NSString stringWithFormat:@"状态:%@",self.model.status];
             
            //[weakSelf getDataForMylucky_URL:nil andPage:nil isRefresh:YES];
             
         }else{
         
         
         }
       
         
         
         
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         
     }];
}

@end
