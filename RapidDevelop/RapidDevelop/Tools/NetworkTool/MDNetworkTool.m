//
//  MDNetworkTool.m
//  MDHealth
//
//  Created by 林志军 on 2020/7/24.
//  Copyright © 2020 stargo. All rights reserved.
//

#import "MDNetworkTool.h"
#import "NSString+Hash.h"
#import "MJExtension.h"
#import "MDErrorView.h"
#import "MDCacheManager.h"
#import "MDAlertHelper.h"
typedef NS_ENUM(NSInteger,SGNetworkResultType){
    SGNetworkResultTypeSuccess = 200,      //成功
    //    SGNetworkResultTypeFailure = 0,      //失败
    SGNetworkResultTypeNotlogin = 401      //未登录
    //    SGNetworkResultTypeUpdate = 4      //更新
    
};

@interface MDNetworkTool (){
    
    AFHTTPSessionManager *_sessionManager;
}

@end

@implementation MDNetworkTool

static id toolManager;
//单例模式
+ (MDNetworkTool * )shareManager{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        toolManager = [[MDNetworkTool alloc] init];
    });
    return toolManager;
}

-(instancetype)init{
    
    if (self = [super init]) {
        _sessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:HOST]];
        [self configHttpHeader];
    }
    
    return self;
}

//初始化AFN 请求头
-(void)configHttpHeader{
    _sessionManager.requestSerializer.timeoutInterval = 60.f;
    
    _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    
    [_sessionManager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    
    [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    NSString *version = kAppVersion;
    version = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    [_sessionManager.requestSerializer setValue:version forHTTPHeaderField:@"versionIos"];
    
    
    if (!kEmptyStr(USERDEFAULT(@"myToken"))) {
        [_sessionManager.requestSerializer setValue:USERDEFAULT(@"myToken") forHTTPHeaderField:@"TOKEN"];
    }
    
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                      @"text/html",
                                                                                      @"text/json",
                                                                                      @"text/plain",
                                                                                      @"text/javascript",
                                                                                      @"text/xml",
                                                                                      @"image/*"]];
}


//普通请求 没缓存
-(void)MDRequestWithHud:(BOOL)isShowhud In:(UIView * __nullable)view type:(NSInteger)type Parameter :(NSMutableDictionary * __nullable)parameter header:(NSDictionary * __nullable)header model:(id __nullable)modelClass url :(NSString *)url  successBlock :(successBlock)successBlock failureBlock:(failureBlock)failureBlock{
    
    [self configHttpHeader];
    //组装参数
    if (kEmptyDict(parameter)) {
        parameter = [NSMutableDictionary dictionary];
    }
    NSLog(@"请求参数:%@",parameter)
    //如果有额外请求头就加进去
    NSMutableDictionary *requestHeader = [NSMutableDictionary dictionary];
    if (!kEmptyDict(header)) {
        [requestHeader addEntriesFromDictionary:header];
    }
    //是否显示HUD
    if (isShowhud) {
        [LZJHudTool showProgressHud:view];
    }
    
    
    if (type == 0) {
        [_sessionManager.requestSerializer requestWithMethod:@"POST" URLString:url parameters:parameter error:nil];
        //请求部分
        [_sessionManager POST:url parameters:parameter headers:requestHeader progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (isShowhud) {
                [LZJHudTool hideProgressHud:view];
            }
            
            
            //如果有 errorview先清除
            MDErrorView *errorView = (MDErrorView *)[view viewWithTag:9998];
            if (errorView) {
                [errorView removeFromSuperview];
            }
            
            NSInteger success = [[NSString stringWithFormat:@"%@", responseObject[@"success"]] integerValue];
            
            NSInteger result = [[NSString stringWithFormat:@"%@", responseObject[@"code"]] integerValue];
            
            WeakSelf
            
            if (result == SGNetworkResultTypeSuccess && success == 1) { //成功
                
                
                [weakSelf requestSuccess:responseObject successBlock:successBlock model:modelClass];
                
            }else if (result == SGNetworkResultTypeNotlogin){ //重新登录
               
                [weakSelf requestNotLogin:responseObject];
                
            }else { //失败
                
                [weakSelf requestFailure:responseObject failureBlock: failureBlock showMessageIn:view task:task];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error)
            if (isShowhud) {
                [LZJHudTool hideProgressHud:view];
            }
            
            MDErrorView *exitErr = (MDErrorView *)[view viewWithTag:9998];
            if (exitErr || error.code == -999) {
                return;
            }
            
            WeakSelf
            MDErrorView *errorView = [[MDErrorView alloc]init];
            errorView.code = error.code;
            [errorView showErrorViewIn:view];
            
            //点击重新请求
            errorView.refreshBlock = ^{
                [weakSelf MDRequestWithHud:isShowhud In:view type:type  Parameter:parameter header:header model:modelClass url:url successBlock:successBlock failureBlock:failureBlock];
                
            };
            
            if (failureBlock) {
                failureBlock(task,error);
            }
            
        }];
        
    }else{
        //请求部分
        [_sessionManager GET:url parameters:parameter headers:requestHeader progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
            if (isShowhud) {
                [LZJHudTool hideProgressHud:view];
            }
            
            //如果有 errorview先清除
            MDErrorView *errorView = (MDErrorView *)[view viewWithTag:9998];
            if (errorView) {
                [errorView removeFromSuperview];
            }
            
            NSInteger success = [[NSString stringWithFormat:@"%@", responseObject[@"success"]] integerValue];
            
            NSInteger result = [[NSString stringWithFormat:@"%@", responseObject[@"code"]] integerValue];
            
            WeakSelf
            
            if (result == SGNetworkResultTypeSuccess && success == 1) { //成功
                
                [weakSelf requestSuccess:responseObject successBlock:successBlock model:modelClass];
                
            }else if (result == SGNetworkResultTypeNotlogin){ //重新登录
                
                [weakSelf requestNotLogin:responseObject];
                
            }else { //失败
                
                [weakSelf requestFailure:responseObject failureBlock: failureBlock showMessageIn:view task:task];
            }
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error)
            if (isShowhud) {
                [LZJHudTool hideProgressHud:view];
            }
            
            MDErrorView *exitErr = (MDErrorView *)[view viewWithTag:9998];
            if (exitErr || error.code == -999) {
                return;
            }
            
            WeakSelf
            MDErrorView *errorView = [[MDErrorView alloc]init];
            errorView.code = error.code;

            [errorView showErrorViewIn:view];
            
            //点击重新请求
            errorView.refreshBlock = ^{
                [weakSelf MDRequestWithHud:isShowhud In:view type:type  Parameter:parameter header:header model:modelClass url:url successBlock:successBlock failureBlock:failureBlock];
                
            };
            
            if (failureBlock) {
                failureBlock(task,error);
            }
            
        }];
    }
    
    
}

//带缓存请求
-(void)MDCacheRequestWithHud:(BOOL)isShowhud In:(UIView *)view type:(NSInteger)type Parameter:(NSMutableDictionary *)parameter header:(NSDictionary *)header model:(id)modelClass url:(NSString *)url cacheBlock:(cacheBlock)cacheBlock successBlock:(successBlock)successBlock failureBlock:(failureBlock)failureBlock{
    
    [self configHttpHeader];
    
    //获取缓存先返回
    NSDictionary *cacheDict = [[MDCacheManager shareManager] cacheJsonWithURL:url];
    if (!kEmptyDict(cacheDict)) {
        
       
        if (modelClass == nil) {
            cacheBlock(nil, nil,cacheDict);
        }else{
            //MJ处理数组或者字典model返回
            cacheBlock([modelClass mj_objectArrayWithKeyValuesArray:cacheDict[@"data"]], [modelClass mj_objectWithKeyValues:cacheDict[@"data"]],cacheDict);
        }
    }
    
    
    if (kEmptyDict(parameter)) {
        parameter = [NSMutableDictionary dictionary];
    }
    //签名
    //    if (![self filterSign:url]) {
    //        //不用过滤签名就去加sign
    //        parameter = [self signToDic:parameter];
    //    }
    
    //如果有额外请求头就加进去
    NSMutableDictionary *requestHeader = [NSMutableDictionary dictionary];
    if (!kEmptyDict(header)) {
        [requestHeader addEntriesFromDictionary:header];
    }
    //是否显示HUD
    if (isShowhud) {
        [LZJHudTool showProgressHud:view];
    }
    
    if (type == 0) {
        //请求部分
        [_sessionManager POST:url parameters:parameter headers:requestHeader progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (isShowhud) {
                [LZJHudTool hideProgressHud:view];
            }
            //如果有 errorview先清除
            MDErrorView *errorView = (MDErrorView *)[view viewWithTag:9998];
            if (errorView) {
                [errorView removeFromSuperview];
            }
            
            NSInteger success = [[NSString stringWithFormat:@"%@", responseObject[@"success"]] integerValue];
            
            NSInteger result = [[NSString stringWithFormat:@"%@", responseObject[@"code"]] integerValue];
            
            WeakSelf
            
            if (result == SGNetworkResultTypeSuccess && success == 1) { //成功
                
                [weakSelf requestSuccess:responseObject successBlock:successBlock model:modelClass];
                
                [[MDCacheManager shareManager] saveJsonResponseToCacheFile:responseObject andURL:url];
                
            }else if (result == SGNetworkResultTypeNotlogin){ //重新登录
                
                [weakSelf requestNotLogin:responseObject];
                
            }else { //失败
                
                [weakSelf requestFailure:responseObject failureBlock: failureBlock showMessageIn:view task:task];
            }
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error)
            if (isShowhud) {
                [LZJHudTool hideProgressHud:view];
            }
//            WeakSelf
            
//            MDErrorView *exitErr = (MDErrorView *)[view viewWithTag:9998];
//                       if (exitErr) {
//                           return;
//                       }
//
//            MDErrorView *errorView = [[MDErrorView alloc]init];
//            [errorView showErrorViewIn:view];
//            
//            //请求
//            errorView.refreshBlock = ^{
//                
//                [weakSelf MDCacheRequestWithHud:isShowhud In:view type:type Parameter:parameter header:header model:modelClass url:url  cacheBlock:cacheBlock successBlock:successBlock failureBlock:failureBlock];
//            };
            
            if (failureBlock) {
                failureBlock(task,error);
            }
            
        }];
    }else{
        //请求部分
        [_sessionManager GET:url parameters:parameter headers:requestHeader progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (isShowhud) {
                [LZJHudTool hideProgressHud:view];
            }
            
            //如果有 errorview先清除
            MDErrorView *errorView = (MDErrorView *)[view viewWithTag:9998];
            if (errorView) {
                [errorView removeFromSuperview];
            }
            
            WeakSelf
            
            NSInteger success = [[NSString stringWithFormat:@"%@", responseObject[@"success"]] integerValue];
            
            NSInteger result = [[NSString stringWithFormat:@"%@", responseObject[@"code"]] integerValue];
            
            
            if (result == SGNetworkResultTypeSuccess && success == 1) { //成功
                
                [weakSelf requestSuccess:responseObject successBlock:successBlock model:modelClass];
                
                 [[MDCacheManager shareManager] saveJsonResponseToCacheFile:responseObject andURL:url];
                
            }else if (result == SGNetworkResultTypeNotlogin){ //重新登录
                
                [weakSelf requestNotLogin:responseObject];
                
            }else { //失败
                
                [weakSelf requestFailure:responseObject failureBlock: failureBlock showMessageIn:view task:task];
            }
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error)
            if (isShowhud) {
                [LZJHudTool hideProgressHud:view];
            }
            WeakSelf
            
//            MDErrorView *exitErr = (MDErrorView *)[view viewWithTag:9998];
//            if (exitErr) {
//                return;
//            }
//            MDErrorView *errorView = [[MDErrorView alloc]init];
//            [errorView showErrorViewIn:view];
            
//            //请求
//            errorView.refreshBlock = ^{
//
//                [weakSelf MDCacheRequestWithHud:isShowhud In:view type:type Parameter:parameter header:header model:modelClass url:url cacheBlock:cacheBlock successBlock:successBlock failureBlock:failureBlock];
//            };
//
            if (failureBlock) {
                failureBlock(task,error);
            }
            
        }];
    }

}

// 不检验登录的请求
-(void)MDNoLoginRequestWithHud:(BOOL)isShowhud In:(UIView *)view type:(NSInteger)type Parameter:(NSMutableDictionary *)parameter header:(NSDictionary *)header model:(id)modelClass url:(NSString *)url successBlock:(successBlock)successBlock failureBlock:(failureBlock)failureBlock{
    
    [self configHttpHeader];
    //组装参数
    if (kEmptyDict(parameter)) {
        parameter = [NSMutableDictionary dictionary];
    }
    NSLog(@"请求参数:%@",parameter)
    //如果有额外请求头就加进去
    NSMutableDictionary *requestHeader = [NSMutableDictionary dictionary];
    if (!kEmptyDict(header)) {
        [requestHeader addEntriesFromDictionary:header];
    }
    //是否显示HUD
    if (isShowhud) {
        [LZJHudTool showProgressHud:view];
    }
    
    
    if (type == 0) {
        [_sessionManager.requestSerializer requestWithMethod:@"POST" URLString:url parameters:parameter error:nil];
        //请求部分
        [_sessionManager POST:url parameters:parameter headers:requestHeader progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
            
            if (isShowhud) {
                [LZJHudTool hideProgressHud:view];
            }
            
            
            //如果有 errorview先清除
            MDErrorView *errorView = (MDErrorView *)[view viewWithTag:9998];
            if (errorView) {
                [errorView removeFromSuperview];
            }
            
            NSInteger success = [[NSString stringWithFormat:@"%@", responseObject[@"success"]] integerValue];
            
            NSInteger result = [[NSString stringWithFormat:@"%@", responseObject[@"code"]] integerValue];
            
            WeakSelf
            
            if (result == SGNetworkResultTypeSuccess && success == 1) { //成功
                
                
                [weakSelf requestSuccess:responseObject successBlock:successBlock model:modelClass];
                
            }else if (result == SGNetworkResultTypeNotlogin){ //重新登录
               
//                [weakSelf requestNotLogin:responseObject];
                
            }else { //失败
                
                [weakSelf requestFailure:responseObject failureBlock: failureBlock showMessageIn:view task:task];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error)
            if (isShowhud) {
                [LZJHudTool hideProgressHud:view];
            }
            
//            MDErrorView *exitErr = (MDErrorView *)[view viewWithTag:9998];
//            if (exitErr) {
//                return;
//            }
//
//            WeakSelf
//            MDErrorView *errorView = [[MDErrorView alloc]init];
//            [errorView showErrorViewIn:view];
//
//            //点击重新请求
//            errorView.refreshBlock = ^{
//                [weakSelf MDRequestWithHud:isShowhud In:view type:type  Parameter:parameter header:header model:modelClass url:url successBlock:successBlock failureBlock:failureBlock];
//
//            };
            
            if (failureBlock) {
                failureBlock(task,error);
            }
            
        }];
        
    }else{
        //请求部分
        [_sessionManager GET:url parameters:parameter headers:requestHeader progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (isShowhud) {
                [LZJHudTool hideProgressHud:view];
            }
            //如果有 errorview先清除
            MDErrorView *errorView = (MDErrorView *)[view viewWithTag:9998];
            if (errorView) {
                [errorView removeFromSuperview];
            }
            
            NSInteger success = [[NSString stringWithFormat:@"%@", responseObject[@"success"]] integerValue];
            
            NSInteger result = [[NSString stringWithFormat:@"%@", responseObject[@"code"]] integerValue];
            
            WeakSelf
            
            if (result == SGNetworkResultTypeSuccess && success == 1) { //成功
                
                [weakSelf requestSuccess:responseObject successBlock:successBlock model:modelClass];
                
            }else if (result == SGNetworkResultTypeNotlogin){ //重新登录
                
//                [weakSelf requestNotLogin:responseObject];
                
            }else { //失败
                
                [weakSelf requestFailure:responseObject failureBlock: failureBlock showMessageIn:view task:task];
            }
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error)
            if (isShowhud) {
                [LZJHudTool hideProgressHud:view];
            }
            
//            MDErrorView *exitErr = (MDErrorView *)[view viewWithTag:9998];
//            if (exitErr) {
//                return;
//            }
//
//            WeakSelf
//            MDErrorView *errorView = [[MDErrorView alloc]init];
//            [errorView showErrorViewIn:view];
//
//            //点击重新请求
//            errorView.refreshBlock = ^{
//                [weakSelf MDRequestWithHud:isShowhud In:view type:type  Parameter:parameter header:header model:modelClass url:url successBlock:successBlock failureBlock:failureBlock];
//
//            };
            
            if (failureBlock) {
                failureBlock(task,error);
            }
            
        }];
    }
    
}


//处理请求成功结果
-(void)requestSuccess:(id)responseObject successBlock :(successBlock)successBokck model:(id)modelClass{
    

    if (modelClass == nil) {
        successBokck(nil, nil,responseObject);
    }else{
        //MJ处理数组或者字典model返回 --普通的list在data层, 分页的数据在data-list层
        NSArray *listArray = [NSArray array];
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {
            listArray = responseObject[@"data"];
        }else if ([responseObject[@"data"][@"list"] isKindOfClass:[NSArray class]]){
            listArray = responseObject[@"data"][@"list"];
        }
        successBokck([modelClass mj_objectArrayWithKeyValuesArray:listArray], [modelClass mj_objectWithKeyValues:responseObject[@"data"]],responseObject);
    }
    
}

//处理请求重新登录结果
-(void)requestNotLogin:(id)responseObject{
    
    //清除登录数据
    [LZJPublicUtility saveUserModel:[MDUserModel new]];
    
    //退出标记
   [kUserDefaults setValue:@"0" forKey:@"loginStatus"];
    //退出im    
    [[MDAlertHelper shareManager]showEnsureAlertView:nil message:kLocalized(@"您的登录信息已过期,请重新登录") :^{
        
        [LZJPublicUtility switchRootVcToLogin];
        
    }];
  
    
}

//处理更新结果
-(void)requestUpdate:(id)responseObject{
    
}

//处理请求失败结果
-(void)requestFailure:(id)responseObject failureBlock:(failureBlock)failureBlock showMessageIn:(UIView *)view task :(NSURLSessionDataTask *)task{
    
    [LZJHudTool showMessageInView:view message:responseObject[@"message"]];
    NSError * _Nonnull error;
    if (failureBlock) {
        
        failureBlock(task,error);
        
    }
}

//是否过滤sign
-(BOOL)filterSign:(NSString *)urlString{
    
    return NO;
    
}

//组装参数
-(NSString *)appendParameter:(NSMutableDictionary *)parameter{
    
    if (kEmptyDict(parameter)) {
        parameter = [NSMutableDictionary dictionary];
    }
    
    //字典转字符串
    return [LZJPublicUtility convertToJsonData:parameter];
}

//签名
- (NSMutableDictionary *)signToDic:(NSMutableDictionary *)parameter{
    
    if (kEmptyDict(parameter)) {
        parameter = [NSMutableDictionary dictionary];
    }
    
    NSMutableString *contentString  = [NSMutableString string];
    NSArray *keys = [parameter allKeys];
    
    //按字母顺序排序 key排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    //拼接字符串
    for (NSString *key in sortedArray) {
        
        [contentString appendFormat:@"%@", [parameter objectForKey:key]];
    }
    
    NSString *signStr = [contentString stringByAppendingString:@""].md5String;
    
    //添加sign参数
    parameter[@"sign"] = signStr;
    
    return parameter;
}

- (void)cancelRequest{
    if ([_sessionManager.tasks count] > 0) {
        NSLog(@"返回时取消网络请求");
        [_sessionManager.tasks makeObjectsPerformSelector:@selector(cancel)];
        //NSLog(@"tasks = %@",manager.tasks);
    }
}
@end
