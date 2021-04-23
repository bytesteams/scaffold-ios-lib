//
//  AppleSignTools.m
//  MDHealth
//
//  Created by 林志军 on 2020/12/14.
//  Copyright © 2020 startgo. All rights reserved.
//

#import "AppleSignTools.h"
#import <AuthenticationServices/AuthenticationServices.h>

@interface AppleSignTools ()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@end

@implementation AppleSignTools

static id instance;

//单例模式
+ (AppleSignTools * )sharedManager{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[AppleSignTools alloc] init];
    });
    return instance;
}


-(void)authorization{
    if (@available(iOS 13.0, *)) {
           // A mechanism for generating requests to authenticate users based on their Apple ID.
           // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
           ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
           // Creates a new Apple ID authorization request.
           // 创建新的AppleID 授权请求
           ASAuthorizationAppleIDRequest *request = appleIDProvider.createRequest;
           // The contact information to be requested from the user during authentication.
           // 在用户授权期间请求的联系信息
           request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
           // A controller that manages authorization requests created by a provider.
           // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
           ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
           // A delegate that the authorization controller informs about the success or failure of an authorization attempt.
           // 设置授权控制器通知授权请求的成功与失败的代理
           controller.delegate = self;
           // A delegate that provides a display context in which the system can present an authorization interface to the user.
           // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
           controller.presentationContextProvider = self;
           // starts the authorization flows named during controller initialization.
           // 在控制器初始化期间启动授权流
           [controller performRequests];
       }
}


#pragma Apple-delegate
//  授权成功地回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){
    
    NSLog(@"授权完成:::%@", authorization.credential);
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", controller);
    NSLog(@"%@", authorization);
    
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
//        NSString *user = appleIDCredential.user;
        // 使用过授权的，可能获取不到以下三个参数
//        NSString *familyName = appleIDCredential.fullName.familyName;
//        NSString *givenName = appleIDCredential.fullName.givenName;
//        NSString *email = appleIDCredential.email;
        NSData *identityToken = appleIDCredential.identityToken;
//        NSData *authorizationCode = appleIDCredential.authorizationCode;
        
        // 服务器验证需要使用的参数
//        NSString *identityTokenStr = [[NSString alloc] initWithData:identityToken encoding:NSUTF8StringEncoding];
        //            NSString *authorizationCodeStr = [[NSString alloc] initWithData:authorizationCode encoding:NSUTF8StringEncoding];
        NSString *userID = appleIDCredential.user;
      
        if (_authoBlock) {
            _authoBlock(userID);
        }
//        _unionId = userID;
//        
//        [self loginWithApple];
        // Create an account in your system.
        // For the purpose of this demo app, store the userIdentifier in the keychain.
        //  需要使用钥匙串的方式保存用户的唯一信息
        //        [YostarKeychain save:KEYCHAIN_IDENTIFIER(@"userIdentifier") data:user];
        
    }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
        // 这个获取的是iCloud记录的账号密码，需要输入框支持iOS 12 记录账号密码的新特性，如果不支持，可以忽略
        // Sign in using an existing iCloud Keychain credential.
        // 用户登录使用现有的密码凭证
        ASPasswordCredential *passwordCredential = authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString *user = passwordCredential.user;
        // 密码凭证对象的密码
        NSString *password = passwordCredential.password;
        
    }else{
        NSLog(@"授权信息均不符");
        
    }
}

//! 授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){
    
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"错误信息：%@", error);
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    }
    
}


//! Tells the delegate from which window it should present content to the user.
//! 告诉代理应该在哪个window 展示内容给用户
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    
    NSLog(@"调用展示window方法：%s", __FUNCTION__);
    // 返回window
    return [LZJPublicUtility getCurrentViewController].view.window;
}

@end
