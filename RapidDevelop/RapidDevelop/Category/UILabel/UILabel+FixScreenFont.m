//
//  UILabel+FixScreenFont.m
//  SayHi
//
//  Created by lzj on 2019/10/30.
//  Copyright © 2019 ledonghuyu.com. All rights reserved.
//

#import "UILabel+FixScreenFont.h"

@implementation UILabel (FixScreenFont)

- (void)setFixFont:(float)font{
    
    if (font > 0 ) {
        self.font = kFont(font);
    }else{
        self.font = self.font;
    }
}

- (float )fixFont{
    return self.fixFont;
}

@end
