//
//  LZJImageBrowserHelper.h
//
//  Created by 林志军 on 17/3/1.
//  Copyright © 2017年 naoxin_Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZJImageBrowserHelper : NSObject

+(void)showPhotoBrowserWithUrls:(NSArray *)urls inVc:(UIViewController *)vc index:(NSInteger)index;

+(void)showPhotoBrowserWithImages:(NSArray *)images inVc:(UIViewController *)vc index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
