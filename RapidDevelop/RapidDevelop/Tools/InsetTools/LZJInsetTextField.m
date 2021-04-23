//
//  LZJInsetTextField.m
//  MDHealth
//
//  Created by 林志军 on 2020/8/5.
//  Copyright © 2020 startgo. All rights reserved.
//

#import "LZJInsetTextField.h"

@implementation LZJInsetTextField

-(CGRect)textRectForBounds:(CGRect)bounds {
    
    CGRect paddedRect = UIEdgeInsetsInsetRect(bounds,self.insets);
    
    if(self.rightViewMode == UITextFieldViewModeAlways ||self.rightViewMode == UITextFieldViewModeUnlessEditing) {
        
        return[self adjustRectWithWidthRightView:paddedRect];
        
    }
    
    return paddedRect;
    
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds {
    
    CGRect paddedRect = UIEdgeInsetsInsetRect(bounds,self.insets);
    
    if(self.rightViewMode == UITextFieldViewModeAlways ||self.rightViewMode == UITextFieldViewModeUnlessEditing) {
        
        return[self adjustRectWithWidthRightView:paddedRect];
        
    }
    
    return paddedRect;
    
}

-(CGRect)editingRectForBounds:(CGRect)bounds {
    
    CGRect paddedRect = UIEdgeInsetsInsetRect(bounds,self.insets);
    
    if(self.rightViewMode == UITextFieldViewModeAlways ||self.rightViewMode == UITextFieldViewModeWhileEditing) {
        
        return[self adjustRectWithWidthRightView:paddedRect];
        
    }
    
    return paddedRect;
    
}

-(CGRect)adjustRectWithWidthRightView:(CGRect)bounds {
    
    CGRect paddedRect = bounds;
    
    paddedRect.size.width -= CGRectGetWidth(self.rightView.frame);
    
    return paddedRect;
    
}


@end
