#import "InviteViewController.h"

@interface InviteViewController ()

@end

@implementation InviteViewController


-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *barbtn=[[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem=barbtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"二维码";
    [ToolClass getQrcode:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"url"]]];
        self.shareDict = [[NSMutableDictionary alloc]init];
        self.shareDict[@"image"] = dic[@"url"];
        [self.barcodeImageView sd_setImageWithURL:url completed:nil];
    }];
}

-(void)share
{
    [ToolClass share:self.shareDict];
}
@end
