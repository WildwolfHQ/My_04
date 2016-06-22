//
//  view2.m
//  zouyun8
//
//  Created by 郑浩 on 16/4/21.
//  Copyright © 2016年 com.bolebrother.zouyun8. All rights reserved.
//

#import "view2.h"

@implementation view2
- (IBAction)红包:(id)sender {
    if([self.delegate respondsToSelector:@selector(pushToType:)])
    {
        [self.delegate pushToType:1];
    }
}
- (IBAction)抽奖:(id)sender {
    if([self.delegate respondsToSelector:@selector(pushToType:)])
    {
        [self.delegate pushToType:2];
    }
}
- (IBAction)揭晓:(id)sender {
    if([self.delegate respondsToSelector:@selector(pushToType:)])
    {
        [self.delegate pushToType:3];
    }
}

- (IBAction)帮助:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(pushToType:)])
    {
        [self.delegate pushToType:4];
    }
}


@end
