//
//  MDLocationTool.h
//  MDHealth
//
//  Created by 林志军 on 2020/8/7.
//  Copyright © 2020 startgo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^locationBlock)(NSString * _Nullable province,NSString * _Nullable city , NSString * _Nullable region);

NS_ASSUME_NONNULL_BEGIN

@interface MDLocationTool : NSObject
+(instancetype)sharedManager;
-(void)getLocation;
@property(nonatomic,copy)locationBlock locationSuccess;
@end

NS_ASSUME_NONNULL_END
