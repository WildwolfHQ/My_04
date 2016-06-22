#import "AllOrderCell.h"

@implementation AllOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setCellWithModel:(AllOrderModel *)model
{
    self.orderNum.text = model.ID;
    self.status.text = model.status;
    NSArray * array  = model.remark;
    
    NSString * thumb = array[0][@"thumb"];
    NSURL * url = [NSURL URLWithString:thumb];
    [self.image sd_setImageWithURL:url];
    
    self.title.text = array[0][@"name"];
    self.money.text = [NSString stringWithFormat:@"%@元",array[0][@"money"]];
    self.realMoney.text = [NSString stringWithFormat:@"%@元",model.money];
    self.num.text = @"共1件商品";
}

@end
