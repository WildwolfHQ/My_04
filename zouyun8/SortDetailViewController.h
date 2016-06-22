//
//  SortDetailViewController.h
//  zouyun8
//
//  Created by 郑浩 on 16/5/30.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortDetailViewController : UIViewController
@property(nonatomic,copy)NSString * min_price;
@property(nonatomic,copy)NSString * max_price;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * name1;
@property(nonatomic,strong)NSString * categoryID;
@property(nonatomic,strong)NSString * urlStr;
@property(nonatomic,strong)NSString * isPG;

@property (nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray * dataSource;
@property(nonatomic,assign)NSInteger page;
@end

