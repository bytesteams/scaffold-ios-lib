//
//  CSGAlertView.m
//  AXWY
//
//  Created by lzj on 2018/1/10.
//  Copyright © 2018年 CSG. All rights reserved.
//

#import "CSGAlertView.h"
#import "TBActionSheet.h"
#import "TBAlertController.h"
@implementation CSGAlertView

+(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message InController:(UIViewController *)vc ensureClick:(ensureBlock)ensureBlock cancelClick:(cancleBlock)cancelBlock{
    TBAlertController *controller = [TBAlertController alertControllerWithTitle:title message:message preferredStyle:TBAlertControllerStyleAlert];
    TBAlertAction *cancel = [TBAlertAction actionWithTitle:kLocalized(@"取消") style: TBAlertActionStyleDefault handler:^(TBAlertAction * _Nonnull action) {
        if (cancelBlock) {
            cancelBlock();
        }
    }];
    
    TBAlertAction *ensure = [TBAlertAction actionWithTitle:kLocalized(@"确定") style: TBAlertActionStyleDefault handler:^(TBAlertAction * _Nonnull action) {
        if (ensureBlock) {
            ensureBlock();
        }
    }];
    [controller addAction:cancel];
    [controller addAction:ensure];
    [vc presentViewController:controller animated:YES completion:nil];
}

+(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message InController:(UIViewController * )vc ensureTitle:(NSString *)ensureTitle ensureClick :(ensureBlock)ensureBlock  cancelTitle:(NSString *)cancelTitle cancelClick:(cancleBlock)cancelBlock{
    TBAlertController *controller = [TBAlertController alertControllerWithTitle:title message:message preferredStyle:TBAlertControllerStyleAlert];
    TBAlertAction *cancel = [TBAlertAction actionWithTitle:cancelTitle style: TBAlertActionStyleDefault handler:^(TBAlertAction * _Nonnull action) {
        if (cancelBlock) {
            cancelBlock();
        }
    }];
    
    TBAlertAction *ensure = [TBAlertAction actionWithTitle:ensureTitle style: TBAlertActionStyleDefault handler:^(TBAlertAction * _Nonnull action) {
        if (ensureBlock) {
            ensureBlock();
        }
    }];
    [controller addAction:cancel];
    [controller addAction:ensure];
    [vc presentViewController:controller animated:YES completion:nil];
}


+(void)showActionSheetWithTitle:(NSString *)title andMessage:(NSString *)message nController:(UIViewController *)vc firstBtnTitle:(NSString *)firstTitle secondBtnTitle:(NSString *)secondTitle firstBtnClick:(firstBtnBlock)firstBtnBlock secondBtnClick:(secondBtnBlock)secondBtnBlock{
    TBAlertController *controller = [TBAlertController alertControllerWithTitle:title message:message preferredStyle:TBAlertControllerStyleActionSheet];
    TBAlertAction *first = [TBAlertAction actionWithTitle:firstTitle style: TBAlertActionStyleDefault handler:^(TBAlertAction * _Nonnull action) {
        if (firstBtnBlock) {
            firstBtnBlock();
        }
    }];
    
    TBAlertAction *second = [TBAlertAction actionWithTitle:secondTitle style: TBAlertActionStyleDefault handler:^(TBAlertAction * _Nonnull action) {
        if (secondBtnBlock) {
            secondBtnBlock();
        }
    }];
    
    TBAlertAction *cancel = [TBAlertAction actionWithTitle:kLocalized(@"取消") style: TBAlertActionStyleCancel handler:^(TBAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:first];
    [controller addAction:second];
    [controller addAction:cancel];
    [vc presentViewController:controller animated:YES completion:nil];
}

+(void)showActionSheetWithTitle:(NSString *)title andMessage:(NSString *)message nController:(UIViewController *)vc firstBtnTitle:(NSString *)firstTitle secondBtnTitle:(NSString *)secondTitle thirdTitle:(NSString *)thirdTitle firstBtnClick:(firstBtnBlock)firstBtnBlock secondBtnClick:(secondBtnBlock)secondBtnBlock thirdBtnClick:(thirdBlock)thirdBlock clearBtnClick:(clearBlock)clearBlock{
    TBAlertController *controller = [TBAlertController alertControllerWithTitle:title message:message preferredStyle:TBAlertControllerStyleActionSheet];
    
    TBAlertAction *first = [TBAlertAction actionWithTitle:firstTitle style: TBAlertActionStyleDefault handler:^(TBAlertAction * _Nonnull action) {
        if (firstBtnBlock) {
            firstBtnBlock();
        }
    }];
    
    TBAlertAction *second = [TBAlertAction actionWithTitle:secondTitle style: TBAlertActionStyleDefault handler:^(TBAlertAction * _Nonnull action) {
        if (secondBtnBlock) {
            secondBtnBlock();
        }
    }];
    
    TBAlertAction *third = [TBAlertAction actionWithTitle:thirdTitle style: TBAlertActionStyleDefault handler:^(TBAlertAction * _Nonnull action) {
        if (thirdBlock) {
            thirdBlock();
        }
    }];
    

    
    TBAlertAction *cancel = [TBAlertAction actionWithTitle:kLocalized(@"取消") style: TBAlertActionStyleCancel handler:^(TBAlertAction * _Nonnull action) {
        
    }];
    
    [controller addAction:first];
    [controller addAction:second];
    [controller addAction:third];
    [controller addAction:cancel];

    [vc presentViewController:controller animated:YES completion:nil];
}
@end
