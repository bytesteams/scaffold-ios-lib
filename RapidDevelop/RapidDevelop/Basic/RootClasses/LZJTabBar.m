//
//  LZJTabBar.m
//  AXWY
//
//  Created by lzj on 2018/5/29.
//  Copyright © 2018年 CSG. All rights reserved.
//

#import "LZJTabBar.h"

@interface LZJTabBar ()<UITabBarDelegate>
@property (nonatomic, weak) UIButton *plusAddButton;

@end

@implementation LZJTabBar

- (UIButton *)plusAddButton{
    
    if (!_plusAddButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tabbar-square"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabbar-square"] forState:UIControlStateHighlighted];
        
        // 一定要记得设置尺寸
        btn.size = CGSizeMake(42, 42);
        [self addSubview:btn];
        _plusAddButton = btn;
        [_plusAddButton addTarget:self action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _plusAddButton;
}

//-(UIButton *)labelButton
//{
//    if (_labelButton==nil) {
//        UIButton *btn=[[UIButton alloc]init];
//        [btn setTitle:@"无忧商家" forState:UIControlStateNormal];
//
//        btn.titleLabel.font=[UIFont systemFontOfSize:11];
//        [btn setTitleColor:RGB(122, 126, 131) forState:UIControlStateNormal];
//        [btn sizeToFit];
//        _labelButton=btn;
//        [_labelButton setTitleColor:RGB(136, 175, 245) forState:UIControlStateSelected];
//        [btn addTarget:self action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_labelButton];
//
//    }
//    return _labelButton;
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 获取子按钮总数
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = kScreenWidth / 5;
    CGFloat h = 49;
    
    int i = 0;
    // 遍历所有的tabBarButton
    for (UIControl *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (i == 2) {
                i = 3;
            }else if (i == 3){
                i = 4;
            }
            x = i * w;
            //  设置UITabBarButton位置
            
            tabBarButton.frame = CGRectMake(x, y, w, h);
            tabBarButton.tag = i;
            
            i++;
       
        }
    }
    
    // 设置加号按钮位置
    self.plusAddButton.center = CGPointMake(kScreenWidth * 0.5, h * 0.5 );
//    self.labelButton.center=self.plusAddButton.center;
//
//    self.labelButton.y = 28.2;
   
}



-(void)plusButtonClick{
//    _labelButton.selected = YES;
    if ([self.myDelegate respondsToSelector:@selector(middleButtonClick:)]) {
        [self.myDelegate middleButtonClick:self];
    }
}

@end
