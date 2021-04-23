//
//  LZJHudTool.m
//  MDHealth
//
//  Created by 林志军 on 2020/8/5.
//  Copyright © 2020 startgo. All rights reserved.
//

#import "LZJHudTool.h"
#import <UIImage+GIF.h>
@implementation LZJHudTool
static id toolManager;

+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toolManager = [[LZJHudTool alloc] init];
    });
    
    return toolManager;
    
}


+(void)showMessageInView:(UIView * _Nullable )view message:(NSString *)message{
    
    //如果已有弹框，先消失
//       if ([LZJHudTool shareInstance].hud != nil) {
//           [[LZJHudTool shareInstance].hud hideAnimated:YES];
//           [LZJHudTool shareInstance].hud = nil;
//       }
    
    if (kEmptyStr(message)) {
        return;
    }
    
    [LZJHudTool shareInstance].hud =  [MBProgressHUD showHUDAddedTo:view ? view :[UIApplication sharedApplication].keyWindow animated:YES];
    [LZJHudTool shareInstance].hud.mode = MBProgressHUDModeText;
    [LZJHudTool shareInstance].hud.bezelView.color = [kText333 colorWithAlphaComponent:0.8];
    [LZJHudTool shareInstance].hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    [LZJHudTool shareInstance].hud.label.textColor = [UIColor whiteColor];
    [[LZJHudTool shareInstance].hud setMargin:10];
    [[LZJHudTool shareInstance].hud setRemoveFromSuperViewOnHide:YES];
    [LZJHudTool shareInstance].hud.detailsLabel.text = [NSString stringWithFormat:@"%@",message];
    [LZJHudTool shareInstance].hud.detailsLabel.font = kFont(15);
    [LZJHudTool shareInstance].hud.detailsLabel.textColor = [UIColor whiteColor];
    [[LZJHudTool shareInstance].hud hideAnimated:YES afterDelay:2.0];
    
    
}

+(void)showEnableTouchMessageInView :(UIView *)view message:(NSString *)message{
    if (kEmptyStr(message)) {
        return;
    }
    
    [LZJHudTool shareInstance].hud =  [MBProgressHUD showHUDAddedTo:view animated:YES];
    [LZJHudTool shareInstance].hud.userInteractionEnabled = NO;
    [LZJHudTool shareInstance].hud.mode = MBProgressHUDModeText;
    [LZJHudTool shareInstance].hud.bezelView.color = [kText333 colorWithAlphaComponent:0.8];
    [LZJHudTool shareInstance].hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    [LZJHudTool shareInstance].hud.label.textColor = [UIColor whiteColor];
    [[LZJHudTool shareInstance].hud setMargin:10];
    [[LZJHudTool shareInstance].hud setRemoveFromSuperViewOnHide:YES];
    [LZJHudTool shareInstance].hud.detailsLabel.text = [NSString stringWithFormat:@"%@",message];
    [LZJHudTool shareInstance].hud.detailsLabel.font = kFont(15);
    [LZJHudTool shareInstance].hud.detailsLabel.textColor = [UIColor whiteColor];
    [[LZJHudTool shareInstance].hud hideAnimated:YES afterDelay:2.0];
}


+(void)showProgressHud:(UIView *)view{
    
    //如果已有弹框，先消失
//          if ([LZJHudTool shareInstance].hud != nil) {
//              [[LZJHudTool shareInstance].hud hideAnimated:YES];
//              [LZJHudTool shareInstance].hud = nil;
//          }
//       
//    
    [LZJHudTool shareInstance].hud =  [MBProgressHUD showHUDAddedTo:view animated:YES];
    [LZJHudTool shareInstance].hud.mode = MBProgressHUDModeIndeterminate;
    
    //gif
//    [LZJHudTool shareInstance].hud =  [MBProgressHUD showHUDAddedTo:view animated:YES];
//    [LZJHudTool shareInstance].hud.mode = MBProgressHUDModeCustomView;
//    [LZJHudTool shareInstance].hud.bezelView.backgroundColor = [UIColor clearColor];
//     [LZJHudTool shareInstance].hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    [LZJHudTool shareInstance].hud.backgroundColor = [UIColor clearColor];
//
//    NSString *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"loading" ofType:@"gif"];
//    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
//    UIImage *image = [UIImage sd_imageWithGIFData:imageData];
//
//    //自定义imageView
//
//    UIImageView *cusImageV = [[UIImageView alloc] initWithImage:image];
//    [LZJHudTool shareInstance].hud.customView = cusImageV;
}

+(void)showProgressHud:(UIView *)view WithTitle:(NSString *)title{
    
    [LZJHudTool shareInstance].hud =  [MBProgressHUD showHUDAddedTo:view animated:YES];
    [LZJHudTool shareInstance].hud.mode = MBProgressHUDModeIndeterminate;
    [LZJHudTool shareInstance].hud.detailsLabel.text = title;
    [LZJHudTool shareInstance].hud.detailsLabel.font = kFont(13);
    [LZJHudTool shareInstance].hud.detailsLabel.textColor = kText262;
}

+(void)hideProgressHud:(UIView *)view{
    
    [[LZJHudTool shareInstance].hud hideAnimated:YES];
    [MBProgressHUD hideHUDForView:view animated:YES];
    
}
@end
