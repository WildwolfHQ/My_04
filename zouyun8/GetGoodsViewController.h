//
//  GetGoodsViewController.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/20.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetGoodsViewController :UIViewController
-(void)getDataForMylucky_URL:(NSMutableDictionary*)dic andPage:(NSString *)page isRefresh:(BOOL)refresh;
@end
