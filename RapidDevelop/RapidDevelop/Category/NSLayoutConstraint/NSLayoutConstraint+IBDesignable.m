//
//  NSLayoutConstraint+IBDesignable.m
//  SayHi
//
//  Created by lzj on 2019/10/30.
//  Copyright © 2019 ledonghuyu.com. All rights reserved.
//

#import "NSLayoutConstraint+IBDesignable.h"




@implementation NSLayoutConstraint (IBDesignable)
-(void)setWidthScreen:(BOOL)widthScreen{
    if (widthScreen) {
        self.constant = kFitW(self.constant);
    }else{
        self.constant = self.constant;
    }
}

-(BOOL)widthScreen{
    return self.widthScreen;
}
@end
