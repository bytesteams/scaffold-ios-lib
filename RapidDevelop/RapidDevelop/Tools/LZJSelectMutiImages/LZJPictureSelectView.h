//
//  NXReleasePictureSelectView.h
//  NaoXinFaWu
//
//  Created by 林志军 on 17/4/15.
//  Copyright © 2017年 naoxin_Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^succeedBlock) (NSUInteger itemCount , NSMutableArray *imageArray );
typedef void(^deleteBlock) (NSUInteger itemCount , NSMutableArray *imageArray , NSInteger index);
typedef void (^selectVideoBlcok) (NSString *path );
@interface LZJPictureSelectView : UIView

-(void)setCollectionViewFrame :(CGRect)frame itemColumnCount:(CGFloat)count margin:(CGFloat)margin;

@property(nonatomic,copy)succeedBlock selectSucceed;
@property(nonatomic,copy)deleteBlock deleteBlock;
@property(nonatomic,copy)selectVideoBlcok selectVideo;

//加载存在的图片 
@property(nonatomic,strong)NSMutableArray *defaultImageArray;

//加载存在的图片
@property(nonatomic,strong)NSMutableArray *defaultImgUrlArray;

///< 照片最大可选张数，设置为1即为单选模式
@property (assign, nonatomic)  NSInteger maxCount;
//每一行展示图片数量
@property(nonatomic,assign)NSInteger columnNumber;
// 6个设置开关
@property (assign, nonatomic) BOOL  showTakePhotoBtnSwitch;  ///< 在内部显示拍照按钮
@property (assign, nonatomic) BOOL  showTakeVideoBtnSwitch;
@property (assign, nonatomic) BOOL  sortAscendingSwitch;     ///< 照片排列按修改时间升序
@property (assign, nonatomic) BOOL  allowPickingVideoSwitch; ///< 允许选择视频
@property (assign, nonatomic) BOOL  allowPickingImageSwitch; ///< 允许选择图片
@property (assign, nonatomic) BOOL  allowPickingGifSwitch;
@property (assign, nonatomic) BOOL  allowPickingOriginalPhotoSwitch; ///< 允许选择原图
@property (assign, nonatomic) BOOL  showSheetSwitch; ///< 显示一个sheet,把拍照按钮放在外面
@property (assign, nonatomic) BOOL  allowPickingMuitlpleVideoSwitch;
@property (assign, nonatomic) BOOL allowCropSwitch;
@property (assign, nonatomic) BOOL needCircleCropSwitch;
@property (assign, nonatomic) BOOL showSelectedIndexSwitch;//显示图片序号

//0默认状态  1浏览状态,不显示删除增加按钮
@property(nonatomic,assign)NSInteger status;

-(void)selectPhotos;

@property(nonatomic,strong)UIImage *defaultImg;
@end
