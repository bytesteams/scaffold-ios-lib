//
//  MDConst.h
//  MDHealth
//
//  Created by 林志军 on 2020/7/29.
//  Copyright © 2020 林志军. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDConst : NSObject
//notification
//企业微信登录成功
extern NSString *const NotificationWWKAuthSuccess;

extern NSString *const NotificationDidReceiveNewMessage;

extern NSString *const NotificationDidUpdateUserMsg ;

extern NSString *const NotificationAlipaySuccess ;

extern NSString *const NotificationAlipayCancel ;

extern NSString *const NotificationAddressDelete ;

//keys

extern NSString *const AppleId;

extern NSString *const AliPayKey;

//微信
extern NSString *const WechatID;
extern NSString *const WechatKey;

//企业微信
extern NSString *const WWKSchema;
extern NSString *const WWKCropId;
extern NSString *const WWKAgentId;
extern NSString *const WWKSecret;

extern NSString *const GeTuiID;
extern NSString *const GeTuiKey;
extern NSString *const GeTuiSecret;

extern NSString *const UMAppKey;

extern NSString *const TIMAppId;

extern NSString *const JMLinkAppKey;

extern NSString *const ZCAppKey;

extern NSString *const BuglyId;

@end

NS_ASSUME_NONNULL_END
