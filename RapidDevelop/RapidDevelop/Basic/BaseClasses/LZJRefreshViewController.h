//
//  LZJRefreshViewController.h
//  AXWY
//
//  Created by lzj on 2017/11/9.
//  Copyright © 2017年 LZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>

#import "LZJCollectionViewPlaceHolder.h"
#import <CYLTableViewPlaceHolder.h>
#import "LZJBaseViewController.h"
@interface LZJRefreshViewController : LZJBaseViewController

/**
 是否存在更多
 */
@property (nonatomic, assign) BOOL hasMore;

@property(nonatomic,copy)NSString *pageNum;

@property (nonatomic, strong) MJRefreshNormalHeader *refreshHeaderView;
@property (nonatomic, strong) MJRefreshAutoStateFooter *refreshFooterView;


@property(nonatomic,assign)BOOL isHideBlankView;
//没数据提示
@property(nonatomic,copy)NSString *blankTips;
@property(nonatomic,strong)UIImage *blankImage;
@property(nonatomic,strong)UIImageView *blankImgV;

/**
 设置需要刷新的表格
 
 @param tableView 表格对象
 */
- (void)setRefreshTableView:(UITableView *)tableView pullDown:(BOOL)pullDown pullUp:(BOOL)pullUp;

/**
 设置需要刷新的collectionView
 
 @param collectionView 需要刷新的collectionView
 */
- (void)setRefreshCollectionView:(UICollectionView *)collectionView pullDown:(BOOL)pullDown pullUp:(BOOL)pullUp;

#pragma mark - 上下拉刷新所执行的方法

/**
 加载最新
 */
- (void)loadNewData : (BOOL) isShowHud ;

/**
 加载更多
 */
- (void)loadMoreData;


- (void)stopLoading;

@property(nonatomic,assign)CGFloat placeholderViewOffsetY;
@end
