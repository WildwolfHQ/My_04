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

////cell.m 中重写prepareForReuse方法
//- (void)prepareForReuse
//{
//    [super prepareForReuse];
//    
//    // 重置image
//    self.image.image = nil;
//    
//    // 更新位置
//    self.image.frame = self.contentView.bounds;
//}
@end
