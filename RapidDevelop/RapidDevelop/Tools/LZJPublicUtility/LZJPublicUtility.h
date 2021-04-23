//
//  LZJPublicUtility.h
//  AXWY
//
//  Created by lzj on 2017/8/11.
//  Copyright © 2017年 LZJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LZJNavigationItemCustomButton.h"
#import "MDUserModel.h"
@interface LZJPublicUtility : NSObject

+ (CGSize)getSizeWithText:(NSString *)text andFont:(UIFont *)font andWidth:(CGFloat)width andHeight:(CGFloat)height;

+ (CGSize)getSizeWithText:(NSString *)text andFont:(UIFont *)font andSpacing:(CGFloat)space andWidth:(CGFloat)width andHeight:(CGFloat)height;

+(NSString *)getDocumedntPathWithName:(NSString *)string;

+ (BOOL)isBlankString:(NSString *)string;

//代替源字符串为空的字符串
+ (NSString *)replaceBlankString:(NSString *)string toString:(NSString *)toString;

//显示价格
+ (NSString *)formatFloat:(NSString *)priceStr;

//navigationBarItem
+(NSArray *)navBarItemWithButton :(LZJNavigationItemCustomButton *)button isLeft:(BOOL)leftBtn;

//图片拉伸保护
+ (UIImage *)resizableImage:(NSString *)imageName;

//json转字典
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//json data转字典
+(NSDictionary *)jsonData2Dictionary:(NSData *)jsonData;
//字典转json
+(NSString *)convertToJsonData:(NSMutableDictionary *)dict;

+(NSData *)dictionary2JsonData:(NSDictionary *)dict;

//每隔4个字符加一个空格
+ (NSString *)stringAddSpaceEveryFourNumber:(NSString *)number;

//可以获取到父容器的控制器的方法,就是这个黑科技.
+(UIViewController *)getViewsController:(UIView *)view;

//判断是否iphonex系列
+(BOOL)isIPhoneXSeries;

//标准适配s字体,
+(CGFloat)adaptFont:(CGFloat)fontSize;

//完全适配字体
+(CGFloat)autoFontSize:(CGFloat)fontSize;

//获取当前顶层控制器
+ (UIViewController*)getCurrentViewController;

//相机拍照图片旋转90°还原
+ (UIImage *)fixOrientation:(UIImage *)aImage ;

//判断view是否在屏幕
+(BOOL)isDisplayedInScreen:(UIView *)view;

+ (NSString *)tk_messageString :(NSDate *)date;

+ (BOOL)isCurrentViewControllerVisible:(NSString *)vcName ;

+(NSString *)getCurrentLaunage;

+(BOOL)checkUrl:(NSString *)url;

//pop的时候设置是否隐藏navbar
+(void)setNavigationBarHiddenByPop:(UIViewController *)viewController;

//创建纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size ;

//个人信息model 的存储跟获取
+(MDUserModel *)getUserModel;
+(void)saveUserModel:(MDUserModel *)model;


+ (NSString *)getDeviceModel;

+(void)checkLoginStatus;

+(void)switchRootVcToLogin;

+(void)switchRootVcToHome;
@end
