//
//  UIImageView+Gesture.m
//  MDHealth
//
//  Created by 林志军 on 2020/9/8.
//  Copyright © 2020 startgo. All rights reserved.
//

#import "UIImageView+Gesture.h"

@implementation UIImageView (Gesture)

static CGRect oldframe;

- (void)showBigImageInView:(UIView *)view {
    
    UIImageView *currentImageview = self;
    UIImage *image = currentImageview.image;
   
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backgroundView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    //当前imageview的原始尺寸->将像素currentImageview.bounds由currentImageview.bounds所在视图转换到目标视图window中，返回在目标视图window中的像素值
    oldframe = [currentImageview convertRect:currentImageview.bounds toView:view];
    //    [backgroundView setBackgroundColor:[UIColor colorWithRed:107 green:107 blue:99 alpha:0.6]];
    
    //此时视图不会显示
    [backgroundView setAlpha:0];
    //将所展示的imageView重新绘制在Window中
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
    [imageView setUserInteractionEnabled:YES];
    [imageView setImage:image];
    [imageView setTag:10];
    [backgroundView addSubview:imageView];
    [view addSubview:backgroundView];
    
    //向imageView添加手势 缩放图片
    UIPanGestureRecognizer *pan =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    //添加到指定视图
    [imageView addGestureRecognizer:pan];
    UIPinchGestureRecognizer *pinch =[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
    [imageView addGestureRecognizer:pinch];
    UIRotationGestureRecognizer *rotation =[[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotationAction:)];
    [imageView addGestureRecognizer:rotation];
    pinch.delegate = self;
    rotation.delegate = self;
    
    //添加点击事件同样是类方法 -> 作用是再次点击回到初始大小
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [backgroundView addGestureRecognizer:tapGestureRecognizer];
    
    //动画放大所展示的ImageView
    [UIView animateWithDuration:0.4 animations:^{
        CGFloat y,width,height;
        y = ([UIScreen mainScreen].bounds.size.height - image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) * 0.5;
        width = [UIScreen mainScreen].bounds.size.width;
        //高度 根据图片宽高比设置
        height = image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width;
        [imageView setFrame:CGRectMake(0, y, width, height)];
        //重要！ 将视图显示出来
        [backgroundView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
    
}

/**
 *  恢复imageView原始尺寸
 *
 *  @param tap 点击事件
 */
- (void)hideImageView:(UITapGestureRecognizer *)tap{
    UIView *backgroundView = tap.view;
    //原始imageview
    UIImageView *imageView = [tap.view viewWithTag:10];
    //恢复
    [UIView animateWithDuration:0.4 animations:^{
        [imageView setFrame:oldframe];
        [backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        //完成后操作->将背景视图删掉
        [backgroundView removeFromSuperview];
    }];
}

//创建平移事件
-(void)panAction:(UIPanGestureRecognizer *)pan
{
    UIImageView *imageView = (UIImageView *)pan.view;
    if (!imageView) {
        return ;
    }
    //获取手势的位置
    CGPoint position =[pan translationInView:imageView];
    
    //通过stransform 进行平移交换
    imageView.transform = CGAffineTransformTranslate(imageView.transform, position.x, position.y);
    //将增量置为零
    [pan setTranslation:CGPointZero inView:imageView];
}

//添加捏合事件
-(void)pinchAction:(UIPinchGestureRecognizer *)pinch
{
    UIImageView *imageView = (UIImageView *)pinch.view;
    if (!imageView) {
        return ;
    }
    //通过 transform(改变) 进行视图的视图的捏合
    imageView.transform = CGAffineTransformScale(imageView.transform, pinch.scale, pinch.scale);
    //设置比例 为 1
    pinch.scale = 1;
}

//旋转事件
-(void)rotationAction:(UIRotationGestureRecognizer *)rote
{
    UIImageView *imageView = (UIImageView *)rote.view;
    if (!imageView) {
        return ;
    }
    //通过transform 进行旋转变换
    imageView.transform = CGAffineTransformRotate(imageView.transform, rote.rotation);
    //将旋转角度 置为 0
    rote.rotation = 0;
}

#pragma gesture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
@end
