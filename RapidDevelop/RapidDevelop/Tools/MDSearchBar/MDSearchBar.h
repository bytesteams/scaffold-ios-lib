//
//  MDSearchBar.h
//  MDHealth
//
//  Created by 林志军 on 2020/8/3.
//  Copyright © 2020 startgo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDSearchBar : UISearchBar
-(void)configPlaceholder:(NSString *)placeholder tintColor:(UIColor *)tintColor  backgourndColor:(UIColor *)bgColoir fontSize:(CGFloat)fontSize;
@end

NS_ASSUME_NONNULL_END
