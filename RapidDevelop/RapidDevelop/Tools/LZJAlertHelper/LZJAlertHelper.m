//
//  LZJAlertHelper.m
//
//  Created by 林志军 on 17/3/1.
//  Copyright © 2017年 naoxin_Ltd. All rights reserved.
//

#import "LZJAlertHelper.h"
#import <SCLAlertView.h>
@implementation LZJAlertHelper

static id shareManager;
//单例模式
+ (LZJAlertHelper * )shareManager{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareManager = [[LZJAlertHelper alloc] init];
    });
    return shareManager;
}

-(instancetype)init{
    
    if (self = [super init]) {
        
    }
    return self;
}

-(void)showTwoButtonAlertViewLeftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle handel:(handelDoneBlock)doneBlock title:(NSString *)title content :(NSString *)content inVc:(UIViewController *)vc{
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.backgroundType = SCLAlertViewBackgroundTransparent;
    
    alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
    [alert setHorizontalButtons:YES];
    
    [alert addButton:leftButtonTitle actionBlock:^(void) {
        
    }];
    
    [alert addButton:rightButtonTitle actionBlock:^(void) {
        if (doneBlock) {
            doneBlock();
        }
    }];
    
    UIColor *color = [UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:144.0/255.0 alpha:1.0];
    
   
    [alert showCustom:vc image:nil color:color title:title subTitle:content closeButtonTitle:nil duration:0.0f];
}

-(void)showOneButtonAlertViewButtonTitle:(NSString *)buttonTitle title:(NSString *)title content:(NSString *)content inVc:(UIViewController *)vc{
     SCLAlertView *alert = [[SCLAlertView alloc] init];
     alert.backgroundType = SCLAlertViewBackgroundTransparent;
     
     alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
     [alert setHorizontalButtons:YES];
     
     [alert addButton:buttonTitle actionBlock:^(void) {
         
     }];
     
   
     UIColor *color = [UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:144.0/255.0 alpha:1.0];
     
     [alert showCustom:vc image:nil color:color title:title subTitle:content closeButtonTitle:nil duration:0.0f];
}

-(void)showAutoDisappearAlertViewTitle:(NSString *)title content:(NSString *)content inVc:(UIViewController *)vc{
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.backgroundType = SCLAlertViewBackgroundTransparent;
    alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
    
    UIColor *color = [UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:144.0/255.0 alpha:1.0];
    [alert showCustom:vc image:nil color:color title:title subTitle:content closeButtonTitle:nil duration:3.0f];
}


-(void)showPhotoSelectWithTitle:(NSString *)title content:(NSString *)content firstBtnTitle:(NSString *)firstTitle firstBlock:(handelFirstBlock)firstBlock secondBtnTitle:(NSString *)secondTitle secondBlock:(handelSecondBlock)secondBlock inVc:(UIViewController *)vc{
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.backgroundType = SCLAlertViewBackgroundTransparent;
    alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
    
    [alert addButton:firstTitle actionBlock:^(void) {
        if (firstBlock) {
            firstBlock();
        }
    }];
    
    
    [alert addButton:secondTitle actionBlock:^(void) {
        if (secondBlock) {
            secondBlock();
        }
    }];
    
    UIColor *color = [UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:144.0/255.0 alpha:1.0];
    
     [alert showCustom:vc image:nil color:color title:title subTitle:content closeButtonTitle:nil duration:0.0f];
    
}
@end
