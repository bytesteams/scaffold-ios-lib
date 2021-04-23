//
//  LZJTextTool.m
//
//  Created by 林志军 on 17/3/1.
//  Copyright © 2017年 naoxin_Ltd. All rights reserved.
//

#import "LZJTextTool.h"

@implementation LZJTextTool

+(void )labelAddImage:(UIImage *)image bounds:(CGRect)bounds index:(NSInteger)index str:(NSString *)str inLabel:(UILabel *)label {
    
    if (kEmptyStr(label.text)) {
        label.text = @" ";
    }
    
    NSMutableAttributedString * attrStr ;
    if (label.attributedText) {
        attrStr = [[NSMutableAttributedString alloc]initWithAttributedString:label.attributedText];
    }else{
        attrStr = [[NSMutableAttributedString alloc] initWithString:label.text];
    }
    
    // 创建一个文字附件对象
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;  //设置图片源
    textAttachment.bounds = bounds;  //设置图片位置和大小
    // 将文字附件转换成属性字符串
    NSAttributedString *attachmentAttrStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
    // 将转换成属性字符串插入到目标字符串
    [attrStr insertAttributedString:attachmentAttrStr atIndex:index];

    label.attributedText = attrStr;
}

+(void)changeFont:(UIFont*)font str:(NSString *)str inLabel:(UILabel *)label{
    
    if (kEmptyStr(label.text)) {
        label.text = @" ";
    }
    
    NSMutableAttributedString * attrStr ;
    
    if (label.attributedText) {
         attrStr = [[NSMutableAttributedString alloc]initWithAttributedString:label.attributedText];
    }else{
        attrStr = [[NSMutableAttributedString alloc] initWithString:label.text];
    }
   
    [attrStr addAttribute:NSFontAttributeName
                    value:font
                    range:[label.text rangeOfString:str]];
    
    label.attributedText = attrStr;
}


+(void)changeColor:(UIColor *)color str:(NSString *)str inLabel:(UILabel *)label{
    
    if (kEmptyStr(label.text)) {
        label.text = @" ";
    }
    
    NSMutableAttributedString * attrStr ;
    
    if (label.attributedText) {
        attrStr = [[NSMutableAttributedString alloc]initWithAttributedString:label.attributedText];
    }else{
        attrStr = [[NSMutableAttributedString alloc] initWithString:label.text];
    }
    
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:color
                    range:[label.text rangeOfString:str]];
    label.attributedText = attrStr;
}

+(void)chanegeLinespace:(CGFloat)space inLabel:(UILabel *)label{
    
    NSLog(@"%ld",(long)label.textAlignment)
    
    if (kEmptyStr(label.text)) {
        label.text = @" ";
    }
    
    NSMutableAttributedString * attrStr ;
    
    if (label.attributedText) {
        attrStr = [[NSMutableAttributedString alloc]initWithAttributedString:label.attributedText];
    }else{
        attrStr = [[NSMutableAttributedString alloc] initWithString:label.text];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:space];
   
    [attrStr addAttribute:NSParagraphStyleAttributeName
                    value:paragraphStyle
                    range:NSMakeRange(0, label.text.length)];
    
   
     label.attributedText = attrStr;
}

+(void)chanegeWordspace:(CGFloat)space inLabel:(UILabel *)label{

    if (kEmptyStr(label.text)) {
        label.text = @" ";
    }
    
    NSMutableAttributedString * attrStr ;
    
    if (label.attributedText) {
        attrStr = [[NSMutableAttributedString alloc]initWithAttributedString:label.attributedText];
    }else{
        attrStr = [[NSMutableAttributedString alloc] initWithString:label.text];
    }
    
    [attrStr addAttribute:NSKernAttributeName value:@(space) range:NSMakeRange(0, label.text.length)];
    label.attributedText = attrStr;
}
 
@end
