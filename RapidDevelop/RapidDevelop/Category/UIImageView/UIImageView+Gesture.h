//
//  UIImageView+Gesture.h
//  MDHealth
//
//  Created by 林志军 on 2020/9/8.
//  Copyright © 2020 startgo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Gesture)<UIGestureRecognizerDelegate>
- (void)showBigImageInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
