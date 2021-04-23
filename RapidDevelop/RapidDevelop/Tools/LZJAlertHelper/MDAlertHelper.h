//
//  MDAlertHelper.h
//  MDHealth
//
//  Created by 林志军 on 2020/8/11.
//  Copyright © 2020 startgo. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^handelDoneBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface MDAlertHelper : NSObject


+(instancetype)shareManager;

-(void)showDoneAlertViewIn:(nullable UIView *)view message:(NSString *)msg :(handelDoneBlock)doneBlock;

-(void)showSelectAlertViewIn:(nullable UIView *)view message:(NSString *)msg :(handelDoneBlock)doneBlock;

-(void)showEnsureAlertView:(nullable UIView *)view message:(NSString *)msg :(handelDoneBlock)doneBlock;

@end

NS_ASSUME_NONNULL_END
