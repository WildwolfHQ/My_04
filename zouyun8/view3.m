#import "view3.h"

@implementation view3

-(void)setData:(NSMutableArray *)names andPrizes:(NSMutableArray *)prizes and:(NSMutableArray *)mutArr
{
    
    [mutArr removeAllObjects];
    for (int i = 0; i < names.count; i ++) {
        NoticeModel *notice = [[NoticeModel alloc] init];
        notice.nickname = names[i];
        notice.title = prizes[i];
        [mutArr addObject:notice];
    }
    __mutArr=mutArr;
    [self creatView];
    [self createNoticeView];
}

- (void)creatView
{
    //如果用代码手写scrollUpView的frame直接用下面初始化方法，
    //    _scrollUpView = [[ScrollUpView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 36)];
    
    //xib设置scrollUpView需要调用createUI方法
   
    
    //scrollUpView点击回调
//    _scrollUpView.clickBlock = ^(NSInteger index){
//        if (__mutArr.count!=0) {
//            NoticeModel *noticeModel = __mutArr[index];
//        }
//        
//       // NSLog(@"恭喜%@获得了%@",noticeModel.nickname,noticeModel.title);
//        //这里跳转到商品详情
//        //[SVProgressHUD showSuccessWithStatus:@"跳转到商品详情"];
//        
//    };
}

- (void)createNoticeView
{
    
    [_datas removeAllObjects];
    for (NoticeModel *noticeModel in __mutArr) {
        NSString *noticeStr = [NSString stringWithFormat:@"恭喜%@获得了%@",noticeModel.nickname,noticeModel.title];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:noticeStr];
        
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"3591f5"] range:NSMakeRange(2,noticeModel.nickname.length)];
        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"333333"] range:NSMakeRange(5+noticeModel.nickname.length,noticeModel.title.length)];
        [_datas addObject:attString];
    }
    
    //设置scrollUpView数据源
    //_scrollUpView=nil;
    [_scrollUpView setScrollUpViewDatas:_datas];
}


- (void)layoutSubviews{
 _datas=[NSMutableArray array];
     [_scrollUpView createUI];
}
- (void)dealloc
{
    [_scrollUpView stopTimer];
}
@end
