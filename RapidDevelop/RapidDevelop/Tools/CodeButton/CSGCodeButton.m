//
//  CSGCodeButton.m
//  ESWY
//
//  Created by lzj on 2018/4/18.
//  Copyright © 2018年 CSG. All rights reserved.
//

#import "CSGCodeButton.h"
#import <MSWeakTimer.h>
@interface CSGCodeButton (){
    /**验证码时间*/
    NSInteger _timeNumber;
    /**计时器*/
    MSWeakTimer *_myTimer;
}
@end

@implementation CSGCodeButton


//-(void)setUrl:(NSString *)url{
//
//    _url = url;
//
//    [self addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
//}
//
//-(void)setMobile:(NSString *)mobile{
//    _mobile = mobile;
//}

-(void)getCodeWithUrl:(NSString *)url mobile:(NSString *)mobile{
    
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"mobile"] =  mobile;
    [[MDNetworkTool shareManager]MDRequestWithHud:YES In:[LZJPublicUtility getCurrentViewController].view type:1 Parameter:para header:nil model:nil url:url successBlock:^( NSMutableArray * _Nullable modelArray, id  _Nullable model, id  _Nullable responseObject) {

        NSLog(@"%@",responseObject)
         [self readSecond];
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {

    }];

}

-(void)readSecond
{
    self.userInteractionEnabled=NO;
    _timeNumber = 60;
    _myTimer = [MSWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dealSecond) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
    [self dealSecond];
}
-(void)dealSecond
{
    _timeNumber= _timeNumber-1;
    [self setTitle:[NSString stringWithFormat:@"%lds",(long)_timeNumber] forState:UIControlStateNormal];
    if (_timeNumber==0) {
        //销毁定制器
        [_myTimer invalidate];
        _myTimer = nil ;
        _timeNumber=60;
        self.userInteractionEnabled=YES;
        [self setTitle: kLocalized(@"获取验证码") forState:UIControlStateNormal];
    }
}

-(void)dealloc{
    [_myTimer invalidate];
    _myTimer = nil ;
}

@end
