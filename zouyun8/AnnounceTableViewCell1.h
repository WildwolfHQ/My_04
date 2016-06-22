//
//  AnnounceTableViewCell1.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/4.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>
#define NOTIFICATION_TIME_CELL  @"NotificationTimeCell"
@interface AnnounceTableViewCell1 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timesLable;

- (void)loadData:(id)data indexPath:(NSIndexPath *)indexPath m_dataArray:(NSMutableArray *)dataArray :(NSTimer *)timer;
@property (nonatomic)       BOOL         m_isDisplayed;
@property (weak, nonatomic) IBOutlet UILabel *naem;
@property (weak, nonatomic) IBOutlet UIImageView *image;
-(void) setProperty:(Lucky_noticeModel *)model;
@property (weak, nonatomic) IBOutlet UILabel *jiexiaoname;
@property (weak, nonatomic) IBOutlet UIImageView *jiexiaotudatu;
@property (weak, nonatomic) IBOutlet UILabel *jiexiaotimes;
@property (weak, nonatomic) IBOutlet UILabel *times2Lable;
@property (weak, nonatomic) IBOutlet UIImageView *timetuxiaotu;
@property (weak, nonatomic) IBOutlet UILabel *xinyunxing1;
@property (weak, nonatomic) IBOutlet UILabel *xiaoliang2;
@property (weak, nonatomic) IBOutlet UILabel *xinyunhao2;
@property (weak, nonatomic) IBOutlet UILabel *xinyunname2;
@property (weak, nonatomic) IBOutlet UILabel *xiaoliang2name;
@property (weak, nonatomic) IBOutlet UILabel *xinyunma2name;
@end
