//
//  LZJBaseViewController.h
//  AXWY
//
//  Created by lzj on 2017/12/5.
//  Copyright © 2017年 LZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRCustomNavigationBar.h"

@interface LZJBaseViewController : UIViewController
//用于状态改变 刷新界面(比如登录)
-(void)refreshView;
//自定义导航栏
-(void)setupNavBar;

@end
