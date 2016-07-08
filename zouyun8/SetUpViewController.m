//
//  SetUpViewController.m
//  zouyun8
//
//  Created by 端正赵 on 16/6/16.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "SetUpViewController.h"
#import "ModifyPasswordViewController.h"
#import "GoodsWebViewController.h"
@interface SetUpViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SetUpViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置";
    [self drawTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)drawTableView{
    UITableView *tview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [tview setDelegate:self];
    [tview setDataSource:self];
    [self.view addSubview:tview];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==3){
    
        return 50;
    }
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

    
    
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==3) {
    
        UITableViewCell*cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellkk"];
        FooterView * footerview1 = [[NSBundle mainBundle]loadNibNamed:@"FooterView" owner:self
                                                              options:nil].firstObject;
        footerview1.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
        
        [cell addSubview:footerview1];
        cell.userInteractionEnabled=NO;
        
        return cell;

    }
    
    
    NSInteger section = indexPath.section;
    //NSInteger row = indexPath.row;
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel  *lable;
        
     
        switch (section) {
                
            
            case 0:
                cell.textLabel.text =  @"安全设置";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 1:
                cell.textLabel.text =  @"版本信息";
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                lable =[[UILabel alloc]init];
                lable.frame=CGRectMake(cell.frame.size.width-(8+80),9, 80, 30);
                [cell addSubview:lable];
                lable.textAlignment=NSTextAlignmentRight;
                lable.font=[UIFont systemFontOfSize:17];

                
                lable.text=APP_Version;
                
                break;
            case 2:
                cell.textLabel.text =  @"关于我们";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
          
            default:
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
         ModifyPasswordViewController *VC=[[ModifyPasswordViewController alloc]init];
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
       
    
    
        
    }else if(indexPath.section==1){
    
    
    
    }else{
    
        
        GoodsWebViewController *VC=[[GoodsWebViewController alloc]init];
        
        //    dic[@"url"]=model;
        //    dic[@"desc"];
        VC.urlStr=@"http://m.zouyun8.com/a/article/3501050422";
        VC.titleName=@"关于我们";
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];

    
    }
    
    
    
}


- ( CGFloat )tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section

{
    
    return 0.01 ;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section==2){
        return 0.00001;
    }
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

@end
