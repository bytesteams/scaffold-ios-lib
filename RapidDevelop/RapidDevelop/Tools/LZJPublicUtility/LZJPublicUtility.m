//
//  LZJPublicUtility.m
//  AXWY
//
//  Created by lzj on 2017/8/11.
//  Copyright © 2017年 LZJ. All rights reserved.
//
#pragma clang diagnostic ignored "-Wdeprecated-declarations" // 忽略警告
#import "LZJPublicUtility.h"
#import "sys/utsname.h"
#import "MDAlertHelper.h"

@implementation LZJPublicUtility


+ (CGSize)getSizeWithText:(NSString *)text andFont:(UIFont *)font andWidth:(CGFloat)width andHeight:(CGFloat)height{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        CGRect rect = [text boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
        return rect.size;
    }
    else
    {
        CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, height)];
        return size;
    }
}

+ (CGSize)getSizeWithText:(NSString *)text andFont:(UIFont *)font andSpacing:(CGFloat)space andWidth:(CGFloat)width andHeight:(CGFloat)height{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        
        //行间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = space;
        
        NSDictionary *cyZoneDocAttribute = @{NSFontAttributeName:font,NSParagraphStyleAttributeName: paragraphStyle};
        CGRect rect = [text boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:cyZoneDocAttribute context:nil];
        return rect.size;
    }
    else
    {
        CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, height)];
        return size;
    }
}

+(NSString *)getDocumedntPathWithName:(NSString *)string{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:string];
    return filePath;
}



+ (BOOL)isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL  ) {
        
        return YES;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    
    if([string isEqual:[NSNull null]])
    {
        return YES;
    }
    
    if ([string isEqualToString:@"null"] || [string isEqualToString:@"NULL"]) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    return NO;
    
}

+ (NSString *)replaceBlankString:(NSString *)string toString:(NSString *)toString{
    
    string = [NSString stringWithFormat:@"%@",string];
    if ([self isBlankString : string]) {
        
        return toString;
        
    }else{
        return string;
    }
    
}

//如果有两位小数不为0则保留两位小数，如果有一位小数不为0则保留一位小数，否则显示整数   fmodf->取余
+ (NSString *)formatFloat:(NSString *)priceStr
{
    CGFloat f = priceStr.floatValue;
    if (fmodf(f, 1)==0) {  //没有小数
        return [NSString stringWithFormat:@"%.0f",f];
    } else if (fmodf(f*10, 1)==0) { //1位小数
        return [NSString stringWithFormat:@"%.1f",f];
    } else {
        return [NSString stringWithFormat:@"%.2f",f];
    }
}



+(NSArray *)navBarItemWithButton :(LZJNavigationItemCustomButton *)button isLeft:(BOOL)leftBtn{
    
    if (@available(iOS 11.0, *)) {
        if (leftBtn) {
            button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, kFitW(-2), 0,kFitW(2));
        }else{
            button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, kFitW(2), 0, kFitW(-2));
        }
        
        [button sizeToFit];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [button.widthAnchor constraintEqualToConstant:button.width].active = YES;
        [button.heightAnchor constraintEqualToConstant:button.height].active = YES;
        
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                        target:nil
                                                                                        action:nil];
        
        return  [NSArray arrayWithObjects:negativeSpacer,buttonItem,nil];
    }else{
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        //设置偏右间隔
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        
        negativeSpacer.width = kFitW(2);
        [button sizeToFit];
        return  [NSArray arrayWithObjects:negativeSpacer,rightItem,nil];
    }
    
}



+ (UIImage *)resizableImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageH * 0.5, imageW * 0.5, imageH * 0.5, imageW * 0.5) resizingMode:UIImageResizingModeStretch];
    
  
}

+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

//每隔4个字符加一个空格
+ (NSString *)stringAddSpaceEveryFourNumber:(NSString *)number
{
    NSString *doneTitle = @" ";
    int count = 0;
    for (int i = 0; i < number.length; i++) {
        
        count++;
        doneTitle = [doneTitle stringByAppendingString:[number substringWithRange:NSMakeRange(i, 1)]];
        if (count == 4) {
            doneTitle = [NSString stringWithFormat:@"%@ ", doneTitle];
            count = 0;
        }
    }
    
    return doneTitle;
}

//可以获取到父容器的控制器的方法,就是这个黑科技.
+(UIViewController *)getViewsController:(UIView *)view{
    UIResponder *responder = view;
    //循环获取下一个响应者,直到响应者是一个UIViewController类的一个对象为止,然后返回该对象.
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

+(BOOL)isIPhoneXSeries{
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    
    return iPhoneXSeries;
}

//json转字符串
+(NSString *)convertToJsonData:(NSMutableDictionary *)dict{
    
    if ([dict isKindOfClass:[NSString class]]) {
        return (NSString *)dict;
    }
    NSError *parseError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonSrt = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (parseError) {
        jsonSrt = @"";
    }
    return jsonSrt;
}


//json字符串转字典
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


// json data转 字典
+(NSDictionary *)jsonData2Dictionary:(NSData *)jsonData
{
    if (jsonData == nil) {
        return nil;
    }
    NSError *err = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err || ![dic isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Json parse failed");
        return nil;
    }
    return dic;
}

+(NSDate *)dictionary2JsonData:(NSDictionary *)dict{
    // 转成Json数据
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
        if(error)
        {
            NSLog(@"[%@] Post Json Error", [self class]);
        }
        return data;
    }
    else
    {
        NSLog(@"[%@] Post Json is not valid", [self class]);
    }
    return nil;
}


+ (NSString *)toJsonStrWithDictionary:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSString class]]) {
        return (NSString *)dict;
    }
    NSError *parseError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonSrt = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (parseError) {
        jsonSrt = @"";
    }
    return jsonSrt;
}

+(CGFloat)autoFontSize:(CGFloat)fontSize{
    
    return fontSize * kRatioW;
}

+(CGFloat)adaptFont:(CGFloat)fontSize{
    
    if (kScreenWidth == 320.0){ //5
        fontSize -= 1 ;
    }else if (kScreenWidth == 375.0){
        fontSize -= 0;
    }else if (kScreenWidth == 414.0){
        fontSize += 1;
    }else{
        fontSize -= 0;
    }
    return fontSize;
}

+ (UIViewController*)getCurrentViewController{
    
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (1) {
        
        if ([vc isKindOfClass:[UITabBarController class]]) {
            
            vc = ((UITabBarController*)vc).selectedViewController;
            
        }
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            
            vc = ((UINavigationController*)vc).visibleViewController;
            
        }
        
        if (vc.presentedViewController) {
            
            vc = vc.presentedViewController;
            
        }else{
            break;
        }
    }
    
    return vc;
}


//相机拍照图片旋转90°还原
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width , aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+(BOOL)isDisplayedInScreen:(UIView *)view{
    // view不存在 或未添加到superview
    if (view == nil || view.superview == nil) {
        return false;
    }
    
    // view 隐藏
    if (view.hidden) {
        return false;
    }
    
    // 转换view对应window的Rect
    CGRect rect = [view convertRect:view.frame toView:nil];
    
    //如果可以滚动，清除偏移量
    if ([[view class] isSubclassOfClass:[UIScrollView class]]) {
        UIScrollView * scorll = (UIScrollView *)view;
        rect.origin.x += scorll.contentOffset.x;
        rect.origin.y += scorll.contentOffset.y;
    }
    
    // 若size为CGrectZero
    if (CGRectIsEmpty(rect) ||
        CGRectIsNull(rect)  ||
        CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return false;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return false;
    }
    
    return true;
}

+ (NSString *)tk_messageString:(NSDate *)date
{
    
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:date];
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc ] init ];
    [dateFmt setLocale:[NSLocale localeWithLocaleIdentifier:@"us"]];
    NSDateComponents *comp =  [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
    
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy-MM-dd";
    }
    else{
        if (nowCmps.day==myCmps.day) {
            dateFmt.dateFormat = @"HH:mm";
        } else if((nowCmps.day-myCmps.day)==1) {
            //            dateFmt.AMSymbol = LDLocalized(@"上午");
            //            dateFmt.PMSymbol = LDLocalized(@"下午");
            dateFmt.dateFormat = @"HH:mm";
            return [NSString stringWithFormat:@"%@ %@",@"昨天",[dateFmt stringFromDate:date]];
            
        } else {
            //            if ((nowCmps.day-myCmps.day) <=7 && (nowCmps.day-myCmps.day) >= 0) {
            //                switch (comp.weekday) {
            //                    case 1:
            //                        dateFmt.dateFormat = LDLocalized(@"星期日") ;
            //                        break;
            //                    case 2:
            //                        dateFmt.dateFormat = LDLocalized(@"星期一") ;
            //                        break;
            //                    case 3:
            //                        dateFmt.dateFormat = LDLocalized(@"星期二") ;
            //                        break;
            //                    case 4:
            //                        dateFmt.dateFormat = LDLocalized(@"星期三");
            //                        break;
            //                    case 5:
            //                        dateFmt.dateFormat = LDLocalized(@"星期四");
            //                        break;
            //                    case 6:
            //                        dateFmt.dateFormat = LDLocalized(@"星期五");
            //                        break;
            //                    case 7:
            //                        dateFmt.dateFormat = LDLocalized(@"星期六");
            //                        break;
            //                    default:
            //
            //                        break;
            //                }
            //
            //                 return dateFmt.dateFormat;
            //            }else {
            
            dateFmt.dateFormat = @"yyyy-MM-dd";
            //            }
        }
    }
    
    return [dateFmt stringFromDate:date];
}


//判断控制器是否已经显示
//假如一个UIView对象当前正在显示，那么它的window属性肯定为非空值
+(BOOL)isCurrentViewControllerVisible:(NSString *)vcName {
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topVC.presentedViewController) {
        
        topVC = topVC.presentedViewController;
        
        if ([[topVC.class description] isEqualToString:@"UINavigationController"]) {
            
            UINavigationController *navi = (UINavigationController *)topVC;
            
            if (navi && navi.viewControllers && navi.viewControllers.count > 0) {
                
                NSInteger count = navi.viewControllers.count;
                
                for (NSInteger i=count-1; i>=0; i--) {
                    
                    UIViewController *controller = [navi.viewControllers objectAtIndex:i];
                    
                    if ([[controller.class description] isEqualToString:vcName]) {
                        
                        return YES;
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    return NO;
}

+(NSString *)getCurrentLaunage{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}

+(BOOL)checkUrl:(NSString *)url{
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", url]]]) {
        
        return YES;
    }
    
    return NO;
}

+(void)setNavigationBarHiddenByPop:(UIViewController *)viewController{
    BOOL isHiddenNavBar =   viewController.navigationController.viewControllers.lastObject.navigationController.navigationBarHidden ;
    [viewController.navigationController setNavigationBarHidden:isHiddenNavBar animated:YES];
}



+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
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

+(MDUserModel *)getUserModel{
    MDUserModel *myModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[LZJPublicUtility getDocumedntPathWithName:@"userModel"]];
    
    return myModel;
}

+(void)saveUserModel:(MDUserModel *)model{
    [NSKeyedArchiver archiveRootObject:model toFile:[LZJPublicUtility getDocumedntPathWithName:@"userModel"]];
}



+ (NSString *)getDeviceModel{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    // 获取设备标识Identifier
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS MAX";
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    if ([platform isEqualToString:@"iPhone12,8"])   return @"iPhone SE2";
    if ([platform isEqualToString:@"iPhone13,1"])   return @"iPhone 12 mini";
    if ([platform isEqualToString:@"iPhone13,2"])   return @"iPhone 12";
    if ([platform isEqualToString:@"iPhone13,3"])   return @"iPhone 12 Pro";
    if ([platform isEqualToString:@"iPhone13,4"])   return @"iPhone 12 Pro Max";
    
    // iPod
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1";
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2";
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3";
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4";
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5";
    if ([platform isEqualToString:@"iPod7,1"])  return @"iPod Touch 6";
    if ([platform isEqualToString:@"iPod9,1"])  return @"iPod Touch 7";
    
    // iPad
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad 1";
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])  return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini 1";
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini 1";
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini 1";
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])  return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])  return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])  return @"iPad 4";
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])  return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,5"])  return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,6"])  return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,7"])  return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,8"])  return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,8"])  return @"iPad mini 3";
    if ([platform isEqualToString:@"iPad4,9"])  return @"iPad mini 4";
    if ([platform isEqualToString:@"iPad5,2"])  return @"iPad mini 4";
    if ([platform isEqualToString:@"iPad5,3"])  return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])  return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,3"])  return @"iPad Pro (9.7-inch)";
    if ([platform isEqualToString:@"iPad6,4"])  return @"iPad Pro (9.7-inch)";
    if ([platform isEqualToString:@"iPad6,7"])  return @"iPad Pro (12.9-inch)";
    if ([platform isEqualToString:@"iPad6,8"])  return @"iPad Pro (12.9-inch)";
    if ([platform isEqualToString:@"iPad6,11"])  return @"iPad 5";
    if ([platform isEqualToString:@"iPad6,12"])  return @"iPad 5";
    if ([platform isEqualToString:@"iPad7,1"])  return @"iPad Pro 2(12.9-inch)";
    if ([platform isEqualToString:@"iPad7,2"])  return @"iPad Pro 2(12.9-inch)";
    if ([platform isEqualToString:@"iPad7,3"])  return @"iPad Pro (10.5-inch)";
    if ([platform isEqualToString:@"iPad7,4"])  return @"iPad Pro (10.5-inch)";
    if ([platform isEqualToString:@"iPad7,5"])  return @"iPad 6";
    if ([platform isEqualToString:@"iPad7,6"])  return @"iPad 6";
    if ([platform isEqualToString:@"iPad7,11"])  return @"iPad 7";
    if ([platform isEqualToString:@"iPad7,12"])  return @"iPad 7";
    if ([platform isEqualToString:@"iPad8,1"])  return @"iPad Pro (11-inch) ";
    if ([platform isEqualToString:@"iPad8,2"])  return @"iPad Pro (11-inch) ";
    if ([platform isEqualToString:@"iPad8,3"])  return @"iPad Pro (11-inch) ";
    if ([platform isEqualToString:@"iPad8,4"])  return @"iPad Pro (11-inch) ";
    if ([platform isEqualToString:@"iPad8,5"])  return @"iPad Pro 3 (12.9-inch) ";
    if ([platform isEqualToString:@"iPad8,6"])  return @"iPad Pro 3 (12.9-inch) ";
    if ([platform isEqualToString:@"iPad8,7"])  return @"iPad Pro 3 (12.9-inch) ";
    if ([platform isEqualToString:@"iPad8,8"])  return @"iPad Pro 3 (12.9-inch) ";
    if ([platform isEqualToString:@"iPad11,1"])  return @"iPad mini 5";
    if ([platform isEqualToString:@"iPad11,2"])  return @"iPad mini 5";
    if ([platform isEqualToString:@"iPad11,3"])  return @"iPad Air 3";
    if ([platform isEqualToString:@"iPad11,4"])  return @"iPad Air 3";
    
    // 其他
    if ([platform isEqualToString:@"i386"])   return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])  return @"iPhone Simulator";
    
    return platform;
}

+(void)checkLoginStatus{
    
    
    NSInteger loginStatus = [USERDEFAULT(@"loginStatus") integerValue];
    WeakSelf
    if (loginStatus == 0) {
        [[MDAlertHelper shareManager]showEnsureAlertView:nil message:kLocalized(@"您的登录信息已过期,请重新登录") :^{
            
            [weakSelf switchRootVcToLogin];
            
        }];
    }
    
}

+(void)switchRootVcToLogin{
    
    //反射获取类
    id loginVc = [[NSClassFromString(@"MDLoginViewController") alloc]init];
    id rootVc = [[NSClassFromString(@"LZJNavigationViewController") alloc]initWithRootViewController:loginVc];

    [UIView transitionWithView:[UIApplication sharedApplication].delegate.window
                     duration:1
                      options:UIViewAnimationOptionTransitionCrossDissolve
                   animations:^{
        
                       BOOL oldState= [UIView areAnimationsEnabled];

                       [UIView setAnimationsEnabled:NO];

                       [[UIApplication sharedApplication].delegate.window setRootViewController: rootVc];
                        [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];

                       [UIView setAnimationsEnabled:oldState];

                   }
                    completion:NULL];
    
}

+ (void)switchRootVcToHome{
    [UIView transitionWithView:[UIApplication sharedApplication].delegate.window
                     duration:1
                      options:UIViewAnimationOptionTransitionCrossDissolve
                   animations:^{
        
                       BOOL oldState= [UIView areAnimationsEnabled];

                       [UIView setAnimationsEnabled:NO];

                       [[UIApplication sharedApplication].delegate.window setRootViewController: [[NSClassFromString(@"LZJTabBarViewController") alloc]init]];
                        [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];

                       [UIView setAnimationsEnabled:oldState];

                   }
                    completion:NULL];
    
}
@end
