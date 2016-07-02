//
//  AlertDialogSubView.h
//  zouyun8
//
//  Created by 端正赵 on 16/7/1.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertDialogSubView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *dismissAlertBt;

@property (weak, nonatomic) IBOutlet UILabel *number1Lb;
@property (weak, nonatomic) IBOutlet UILabel *number2Lb;
@property (weak, nonatomic) IBOutlet UILabel *number3Lb;
@property (weak, nonatomic) IBOutlet UILabel *number4Lb;
@property (weak, nonatomic) IBOutlet UILabel *number5Lb;
@property (weak, nonatomic) IBOutlet UITextField *shuruTf;
@property (weak, nonatomic) IBOutlet UIButton *faqihegouBt;
@property (weak, nonatomic) IBOutlet UILabel *price1Lb;
@property (weak, nonatomic) IBOutlet UILabel *price2Lb;
@property (weak, nonatomic) IBOutlet UILabel *price3Lb;

@property (weak, nonatomic) IBOutlet UILabel *price4Lb;
@property (weak, nonatomic) IBOutlet UILabel *price5Lb;
@property (weak, nonatomic) IBOutlet UILabel *price6Lb;
- (IBAction)selectBt:(UIButton *)sender;

@property (strong, nonatomic) NSString *selectedNumber;
@property (strong, nonatomic) NSString *selectedPrice;
@property (weak, nonatomic) IBOutlet UILabel *tishi1;
@property (weak, nonatomic) IBOutlet UILabel *tishi2;
-(void)setdata:(NSArray *)array addPrice:(NSString *)price addArray1:(NSArray *)array1;
@property (strong, nonatomic) NSString *price1;

@property (weak, nonatomic) IBOutlet UIButton *canyugongkaihegouBt;
@property (weak, nonatomic) IBOutlet UILabel *countPriceLb;

@property (weak, nonatomic) IBOutlet UILabel *suanfaLb;
@end
