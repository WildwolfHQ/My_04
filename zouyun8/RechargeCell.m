#import "RechargeCell.h"

@interface RechargeCell()<UITextFieldDelegate>

@end

@implementation RechargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.otherMoneyTextField.delegate = self;
    [self.otherMoneyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (IBAction)二十:(id)sender {
    [self selectedState:sender];
    if([self.delegate respondsToSelector:@selector(changeRechargeNum:)])
    {
        [self.delegate changeRechargeNum:@"20"];
    }
}
- (IBAction)五十:(id)sender {
    [self selectedState:sender];
    if([self.delegate respondsToSelector:@selector(changeRechargeNum:)])
    {
        [self.delegate changeRechargeNum:@"50"];
    }
}
- (IBAction)一百:(id)sender {
    [self selectedState:sender];
    if([self.delegate respondsToSelector:@selector(changeRechargeNum:)])
    {
        [self.delegate changeRechargeNum:@"100"];
    }
}
- (IBAction)两百:(id)sender {
    [self selectedState:sender];
    if([self.delegate respondsToSelector:@selector(changeRechargeNum:)])
    {
        [self.delegate changeRechargeNum:@"200"];
    }
}
- (IBAction)五百:(id)sender {
    [self selectedState:sender];
    if([self.delegate respondsToSelector:@selector(changeRechargeNum:)])
    {
        [self.delegate changeRechargeNum:@"500"];
    }
}

-(void)selectedState:(UIButton *)sender
{
    for (UIButton * btn in self.contentView.subviews)
    {
        if (btn.tag < 100)
        {
            btn.selected = NO;
        }
    }
    self.otherMoneyTextField.text = nil;
    [self.otherMoneyTextField resignFirstResponder];
    sender.selected = YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if([self.delegate respondsToSelector:@selector(changeRechargeNum:)])
    {
        [self.delegate changeRechargeNum:textField.text];
    }
}

-(void)textFieldDidChange:(UITextField *)textField {
    if([self.delegate respondsToSelector:@selector(changeRechargeNum:)])
    {
        [self.delegate changeRechargeNum:textField.text];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    for (UIButton * btn in self.contentView.subviews)
    {
        if (btn.tag < 100)
        {
            btn.backgroundColor = [UIColor grayColor];
            btn.selected = NO;
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.otherMoneyTextField resignFirstResponder];
}

@end
