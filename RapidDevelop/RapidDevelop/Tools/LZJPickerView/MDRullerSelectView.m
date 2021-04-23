//
//  MDRullerSelectView.m
//  MDHealth
//
//  Created by 林志军 on 2020/8/28.
//  Copyright © 2020 startgo. All rights reserved.
//

#import "MDRullerSelectView.h"
#import "DYScrollRulerView.h"
@interface MDRullerSelectView()<DYScrollRulerDelegate>{
    DYScrollRulerView *_weightRuler;
    DYScrollRulerView *_heightRuler;
    NSString *_value;
}
@property(nonatomic,assign)CGFloat height;
@property (nonatomic,strong)UIView *bgV;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UIView *contentView;
@end

@implementation MDRullerSelectView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
       
        _height = frame.size.height;
        self.frame = frame;
        self.backgroundColor = RGB_Alpha(51, 51, 51, 0.3);

        self.bgV = [[UIView alloc]initWithFrame:CGRectMake(0, _height, kScreenWidth, 270)];
        self.bgV.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgV];
       
        //部分圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgV.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerTopLeft) cornerRadii:CGSizeMake(kFitW(15),kFitW(15))];//圆角大小
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bgV.bounds;
        maskLayer.path = maskPath.CGPath;
        self.bgV.layer.mask = maskLayer;
        
        UIView *topView = [[UIView alloc]init];
        topView.frame = CGRectMake(0, 0, kScreenWidth, 44);
        [self.bgV addSubview:topView];
        topView.backgroundColor = kWhiteColor;
        
        

      
        //取消
        UIButton *cancelBtn = [[UIButton alloc]init];
          cancelBtn.frame = CGRectMake(8, kFitW(10), 60, 44);
        [cancelBtn setTitleColor:kText262 forState:0];
        [topView addSubview:cancelBtn];
      
      
        cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [cancelBtn setTitle:kLocalized(@"取消") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(hideAnimation) forControlEvents:UIControlEventTouchUpInside];
       
        //完成
        UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         completeBtn.frame = CGRectMake(kScreenWidth - 69, kFitW(10), 60, 44);
        [topView addSubview:completeBtn];
       
       
        completeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [completeBtn setTitleColor:kMainColor forState:0];
        [completeBtn setTitle:kLocalized(@"确认") forState:UIControlStateNormal];
        [completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
  
        _titleLb= [[UILabel alloc]init];
        _titleLb.font = kFont(14);
        _titleLb.textColor = kText9A9;
        _titleLb.text = _titleStr;
        [topView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(completeBtn);
            make.centerX.mas_equalTo(topView);
            make.width.mas_lessThanOrEqualTo(kScreenWidth - 120);
        }];
        
        //线
        UIView *line = [UIView new];
        line.frame = CGRectMake(0, CGRectGetMaxY(topView.frame), kScreenHeight, 0.5);
        [self.bgV addSubview:line];
        
        line.backgroundColor = kWhiteColor;
        
  
        self.contentView = [UIView new];
        self.contentView.frame = CGRectMake(0, CGRectGetMaxY(line.frame), kScreenWidth, 270 -CGRectGetMaxY(line.frame) );
        [self.bgV addSubview:self.contentView];
        
        
        UITapGestureRecognizer *bgTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgViewTap:)];
        [self addGestureRecognizer:bgTap];
        
         [self showAnimation];
        
       
        
    }
    return self;
    
}


-(void)setType:(MDRullerType)type{
    _type = type;
    
    if (_type == MDRullerWeight) {
        
        [self setupWeightRuller];
        
    }else if (type == MDRullerHeight){
        [self setupheightRuller];
    }
    
}

-(void)setCurrentValue:(NSString *)currentValue{
    _currentValue = currentValue;
}

-(void)setTitleStr:(NSString *)titleStr{
    _titleLb.text = titleStr;
}

-(void)setupWeightRuller{
    _weightRuler  = [[DYScrollRulerView alloc]initWithFrame:RECT(0, kFitW(50), kScreenWidth, kFitW(80)) theMinValue:0 theMaxValue:250 theStep:0.1 theUnit:@"kg" theNum:10];
    _weightRuler.triangleColor = kMainColor;
    if (_currentValue.floatValue > 0) {
       _value = [NSString stringWithFormat:@"%.1f",_currentValue.floatValue] ;
    }else{
        _value = @"60.0";
    }
    [_weightRuler setDefaultValue:_value.floatValue animated:YES];
    
    _weightRuler.bgColor = COLOR_WITH_HEX(0xf6f6f6);
    _weightRuler.delegate        = self;
    _weightRuler.scrollByHand    = YES;
    [self.contentView addSubview:_weightRuler];
    [_weightRuler mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kFitW(35));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kFitW(120));
    }];
    
}

-(void)setupheightRuller{
    _heightRuler  = [[DYScrollRulerView alloc]initWithFrame:RECT(0, kFitW(50), kScreenWidth, kFitW(80)) theMinValue:0 theMaxValue:250 theStep:0.1 theUnit:@"cm" theNum:10];
    _heightRuler.triangleColor = kMainColor;
  
    if (_currentValue.floatValue > 0) {
        _value = [NSString stringWithFormat:@"%.1f",_currentValue.floatValue] ;
    }else{
        _value = @"160.0";
    }
    
    [_heightRuler setDefaultValue:_value.floatValue animated:YES];
    _heightRuler.bgColor = COLOR_WITH_HEX(0xf6f6f6);
    _heightRuler.delegate        = self;
    _heightRuler.scrollByHand    = YES;
    [self.contentView addSubview:_heightRuler];
    [_heightRuler mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kFitW(35));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kFitW(120));
    }];
}



-(void)dyScrollRulerView:(DYScrollRulerView *)rulerView valueChange:(float)value{
    
    _value = [NSString stringWithFormat:@"%.1lf",value];
}

- (void)completeBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(MDRullerSelectStr::)]) {
        [self.delegate MDRullerSelectStr:_value : self];
    }
    
    [self hideAnimation];
}


-(void)bgViewTap :(UITapGestureRecognizer *)tap{
    CGPoint tapPoint = [tap locationInView:self];
    
    if (CGRectContainsPoint(_bgV.frame, tapPoint)) {
        
    }else{
        
        [self hideAnimation];
        
    }
}

//隐藏动画
- (void)hideAnimation{
   
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = self.bgV.frame;
        frame.origin.y = _height;
        self.bgV.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [self.bgV removeFromSuperview];
        [self removeFromSuperview];
        
    }];
    
}

//显示动画
- (void)showAnimation{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = self.bgV.frame;
        frame.origin.y = _height-270;
        self.bgV.frame = frame;
    }];
    
}

@end
