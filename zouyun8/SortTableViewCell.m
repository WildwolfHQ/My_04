#import "SortTableViewCell.h"

@implementation SortTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)SelectSection:(id)sender {
    //点击了选择价格区间按钮后，代理方式弹出提示框
    if ([self.delegate respondsToSelector:@selector(SelectSection:)]) {
        [self.delegate SelectSection:self.model];
    }
}

@end
