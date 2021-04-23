//
//  MDAlertView.h
//  MDHealth
//
//  Created by 林志军 on 2020/9/16.
//  Copyright © 2020 startgo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^handelDoneBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface MDAlertView : UIView
-(void)showSelectAlertView:(NSString *)msg inView:(UIView *)view WithBlock :(handelDoneBlock)doneBlock;


-(void)showDoneAlertView:(NSString *)msg inView:(UIView *)view WithBlock :(handelDoneBlock)doneBlock;
@end

NS_ASSUME_NONNULL_END
