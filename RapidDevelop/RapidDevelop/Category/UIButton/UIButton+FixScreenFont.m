//
//  UIButton+FixScreenFont.m
//  SayHi
//
//  Created by lzj on 2019/11/4.
//  Copyright © 2019 ledonghuyu.com. All rights reserved.
//

#import "UIButton+FixScreenFont.h"



@implementation UIButton (FixScreenFont)

- (void)setFixFont:(float)font{
    
    if (font > 0 ) {
        self.titleLabel.font = kFont(font);
    }else{
        self.titleLabel.font = self.titleLabel.font;
    }
}

- (float )fixFont{
    return self.fixFont;
}

@end
