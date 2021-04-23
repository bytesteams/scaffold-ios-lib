//
//  AppDelegate.m
//  MDHealth
//
//  Created by 林志军 on 2020/7/28.
//  Copyright © 2020 林志军. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+SDK.h"
#import "AppDelegate+PUSH.h"
#import "LZJTabBarViewController.h"
#import "LZJNavigationViewController.h"
#import "GSKeyChainDataManager.h"
#import <XHLaunchAd.h>
#import "HcdGuideView.h"
#import <AFNetworkReachabilityManager.h>
#import "MDAlertView.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    //初始化第三方SDK
    [self initSDKAppDelegate:application withOptions:launchOptions];
    
    //初始化推送SDK
    [self initPushAppDelegate:application withOptions:launchOptions];
    
    [self configData];
    
    [self checkNetwork];
    
//    [self setupAD];
    
    [self setupGuideView];
    
    
    return YES;
}

-(void)configData{
    
    if ([LZJPublicUtility isBlankString:USERDEFAULT(@"myDeviceId")]) {
        NSString *deviceUUID = [[UIDevice currentDevice].identifierForVendor UUIDString];
        [GSKeyChainDataManager saveUUID:deviceUUID];
        [[NSUserDefaults standardUserDefaults]setObject:[GSKeyChainDataManager readUUID] forKey:@"myDeviceId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)checkNetwork{
    AFNetworkReachabilityManager * manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"网络状态未知23666666");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络23666666");
            
                [self showNoNet];
                
                break;
            case  AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G|4G蜂窝移动网络23666666");
             
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI网络23666666");
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
}

-(void)showNoNet{
    MDAlertView *alertView = [[MDAlertView alloc]init];
    [alertView showSelectAlertView:kLocalized(@"检测到无网络连接\n1.请检查是否已连接到网络\n2.开启APP的WLAN与蜂窝网络") inView:[UIApplication sharedApplication].keyWindow WithBlock:^{
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
}

-(void)setupAD{
//    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    //配置广告数据
      //1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
    //2.设为2即表示:启动页将停留2s等待服务器返回广告数据,2s内等到广告数据,将正常显示广告,否则将不显示
    //3.数据获取成功,配置广告数据后,自动结束等待,显示广告
    //注意:请求广告数据前,必须设置此属性,否则会先进入window的的根控制器
//    [XHLaunchAd setWaitDataDuration:2];
    
    //广告数据请求
//    [Network getLaunchAdImageDataSuccess:^(NSDictionary * response) {
//        
//        NSLog(@"广告数据 = %@",response);
//        
//        //广告数据转模型
//        LaunchAdModel *model = [[LaunchAdModel alloc] initWithDict:response[@"data"]];
//        //配置广告数据
//        XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
//         imageAdconfiguration.duration = 3;
//        //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
//        imageAdconfiguration.imageNameOrURLString = model.content;
//         //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
//        imageAdconfiguration.openModel = model.openUrl;
//        //显示开屏广告
//        [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
//        
//    } failure:^(NSError *error) {
//    }];
}


-(void)setupGuideView{
//     if ([USERDEFAULT(@"isInstall") boolValue] == NO ) {
//         self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
//         //先显示空白的根控制器, 等引导图完了后再显示tabbbarvc
//         self.window.rootViewController = [UIViewController new];
//
//         [self.window makeKeyAndVisible];
//
//         //第一次安装，不加载开屏广告
//         NSArray *fistImgArr = [NSArray array];
//
//         fistImgArr = @[[UIImage imageNamed:@"Guide1"],
//                        [UIImage imageNamed:@"Guide2"],
//                        [UIImage imageNamed:@"Guide3"],
//                        [UIImage imageNamed:@"Guide4"]
//         ];
//
//         //引导图
//         HcdGuideView *guideView = [HcdGuideView sharedInstance];
//         guideView.window = self.window;
//         [guideView showGuideViewWithImages:fistImgArr
//                             andButtonTitle:@""
//                        andButtonTitleColor:[UIColor yellowColor]
//                           andButtonBGColor:[UIColor clearColor]
//                       andButtonBorderColor:[UIColor whiteColor]];
//
//         WeakSelf
//         guideView.enterBlock = ^{
//             [weakSelf setupWindow];
//         };
//
//     }else{
         
         [self setupWindow];
//     }
}

-(void)setupWindow{
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];

    NSInteger loginStatus = [USERDEFAULT(@"loginStatus") integerValue];
//    if (loginStatus == 1) {
//        self.window.rootViewController = [[LZJTabBarViewController alloc]init];
//        [self.window makeKeyAndVisible];
//    }else{
        
        LZJTabBarViewController *rooVc = [[LZJTabBarViewController alloc]init];
        self.window.rootViewController = rooVc;
        [self.window makeKeyAndVisible];
        
        if (@available(iOS 11, *)) {
            [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
//    }
    
    [kUserDefaults setObject:[NSNumber numberWithBool:YES] forKey:@"isInstall"];
    [kUserDefaults synchronize];
}


@end
