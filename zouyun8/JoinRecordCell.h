//
//  JoinRecordCell.h
//  zouyun8
//
//  Created by 郑浩 on 16/5/21.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *date;
-(void)setProperty:(NSDictionary *)dic;
@end
