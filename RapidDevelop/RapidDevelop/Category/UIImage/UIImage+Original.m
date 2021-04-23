//
//  UIImage+Original.m
//  NaoXinFaWu
//
//  Created by linzhijun on 16/5/26.
//  Copyright © 2016年 naoxin_Ltd. All rights reserved.
//

#import "UIImage+Original.h"

@implementation UIImage (Original)
+ (UIImage *)imageWithRenderingOriginalName:(NSString *)name{
    UIImage *image = [UIImage imageNamed:name];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}
@end
