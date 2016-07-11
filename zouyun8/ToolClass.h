#import <Foundation/Foundation.h>
#import "AddrDataModel.h"

@interface ToolClass : NSObject

+(void)savePersonalImageUrl:(NSString *)url;

//判断用户是否登录
+(BOOL)isUserLogined;

//登录成功后保存用户信息，token用于判断是否登录，其余显示。
+(void)saveUserInfo:(NSDictionary *)dict;

//网络状态判断方法
+(BOOL)isNetConnect;

//获取用户资金和奖励信息
+(NSDictionary *)getPayInfo:(void (^)(NSDictionary * dic))cb;

//二次登录获取用户信息
+(NSDictionary *)getUserInfoSuccess:(void (^)(NSDictionary *))cb;

//上传购物车订单信息
+(NSDictionary *)create_bill:(void (^)(NSDictionary *))cb order:(NSString *)json addressID:(NSString *)address is_discount:(NSString * )discount payID:(NSString *)payID payType:(NSString *)pay_type rechargeMoney:(NSString *)money app:(NSString *)is_app;

//获取到（微信，银联）支付所需参数
+(NSDictionary *)getPayParameter:(void (^)(NSDictionary  *))cb orderID:(NSString *)orderID payType:(NSString *)pay_type andApp:(NSString *)app;

//获取最新中奖消息
+(NSDictionary *)getLucky_notice:(void (^)(NSDictionary *dic))cb;

//获取已经开奖喇叭消息
+(NSDictionary *)getAlreadyNotice:(void (^)(NSDictionary *dic))cb;

//获取二维码图片
+(NSDictionary *)getQrcode:(void (^)(NSDictionary *dic))cb;

//清空购物车数据
+(void)removeAllCart;

//二维码，商品信息分享
+(void)share:(NSDictionary *)dict;

//商品搜索和分类界面数据
+(NSDictionary *)getSort:(void (^)(NSDictionary *dic))cb :(NSString *)strUrl;

//商品搜索和分类详情界面数据
+(NSDictionary *)getSortDetail:(void (^)(NSDictionary *dic))cb minPrice:(NSString *)min maxPrice:(NSString *)max page:(NSString *)page name:(NSString *)name category:(NSString *)categoryID urlStr:(NSString *)urlStr;

//首页商品排序
+(NSDictionary *)getRank:(void (^)(NSDictionary *dic))cb minPrice:(NSString *)min maxPrice:(NSString *)max page:(NSString *)page name:(NSString *)name category:(NSString *)category top:(NSString *)top type:(NSString *)type;

//获取发现页数据
+(NSDictionary *)getNewsList:(void (^)(NSDictionary *dic))cb ID:(NSString *)category_id;

//获取走运币明细
+(NSDictionary *)getMoney_log:(void (^)(NSDictionary *dic))cb type:(NSString *)type;

//获取公开的合购
+(NSDictionary *)getPub_lucky:(void (^)(NSDictionary *dic))cb page:(NSString *)page andTop:(NSString *)top;

//获取网友晒单
+(NSDictionary *)getEvaluate_all_list:(void (^)(NSDictionary *dic))cb page:(NSString *)page andID:(NSString *)ID;

//获取佣金明细
+(NSDictionary *)getComm_log:(void (^)(NSDictionary *dic))cb page:(NSString *)page;

//获取奖金明细
+(NSDictionary *)getScore_log:(void (^)(NSDictionary *dic))cb page:(NSString *)page;

//获取奖金明细
+(NSDictionary *)getScore_log:(void (^)(NSDictionary *dic))cb page:(NSString *)page;

//获取我的订单
+(NSDictionary *)getMyBill:(void (^)(NSDictionary *dic))cb page:(NSString *)page;

//删除收货地址
+(NSDictionary *)DelegateAddress_del:(void (^)(NSDictionary *dic))cb ID:(NSString *)addressID;

//编辑收货地址（将选中的地址设置为默认）
+(NSDictionary *)SetDefaultAddress:(void (^)(NSDictionary *dic))cb addressModel:(AddrDataModel *)model;

@end
