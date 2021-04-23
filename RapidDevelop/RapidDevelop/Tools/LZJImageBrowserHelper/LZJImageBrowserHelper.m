//
//  LZJImageBrowserHelper.m
//
//  Created by 林志军 on 17/3/1.
//  Copyright © 2017年 naoxin_Ltd. All rights reserved.
//

#import "LZJImageBrowserHelper.h"
#import <IDMPhoto.h>
#import <IDMPhotoBrowser.h>
@implementation LZJImageBrowserHelper


+(void)showPhotoBrowserWithUrls:(NSArray *)urls inVc:(UIViewController *)vc index:(NSInteger)index{
    
    NSArray *photos = [IDMPhoto photosWithURLs:urls];
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    browser.displayDoneButton = NO;
    browser.dismissOnTouch = YES;
    browser.autoHideInterface = NO;
     [browser setInitialPageIndex:index];
    [vc presentViewController:browser animated:YES completion:nil];
}

+(void)showPhotoBrowserWithImages:(NSArray *)images inVc:(UIViewController *)vc index:(NSInteger)index{
    
     NSMutableArray *photos = [NSMutableArray new];
    
    for (UIImage *img in images) {
        IDMPhoto *idmPhoto = [[IDMPhoto alloc]initWithImage:img];
        [photos addObject:idmPhoto];
    }
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    browser.displayDoneButton = NO;
    browser.autoHideInterface = NO;
    browser.dismissOnTouch = YES;
    [browser setInitialPageIndex:index];
    [vc presentViewController:browser animated:YES completion:nil];
}

@end
