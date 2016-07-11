//
//  AnnounceTableViewCell1.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/4.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "AnnounceTableViewCell1.h"
@interface AnnounceTableViewCell1 ()



@property (nonatomic, weak)   id           m_data;
@property (nonatomic, weak)   NSIndexPath *m_tmpIndexPath;
@property (nonatomic, strong) NSMutableArray *m_dataArray;
@property (nonatomic, strong) NSTimer *m_timer;

//@property (nonatomic, weak) NSIndexPath *m_indexPath;



@end
@implementation AnnounceTableViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    [self registerNSNotificationCenter];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadData:(id)data indexPath:(NSIndexPath *)indexPath m_dataArray:(NSMutableArray *)dataArray :(NSTimer *)timer{
    
//         //判断定时器是否有效或是否为空
//        if (!timer.isValid||timer==nil) {
//            return;
//        }
    
    
        TimeModel *model = data;
        [self storeWeakValueWithData:model indexPath:indexPath m_dataArray:dataArray :timer];
         if ([self.timesLable.text isEqualToString:@""]) {
            return;
         }
        self.timesLable.text  = [NSString stringWithFormat:@"%@",[model currentTimeString]];
    
    
    
        if ([self.timesLable.text isEqualToString:@"00:00:00"]) {
            
            self.timesLable.text=@"";

            
            Lucky_noticeModel * model1=dataArray[indexPath.row];
            
            [self getData:model1.hg_id  :self];

          
            
        
        }else{
         Lucky_noticeModel * model1=dataArray[indexPath.row];
            self.timesLable.hidden=NO;
            self.jiexiaotudatu.hidden=NO;
            self.jiexiaoname.hidden=NO;
            self.faqizheName.hidden=NO;
            
            [self.jiexiaotudatu setImage:[UIImage imageNamed:@"times"]];
            
            self.jiexiaoname.text=@"即将揭晓";
            self.faqizheName.text=[NSString stringWithFormat:@"发起者:%@",model1.username];
            //数据
            self.xinyunname2.hidden=YES;
            self.xinyunma2name.hidden=YES;
            self.xiaoliang2name.hidden=YES;
            self.times2Lable.hidden=YES;
            //
            
            self.xinyunxing1.hidden=YES;
            self.xiaoliang2.hidden=YES;
            self.xinyunhao2.hidden=YES;
            self.timetuxiaotu.hidden=YES;
            self.jiexiaotimes.hidden=YES;
            self.kaijinagzhongLb.hidden=YES;


        
        
        }

    
}
- (void)storeWeakValueWithData:(id)data indexPath:(NSIndexPath *)indexPath m_dataArray:(NSMutableArray *)dataArray :(NSTimer *)timer{
    
    self.m_data         = data;
    self.m_tmpIndexPath = indexPath;
    self.m_dataArray=dataArray;
    self.m_timer=timer;
}


- (void)dealloc {
    
    [self removeNSNotificationCenter];
}

#pragma mark - 通知中心
- (void)registerNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEvent:)
                                                 name:NOTIFICATION_TIME_CELL
                                               object:self.m_timer];
}

- (void)removeNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_TIME_CELL object:self.m_timer];
}

- (void)notificationCenterEvent:(id)sender {
    
    if (self.m_isDisplayed) {
        [self loadData:self.m_data indexPath:self.m_tmpIndexPath m_dataArray:self.m_dataArray :self.m_timer];
    }
}


-(void) setProperty:(Lucky_noticeModel *)model{
    
     self.naem.text=model.name;
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    
    
    
    
}


#pragma mark - 获取商品数据
-(void)getData:(NSString *)lucky_id   :(AnnounceTableViewCell1 *) cell
{
    
    
//    NSString *nowTimeInterval=[NSString stringWithFormat:@"%f",[self getNowTimeInterval]+3600];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
//    if (time==nil) {
//        params[@"time"] =nowTimeInterval;
//    }else{
//        params[@"time"] =time;
//        
//    }
//    params[@"uid"] = UID;
    params[@"lucky_id"] = lucky_id;
    
    
    
    
   AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.validatesDomainName = NO;
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    [manager GET:Lucky_view_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"进来了");
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         
         NSLog(@"%@",dict);
         NSDictionary * dict1 = dict[@"data"];
         //请求成功,将图片下载完保存到数组中
         
        
         
        
             HG_XiangGing * model = [[HG_XiangGing alloc]initWithDictionary: dict1 error:nil];
         
          if (model.lucky_code.integerValue==0) {
              cell.faqizheName.hidden=YES;
              cell.timesLable.hidden=YES;
              cell.jiexiaotudatu.hidden=YES;
              cell.jiexiaoname.hidden=YES;
              //数据
              cell.xinyunname2.hidden=YES;
              cell.xinyunma2name.hidden=YES;
              cell.xiaoliang2name.hidden=YES;
              cell.times2Lable.hidden=YES;
              //
              
              cell.xinyunxing1.hidden=YES;
              cell.xiaoliang2.hidden=YES;
              cell.xinyunhao2.hidden=YES;
              cell.timetuxiaotu.hidden=YES;
              cell.jiexiaotimes.hidden=YES;
              
              cell.kaijinagzhongLb.hidden=NO;
              //self.timesLable.text=nil;
              //[self getData:lucky_id :cell];
//              cell.textLabel.text=@"开奖中...";
              
          }else{
             cell.faqizheName.hidden=YES;
             cell.timesLable.hidden=YES;
             cell.jiexiaotudatu.hidden=YES;
             cell.jiexiaoname.hidden=YES;
             cell.kaijinagzhongLb.hidden=YES;
             
             
             
             
             //数据
             cell.xinyunname2.hidden=NO;
             cell.xinyunma2name.hidden=NO;
             cell.xiaoliang2name.hidden=NO;
             cell.times2Lable.hidden=NO;
             //
             
             cell.xinyunxing1.hidden=NO;
             cell.xiaoliang2.hidden=NO;
             cell.xinyunhao2.hidden=NO;
             cell.timetuxiaotu.hidden=NO;
             cell.jiexiaotimes.hidden=NO;
             //数据
         
             cell.xinyunname2.text=model.lucky_username;
             cell.xinyunma2name.text=model.lucky_code;
             cell.xiaoliang2name.text=model.lucky_buynum;
             cell.times2Lable.text=model.lucky_time;
             //
             
             cell.xinyunxing1.text=@"幸运星:";
             cell.xiaoliang2.text=@"购买量:";
             cell.xinyunhao2.text=@"幸运号:";
             [cell.timetuxiaotu setImage:[UIImage imageNamed:@"times"]];
              cell.jiexiaotimes.text=@"揭晓时间";
          }

             
         UIFont *font;
         if (iPhone5) {
             
             if (cell.jiexiaotimes.text.length>5) {
                 font= [UIFont systemFontOfSize:10];
             }else{
                 
                 font= [UIFont systemFontOfSize:12];
             }
             
             
         }
         else if (iPhone6) {
             
             font= [UIFont systemFontOfSize:12];
         }
         else if(iPhone6_plus)
         {
             
             
             font= [UIFont systemFontOfSize:12];
         }
         else if(iPhone4)
         {
             //4
             
             if (cell.jiexiaotimes.text.length>5) {
                 font= [UIFont systemFontOfSize:10];
             }else{
                 
                 font= [UIFont systemFontOfSize:12];
             }

         }else{
         
             if (cell.jiexiaotimes.text.length>5) {
                 font= [UIFont systemFontOfSize:10];
             }else{
                 
                 font= [UIFont systemFontOfSize:12];
             }

         
         }
         
         cell.jiexiaotimes.font=font;
         CGSize size = [cell.jiexiaotimes.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:cell.jiexiaotimes.font,NSFontAttributeName, nil]];
         // 名字的H
         CGFloat nameH = size.height;
         // 名字的W
         CGFloat nameW = size.width;
         
         
         cell.jiexiaotimes.frame =CGRectMake(self.jiexiaotimes.frame.origin.x, cell.jiexiaotimes.frame.origin.y,nameW,nameH);
       
         
         
         
         
        
         
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
     }];
}


@end
