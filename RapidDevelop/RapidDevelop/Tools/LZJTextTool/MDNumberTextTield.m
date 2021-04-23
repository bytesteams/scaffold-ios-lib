//
//  MDNumberTextTield.m
//  MDHealth
//
//  Created by 林志军 on 2021/2/2.
//  Copyright © 2021 startgo. All rights reserved.
//

#import "MDNumberTextTield.h"


@interface MDNumberTextTield ()<UITextFieldDelegate>

@end

@implementation MDNumberTextTield

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.delegate = self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;

    }
    return  self;
}

- ( BOOL )textField:( UITextField *)textField shouldChangeCharactersInRange:( NSRange )range replacementString:( NSString *)string

{   // 删除按钮
    if (!string.length) return YES;
    // 如果输入不是纯数字或者.,不显示
    if( ![self isPureInt:string] || [string isEqualToString:@"."]) return NO;
    
    return YES;
    
}

- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}
    
@end
