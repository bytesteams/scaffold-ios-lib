//
//  UIImage+Circle.m
//  01-BuDeJie
//
//  Created by xmg on 16/1/31.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

#import "UIImage+Circle.h"

@implementation UIImage (Circle)

- (instancetype)Lzj_circleImage
{
    // 1.开启位图上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    
    // 2.描述裁剪路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    // 3.设置裁剪区域
    [path addClip];
    
    // 4.绘图
    [self drawAtPoint:CGPointZero];
    
    // 5.从上下文获取裁剪好图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    
    return image;
}

+ (instancetype)Lzj_circleImageNamed:(NSString *)name
{
    return [[self imageNamed:name] Lzj_circleImage];
}



@end
