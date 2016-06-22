#import "BigImageViewController.h"

@interface BigImageViewController ()<UIScrollViewDelegate>
{
    CGFloat offset;
}
@property(nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, retain) UIScrollView *imageScrollView;
@property float scale_;

@end

@implementation BigImageViewController
@synthesize imageScrollView;
@synthesize scale_;

- (void)viewDidLoad {

    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    offset = 0.0;
    scale_ = 1.0;
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.imageScrollView.contentSize = CGSizeMake(WIDTH * self.images.count, 0);
    self.imageScrollView.backgroundColor = [UIColor clearColor];
    self.imageScrollView.scrollEnabled = YES;
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.delegate = self;
    self.imageScrollView.bounces = NO;
    self.imageScrollView.contentSize = CGSizeMake(WIDTH*self.images.count, 0);
    
    [self createUI];
}

-(void)createUI
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.scrollView.contentSize = CGSizeMake(WIDTH * self.images.count, 0);
    for (int i = 0; i < self.images.count; i ++) {
        
        UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        
        UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];
        [Tap setNumberOfTapsRequired:1];
        
        
        UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, HEIGHT)];
        s.backgroundColor = [UIColor clearColor];
        s.contentSize = CGSizeMake(WIDTH, HEIGHT);
        s.showsHorizontalScrollIndicator = NO;
        s.showsVerticalScrollIndicator = NO;
        s.bounces = NO;
        s.pagingEnabled = NO;
        s.delegate = self;
        s.minimumZoomScale = 1.0;
        s.maximumZoomScale = 3.0;
        s.tag = i+1;
        [s setZoomScale:1.0];

        
        
        
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.images[i]]]]];
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH * i, 0 , WIDTH, HEIGHT)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        imageView.image = image;
        imageView.tag = i+1;
        [imageView addGestureRecognizer:doubleTap];
        [imageView addGestureRecognizer:Tap];
        
        [Tap requireGestureRecognizerToFail:doubleTap];

        [s addSubview:imageView];

        [self.imageScrollView addSubview:s];
    }
    
    [self.view addSubview:self.imageScrollView];
}
#pragma mark - ScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.imageScrollView){
        CGFloat x = scrollView.contentOffset.x;
        if (x==offset){
            
        }
        else {
            offset = x;
            for (UIScrollView *s in scrollView.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0];
                    UIImageView *image = [[s subviews] objectAtIndex:0];
                    image.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
                }
            }
        }
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    NSLog(@"Did zoom!");
    UIView *v = [scrollView.subviews objectAtIndex:0];
    if ([v isKindOfClass:[UIImageView class]]){
        if (scrollView.zoomScale<1.0){
            //         v.center = CGPointMake(scrollView.frame.size.width/2.0, scrollView.frame.size.height/2.0);
        }
    }
}

#pragma mark -
-(void)handleDoubleTap:(UITapGestureRecognizer *)gesture{
        float newScale = [(UIScrollView*)gesture.view.superview zoomScale] * 1.5;
        CGRect zoomRect = [self zoomRectForScale:newScale  inView:(UIScrollView*)gesture.view.superview withCenter:[gesture locationInView:gesture.view]];
        UIView *view = gesture.view.superview;
        if ([view isKindOfClass:[UIScrollView class]]){
            UIScrollView *s = (UIScrollView *)view;
            [s zoomToRect:zoomRect animated:YES];
        }
}
-(void)Tap:(UITapGestureRecognizer *)gesture{
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Utility methods

-(CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = [scrollView frame].size.height / scale;
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

-(CGRect)resizeImageSize:(CGRect)rect{
    //    NSLog(@"x:%f y:%f width:%f height:%f ", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    CGRect newRect;
    
    CGSize newSize;
    CGPoint newOri;
    
    CGSize oldSize = rect.size;
    if (oldSize.width>=WIDTH || oldSize.height>=WIDTH){
        float scale = (oldSize.width/WIDTH>oldSize.height/HEIGHT?oldSize.width/WIDTH:oldSize.height/HEIGHT);
        newSize.width = oldSize.width/scale;
        newSize.height = oldSize.height/scale;
    }
    else {
        newSize = oldSize;
    }
    newOri.x = (WIDTH-newSize.width)/2.0;
    newOri.y = (HEIGHT-newSize.height)/2.0;
    
    newRect.size = newSize;
    newRect.origin = newOri;
    
    return newRect;
}



-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden  = YES;
}

@end
