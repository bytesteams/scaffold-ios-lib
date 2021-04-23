//
//  LZJTabBarViewController.m
//  AXWY
//
//  Created by lzj on 2017/8/10.
//  Copyright © 2017年 apple. All rights reserved.
//
#pragma clang diagnostic ignored "-Wdeprecated-declarations" // 忽略警告
#import "LZJTabBarViewController.h"
#import "LZJNavigationViewController.h"
#import "LZJTabBar.h"


@interface LZJTabBarViewController ()<UIAlertViewDelegate,UITabBarControllerDelegate>
@property(nonatomic,strong) LZJTabBar *myTabBar;
@end

@implementation LZJTabBarViewController

+(void)load{
    
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:[self class] , nil];
    NSMutableDictionary *testAttrNor = [NSMutableDictionary dictionary];
    NSMutableDictionary *testAttrSel = [NSMutableDictionary dictionary];
    testAttrNor[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    [item setTitleTextAttributes:testAttrNor forState:UIControlStateNormal];
    testAttrNor[NSForegroundColorAttributeName] = RGB(110, 110, 110);
    testAttrSel[NSForegroundColorAttributeName] = kMainColor;
    [item setTitleTextAttributes:testAttrNor forState:UIControlStateNormal];
    [item setTitleTextAttributes:testAttrSel forState:UIControlStateSelected];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabBar];
    [self setupAllChildViewController];
    [self setupAllTabBarButton];
    [self removeBlackLine];
    self.delegate = self;
    //添加未读计数的监听
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(onChangeUnReadCount:)
//                                                 name:@"TUIKitNotification_onChangeUnReadCount"
//                                               object:nil];
    
}
//
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//
//    NSInteger notiCount =  [UIApplication sharedApplication].applicationIconBadgeNumber;
//
//    int unReadCount = 0;
//    NSArray *convs = [[TIMManager sharedInstance] getConversationList];
//    for (TIMConversation *conv in convs) {
//        if([conv getType] == TIM_SYSTEM){
//            continue;
//        }
//        unReadCount += [conv getUnReadMessageNum];
//    }
//
//    if (unReadCount > 0 || notiCount > 0) {
//        [self.tabBar showBadgeIndex:1];
//    }
//
//
//}

-(void)setupAllChildViewController{
    
    UIViewController *homeVc =[[UIViewController alloc]init];
    LZJNavigationViewController *navHomeVc = [[LZJNavigationViewController alloc] init];
    [navHomeVc setViewControllers:@[homeVc] animated:NO];
    [self addChildViewController:navHomeVc];

    UIViewController *discoverVc = [[UIViewController alloc]init];
    LZJNavigationViewController *navDiscoverVc = [[LZJNavigationViewController alloc] init];
    [navDiscoverVc setViewControllers:@[discoverVc] animated:NO];
    [self addChildViewController:navDiscoverVc];
    
    UIViewController *dieteVc = [[UIViewController alloc]init];
    LZJNavigationViewController *navDieteVcVc = [[LZJNavigationViewController alloc] init];
    [navDieteVcVc setViewControllers:@[dieteVc] animated:NO];
    [self addChildViewController:navDieteVcVc];
    
    UIViewController *mineVc = [[UIViewController alloc]init];
    LZJNavigationViewController *navMineVc = [[LZJNavigationViewController alloc] init];
    [navMineVc setViewControllers:@[mineVc] animated:NO];
    [self addChildViewController:navMineVc];
    
}

-(void)setupAllTabBarButton{
    
    LZJNavigationViewController *navHome = self.childViewControllers[0];
    navHome.tabBarItem.title = kLocalized(@"测试");
    navHome.tabBarItem.image = [self imageWithRenderingOriginalName:@"tabbar_home_normal"];
    navHome.tabBarItem.selectedImage = [self imageWithRenderingOriginalName:@"tabbar_home_selected"];
    
    
    LZJNavigationViewController *navHot = self.childViewControllers[1];
    navHot.tabBarItem.title = kLocalized(@"测试");
    navHot.tabBarItem.image = [self imageWithRenderingOriginalName:@"tabbar_find_normal"];
    navHot.tabBarItem.selectedImage = [self imageWithRenderingOriginalName:@"tabbar_find_selected"];
    
    LZJNavigationViewController *navCollege = self.childViewControllers[2];
    navCollege.tabBarItem.title = kLocalized(@"测试");
    navCollege.tabBarItem.image = [self imageWithRenderingOriginalName:@"tabbar_dieter_normal"];
    navCollege.tabBarItem.selectedImage = [self imageWithRenderingOriginalName:@"tabbar_dieter_selected"];
    
    
    LZJNavigationViewController *navMine = self.childViewControllers[3];
    navMine.tabBarItem.title = kLocalized(@"测试");
    navMine.tabBarItem.image = [self imageWithRenderingOriginalName:@"tabbar_mine_normal"];
    navMine.tabBarItem.selectedImage = [self imageWithRenderingOriginalName:@"tabbar_mine_selected"];
 
}
//这个是UITabBarController的代理方法
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//
//    if ([viewController isEqual:tabBarController.selectedViewController]) {
//        // 执行操作
//        [[NSNotificationCenter defaultCenter]postNotificationName:NotificationUserReloadData object:nil];
//
//    }
//    return YES;
//
//}


-(void)setupTabBar{
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    //TABBAR取消透明
    [UITabBar appearance].translucent = NO;
    UIImage *image = [self imageWithColor:kBgColor size:CGSizeMake(kScreenWidth, kTabBarHeight)];
    [[UITabBar appearance]  setBackgroundImage:image];
//    _myTabBar = [[LZJTabBar alloc] init];
//    _myTabBar.myDelegate = self;
//    _myTabBar.delegate = self;
//    [self setValue:_myTabBar forKey:@"tabBar"];
}


//
//- (void)onChangeUnReadCount:(NSNotification *)notifi{
//    NSNumber *count = notifi.object;
//    NSInteger unReanCount = count.integerValue;
//    if (unReanCount > 0) {
//        [self.tabBar showBadgeIndex:1];
//    }else{
//        [self.tabBar hideBadgeIndex:1];
//    }
//    
//}

//-(void)dealloc{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}

-(void)removeBlackLine{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, kScreenWidth, 0.5)];
    view.backgroundColor = kWhiteColor;
    [[UITabBar appearance] insertSubview:view atIndex:0];
}

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

- (UIImage *)imageWithRenderingOriginalName:(NSString *)name{
    UIImage *image = [UIImage imageNamed:name];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}
@end
