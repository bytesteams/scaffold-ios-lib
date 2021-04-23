//
//  LZJCollectionViewPlaceHolderDelegate.h
//  MDHealth
//
//  Created by 林志军 on 2020/10/15.
//  Copyright © 2020 startgo. All rights reserved.
//


@protocol LZJCollectionViewPlaceHolderDelegate <NSObject>

@required
/*!
 @brief  make an empty overlay view when the tableView is empty
 @return an empty overlay view
 */
- (UIView *)makeCollectionViewPlaceHolderView;

@optional
/*!
 @brief enable tableView scroll when place holder view is showing, it is disabled by default.
 @attention There is no need to return  NO, it will be NO by default
 @return enable tableView scroll, you can only return YES
 */
- (BOOL)enableCollectionViewScrollWhenPlaceHolderViewShowing;

@end
