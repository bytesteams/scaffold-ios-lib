//
//  AppleSignTools.h
//  MDHealth
//
//  Created by 林志军 on 2020/12/14.
//  Copyright © 2020 startgo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^handelAuthorizationBlock)(NSString * _Nonnull userId);

NS_ASSUME_NONNULL_BEGIN

@interface AppleSignTools : NSObject

+(instancetype)sharedManager;

-(void)authorization;


@property(nonatomic,copy)handelAuthorizationBlock authoBlock;

@end

NS_ASSUME_NONNULL_END
