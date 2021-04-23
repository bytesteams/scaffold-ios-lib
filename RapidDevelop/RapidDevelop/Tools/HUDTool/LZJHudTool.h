//
//  LZJHudTool.h
//  MDHealth
//
//  Created by 林志军 on 2020/8/5.
//  Copyright © 2020 startgo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>
NS_ASSUME_NONNULL_BEGIN

@interface LZJHudTool : NSObject


@property (nonatomic,strong) MBProgressHUD  *hud;


+(instancetype)shareInstance;

+(void)showMessageInView :(UIView * _Nullable )view message:(NSString *)message;

+(void)showEnableTouchMessageInView :(UIView *)view message:(NSString *)message;

+(void)showProgressHud:(UIView *)view;

+(void)showProgressHud:(UIView *)view WithTitle:(NSString *)title;

+(void)hideProgressHud:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
