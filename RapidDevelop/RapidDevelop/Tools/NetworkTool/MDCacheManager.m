//
//  MDCacheManager.m
//  MDHealth
//
//  Created by 林志军 on 2020/7/29.
//  Copyright © 2020 stargo. All rights reserved.
//

#import "MDCacheManager.h"
#import "NSString+Hash.h"
#import <YYCache/YYCache.h>

@implementation MDCacheManager

static id shareManager;
//单例模式
+ (MDCacheManager * )shareManager{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareManager = [[MDCacheManager alloc] init];
    });
    return shareManager;
}

-(instancetype)init{
    
    if (self = [super init]) {
        
    }
    return self;
}


// 缓存
-(BOOL)saveJsonResponseToCacheFile:(id)jsonResponse andURL:(NSString *)URL{
    
    NSDictionary *json = (NSDictionary *)jsonResponse;
    
    NSString *path = [self cacheFilePathWithURL:URL];
    
    YYCache *cache = [[YYCache alloc] initWithPath:path];
    
    if( !kEmptyDict(json)){
                 
        [cache setObject:json forKey:URL];
        
        BOOL state = [cache containsObjectForKey:URL];
        
        if(state){
            
            NSLog(@"缓存写入/更新成功");
        }
        
        return state;
    }
    
    return NO;
}

//获取缓存数据
-(id )cacheJsonWithURL:(NSString *)URL{
    
    id cacheJson;
    
    NSString *path = [self cacheFilePathWithURL:URL];
    
    YYCache *cache = [[YYCache alloc] initWithPath:path];
    
    BOOL state = [cache containsObjectForKey:URL];
    
    if(state){
        
        cacheJson = [cache objectForKey:URL];
    }
    
    return cacheJson;
}

//获取缓存文件地址
- (NSString *)cacheFilePathWithURL:(NSString *)URL {
    
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"MDHealthYYCache"];
    
    [self checkDirectory:path];//check路径
    
    //文件名
    NSString *cacheFileNameString = [NSString stringWithFormat:@"URL:%@ AppVersion:%@",URL,kAppVersion].md5String;
   
    path = [path stringByAppendingPathComponent:cacheFileNameString];
        
    return path;
}

-(void)checkDirectory:(NSString *)path {
    //如果没有这个文件夹就直接创建
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (!isDir) {
        [self createBaseDirectoryAtPath:path];
    }
}

//创建文件夹
-(void)createBaseDirectoryAtPath:(NSString *)path {
    __autoreleasing NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                               attributes:nil error:&error];
    if (!error) {
        //禁止icloud备份
        [self addDoNotBackupAttribute:path];
    }
}
//禁止icloud备份
- (void)addDoNotBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
       
    }
}

-(BOOL)compareCache:(NSString *)url WithResponseObject:(id)responseObject{
    
    id cache = [self cacheJsonWithURL:url];
    
    id cacheData = cache[@"data"];
    id newData = responseObject[@"data"];
    if ([cacheData isEqual:newData]) {
          NSLog(@"YES YES")
        return YES;
      
    }
      NSLog(@"no no")
    return NO;
    
}
@end
