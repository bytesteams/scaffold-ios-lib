//
//  MDScrollView.m
//  MDHealth
//
//  Created by 林志军 on 2020/9/24.
//  Copyright © 2020 startgo. All rights reserved.
//

#import "MDScrollView.h"

@implementation MDScrollView

//解决滑动返回冲突
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
    CGPoint location = [gestureRecognizer locationInView:self];
    
    if (velocity.x > 0.0f&&(int)location.x%(int)[UIScreen mainScreen].bounds.size.width<30) {
        return NO;
    }
    return YES;
}

@end
