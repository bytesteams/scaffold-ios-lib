//
//  MDErrorView.m
//  MDHealth
//
//  Created by 林志军 on 2020/7/28.
//  Copyright © 2020 stargo. All rights reserved.
//

#import "MDErrorView.h"

@interface MDErrorView(){
    
    UILabel *_tipsLb;
    
}

@end
@implementation MDErrorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)showErrorViewIn:(UIView *)contentView{
    
    self.tag = 9998;
    
    if (!contentView) {
        return;
    }
    
    [contentView addSubview:self];
    CGFloat top = [LZJPublicUtility getCurrentViewController].navigationController.navigationBarHidden ? kNavBarHeight : 0;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    self.backgroundColor = kWhiteColor;
    
    UIImageView *imageV = [[UIImageView alloc]init];
      imageV.image = [UIImage imageNamed:@"no_net"];
      [self addSubview:imageV];
      [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
          make.centerX.mas_equalTo(self);
          make.centerY.mas_equalTo(self).offset(kFitW(-40));
          make.width.height.mas_equalTo(kFitW(0));
      }];
      
    _tipsLb  = [[UILabel alloc]init];
    _tipsLb.textColor = kText999;
    _tipsLb.font = kBoldFont(15);
    _tipsLb.text = kLocalized(@"服务器出错,请刷新试试看~");
    if (_code == -1009) {
        _tipsLb.text = @"网络异常,请检查网络连接";

    }
    [self addSubview:_tipsLb];
    [_tipsLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageV.mas_bottom).offset(kFitW(15));
        make.centerX.mas_equalTo(imageV);
    }];
    
    UIButton *refreshBtn = [[UIButton alloc]init];
    refreshBtn.titleLabel.font = kFont(15);
    [refreshBtn setTitle:kLocalized(@"点击刷新") forState:UIControlStateNormal];
    [refreshBtn setTitleColor:kText999 forState:UIControlStateNormal];
    refreshBtn.layer.cornerRadius = kFitW(30) /2;
    refreshBtn.clipsToBounds = YES;
    refreshBtn.layer.borderWidth = 0.5;
    refreshBtn.layer.borderColor = kText999.CGColor;
    [self addSubview:refreshBtn];
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tipsLb.mas_bottom).offset(kFitW(20));
        make.centerX.mas_equalTo(imageV);
        make.height.mas_equalTo(kFitW(30));
        make.width.mas_equalTo(refreshBtn.intrinsicContentSize.width + kFitW(20));
    }];
    [refreshBtn addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)setCode:(NSInteger)code{
    _code = code;
   
}


-(void)refreshBtnClick{
    
    
    if (_refreshBlock) {
        _refreshBlock();
    }
    
//    [self removeFromSuperview];
}


@end
