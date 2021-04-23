//
//  MDAlertView.m
//  MDHealth
//
//  Created by 林志军 on 2020/9/16.
//  Copyright © 2020 startgo. All rights reserved.
//

#import "MDAlertView.h"
#import "UIButton+Block.h"
#import "LZJTextTool.h"

@interface MDAlertView (){
    
    UIView *_contentView;
}

@end

@implementation MDAlertView

-(void)showSelectAlertView:(NSString *)msg inView:(UIView *)view WithBlock :(handelDoneBlock)doneBlock{
    
    self.backgroundColor = RGB_Alpha(0, 0, 0, 0.2);
    [view addSubview:self];
    
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];;
    
    
    
    
    _contentView = [[UIView alloc]init];
    _contentView.backgroundColor = kWhiteColor;
    _contentView.layer.cornerRadius = kFitW(10);
    _contentView.clipsToBounds = YES;
    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kFitW(300));
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
    }];
    
    
    UILabel *msgLb = [[UILabel alloc]init];
    msgLb.numberOfLines = 6;
    msgLb.textColor = kText262;
    msgLb.font = kFont(16);
    msgLb.text = msg;
    [_contentView addSubview:msgLb];
    [msgLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentView.mas_top).offset(kFitW(32));
        make.left.mas_equalTo(kFitW(18));
        make.right.mas_equalTo(kFitW(-18));
    }];
    [LZJTextTool chanegeLinespace:kFitW(10) inLabel:msgLb];
    msgLb.textAlignment = NSTextAlignmentCenter;
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn setTitle:kLocalized(@"取消") forState:0];
    [cancelBtn setTitleColor:kText262 forState:0];
    cancelBtn.titleLabel.font = kFont(16);
    cancelBtn.layer.cornerRadius = kFitW(16);
    cancelBtn.backgroundColor = COLOR_WITH_HEX(0XDCDCDC);
    cancelBtn.clipsToBounds = YES;
    [_contentView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(msgLb.mas_bottom).offset(kFitW(32));
        make.bottom.mas_equalTo(_contentView.mas_bottom).offset(kFitW(-25));
        make.centerX.mas_equalTo(_contentView).offset(-kFitW(60));
        make.height.mas_equalTo(kFitW(32));
        make.width.mas_equalTo(kFitW(80));
    }];
    
    UIButton *doneBtn = [[UIButton alloc]init];
    [doneBtn setTitle:kLocalized(@"确定") forState:0];
    [doneBtn setTitleColor:kWhiteColor forState:0];
    doneBtn.titleLabel.font = kFont(16);
    doneBtn.layer.cornerRadius = kFitW(16);
    doneBtn.clipsToBounds = YES;
    [_contentView addSubview:doneBtn];
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_contentView.mas_bottom).offset(kFitW(-25));
        make.centerX.mas_equalTo(_contentView).offset(kFitW(60));   make.height.mas_equalTo(kFitW(32));
        make.width.mas_equalTo(kFitW(80));
    }];
    
    //渐变颜色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors     = @[(__bridge id)COLOR_WITH_HEX(0xFF6B6B).CGColor, (__bridge id)COLOR_WITH_HEX(0xE52057).CGColor];
    gradientLayer.locations  = @[@0.3, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint   = CGPointMake(1.0, 0);
    gradientLayer.frame      =  RECT(0, 0, kFitW(130), kFitW(36));
    [doneBtn.layer insertSublayer:gradientLayer atIndex:0];
    
    
    WeakSelf
    [doneBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if (doneBlock) {
            doneBlock();
        }
        [weakSelf doneClick];
        
    }];
    
    [cancelBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        [weakSelf doneClick];
        
    }];
}

-(void)showDoneAlertView:(NSString *)msg inView:(UIView *)view WithBlock :(handelDoneBlock)doneBlock{
    
    self.backgroundColor = RGB_Alpha(0, 0, 0, 0.2);
    [view addSubview:self];
    
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    _contentView = [[UIView alloc]init];
    _contentView.backgroundColor = kWhiteColor;
    _contentView.layer.cornerRadius = kFitW(10);
    _contentView.clipsToBounds = YES;
    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kFitW(265));
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
    }];
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_done"]];
    [_contentView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(kFitW(0));
        make.width.mas_equalTo(kFitW(170));
        make.height.mas_equalTo(kFitW(120));
        
    }];
    
    UILabel *msgLb = [[UILabel alloc]init];
    msgLb.numberOfLines = 6;
    msgLb.textColor = kText262;
    msgLb.font = kFont(14);
    msgLb.text = msg;
    [_contentView addSubview:msgLb];
    [msgLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageV.mas_bottom).offset(kFitW(20));
        make.left.mas_equalTo(kFitW(18));
        make.right.mas_equalTo(kFitW(-18));
    }];
    
    UIButton *doneBtn = [[UIButton alloc]init];
    [doneBtn setTitle:kLocalized(@"确定") forState:0];
    [doneBtn setTitleColor:kWhiteColor forState:0];
    doneBtn.titleLabel.font = kFont(16);
    doneBtn.layer.cornerRadius = kFitW(18);
    doneBtn.clipsToBounds = YES;
    [_contentView addSubview:doneBtn];
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_contentView.mas_bottom).offset(kFitW(-25));
        make.centerX.mas_equalTo(_contentView);
        make.height.mas_equalTo(kFitW(36));
        make.width.mas_equalTo(kFitW(130));
    }];
    
    //渐变颜色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors     = @[(__bridge id)COLOR_WITH_HEX(0xFF6B6B).CGColor, (__bridge id)COLOR_WITH_HEX(0xE52057).CGColor];
    gradientLayer.locations  = @[@0.3, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint   = CGPointMake(1.0, 0);
    gradientLayer.frame      =  RECT(0, 0, kFitW(130), kFitW(36));
    [doneBtn.layer insertSublayer:gradientLayer atIndex:0];
    
    
    WeakSelf
    [doneBtn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if (doneBlock) {
            doneBlock();
        }
        [weakSelf doneClick];
        
    }];
    
}

-(void)doneClick{
    [self removeFromSuperview];
    
}
@end
