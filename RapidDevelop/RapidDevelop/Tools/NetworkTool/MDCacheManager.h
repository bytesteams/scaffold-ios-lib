//
//  MDCacheManager.h
//  MDHealth
//
//  Created by 林志军 on 2020/7/29.
//  Copyright © 2020 stargo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDCacheManager : NSObject

/**
 *  单利方法
 *
 *  @return 实例对象
 */
+(instancetype)shareManager;


// 缓存
-(BOOL)saveJsonResponseToCacheFile:(id)jsonResponse andURL:(NSString *)URL;

//获取缓存数据
-(id )cacheJsonWithURL:(NSString *)URL;

//获取缓存文件地址
- (NSString *)cacheFilePathWithURL:(NSString *)URL;

 //检查目录是否存在,不存在则创建
-(void)checkDirectory:(NSString *)path;

//创建目录
-(void)createBaseDirectoryAtPath:(NSString *)path;

//禁止icloud备份
- (void)addDoNotBackupAttribute:(NSString *)path;

-(BOOL)compareCache:(NSString *)url WithResponseObject:(id)responseObject;
@end

NS_ASSUME_NONNULL_END
