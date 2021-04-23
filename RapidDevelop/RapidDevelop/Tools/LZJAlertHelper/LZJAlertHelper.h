//
//  LZJAlertHelper.h
//
//  Created by 林志军 on 17/3/1.
//  Copyright © 2017年 naoxin_Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^handelDoneBlock)(void);

typedef void(^handelFirstBlock)(void);

typedef void(^handelSecondBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface LZJAlertHelper : NSObject

/**
 *  单利方法
 *
 *  @return 实例对象
 */
+(instancetype)shareManager;


-(void)showTwoButtonAlertViewLeftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle handel:(handelDoneBlock)doneBlock title:(NSString *)title content :(NSString *)content inVc:(UIViewController *)vc;


-(void)showOneButtonAlertViewButtonTitle:(NSString *)buttonTitle title:(NSString *)title content :(NSString *)content inVc:(UIViewController *)vc;

-(void)showAutoDisappearAlertViewTitle:(NSString *)title content :(NSString *)content inVc:(UIViewController *)vc;

-(void)showPhotoSelectWithTitle:(NSString *)title content:(NSString *)content firstBtnTitle:(NSString *)firstTitle firstBlock:(handelFirstBlock)firstBlock secondBtnTitle:(NSString *)secondTitle secondBlock:(handelSecondBlock)secondBlock inVc:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
