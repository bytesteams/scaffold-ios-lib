//
//  LZJBaseViewController.m
//  AXWY
//
//  Created by lzj on 2017/12/5.
//  Copyright © 2017年 LZJ. All rights reserved.
//

#import "LZJBaseViewController.h"


@interface LZJBaseViewController ()
@property(nonatomic,strong)WRCustomNavigationBar *customNavBar;
@end

@implementation LZJBaseViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];   
}


/* 使用方法
  1继承 basevc
  2.在viewdidload :
 [self setupNavBar];
 [self.view insertSubview:self.customNavBar aboveSubview:_tableView];
 //隐藏自定义导航
 [self.customNavBar wr_setBackgroundAlpha:0];
 
 3.上滑显示导航就要在在scrollViewDidScroll
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
 {
     CGFloat offsetY = scrollView.contentOffset.y;

     if (offsetY > NAVBAR_COLORCHANGE_POINT)
     {
         CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / kNavBarHeight;
         [self.customNavBar wr_setBackgroundAlpha:alpha];
         self.customNavBar.titleLabelColor = RGB_Alpha(66, 66, 66, alpha);
         
     }
     else
     {
         [self.customNavBar wr_setBackgroundAlpha:0];
         self.customNavBar.titleLabelColor = RGB_Alpha(66, 66, 66, 0);
     }
 }
 */
 

//自定义导航栏
- (void)setupNavBar
{
    [self.view addSubview:self.customNavBar];
    
    // 设置自定义导航栏背景图片
    self.customNavBar.barBackgroundImage = [LZJPublicUtility imageWithColor:[UIColor whiteColor] size:CGSizeMake(kScreenWidth, kNavBarHeight)];
    
    // 设置自定义导航栏标题颜色
    self.customNavBar.titleLabelColor = kText171;
    
    if (self.navigationController.childViewControllers.count != 1) {
        [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"navBack_black"]];
    }
    
}

- (WRCustomNavigationBar *)customNavBar
{
    if (_customNavBar == nil) {
        _customNavBar = [WRCustomNavigationBar CustomNavigationBar];
        [_customNavBar wr_setBottomLineHidden:YES];
    }
    return _customNavBar;
}

-(void)refreshView{
    
}

@end
