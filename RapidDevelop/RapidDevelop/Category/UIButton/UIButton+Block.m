//
//  UIButton+Block.m
//  UIButton+Block
//
//  Created by develop on 15/9/17.
//  Copyright (c) 2015年 songhailiang. All rights reserved.
//

#import "UIButton+Block.h"

@implementation UIButton (Block)

static char eventKey;


- (void) handleControlEvent:(UIControlEvents)event withBlock:(void (^)())action {
    objc_setAssociatedObject(self, &eventKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

- (void)callActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &eventKey);
    if (block) {
        block();
    }
}

@end
