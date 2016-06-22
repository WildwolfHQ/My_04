#import "LblTxtTableViewCell.h"

@interface LblTxtTableViewCell()<UITextFieldDelegate>

@end

@implementation LblTxtTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"点击了return");
    [self.textField resignFirstResponder];
    return YES;
}

@end
