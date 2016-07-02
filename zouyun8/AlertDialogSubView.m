//
//  AlertDialogSubView.m
//  zouyun8
//
//  Created by 端正赵 on 16/7/1.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "AlertDialogSubView.h"

@implementation AlertDialogSubView
-(void)setdata:(NSArray *)array addPrice:(NSString *)price addArray1:(NSArray *)array1{

    
    self.price1=price;
    self.countPriceLb.text=[NSString stringWithFormat:@"商品总价:%@",price];

    self.number1Lb.text=array[0];
    self.number2Lb.text=array[1];
    self.number3Lb.text=array[2];
    self.number4Lb.text=array[3];
    self.number5Lb.text=[array lastObject];
    
    if (array1.count!=0) {
        self.price1Lb.text=[NSString stringWithFormat:@"¥:%d",[array1[0] intValue]];
        self.price2Lb.text=[NSString stringWithFormat:@"¥:%d",[array1[1] intValue]];
        self.price3Lb.text=[NSString stringWithFormat:@"¥:%d",[array1[2] intValue]];
        self.price4Lb.text=[NSString stringWithFormat:@"¥:%d",[array1[3] intValue]];
        self.price5Lb.text=[NSString stringWithFormat:@"¥:%d",[array1[4] intValue]];

        
    }else{
    
    
    
    self.price1Lb.text=[NSString stringWithFormat:@"¥:%d",price.intValue/self.number1Lb.text.intValue];
    self.price2Lb.text=[NSString stringWithFormat:@"¥:%d",price.intValue/self.number2Lb.text.intValue];
    self.price3Lb.text=[NSString stringWithFormat:@"¥:%d",price.intValue/self.number3Lb.text.intValue];
    self.price4Lb.text=[NSString stringWithFormat:@"¥:%d",price.intValue/self.number4Lb.text.intValue];
    self.price5Lb.text=[NSString stringWithFormat:@"¥:%d",price.intValue/self.number5Lb.text.intValue];
    }
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (IBAction)selectBt:(UIButton *)sender {
    [self endEditing:YES];
    self.shuruTf.text=@"";
    self.price6Lb.text=@"¥:";
    switch (sender.tag) {
        case 0:
            self.number1Lb.textColor=[UIColor redColor];
            self.number2Lb.textColor=[UIColor blackColor];
            self.number3Lb.textColor=[UIColor blackColor];
            self.number4Lb.textColor=[UIColor blackColor];
            self.number5Lb.textColor=[UIColor blackColor];
            self.selectedNumber=self.number1Lb.text;
            self.selectedPrice=self.price1Lb.text;
            
            
            break;
        case 1:
            
            self.number2Lb.textColor=[UIColor redColor];
            self.number1Lb.textColor=[UIColor blackColor];
            self.number3Lb.textColor=[UIColor blackColor];
            self.number4Lb.textColor=[UIColor blackColor];
            self.number5Lb.textColor=[UIColor blackColor];
            self.selectedNumber=self.number2Lb.text;
            self.selectedPrice=self.price2Lb.text;
            break;
        case 2:
            
            self.number3Lb.textColor=[UIColor redColor];
            self.number2Lb.textColor=[UIColor blackColor];
            self.number1Lb.textColor=[UIColor blackColor];
            self.number4Lb.textColor=[UIColor blackColor];
            self.number5Lb.textColor=[UIColor blackColor];
            self.selectedNumber=self.number3Lb.text;
            self.selectedPrice=self.price3Lb.text;
            break;
        case 3:
            self.number4Lb.textColor=[UIColor redColor];
            self.number2Lb.textColor=[UIColor blackColor];
            self.number3Lb.textColor=[UIColor blackColor];
            self.number1Lb.textColor=[UIColor blackColor];
            self.number5Lb.textColor=[UIColor blackColor];
            self.selectedNumber=self.number4Lb.text;
            self.selectedPrice=self.price4Lb.text;
            break;
        case 4:
            
            self.number5Lb.textColor=[UIColor redColor];
            self.number2Lb.textColor=[UIColor blackColor];
            self.number3Lb.textColor=[UIColor blackColor];
            self.number4Lb.textColor=[UIColor blackColor];
            self.number1Lb.textColor=[UIColor blackColor];
            self.selectedNumber=self.number5Lb.text;
            self.selectedPrice=self.price5Lb.text;
            break;
            
        default:
            break;
    }
    
    
    self.suanfaLb.text=[NSString stringWithFormat:@"%@元X%@人次",self.selectedPrice,self.selectedNumber];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    [self endEditing:YES];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    self.number1Lb.textColor=[UIColor blackColor];
    self.number2Lb.textColor=[UIColor blackColor];
    self.number3Lb.textColor=[UIColor blackColor];
    self.number4Lb.textColor=[UIColor blackColor];
    self.number5Lb.textColor=[UIColor blackColor];

  [textField addTarget:self action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
   
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    

  
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;{
    

       
    return YES;

}
- (void)textFieldDidEndEditing:(UITextField *)textField{

    
    self.selectedNumber=textField.text;
    
    self.selectedPrice=self.price6Lb.text;
    self.suanfaLb.text=[NSString stringWithFormat:@"%@元X%@人次",self.selectedPrice,self.selectedNumber];
    
}
-(void)valueChanged:(UITextField *)textField{

    if (textField.text.intValue!=0) {
        
        if (textField.text.intValue>self.number5Lb.text.intValue||textField.text.intValue<self.number1Lb.text.intValue) {
            
            
            
//            if(textField.text.intValue>self.number5Lb.text.intValue){
//             self.price6Lb.text=[NSString stringWithFormat:@"¥:%d",[self.price5Lb.text substringFromIndex:2].intValue];
//            
//            }else{
//            
//               self.price6Lb.text=[NSString stringWithFormat:@"¥:%d",[self.price1Lb.text substringFromIndex:2].intValue];
//            }
            if(textField.text.intValue>self.number5Lb.text.intValue){
                textField.text=[NSString stringWithFormat:@"%d",self.number5Lb.text.intValue];
                
            }else{
                
                textField.text=[NSString stringWithFormat:@"%d",self.number1Lb.text.intValue];
            }

            
//            return ;
        }

        
        int m;
        if (self.price1.intValue%textField.text.intValue!=0) {
            m= self.price1.intValue/textField.text.intValue + 1;
        }else{
            
            m= self.price1.intValue/textField.text.intValue;
        }
        self.price6Lb.text=[NSString stringWithFormat:@"¥:%d",m];
    }else{
        self.price6Lb.text=@"¥:";
    }
    
    self.selectedNumber=textField.text;
    
    self.selectedPrice=self.price6Lb.text;
     self.suanfaLb.text=[NSString stringWithFormat:@"%@元X%@人次",self.selectedPrice,self.selectedNumber];
}
@end
