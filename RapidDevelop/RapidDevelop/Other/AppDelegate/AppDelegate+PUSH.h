//
//  AppDelegate+PUSH.h
//  MDHealth
//
//  Created by 林志军 on 2020/7/29.
//  Copyright © 2020 林志军. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (PUSH)<UIApplicationDelegate, UNUserNotificationCenterDelegate>
-(void)initPushAppDelegate : (UIApplication *)application withOptions:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END
