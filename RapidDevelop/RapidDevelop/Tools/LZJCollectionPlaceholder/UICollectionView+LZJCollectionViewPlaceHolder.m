//
//  UICollectionView+LZJCollectionViewPlaceHolder.m
//  MDHealth
//
//  Created by 林志军 on 2020/10/15.
//  Copyright © 2020 startgo. All rights reserved.
//

#import "UICollectionView+LZJCollectionViewPlaceHolder.h"
#import "LZJCollectionViewPlaceHolderDelegate.h"

#import <objc/runtime.h>

@interface UICollectionView ()
@property (nonatomic, assign) BOOL scrollWasEnabled;
@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation UICollectionView (LZJCollectionViewPlaceHolder)

- (BOOL)scrollWasEnabled {
    NSNumber *scrollWasEnabledObject = objc_getAssociatedObject(self, @selector(scrollWasEnabled));
    return [scrollWasEnabledObject boolValue];
}

- (void)setScrollWasEnabled:(BOOL)scrollWasEnabled {
    NSNumber *scrollWasEnabledObject = [NSNumber numberWithBool:scrollWasEnabled];
    objc_setAssociatedObject(self, @selector(scrollWasEnabled), scrollWasEnabledObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)placeHolderView {
    return objc_getAssociatedObject(self, @selector(placeHolderView));
}

- (void)setPlaceHolderView:(UIView *)placeHolderView {
    objc_setAssociatedObject(self, @selector(placeHolderView), placeHolderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lzj_reloadData {
    [self reloadData];
    [self lzj_checkEmpty];
}

- (void)lzj_checkEmpty {
    BOOL isEmpty = YES;
    
    id<UICollectionViewDataSource> src = self.dataSource;
    NSInteger sections = 1;
    if ([src respondsToSelector: @selector(collectionView:numberOfItemsInSection:)]) {
       //判断有几个section
        sections = [src numberOfSectionsInCollectionView:self];
    }
    //判断section中 item是否大于0
    for (int i = 0; i<sections; ++i) {
        NSInteger item = [self numberOfItemsInSection:i];
        if (item > 0) {
            isEmpty = NO;
            break;
        }
        
    }
    if (!isEmpty != !self.placeHolderView) {
        if (isEmpty) {
            self.scrollWasEnabled = self.scrollEnabled;
            BOOL scrollEnabled = NO;
            if ([self respondsToSelector:@selector(enableCollectionViewScrollWhenPlaceHolderViewShowing)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wint-conversion"
                scrollEnabled = [self performSelector:@selector(enableCollectionViewScrollWhenPlaceHolderViewShowing)];
#pragma clang diagnostic pop
                if (!scrollEnabled) {
                    NSString *reason = @"There is no need to return  NO for `-enableScrollWhenPlaceHolderViewShowing`, it will be NO by default";
                    NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), reason);
                }
            } else if ([self.delegate respondsToSelector:@selector(enableCollectionViewScrollWhenPlaceHolderViewShowing)]) {
                scrollEnabled = [self.delegate performSelector:@selector(enableCollectionViewScrollWhenPlaceHolderViewShowing)];
                if (!scrollEnabled) {
                    NSString *reason = @"There is no need to return  NO for `-enableScrollWhenPlaceHolderViewShowing`, it will be NO by default";
                   NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), reason);
                }
            }
            self.scrollEnabled = scrollEnabled;
            if ([self respondsToSelector:@selector(makeCollectionViewPlaceHolderView)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wint-conversion"
                self.placeHolderView = [self performSelector:@selector(makeCollectionViewPlaceHolderView)];
#pragma clang diagnostic pop
            } else if ( [self.delegate respondsToSelector:@selector(makeCollectionViewPlaceHolderView)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wint-conversion"
                self.placeHolderView = [self.delegate performSelector:@selector(makeCollectionViewPlaceHolderView)];
#pragma clang diagnostic pop
            } else {
                NSString *selectorName = NSStringFromSelector(_cmd);
                NSString *reason = [NSString stringWithFormat:@"You must implement makePlaceHolderView method in your custom tableView or its delegate class if you want to use %@", selectorName];
                NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), reason);
            }
            self.placeHolderView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            [self addSubview:self.placeHolderView];
        } else {
            self.scrollEnabled = self.scrollWasEnabled;
            [self.placeHolderView removeFromSuperview];
            self.placeHolderView = nil;
        }
    } else if (isEmpty) {
        // Make sure it is still above all siblings.
        [self.placeHolderView removeFromSuperview];
        if ([self respondsToSelector:@selector(makeCollectionViewPlaceHolderView)]) {
            self.placeHolderView = [self performSelector:@selector(makeCollectionViewPlaceHolderView)];
        } else if ( [self.delegate respondsToSelector:@selector(makeCollectionViewPlaceHolderView)]) {
            self.placeHolderView = [self.delegate performSelector:@selector(makeCollectionViewPlaceHolderView)];
        }
        self.placeHolderView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:self.placeHolderView];
    }
}

@end
