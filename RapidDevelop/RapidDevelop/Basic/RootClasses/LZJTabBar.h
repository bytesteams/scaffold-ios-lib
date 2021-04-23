//
//  LZJTabBar.h
//  AXWY
//
//  Created by lzj on 2018/5/29.
//  Copyright © 2018年 CSG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LZJTabBar ;
@protocol MyTabBarDelegate <NSObject>

-(void)middleButtonClick:(LZJTabBar *)tabBar;

@end
@interface LZJTabBar : UITabBar
@property (nonatomic, weak) UIButton *labelButton;
@property(nonatomic, weak) id<MyTabBarDelegate> myDelegate;
@end
