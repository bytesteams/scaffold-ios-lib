//
//  NXPickerView.h
//  NaoXinFaWu
//
//  Created by 林志军 on 17/1/4.
//  Copyright © 2017年 naoxin_Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LZJPickerView;
@protocol LZJPickerViewDelegate <NSObject>

-(void)pickerViewSelectStr  :(NSString *)string :(LZJPickerView *)pickerView;
//-(void)pickerViewSelectStr  :(NSString *)string;
@optional
-(void)pickerViewHide;
@end

typedef NS_ENUM(NSInteger,pickerArray){
    role,//角色 原告被告
    fenceAlertType,//围栏警告方式
    myArea,//我的地址
    address,//地址
    carType,//汽车类型
    bidDuration,//围栏警告方式
    mileRange,//里程数
    meetDate,//时间
    dateYMD,//年月日
    dateYM, //年月
    dateYMDHM,//年月日时分
    height,//身高
    accountType, //银行卡 支付宝
    cardType, //证件类型 1身份证，2护照, 3社保卡,4驾驶证,5军人证，6武警证， 7港澳居民往来内地通行证, 8.台湾居民来往大陆通行证
    country,//国家
    gameList,
    gender
    
};

@interface LZJPickerView : UIView
@property(nonatomic,assign)pickerArray typeArray;
@property(nonatomic,assign)id<LZJPickerViewDelegate> delegate;
@property(nonatomic,strong)NSMutableArray *messageArray;
-(void)cancelBtnClick;
@property(nonatomic,copy)NSString *titleStr;
//是否显示全部
@property(nonatomic,assign)BOOL isShowAllStr;
@end
