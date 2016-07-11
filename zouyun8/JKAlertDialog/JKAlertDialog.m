//
//  JKAlertDialog.m
//  JKAlertDialog
//
//  Created by Jakey on 15/3/8.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "JKAlertDialog.h"


@implementation JKAlertDialog
- (instancetype)init{
    self = [super init];
    if (self) {
    
        
        [self buildViews];
    }
    return self;
}
-(void)buildViews{
    self.frame = [self screenBounds];
     _coverView = [[UIView alloc]initWithFrame:[self topView].bounds];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0;
    _coverView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [[self topView] addSubview:_coverView];
    
    _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentViewSize.width, self.contentViewSize.width)];
    _alertView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _alertView.layer.cornerRadius = 5;
    _alertView.layer.masksToBounds = YES;
    _alertView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_alertView];
  
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    [_alertView addSubview:_contentScrollView];
    _contentScrollView.userInteractionEnabled=YES;

    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
}
- (void)dealloc
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)layoutSubviews{
   
    _contentScrollView.frame = CGRectMake(0, 0, self.contentViewSize.width, self.contentViewSize.height);
    self.contentView.frame = CGRectMake(0,0,self.contentViewSize.width, self.contentViewSize.height);
    _contentScrollView.contentSize = self.contentView.frame.size;

}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    
    [_contentScrollView addSubview:self.contentView];
    [self reLayout];
}
-(void)reLayout{

    
    _alertView.frame = CGRectMake(_alertView.frame.origin.x, _alertView.frame.origin.y, self.contentViewSize.width, self.contentViewSize.height);
    _alertView.center = self.center;
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

#pragma mark - show and dismiss
-(UIView*)topView{
    window = [[UIApplication sharedApplication] keyWindow];
    //我们都知道UIWindow有三个层级，分别是Normal，StatusBar，Alert。打印输出他们三个这三个层级的值我们发现从左到右依次是0，1000，2000 .默认的window的level是0，即normal级别；AlertView的window的level是1996
    window.windowLevel=1;
    return  window.subviews[0];
}
- (void)show {
    [UIView animateWithDuration:0.5 animations:^{
        _coverView.alpha = 0.5;

    } completion:^(BOOL finished) {
        
    }];
    
    [[self topView] addSubview:self];
    [self showAnimation];
}

- (void)dismiss {
    //window.windowLevel=0;
    [self hideAnimation];
}

- (void)showAnimation {
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_alertView.layer addAnimation:popAnimation forKey:nil];
}

- (void)hideAnimation{
    [UIView animateWithDuration:0.4 animations:^{
        _coverView.alpha = 0.0;
        _alertView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
         window.windowLevel=0;
        [window removeFromSuperview];
        
    }];

    
}


#pragma mark - Handle device orientation changes
// Handle device orientation changes
- (void)deviceOrientationDidChange: (NSNotification *)notification
{
    //    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    self.frame = [self screenBounds];
    //NSLog(@"self.frame%@",NSStringFromCGRect(self.frame));
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         [self reLayout];
                     }
                     completion:nil
     ];
  

}
- (CGRect)screenBounds
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // On iOS7, screen width and height doesn't automatically follow orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }
    
    return CGRectMake(0, 0, screenWidth, screenHeight);
}
@end
