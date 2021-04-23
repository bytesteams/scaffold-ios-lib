//
//  MDUserModel.h
//  MDHealth
//
//  Created by 林志军 on 2020/7/31.
//  Copyright © 2020 startgo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LDKeyedArchiverModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface MDUserModel : LDKeyedArchiverModel
@property(nonatomic,copy)NSString *userId;
//1男 2女
@property(nonatomic,copy)NSString *gender;
@property(nonatomic,copy)NSString *mobile;

@property(nonatomic,copy)NSString *nickName;
//头像
@property(nonatomic,copy)NSString *headUrl;

//1需要去设置个人信息 0不需要
@property(nonatomic,copy)NSString *ifFirstRegster;
//0 不需要 1需要
@property(nonatomic,copy)NSString *ifNeedBindMobile;
@property(nonatomic,copy)NSString *token;
//腾讯im的密码
@property(nonatomic,copy)NSString *imSig;


@property(nonatomic,assign)long long birthday;
@end

NS_ASSUME_NONNULL_END
