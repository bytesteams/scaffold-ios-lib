//
//  CSGAlertView.h
//  AXWY
//
//  Created by lzj on 2018/1/10.
//  Copyright © 2018年 CSG. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^cancleBlock)(void);
typedef void(^ensureBlock)(void);

typedef void(^firstBtnBlock)(void);
typedef void(^secondBtnBlock)(void);

typedef void(^thirdBlock)(void);
typedef void(^clearBlock)(void);


@interface CSGAlertView : NSObject
+(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message InController:(UIViewController * )vc ensureClick :(ensureBlock)ensureBlock cancelClick:(cancleBlock)cancelBlock;

+(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message InController:(UIViewController * )vc ensureTitle:(NSString *)ensureTitle ensureClick :(ensureBlock)ensureBlock  cancelTitle:(NSString *)cancelTitle cancelClick:(cancleBlock)cancelBlock;

+(void)showActionSheetWithTitle : (NSString *)title andMessage: (NSString *)message nController:(UIViewController * )vc firstBtnTitle :(NSString *)firstTitle secondBtnTitle:(NSString*)secondTitle firstBtnClick :(firstBtnBlock)firstBtnBlock secondBtnClick:(secondBtnBlock)secondBtnBlock;
//3个
+(void)showActionSheetWithTitle : (NSString *)title andMessage: (NSString *)message nController:(UIViewController * )vc firstBtnTitle :(NSString *)firstTitle secondBtnTitle:(NSString*)secondTitle thirdTitle:(NSString *)thirdTitle  firstBtnClick :(firstBtnBlock)firstBtnBlock secondBtnClick:(secondBtnBlock)secondBtnBlock thirdBtnClick :(thirdBlock)thirdBlock clearBtnClick :(clearBlock)clearBlock ;
@end
