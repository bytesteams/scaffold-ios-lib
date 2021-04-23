//
//  MDSearchBar.m
//  MDHealth
//
//  Created by 林志军 on 2020/8/3.
//  Copyright © 2020 startgo. All rights reserved.
//

#import "MDSearchBar.h"

@implementation MDSearchBar


-(void)configPlaceholder:(NSString *)placeholder tintColor:(UIColor *)tintColor backgourndColor:(UIColor *)bgColoir fontSize:(CGFloat)fontSize{
    
    self.placeholder = placeholder;
    self.tintColor = tintColor;
    
    [self setBackgroundImage:[UIImage new]];
    [self setTranslucent:YES];
    //设置背景色
    [self setBackgroundColor:bgColoir];
    
    UITextField * searchField = nil;
    if (@available(iOS 13.0, *)) {
        searchField = self.searchTextField;
    }else {
        searchField = [self valueForKey:@"_searchField"];
    }
    searchField.backgroundColor = bgColoir;
    
    searchField.font = [UIFont systemFontOfSize:fontSize];
    
    NSMutableAttributedString *arrStr = [[NSMutableAttributedString alloc] initWithString:searchField.placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:kPlaceholderColor}];
    searchField.attributedPlaceholder = arrStr;
}
@end
