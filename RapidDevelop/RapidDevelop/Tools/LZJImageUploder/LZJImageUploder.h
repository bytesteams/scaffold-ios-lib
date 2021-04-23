//
//  LZJImageUploder.h
//  MDHealth
//
//  Created by 林志军 on 2020/7/30.
//  Copyright © 2020 startgo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSKImageCropViewController.h"

typedef void(^uploadSingleBlock)(NSString * _Nullable urlString , UIImage * _Nullable image);

typedef void(^uploadMutiBlock)(NSArray * _Nullable imgsArray , NSArray * _Nullable urlsArray);


NS_ASSUME_NONNULL_BEGIN

@interface LZJImageUploder : NSObject

@property(nonatomic,copy)uploadSingleBlock uploadSingleSuccess;

@property(nonatomic,copy)uploadMutiBlock uploadMutiSuccess;

@property(nonatomic,assign)CGRect cropperRect;

-(void)uploadSingleImageWithCompressFloder:(NSString *)floder;

-(void)uploadImages:(NSArray *)imgsArray CompressWidth:(CGFloat)width url:(NSString *)url;

-(void)uploadFieldToOSS:(UIImage *)img AndPath :(NSString *)path;

//压缩图片指定size
-(UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size;

//检查权限
-(BOOL)checkImageStatus;
@end

NS_ASSUME_NONNULL_END
