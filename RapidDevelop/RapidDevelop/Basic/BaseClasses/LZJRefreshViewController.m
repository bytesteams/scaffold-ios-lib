//
//  LZJRefreshViewController.m
//  AXWY
//
//  Created by lzj on 2017/11/9.
//  Copyright © 2017年 LZJ. All rights reserved.
//

#import "LZJRefreshViewController.h"

@interface LZJRefreshViewController ()<CYLTableViewPlaceHolderDelegate,LZJCollectionViewPlaceHolderDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UICollectionView *collectionView;
@end

@implementation LZJRefreshViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
}
/**
 停止刷新
 */
-(void)setHasMore:(BOOL)hasMore{
    _hasMore = hasMore;
    _refreshFooterView.hidden = NO;
    if (_hasMore) {
        
        [self.refreshFooterView endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        [self.refreshFooterView resetNoMoreData];
    }else{
        
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.refreshFooterView endRefreshingWithNoMoreData];
    }
}

/**
 设置需要刷新的表格
 
 @param tableView 表格对象
 */
- (void)setRefreshTableView:(UITableView *)tableView pullDown:(BOOL)pullDown pullUp:(BOOL)pullUp {
    if (@available(iOS 11, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    // 设置过了就不设置了
    if (_tableView == nil) {
        _tableView = tableView;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0 ;
        if (pullDown) {
            // 下拉刷新
            _refreshHeaderView =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData:)];
            _tableView.mj_header = self.refreshHeaderView;
        }
        
        if (pullUp) {
            // 上拉加载更多
            _refreshFooterView = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(loadMoreData)];
            _tableView.mj_footer = self.refreshFooterView;
            _refreshFooterView.hidden = YES;
            
        }
    }
}

/**
 设置需要刷新的collectionView
 
 @param collectionView 需要刷新的collectionView
 */
- (void)setRefreshCollectionView:(UICollectionView *)collectionView pullDown:(BOOL)pullDown pullUp:(BOOL)pullUp {
    if (@available(iOS 11, *)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    // 设置过了就不设置了
    if (_collectionView == nil) {
        _collectionView = collectionView;
        
        if (pullDown) {
            // 下拉刷新
            _refreshHeaderView =  [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData:)];
            _collectionView.mj_header = self.refreshHeaderView;
        }
        
        if (pullUp) {
            // 上拉加载更多
            _refreshFooterView = [MJRefreshAutoStateFooter footerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(loadMoreData)];
            _collectionView.mj_footer = self.refreshFooterView;
            _refreshFooterView.hidden = YES;
            
        }
    }
}

/**
 加载最新
 */
- (void)loadNewData : (BOOL) isShowHud{
    
    //    NSLog(@"加载最新");
}

/**
 加载更多
 */
- (void)loadMoreData {
    //    NSLog(@"加载更多");
    // 判断是否有下一页,隐藏底部
    
}

- (void)stopLoading {
    
    if (self.tableView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            [self.refreshFooterView resetNoMoreData];
        });
    }
    else if (self.collectionView) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView.mj_header endRefreshing];
            [self.refreshFooterView resetNoMoreData];
        });
    }
}


- (BOOL)enableScrollWhenPlaceHolderViewShowing{
    return YES;
}

-(void)setPlaceholderViewOffsetY:(CGFloat)placeholderViewOffsetY{
    _placeholderViewOffsetY = placeholderViewOffsetY;
}

-(UIView *)makePlaceHolderView{
    [self.view layoutIfNeeded];

    //    没数据上拉刷新不显示
    _refreshFooterView.hidden = YES;
    
    UIView *placeholderView = [[UIView alloc]init];
    placeholderView.userInteractionEnabled = NO;
    //    placeholderView.center = CGPointMake(0, 100);
    
    
    if (!_isHideBlankView) {
        
        
       _blankImgV  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noData_placeholder"]];
        [placeholderView addSubview:_blankImgV];
        if (_placeholderViewOffsetY > 0) {
            [_blankImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(placeholderView);
                make.centerY.mas_equalTo(placeholderView).offset(-kFitW(15) + kFitW(_placeholderViewOffsetY));
                make.height.width.mas_equalTo(kFitW(160));
            }];
        }else{
            [_blankImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(placeholderView);
                make.centerY.mas_equalTo(placeholderView).offset(-kFitW(40));
                make.height.width.mas_equalTo(kFitW(160));
            }];
        }
        
        
        UILabel *lb = [[UILabel alloc]init];
        lb.textColor = COLOR_WITH_HEX(0x606060);
        lb.font = kFont(14);
        lb.center = self.view.center;
        lb.textAlignment= NSTextAlignmentCenter;
        if (kEmptyStr(_blankTips)) {
            lb.text = kLocalized(@"还没有记录哦~");
        }else{
            lb.text = _blankTips;
        }
        
        if (!_blankImage) {
            //             imagV.image = _blankImage;
        }
        [placeholderView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_blankImgV.mas_bottom).offset(kFitW(0));
            make.centerX.mas_equalTo(placeholderView);
        }];
        
    }
    
    return placeholderView;
}

-(BOOL)enableCollectionViewScrollWhenPlaceHolderViewShowing{
    return YES;
}

-(UIView *)makeCollectionViewPlaceHolderView{
    [self.view layoutIfNeeded];

    //    没数据上拉刷新不显示
    _refreshFooterView.hidden = YES;
    
    UIView *placeholderView = [[UIView alloc]init];
    placeholderView.userInteractionEnabled = NO;
    //    placeholderView.center = CGPointMake(0, 100);
    
    
    if (!_isHideBlankView) {
        
        
       _blankImgV  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noData_placeholder"]];
        [placeholderView addSubview:_blankImgV];
        if (_placeholderViewOffsetY > 0) {
            [_blankImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(placeholderView);
                make.centerY.mas_equalTo(placeholderView).offset(-kFitW(15) + kFitW(_placeholderViewOffsetY));
                make.height.width.mas_equalTo(kFitW(160));
            }];
        }else{
            [_blankImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(placeholderView);
                make.centerY.mas_equalTo(placeholderView).offset(-kFitW(40));
                make.height.width.mas_equalTo(kFitW(160));
            }];
        }
        
        
        UILabel *lb = [[UILabel alloc]init];
        lb.textColor = COLOR_WITH_HEX(0x606060);
        lb.font = kFont(14);
        lb.center = self.view.center;
        lb.textAlignment= NSTextAlignmentCenter;
        if (kEmptyStr(_blankTips)) {
            lb.text = kLocalized(@"还没有记录哦~");
        }else{
            lb.text = _blankTips;
        }
        
        if (!_blankImage) {
            //             imagV.image = _blankImage;
        }
        [placeholderView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_blankImgV.mas_bottom).offset(kFitW(0));
            make.centerX.mas_equalTo(placeholderView);
        }];
        
    }
    
    return placeholderView;
}
@end
