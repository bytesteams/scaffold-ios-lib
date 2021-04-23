//
//  LZJNavigationItemCustomButton.m
//  Whisper
//
//  Created by 林志军 on 2020/4/17.
//  Copyright © 2020 PAGO. All rights reserved.
//

#import "LZJNavigationItemCustomButton.h"


@implementation LZJNavigationItemCustomButton

- (UIEdgeInsets)alignmentRectInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(self.alignmentRectInsetsOverride, UIEdgeInsetsZero)) {
        return super.alignmentRectInsets;
    } else {
        return self.alignmentRectInsetsOverride;
    }

}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event

{
    //通过修改bounds 的x,y 值就可以只向X 轴或者Y轴的某一个方向扩展
    
    //当bounds 的X 为负,Y 为0,就只向X的正方向扩展点击区域,反之亦然
    
    //当bounds 的Y 为负,X 为0,就只向Y的正方向扩展点击区域,反之亦然
    
    //当bounds 的Y 为0,X 为0,widthDelta,heightDelta来控制扩大的点击区域 ,这个是同时向X 轴正负方向或者同时向Y轴的正负方向
    
    CGRect bounds = self.bounds;
    
    //90 是希望的X 轴或者Y轴方向的点击区域的宽度或者高度
    
    CGFloat widthDelta = bounds.size.width ;
    
    CGFloat heightDelta =  bounds.size.height ;
    
    bounds = CGRectInset(bounds, -0.5*widthDelta, -0.5* heightDelta);//注意这里是负数，扩大了之前的bounds的范围
    
    return CGRectContainsPoint(bounds, point);
    
}

@end
