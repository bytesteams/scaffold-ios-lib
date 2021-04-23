//
//  NXReleasePictureSelectView.m
//  NaoXinFaWu
//
//  Created by 林志军 on 17/4/15.
//  Copyright © 2017年 naoxin_Ltd. All rights reserved.
//

#import "LZJPictureSelectView.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZAssetCell.h"
#import "TZImagePreviewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImage+GIF.h>
#import "FLAnimatedImage.h"
#import "CSGAlertView.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@interface LZJPictureSelectView ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
{
    
    BOOL _isSelectOriginalPhoto;
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAsset;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSArray *videoSuffixs;
@end

@implementation LZJPictureSelectView

//-(instancetype)initWithFrame:(CGRect)frame{
//    if (self==[super initWithFrame:frame]) {
//        [self setupSelectPictureView];
//    }return self;
//}

-(void)setCollectionViewFrame:(CGRect)frame itemColumnCount:(CGFloat)count margin:(CGFloat)margin{
    
    [self config];
    
    [self configCollectionView:frame itemColumnCount:count margin:margin];
}

-(void)config{
    
    self.showTakePhotoBtnSwitch = NO;
    self.showSheetSwitch = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.selectedPhotos = [NSMutableArray array];
    
    
    
    for (UIImage *img in _defaultImageArray) {
        [self.selectedPhotos addObject:img];
    }
    
    for (NSString *urlStr in _defaultImgUrlArray) {
        
        [self.selectedPhotos addObject:[NSURL URLWithString:urlStr]];
    }
    
    self.maxCount = self.maxCount - self.selectedPhotos.count;
}

-(void)setDefaultImageArray:(NSMutableArray *)defaultImageArray{
    _defaultImageArray = defaultImageArray;
    [self config];
}

-(void)setDefaultImgUrlArray:(NSMutableArray *)defaultImgUrlArray{
    _defaultImgUrlArray = defaultImgUrlArray;
    [self config];
    [_collectionView reloadData];

}

-(void)setStatus:(NSInteger)status{
    
    _status = status;
    [_collectionView reloadData];
    
}

-(void)configCollectionView :(CGRect)frame itemColumnCount:(CGFloat)count margin:(CGFloat)margin {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _itemWH =  (frame.size.width - margin*(count-1))/count ;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = margin - 1;
    _layout.minimumLineSpacing = margin ;
    [_collectionView setCollectionViewLayout:_layout];
    [_collectionView reloadData];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:_layout];
    _collectionView.backgroundColor = kWhiteColor;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.scrollEnabled = NO;
    _collectionView.bounces = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _collectionView.contentSize = frame.size;
    [self addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(kFitW(0));
    }];
}

-(void)setAllowPickingVideoSwitch:(BOOL)allowPickingVideoSwitch{
    _allowPickingVideoSwitch = allowPickingVideoSwitch;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}





#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_status == 1) {
        return _selectedPhotos.count ;
    }else{
        return _selectedPhotos.count + 1;
    }
   
   
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    cell.videoURL = nil;
    cell.imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    
    
    if (indexPath.item == _selectedPhotos.count && _status == 0) {
        if (_defaultImg) {
            cell.imageView.image = _defaultImg;
        }else{
            cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        }
       
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        id photo = _selectedPhotos[indexPath.item];
        if ([photo isKindOfClass:[UIImage class]]) {
            
            //加载压缩图 防止内存暴增
            cell.imageView.image = photo;
            
        } else if ([photo isKindOfClass:[NSURL class]]) {
            NSURL *URL = (NSURL *)photo;
            NSString *suffix = [[URL.absoluteString.lowercaseString componentsSeparatedByString:@"."] lastObject];
            if (suffix && [self.videoSuffixs containsObject:suffix]) {
                cell.videoURL = URL;
            } else {
                [self configImageView:cell.imageView URL:(NSURL *)photo completion:nil];
            }
        } else if ([photo isKindOfClass:[PHAsset class]]) {
            [[TZImageManager manager] getPhotoWithAsset:photo photoWidth:100 completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                cell.imageView.image = photo;
            }];
        }
        cell.asset = _selectedPhotos[indexPath.item];
        if (_status == 1) {
            cell.deleteBtn.hidden = YES;
        }else{
            cell.deleteBtn.hidden = NO;
        }
      
    }
    cell.deleteBtn.tag = indexPath.item;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _selectedPhotos.count && _status == 0) { // 
        
        if (self.maxCount <= 0) {
            self.maxCount = 0;
            NSString *str = [NSString stringWithFormat:@"还能选%ld张照片",self.maxCount];
            [LZJHudTool showMessageInView:[LZJPublicUtility getCurrentViewController].view message:kLocalized(str)];
            return ;
        }
        
        TZImagePickerController *imagePickerVc = [self createTZImagePickerController];
        imagePickerVc.isSelectOriginalPhoto = NO;
        
        [[LZJPublicUtility getCurrentViewController] presentViewController:imagePickerVc animated:YES completion:nil];
    } else { // 预览
        
        
        
        TZImagePickerController *imagePickerVc = [self createTZImagePickerController];
        imagePickerVc.maxImagesCount = 1;
        imagePickerVc.showSelectBtn = NO;
        [imagePickerVc setPhotoPreviewPageDidLayoutSubviewsBlock:^(UICollectionView *collectionView, UIView *naviBar, UIButton *backButton, UIButton *selectButton, UILabel *indexLabel, UIView *toolBar, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel) {
            if (numberLabel) {
                [numberLabel removeFromSuperview];
                numberLabel = nil;
            }
            if (numberImageView) {
                [numberImageView removeFromSuperview];
                numberImageView = nil;
            }
            if (doneButton) {
                [doneButton removeFromSuperview];
                doneButton = nil;
            }
        }];
        TZImagePreviewController *previewVc = [[TZImagePreviewController alloc] initWithPhotos:self.selectedPhotos currentIndex:indexPath.row tzImagePickerVc:imagePickerVc];
        [previewVc setBackButtonClickBlock:^(BOOL isSelectOriginalPhoto) {
            self.isSelectOriginalPhoto = isSelectOriginalPhoto;
            NSLog(@"预览页 返回 isSelectOriginalPhoto:%d", isSelectOriginalPhoto);
        }];
        [previewVc setSetImageWithURLBlock:^(NSURL *URL, UIImageView *imageView, void (^completion)(void)) {
            [self configImageView:imageView URL:URL completion:completion];
        }];
        [previewVc setDoneButtonClickBlock:^(NSArray *photos, BOOL isSelectOriginalPhoto) {
            self.isSelectOriginalPhoto = isSelectOriginalPhoto;
            self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
            NSLog(@"预览页 完成 isSelectOriginalPhoto:%d photos.count:%zd", isSelectOriginalPhoto, photos.count);
            [self.collectionView reloadData];
        }];
        [[LZJPublicUtility getCurrentViewController] presentViewController:previewVc animated:YES completion:nil];
    }
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

#pragma mark - TZImagePickerController

- (TZImagePickerController *)createTZImagePickerController {
    
    
    
    [TZImageManager manager].isPreviewNetworkImage = YES;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxCount columnNumber:self.columnNumber delegate:self pushPhotoPickerVc:NO];
    
    if (self.maxCount > 1) {
        //如果有默认图 会有冲突
        if (_defaultImageArray.count > 0 || _defaultImgUrlArray.count > 0) {
            NSLog(@"11111")
        }else{  // 1.设置目前已经选中的图片数组
            NSLog(@"22222")
            imagePickerVc.selectedAssets = _selectedAsset; // 目前已经选中的图片数组
        }
        
    }
#pragma mark - 个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    
    imagePickerVc.allowPickingVideo = self.allowPickingVideoSwitch;
    imagePickerVc.allowPickingImage = self.allowPickingImageSwitch;
    imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch;
    imagePickerVc.allowPickingGif = self.allowPickingGifSwitch;
    imagePickerVc.allowPickingMultipleVideo = self.allowPickingMuitlpleVideoSwitch; // 是否可以多选视频
    
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    imagePickerVc.showSelectBtn = NO;
    //imagePickerVc.allowPreview = NO;
    // imagePickerVc.preferredLanguage = @"zh-Hans";
    
#pragma mark - 到这里为止
    
    return imagePickerVc;
}

- (void)configImageView:(UIImageView *)imageView URL:(NSURL *)URL completion:(void (^)(void))completion{
    if ([URL.absoluteString.lowercaseString hasSuffix:@"gif"]) {
        // 先显示静态图占位
        [[SDWebImageManager sharedManager] loadImageWithURL:URL options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (!imageView.image) {
                imageView.image = image;
            }
        }];
        
        // 动图加载完再覆盖掉
        [[SDWebImageManager sharedManager]loadImageWithURL:URL options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            imageView.image = [UIImage sd_imageWithGIFData:data];
            if (completion) {
                completion();
            }
        }];
        
        
    } else {
        [imageView sd_setImageWithURL:URL completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (completion) {
                completion();
            }
        }];
    }
}

//选择完成
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    if (_defaultImageArray.count > 0 || _defaultImgUrlArray.count > 0) {
        
        self.maxCount = self.maxCount - photos.count;
        
        [self.selectedPhotos addObjectsFromArray:photos];
        
        
    }else{
        _selectedAsset =  [NSMutableArray arrayWithArray:assets];
        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
        
    }
    
    
    NSLog(@"%@",photos)
    
    [self.collectionView reloadData];
    if (_selectSucceed) {
        _selectSucceed(_selectedPhotos.count,_selectedPhotos);
    }
    
    
}


-(void)deleteBtnClik:(UIButton *)sender{
    
    
    
    if ([self collectionView:self.collectionView numberOfItemsInSection:0] <= _selectedPhotos.count) {
        [_selectedPhotos removeObjectAtIndex:sender.tag];
        [self.collectionView reloadData];
        return;
    }
    
    NSLog(@"%@",_selectedPhotos)
    
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self->_collectionView reloadData];
        if (self->_deleteBlock) {
            self->_deleteBlock(self->_selectedPhotos.count,self->_selectedPhotos , sender.tag);
        }
    }];
    
    if (_defaultImageArray.count > 0 || _defaultImgUrlArray.count > 0) {
        
        self.maxCount =  self.maxCount + 1;
        
    }
}

-(void)selectPhotos{
    
    TZImagePickerController *imagePickerVc = [self createTZImagePickerController];
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    [[LZJPublicUtility getCurrentViewController] presentViewController:imagePickerVc animated:YES completion:nil];
}

@end
