#import "AddrListTableViewCell.h"

@implementation AddrListTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
- (IBAction)switchBtn:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn)
    {
        //将开关打开的该地址设置为默认，发送数据给后台并刷新表格
        if ([self.delegate respondsToSelector:@selector(setDefaultAddress:)]) {
            [self.delegate setDefaultAddress:[self getIndexPath]];
        }
    }
}

- (IBAction)deleteAddress:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteAddress:)]) {
        NSIndexPath * index = [self getIndexPath];
        [self.delegate deleteAddress:index];
    }
}

- (NSIndexPath *)getIndexPath
{
    //IOS7 OR LATER AVALIABLE
    UITableView *tableView = (UITableView *)self.superview.superview;
    return [tableView indexPathForCell:self];
}
@end
