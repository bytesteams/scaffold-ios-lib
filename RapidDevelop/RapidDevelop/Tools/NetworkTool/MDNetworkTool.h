//
//  MDNetworkTool.h
//  MDHealth
//
//  Created by 林志军 on 2020/7/24.
//  Copyright © 2020 stargo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"



NS_ASSUME_NONNULL_BEGIN

//成功block 包含处理过的model 和 modelArray
typedef void(^successBlock)(NSMutableArray * _Nullable modelArray , id _Nullable model, id _Nullable responseObject);

//错误回调
typedef void(^failureBlock)(NSURLSessionDataTask * task , NSError * error);

/**缓存的block*/
typedef void(^cacheBlock)(NSMutableArray * _Nullable modelArray , id _Nullable model, id _Nullable responseObject);

@interface MDNetworkTool : NSObject

//单例
+(instancetype)shareManager;

/**
*  普通请求
*
*  @param isShowhud   是否显示HUD
*  @param view     显示HUD的View
*  @param type    0post 1get
*  @param parameter        请求参数
*  @param header 额外请求头
*  @param modelClass  modelClass
*  @param url     url
*  @param successBlock     成功回调
*  @param failureBlock     失败回调
*/
-(void)MDRequestWithHud:(BOOL)isShowhud In:(UIView * __nullable)view type:(NSInteger)type Parameter :(NSMutableDictionary * __nullable)parameter header:(NSDictionary * __nullable)header model:(id __nullable)modelClass url :(NSString *)url  successBlock :(successBlock)successBlock failureBlock:(failureBlock)failureBlock;


/**
*  带缓存请求
*
*  @param isShowhud   是否显示HUD
*  @param view     显示HUD的View
*  @param parameter        请求参数
*  @param header 额外请求头
*  @param modelClass  modelClass
*  @param url     url
*  @param isCache     是否缓存
*  @param successBlock     成功回调
*  @param failureBlock     失败回调
*/
-(void)MDCacheRequestWithHud:(BOOL)isShowhud In:(UIView * __nullable)view type:(NSInteger)type Parameter :(NSMutableDictionary * __nullable)parameter header:(NSDictionary * __nullable)header model:(id __nullable)modelClass url :(NSString *)url cacheBlock:(cacheBlock)cacheBlock successBlock :(successBlock)successBlock failureBlock:(failureBlock)failureBlock;


/**
*  普通请求不带登录验证
*
*  @param isShowhud   是否显示HUD
*  @param view     显示HUD的View
*  @param type    0post 1get
*  @param parameter        请求参数
*  @param header 额外请求头
*  @param modelClass  modelClass
*  @param url     url
*  @param successBlock     成功回调
*  @param failureBlock     失败回调
*/
-(void)MDNoLoginRequestWithHud:(BOOL)isShowhud In:(UIView * __nullable)view type:(NSInteger)type Parameter :(NSMutableDictionary * __nullable)parameter header:(NSDictionary * __nullable)header model:(id __nullable)modelClass url :(NSString *)url  successBlock :(successBlock)successBlock failureBlock:(failureBlock)failureBlock;

//取消请求
-(void)cancelRequest;

@end

NS_ASSUME_NONNULL_END
