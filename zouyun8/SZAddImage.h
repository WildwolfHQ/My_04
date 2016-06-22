//
//  SZAddImage.h
//  zouyun8
//
//  Created by 端正赵 on 16/6/21.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZAddImage : UIView
 @property (nonatomic, strong) NSMutableArray *images;
 @property (atomic, assign) CGFloat  theimageW;

 #define imageH 60.0 // 图片高度
 #define imageW 60.0 // 图片宽度
 #define kMaxColumn 4 // 每行显示数量
 #define MaxImageCount 6 // 最多显示图片个数
 #define deleImageWH 25 // 删除按钮的宽高
 #define kAdeleImage @"close.png" // 删除按钮图片
 #define kAddImage @"mine_upload_add" // 添加按钮图片
@end
