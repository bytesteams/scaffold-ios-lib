//
//  HcdGuideViewCell.m
//  HcdGuideViewDemo
//
//  Created by polesapp-hcd on 16/7/12.
//  Copyright © 2016年 Polesapp. All rights reserved.
//

#import "HcdGuideViewCell.h"
#import "HcdGuideView.h"
@interface HcdGuideViewCell()

@end

@implementation HcdGuideViewCell

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.layer.masksToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView = [[UIImageView alloc]initWithFrame:kHcdGuideViewBounds];
    self.imageView.center = CGPointMake(kHcdGuideViewBounds.size.width / 2, kHcdGuideViewBounds.size.height / 2);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    button.hidden = YES;
    [button setTitle:kLocalized(@"立即体验") forState:UIControlStateNormal];


    self.button = button;
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.button];
    
    button.layer.cornerRadius = kFitW(16);
    button.clipsToBounds = YES;
    [button setBackgroundImage:[UIImage imageNamed:@"login_red_bar"] forState:0];
    [button setTitleColor:kWhiteColor forState:0];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(kFitW(-32));
        make.width.mas_equalTo(kFitW(180));
        make.height.mas_equalTo(kFitW(32));
    }];
    
}

@end
