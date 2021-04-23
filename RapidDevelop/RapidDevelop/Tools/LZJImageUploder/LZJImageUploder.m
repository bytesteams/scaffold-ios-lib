//
//  LZJImageUploder.m
//  MDHealth
//
//  Created by 林志军 on 2020/7/30.
//  Copyright © 2020 startgo. All rights reserved.
//

#import "LZJImageUploder.h"
#import "CSGAlertView.h"
#import "LZJTimeTool.h"
#import <PhotosUI/PhotosUI.h>
#import "MDAlertHelper.h"
@interface LZJImageUploder ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate,RSKImageCropViewControllerDataSource>{
    CGFloat _compressWidth;
    NSString *_url;
    NSString *_floder;
}

@end

@implementation LZJImageUploder

//上传单张图
-(void)uploadSingleImageWithCompressFloder:(NSString *)floder{
    
//    _compressWidth = width;
//    _url = url;
    _floder = floder;
    WeakSelf
    [CSGAlertView showActionSheetWithTitle:nil andMessage:nil nController:[LZJPublicUtility getCurrentViewController] firstBtnTitle:kLocalized(@"拍摄新照片") secondBtnTitle:kLocalized(@"从照片库选择") firstBtnClick:^{
           [weakSelf getCameraPic];
      } secondBtnClick:^{
           [weakSelf getExistinPic];
      }];
}

-(void)getExistinPic {
    
    UIViewController *vc = [LZJPublicUtility getCurrentViewController];
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker =
        [[UIImagePickerController alloc] init];
        picker.delegate = self;
        
        picker.navigationBar.translucent = false;
        picker.navigationBar.barStyle = UIBarStyleBlack;
        picker.navigationBar.tintColor = [UIColor whiteColor];
 
        //修复控制器
        if (@available(iOS 11, *)) {
            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
            //重复箭头问题
            picker.navigationBar.backIndicatorImage = [[UIImage alloc] init];
            picker.navigationBar.backIndicatorTransitionMaskImage = [[UIImage alloc] init];
            
        }
        
        // 图片库
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.modalPresentationStyle = 0 ;
        [vc presentViewController:picker animated:YES completion:^{
            
        }];
    }
    else {
        NSLog(@"打开相册失败")
        
        //        [self removeFromSuperview];
    }
}

-(void)getCameraPic{
    
    UIViewController *vc = [LZJPublicUtility getCurrentViewController];
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker =
        [[UIImagePickerController alloc] init];
        picker.delegate = self;
        // 摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
      
        [vc presentViewController:picker animated:YES completion:^{
            
        }];
    }else {
        NSLog(@"打开相机失败")
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // 得到图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (!CGRectEqualToRect(_cropperRect,CGRectZero)) {
           
           [picker dismissViewControllerAnimated:NO completion:^{
               RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCustom];
               //imageCropVC.maskLayerColor = [UIColor blueColor];
               imageCropVC.maskLayerLineWidth = 1;
               imageCropVC.maskLayerStrokeColor =  [UIColor whiteColor];
               imageCropVC.dataSource = self;
               imageCropVC.delegate = self;
               imageCropVC.modalPresentationStyle = 0;
               [[LZJPublicUtility getCurrentViewController] presentViewController:imageCropVC animated:NO completion:nil];
           }];
       }else{ //无裁剪
           
          
           [picker dismissViewControllerAnimated:YES completion:^{
               if (image) { 
                   [self uploadFieldToOSS:image AndPath:_floder];
               }
           }];
        
       }

    
    if (@available(iOS 11, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
}

//上传图片--网络部分
-(void)uploadImg:(UIImage *)img{
    [LZJHudTool showProgressHud:[LZJPublicUtility getCurrentViewController].view];
    WeakSelf
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:_url parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSUInteger i = 0 ;
        
        NSData * imgData = UIImageJPEGRepresentation(img, .6);
        
        NSString *str = [LZJTimeTool currentDataFormat:@"yyyyMMddHHmmss"];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        NSString *name = [NSString stringWithFormat:@"image_%ld.png",(long)i];
        
        //将得到的二进制图片拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名*/
        [formData appendPartWithFileData:imgData name:name fileName:fileName mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (weakSelf.uploadSingleSuccess) {
            weakSelf.uploadSingleSuccess(@"",img);
        }
        
         [LZJHudTool hideProgressHud:[LZJPublicUtility getCurrentViewController].view];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [LZJHudTool hideProgressHud:[LZJPublicUtility getCurrentViewController].view];
    }];
}

//上传多张图 利用gcdgroup

-(void)uploadImages:(NSArray *)imgsArray CompressWidth:(CGFloat)width url:(NSString *)url{
    
    NSMutableArray *compressImgsArr = [NSMutableArray array];
    if (width > 0) {
        for (int i = 0; i<imgsArray.count; i++) {
            UIImage *img = imgsArray[i];
            img = [self IMGCompressed:img targetWidth:width];
            [compressImgsArr addObject:img];
        }
    }else{
        [compressImgsArr addObjectsFromArray:imgsArray];
    }
    
    NSMutableArray *urlsArray = [NSMutableArray array];
    
    dispatch_group_t uploadGroud = dispatch_group_create() ; //第一步
    
     [LZJHudTool showProgressHud:[LZJPublicUtility getCurrentViewController].view];
    
    for (int i = 0; i < compressImgsArr.count; i++) {
        UIImage *img = compressImgsArr[i];
        
        dispatch_group_enter(uploadGroud);//第二步
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:_url parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSUInteger i = 0 ;
            
            NSData * imgData = UIImageJPEGRepresentation(img, .6);
            
            NSString *str = [LZJTimeTool currentDataFormat:@"yyyyMMddHHmmss"];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            NSString *name = [NSString stringWithFormat:@"image_%ld.png",(long)i];
            
            //将得到的二进制图片拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名*/
            [formData appendPartWithFileData:imgData name:name fileName:fileName mimeType:@"image/png"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            dispatch_group_leave(uploadGroud);
            
            [urlsArray addObject:@"fuck"];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_group_leave(uploadGroud);
            
        }];
    }
    
    WeakSelf
    dispatch_group_notify(uploadGroud, dispatch_get_main_queue(), ^{ //全部上传完毕
        
        if (weakSelf.uploadMutiSuccess) {
            weakSelf.uploadMutiSuccess(compressImgsArr,urlsArray);
        }
        
    });
}

//裁剪
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [[LZJPublicUtility getCurrentViewController] dismissViewControllerAnimated:YES completion:nil];
  
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle
{
    
    [[LZJPublicUtility getCurrentViewController] dismissViewControllerAnimated:YES completion:nil];
    
    //上传图片
   [self uploadFieldToOSS:croppedImage AndPath:_floder];
  
}

- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller{
    return _cropperRect;
}

- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller{
    return _cropperRect;
}

- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller{//返回裁剪框的位置
    UIBezierPath *path= [UIBezierPath bezierPathWithRoundedRect:_cropperRect cornerRadius:0];
    return path;
    
}


//压缩图片指定宽度
-(UIImage *)IMGCompressed:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        
        NSAssert(!newImage,@"图片压缩失败");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
 
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
 
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
 
    UIGraphicsEndImageContext();
 
    return scaledImage;   //返回的就是已经改变的图片
}

//OSS

-(void)uploadFieldToOSS:(UIImage *)img AndPath:(NSString *)path{
 
//    [OSSUploadImageManage asyncUploadImage:img Floder:path progress:nil complete:^(NSArray< NSMutableDictionary*> *para, UploadImageState state) {
//        
//        if (para.count > 0) {
//            
//            NSMutableDictionary *dict = para[0];
//            if (_uploadSingleSuccess) {
//                _uploadSingleSuccess(dict[@"imgUrl"],img);
//                NSLog(@"上传成功")
//            
//            }
//            
//        }
//    }];
    
   
}

-(BOOL)checkImageStatus{
    if (@available(iOS 14, *)) {
        PHAccessLevel level2 = PHAccessLevelReadWrite;// 允许访问照片，limitedLevel 必须为 readWrite
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:level2];//查询权限
          switch (status) {
              case PHAuthorizationStatusLimited:
                  [self showMsg];
                  return NO;
                  NSLog(@"limited");
                  break;
              case PHAuthorizationStatusDenied:
                  NSLog(@"denied");
                 
                  [self showMsg];
                  return NO;
                  break;
              case PHAuthorizationStatusAuthorized:
                  NSLog(@"authorized");
                  return YES;
                  break;
              default:
                  return YES;
                  break;
        }
    } else {
        
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            //无权限
            [self showMsg];
            return NO;
        }else{
            return YES;
        }
        
    }
}


-(void)showMsg{
    

    [[MDAlertHelper shareManager]showSelectAlertViewIn:nil message:@"检测到无访问相册权限!\n请到系统设置->魔胴健康-照片-选择所有照片" :^{
        // 系统是否大于10
         NSURL *url = nil;
         if ([[UIDevice currentDevice] systemVersion].floatValue < 10.0) {
             url = [NSURL URLWithString:@"prefs:root=privacy"];
             
         } else {
             url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
         }
         [[UIApplication sharedApplication] openURL:url];
        
        
    }];
   
}
@end
