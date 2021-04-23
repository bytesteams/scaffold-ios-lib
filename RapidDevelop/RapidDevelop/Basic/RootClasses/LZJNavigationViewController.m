//
//  LZJNavigationViewController.m
//  AXWY
//
//  Created by lzj on 2017/8/10.
//  Copyright © 2017年 apple. All rights reserved.
//
#pragma clang diagnostic ignored "-Wdeprecated-declarations" // 忽略警告
#import "LZJNavigationViewController.h"
#import "LZJNavigationItemCustomButton.h"

@interface LZJNavigationViewController ()<UIGestureRecognizerDelegate>

@end

@implementation LZJNavigationViewController


+(void)load{
    //获取整体的UINavigationBar
    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    
    NSMutableDictionary *titleAttribute=[NSMutableDictionary dictionary];
    titleAttribute[NSFontAttributeName] = kFont(20);
    titleAttribute[NSForegroundColorAttributeName] = kText262;
  
    [navigationBar setTitleTextAttributes:titleAttribute];
    
    navigationBar.translucent = NO;

    [navigationBar setShadowImage:[UIImage new]];
    [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    id target = self.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
     self.interactivePopGestureRecognizer.enabled = NO;
    

    [self.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [self.navigationBar setBackgroundImage:[self imageWithColor:kWhiteColor size:CGSizeMake(kScreenWidth , kNavBarHeight)] forBarMetrics:UIBarMetricsDefault];
    //修改线颜色
//    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationBar setShadowImage:[self imageWithColor:RGB(209, 209, 209) size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 0.5)]];
    
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        //全局自定义返回按钮
        //非根控制器 隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
    
      
        LZJNavigationItemCustomButton *btn = [[LZJNavigationItemCustomButton alloc]init];
        [btn setImage:[UIImage imageNamed:@"navBack_black"].imageFlippedForRightToLeftLayoutDirection forState:UIControlStateNormal];
        [btn setTitle:@"      " forState:UIControlStateNormal];
        [btn sizeToFit];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItems = [LZJPublicUtility navBarItemWithButton:btn isLeft:YES];
        

    }
    

    [super pushViewController:viewController animated:animated];
}

#pragma mark - public methods
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(void)back{

    if (self.childViewControllers.count>1) {
       
       [[MDNetworkTool shareManager] cancelRequest];
        [self popViewControllerAnimated:YES];
    }
}

#pragma mark - UIGestureRecognizerDelegate
// 是否触发手势

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint touchPoint = [touch locationInView:self.view];
    // NSLog(@"%lf",touchPoint.x);
    if (self.childViewControllers.count>1) {

          if (touchPoint.x> 40) {
              
              return NO;
              
          }else{
              
              [[MDNetworkTool shareManager] cancelRequest];
              
              return YES;
          }

    }else{
        
        return NO;
    }
}


@end
