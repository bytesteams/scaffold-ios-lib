//
//  LZJCustomButton.m
//  NaoXinFaWu
//
//  Created by 林志军 on 17/3/1.
//  Copyright © 2017年 naoxin_Ltd. All rights reserved.
//

#import "LZJCustomButton.h"

@interface LZJCustomButton(){
    LZJCustomButtonType _type;
    CGSize _imageSize;
    CGFloat _margin;
}

@end

@implementation LZJCustomButton

-(void)setCustomButtonWithType:(LZJCustomButtonType)type imageSize:(CGSize)size margin :(CGFloat)margin{
    //图上文字下
    _type = type;
    _imageSize = size;
    _margin = margin;

    //或者正确的frame -- runloop下一帧(屏幕刷新)
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
                
           
            
        });
    });
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (_type == LZJCustomButtonTypeImageTopTitleBottom) {
            
            self.imageView.frame = CGRectMake(0, 0, _imageSize.width , _imageSize.height);
            self.imageView.centerX = self.width/2;
      
            if ( _margin > 0) {
                self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + _margin, self.width, self.titleLabel.font.lineHeight);
            }else{
                self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + kFitW(5), self.width, self.titleLabel.font.lineHeight);
            }
            
            self.titleLabel.centerX = self.imageView.centerX;
            
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
         
            //图右文字左
        }else if (_type == LZJCustomButtonTypeImageRightTitleLeft){
            
            self.titleLabel.x = 0;

            if ( _margin > 0) {
                self.imageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + _margin, 0, _imageSize.width, _imageSize.height);
                self.imageView.centerY = self.titleLabel.centerY;
                
            }else{
                 self.imageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + kFitW(5), 0, _imageSize.width, _imageSize.height);
                 self.imageView.centerY = self.titleLabel.centerY;
            }

            //修改图片大小
        }else if (_type == LZJCustomButtonTypeImageSize){
            
            self.imageView.size = _imageSize;
            self.imageView.y = (self.height - _imageSize.height)/2;
            
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            self.imageView.clipsToBounds = YES;
           if ( _margin > 0) {
               self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + _margin, self.titleLabel.frame.origin.y, self.titleLabel.width, self.titleLabel.height);

             
                self.titleLabel.centerY = self.imageView.centerY;
            }else{
               self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + kFitW(5),  self.titleLabel.frame.origin.y, self.titleLabel.width, self.titleLabel.height);
                
                 self.titleLabel.centerY = self.imageView.centerY;
            }
            
        }else if ( _type == LZJCustomButtonTypeImageMiddleTitleMiddle){
            
            self.imageView.size = _imageSize;
            self.x = 0;
            self.y  = 0;
            
            self.titleLabel.x = (self.width - self.titleLabel.width)/2 ;
            self.titleLabel.y = (self.height - self.titleLabel.height)/2 ;
        }
    
}

@end
