#import <UIKit/UIKit.h>
#import "AddrDataModel.h"
#import "MyTableView.h"

@interface AddDetailAddressController : UIViewController
@property (nonatomic, strong) UIPickerView * pickerView;

@property (nonatomic, strong) NSArray * arrayDS;

@property (nonatomic,strong)NSString * editOrAdd;
@property (nonatomic,strong)NSString * addressID;
@property (weak, nonatomic) IBOutlet UIButton *baocunBt;
@end
