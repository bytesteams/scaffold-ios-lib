//
//  Header.h
//  MDHealth
//
//  Created by 林志军 on 2020/7/28.
//  Copyright © 2020 林志军. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef Header_h
#define Header_h

//测试服务器
#ifdef DEBUG

#define HOST  @"https://test-api.hugestargo.com"

#define OSSUploadPath @"testmdjk/app"

#define TIMAPNSID 24306

//正式服务器
#else
//服务器地址
#define HOST  @"https://m.hugestargo.com"
//OSS保存路径
#define OSSUploadPath @"mdjk/app"
//推送证书ID
#define TIMAPNSID 24309

#endif

#define OSSHOST  @"https://jxxdpublic.oss-cn-shanghai.aliyuncs.com/"

//版本信息
#define api_version [HOST stringByAppendingString:@""]



#endif /* Header_h */
