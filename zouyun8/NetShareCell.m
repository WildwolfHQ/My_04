#import "NetShareCell.h"

@interface NetShareCell()
@end

@implementation NetShareCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setCellWithModel:(NetShareModel *)model
{
    self.image1.hidden = NO;
    self.image2.hidden = NO;
    self.image3.hidden = NO;
    self.image4.hidden = NO;
    self.image5.hidden = NO;
    
    [self.personalImage sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"star"]];
    self.nickName.text = model.username;
    self.createTime.text = model.create_time;
    self.title.text = model.name;
    self.content.text = model.title;
    
    
    NSData * data = [model.images dataUsingEncoding:NSASCIIStringEncoding];
    NSMutableArray * array = [self toArrayOrNSDictionary:data];
    NSLog(@"当前个数为%ld",array.count);
    NSLog(@"数组为%@",array);
    if (self.count == 1)
    {
        self.image2.hidden = YES;
        self.image3.hidden = YES;
        self.image4.hidden = YES;
        self.image5.hidden = YES;
        
        [self.image1 sd_setImageWithURL:[NSURL URLWithString:array[0]]];
        //为图像增加点击事件
        [self.image1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageBtn1)]];
    }
    if (self.count == 2)
    {
        self.image3.hidden = YES;
        self.image4.hidden = YES;
        self.image5.hidden = YES;
        
        [self.image1 sd_setImageWithURL:[NSURL URLWithString:array[0]]];
        [self.image2 sd_setImageWithURL:[NSURL URLWithString:array[1]]];
        
        [self.image1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageBtn1)]];
        [self.image2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageBtn2)]];
    }
    if (self.count == 3)
    {
        self.image4.hidden = YES;
        self.image5.hidden = YES;
        
        [self.image1 sd_setImageWithURL:[NSURL URLWithString:array[0]]];
        [self.image2 sd_setImageWithURL:[NSURL URLWithString:array[1]]];
        [self.image3 sd_setImageWithURL:[NSURL URLWithString:array[2]]];
        [self.image1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageBtn1)]];
        [self.image2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageBtn2)]];
        [self.image3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageBtn3)]];
    }
    if (self.count == 4)
    {
        self.image5.hidden = YES;
        
        [self.image1 sd_setImageWithURL:[NSURL URLWithString:array[0]]];
        [self.image2 sd_setImageWithURL:[NSURL URLWithString:array[1]]];
        [self.image3 sd_setImageWithURL:[NSURL URLWithString:array[2]]];
        [self.image4 sd_setImageWithURL:[NSURL URLWithString:array[3]]];
        
        [self.image1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageBtn1)]];
        [self.image2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageBtn2)]];
        [self.image3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageBtn3)]];
        [self.image4 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageBtn4)]];
    }
    if (self.count == 5 || self.count > 5)
    {
        [self.image1 sd_setImageWithURL:[NSURL URLWithString:array[0]]];
        [self.image2 sd_setImageWithURL:[NSURL URLWithString:array[1]]];
        [self.image3 sd_setImageWithURL:[NSURL URLWithString:array[2]]];
        [self.image4 sd_setImageWithURL:[NSURL URLWithString:array[3]]];
        [self.image5 sd_setImageWithURL:[NSURL URLWithString:array[4]]];
        
        [self.image1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageBtn1)]];
        [self.image2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageBtn2)]];
        [self.image3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageBtn3)]];
        [self.image4 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageBtn4)]];
        [self.image5 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageBtn5)]];
    }
}

-(void)ImageBtn1
{
    NSLog(@"点击第一张");
    if ([self.delegate respondsToSelector:@selector(showBigImage:andCount:)]) {
        [self.delegate showBigImage:self.imagesArray andCount:0];
    }
}
-(void)ImageBtn2
{
    NSLog(@"点击第2张");

    if ([self.delegate respondsToSelector:@selector(showBigImage:andCount:)]) {
        [self.delegate showBigImage:self.imagesArray andCount:1];
    }
}
-(void)ImageBtn3
{
    NSLog(@"点击第3张");

    NSLog(@"崩溃的数组%@",self.imagesArray);
    if ([self.delegate respondsToSelector:@selector(showBigImage:andCount:)]) {
        [self.delegate showBigImage:self.imagesArray andCount:2];
    }
}
-(void)ImageBtn4
{
    NSLog(@"点击第4张");

    if ([self.delegate respondsToSelector:@selector(showBigImage:andCount:)]) {
        [self.delegate showBigImage:self.imagesArray andCount:3];
    }
}
-(void)ImageBtn5
{
    NSLog(@"点击第5张");

    if ([self.delegate respondsToSelector:@selector(showBigImage:andCount:)]) {
        [self.delegate showBigImage:self.imagesArray andCount:4];
    }
}

- (id)toArrayOrNSDictionary:(NSData *)jsonData
{
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    if (jsonObject != nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

@end
