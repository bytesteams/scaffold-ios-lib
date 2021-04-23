//
//  LZJTextTool.h
//
//  Created by 林志军 on 17/3/1.
//  Copyright © 2017年 naoxin_Ltd. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZJTextTool : NSObject
//文本增加图片
+ (void)labelAddImage:(UIImage *)image bounds:(CGRect )bounds index:(NSInteger)index str:(NSString *)str inLabel:(UILabel *)label;

// 改变某个范围内的字号
+ (void)changeFont:(UIFont * )font str:(NSString *)str inLabel:(UILabel *)label;

// 改变某个范围内的颜色
+ (void)changeColor:(UIColor *)color str:(NSString *)str inLabel:(UILabel *)label;

//改变行间距
+(void)chanegeLinespace:(CGFloat)space inLabel:(UILabel *)label;

//改变字间距
+(void)chanegeWordspace:(CGFloat)space inLabel:(UILabel *)label;



@end

NS_ASSUME_NONNULL_END
