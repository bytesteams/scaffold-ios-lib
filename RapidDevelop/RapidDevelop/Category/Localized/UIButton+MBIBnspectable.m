//
//  UIButton+MBIBnspectable.m
//  iBestProduct
//
//  Created by xiekunpeng on 2018/6/19.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import "UIButton+MBIBnspectable.h"

@implementation UIButton (MBIBnspectable)
- (void)setLocalized:(NSString *)localized {
    [self setTitle:kLocalized(localized) forState:UIControlStateNormal];
}


- (NSString *)localized {
    return self.titleLabel.text;
}


@end
