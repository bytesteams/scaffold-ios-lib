//
//  LZJCustomButton.h
//  NaoXinFaWu
//
//  Created by 林志军 on 17/3/1.
//  Copyright © 2017年 naoxin_Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LZJCustomButtonType){
    LZJCustomButtonTypeImageTopTitleBottom = 0,     //图片上,文字下
    LZJCustomButtonTypeImageRightTitleLeft = 1,     //图片右,文字左
    LZJCustomButtonTypeImageSize = 2   ,              //图片大小 (默认图片做左边文字右)
     LZJCustomButtonTypeImageMiddleTitleMiddle =3     //全部居中
};

@interface LZJCustomButton : UIButton


-(void)setCustomButtonWithType:(LZJCustomButtonType)type imageSize:(CGSize)size margin :(CGFloat)margin;


@end
