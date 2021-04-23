//
//  UITextField+Placeholder.m
//  SayHi
//
//  Created by lzj on 2019/10/31.
//  Copyright © 2019 ledonghuyu.com. All rights reserved.
//

#import "UITextField+Placeholder.h"
#import <objc/message.h>


@implementation UITextField (Placeholder)
+ (void)load
{
    Method setPlaceholderMethod = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method wg_setPlaceholderMethod = class_getInstanceMethod(self, @selector(wg_setPlaceholder:));

    // 交互方法
    method_exchangeImplementations(setPlaceholderMethod, wg_setPlaceholderMethod);

}

// 设置占位文字颜色
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    // 1.保存占位文字颜色到系统的类,关联
    // object:保存到哪个对象中
    // key:属性名
    // value:属性值
    // policy:策略
    objc_setAssociatedObject(self, @"placeholderColor", placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    UILabel *placeholderLabel = [self valueForKeyPath:@"placeholderLabel"];
   
    placeholderLabel.textColor = placeholderColor;
      
}

- (UIColor *)placeholderColor
{
    
    return objc_getAssociatedObject(self, @"placeholderColor");
}

- (void)wg_setPlaceholder:(NSString *)placeholder
{
    // 设置占位文字
    [self wg_setPlaceholder:placeholder];

    // 设置占位文字颜色
    self.placeholderColor = self.placeholderColor;

}
@end
