//
//  NXPickerView.m
//  NaoXinFaWu
//
//  Created by 林志军 on 17/1/4.
//  Copyright © 2017年 naoxin_Ltd. All rights reserved.
//

#import "LZJPickerView.h"
#import <Masonry.h>
#import "MDCacheManager.h"
@interface LZJPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,assign)CGFloat height;
@property (nonatomic,strong)UIView *bgV;
@property(nonatomic,strong)UILabel *titleLb;
@property (nonatomic,strong)UILabel *selectLb;
@property (nonatomic,strong)UIPickerView *pickerV;
//国家
@property(nonatomic,strong)NSMutableArray *countryModels;
//地址
@property(nonatomic,copy)NSDictionary *pickerDic;
@property(nonatomic,strong)NSMutableArray *provinceArray;
@property(nonatomic,copy)NSArray *selectedArray;
@property(nonatomic,copy)NSArray *cityArray;
@property(nonatomic,copy)NSArray *townArray;
//案件分类
@property(nonatomic,strong)NSMutableArray *lawCategoryArray;
@property(nonatomic,strong)NSMutableArray *firstArray;
@property(nonatomic,strong)NSMutableArray *secondArray;


@property(nonatomic,copy)NSDictionary *areaDict ;
@property(nonatomic,strong)NSMutableArray *provinceKeysArray;
@property(nonatomic,copy)NSArray *cityKeysArray;

@property(nonatomic,assign)NSInteger selectingProvinceIndex;
@end



@implementation LZJPickerView



-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.messageArray = [NSMutableArray array];
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
        
        
        _titleLb= [[UILabel alloc]init];
        _titleLb.font = kFont(14);
        _titleLb.textColor = kText9A9;
        _titleLb.text = _titleStr;
        [topView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(topView);
            make.width.mas_lessThanOrEqualTo(kScreenWidth - 120);
        }];
      
        //取消
        UIButton *cancelBtn = [[UIButton alloc]init];
          cancelBtn.frame = CGRectMake(8, kFitW(10), 60, 44);
        [cancelBtn setTitleColor:kText262 forState:0];
        [topView addSubview:cancelBtn];
      
      
        cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [cancelBtn setTitle:kLocalized(@"取消") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
       
        //完成
        UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         completeBtn.frame = CGRectMake(kScreenWidth - 69, kFitW(10), 60, 44);
        [topView addSubview:completeBtn];
       
       
        completeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [completeBtn setTitleColor:kMainColor forState:0];
        [completeBtn setTitle:kLocalized(@"确认") forState:UIControlStateNormal];
        [completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
  
        
        
        //线
        UIView *line = [UIView new];
        line.frame = CGRectMake(0, CGRectGetMaxY(topView.frame), kScreenHeight, 0.5);
        [self.bgV addSubview:line];
       
        line.backgroundColor = kWhiteColor;
        
        //选择器
        self.pickerV = [UIPickerView new];
        self.pickerV.frame = CGRectMake(0, CGRectGetMaxY(line.frame), kScreenWidth, 270 -CGRectGetMaxY(line.frame) );
        [self.bgV addSubview:self.pickerV];
       
      
        self.pickerV.delegate = self;
        self.pickerV.dataSource = self;
        
         [self showAnimation];
        
        UITapGestureRecognizer *bgTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgViewTap:)];
        [self addGestureRecognizer:bgTap];
        
    }
    return self;
    
}

-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    _titleLb.text = _titleStr;
}

-(void)setIsShowAllStr:(BOOL)isShowAllStr{
    _isShowAllStr = isShowAllStr;
}

-(void)setTypeArray:(pickerArray)typeArray
{
    _typeArray=typeArray;
    switch (typeArray) {
        case role:
            [self.messageArray addObject:@[@"原告",@"被告"]];
            break;
        case fenceAlertType:
            [self.messageArray addObject:@[@"使出提醒",@"驶入提醒",@"进出提醒"]];
        case country:
            [self downloadCountry];
            break;
        case myArea:
            [self createAddress];
            break;
            
         case gameList:
//            [self getGameList];
            break;
        case carType:
            [self.messageArray addObject:@[@"小型汽车",@"大型汽车"]];
            break;
        case bidDuration:
            [self.messageArray addObject:@[@"进出提醒",@"驶出提醒",@"驶入提醒"]];
            break;
        case mileRange:
            [self.messageArray addObject:@[@"500KM",@"1000KM",@"2000KM",@"2500KM"]];
            break;
        case meetDate:
            [self createDate];
            break ;
        case dateYMD:
            [self createDateYMD];
            break ;
        case dateYM:
            [self createDateYM];
            break;
            
        case dateYMDHM:
            [self createDate];
            break;
            
        case height:
          
            [self createHeight];
          
            break;
            
        case accountType:
            [self.messageArray addObject:@[@"银行卡",@"支付宝账号"]];
            break ;
            
        case cardType:
            [self.messageArray addObject:@[@"身份证",@"护照",@"社保卡",@"驾驶证",@"军人证",@"武警证",@"武警证",@"港澳居民往来内地通行证",@"台湾居民来往大陆通行证"]];
            break ;
      
        case gender:
            [self.messageArray addObject:@[kLocalized(@"男"),kLocalized(@"女")]];
            break;
        default:
            break;
    }
}

-(void)getGameList{
   
}

-(void)createAddress{
    [self downloadCountry];
}

-(void)downloadCountry{

    [[MDNetworkTool shareManager]MDCacheRequestWithHud:YES In:[LZJPublicUtility getCurrentViewController].view type:1 Parameter:nil header:nil model:nil url:@"" cacheBlock:^(NSMutableArray * _Nullable modelArray, id  _Nullable model, id  _Nullable responseObject) {
        
        [self setupData:responseObject];
        
    } successBlock:^(NSMutableArray * _Nullable modelArray, id  _Nullable model, id  _Nullable responseObject) {
        
        BOOL isSameData  = [[MDCacheManager shareManager]compareCache:@"" WithResponseObject:responseObject];
        if (!isSameData) {
            [self setupData:responseObject];
        }
        
       
        
    } failureBlock:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}

-(void)setupData:(id)responseObject{
    
    NSMutableArray *dataArray =[NSMutableArray arrayWithArray: responseObject[@"data"]];
    
    if (_isShowAllStr) {
        //插入全部
        NSDictionary *allDict = @{
            
            @"id" : @999 ,
            @"provinceId" : @999999,
            @"province" : @"全部",
            @"cityList" :@[
                    @{
                        @"id": @1,
                        @"cityId": @999998,
                        @"city": @"全部",
                        @"provinceId": @999999,
                        
                        @"areasList": @[
                                @{
                                    @"id" : @1,
                                    @"areaId": @999997,
                                    @"area": @"全部",
                                    @"cityId": @999998,
                                }
                                
                        ]
                    }
            ]
        };

        
        [dataArray insertObject:allDict atIndex:0];
    }

    NSMutableDictionary *tempData = [NSMutableDictionary dictionaryWithDictionary:responseObject];
    tempData[@"data"] = dataArray;
    self.areaDict = tempData;
    
    NSMutableArray *provinceArray = [NSMutableArray array];
    
    NSMutableArray *cityArray = [NSMutableArray array];
    
    NSMutableArray *areaArray = [NSMutableArray array];
    
    for (NSDictionary *dict in dataArray) {
        
        [provinceArray addObject:dict[@"province"]];
       
    }
    
    
    
    NSDictionary *dict = dataArray[0];
    
    NSArray *tempCity = dict[@"cityList"];
    for (NSDictionary *dict in tempCity) {
        [cityArray addObject:dict[@"city"]];
        
    }
    
    NSDictionary *areaDict = tempCity[0];
    NSArray *tempArea = areaDict[@"areasList"];
    for (NSDictionary *dict in tempArea) {
        [areaArray addObject:dict[@"area"]];
    }
    
    self.provinceArray = provinceArray;
    
    self.cityArray = cityArray;
    
    self.townArray = areaArray;
    
    [self.pickerV reloadAllComponents];
    

    
}

-(void)createHeight{
    NSMutableArray *heightArray = [NSMutableArray array];
    for (int i = 140; i<220; i++) {
        [heightArray addObject:[NSString stringWithFormat:@"%dcm",i]];
    }
    [self.messageArray addObject:heightArray];
}

-(void)setAddressData:(id)responseObject{
    //成功 缓存
//    YYCache *yyCache=[YYCache cacheWithName:@"LD_ESWY_Cache"];
//    [yyCache setObject:responseObject forKey:@"addressCache"];
    
    NSDictionary *dict = responseObject[@"data"];
    self.areaDict = dict;
    NSDictionary *provinceDict = dict[@"100000"];
    
    NSArray *provinceKeysArray = [provinceDict.allKeys  sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        return NSOrderedDescending ;
    }];
    NSArray *provinceValuesArray = [provinceDict.allValues  sortedArrayUsingComparator: ^(id obj1, id obj2) {
        return NSOrderedDescending ;
    }];
    
    self.provinceKeysArray = [NSMutableArray arrayWithArray:provinceKeysArray];
    self.provinceArray = [NSMutableArray arrayWithArray:provinceValuesArray];
    //    //把广东放第一
    [self.provinceKeysArray exchangeObjectAtIndex:0 withObjectAtIndex:5];
    [self.provinceArray exchangeObjectAtIndex:0 withObjectAtIndex:5];
    
    
    NSDictionary *cityDict = self.areaDict[self.provinceKeysArray[0]];
    NSArray *cityKeysArray = cityDict.allKeys;
    NSArray *cityValuesArray =  cityDict.allValues;
    self.cityArray = cityValuesArray;
    self.cityKeysArray = cityKeysArray;//保存keys
    
    NSDictionary *districtDict = self.areaDict[self.cityKeysArray[0]];
    NSArray *districtValues =  districtDict.allValues;
    self.townArray = districtValues;
    //刷新数据
    [self.pickerV reloadAllComponents];
}

-(void)createDate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    formatter.dateFormat=@"yyyy";
    NSString *year = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    int yearForArray=year.intValue;
    
    NSMutableArray *yearArray = [[NSMutableArray alloc] init];
    for (int i = yearForArray - 10; i <= yearForArray  ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.messageArray addObject:yearArray];
    
    NSMutableArray *monthArray = [[NSMutableArray alloc]init];
    for (int i = 1; i < 13; i ++) {
        
        [monthArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.messageArray addObject:monthArray];
    
    NSMutableArray *daysArray = [[NSMutableArray alloc]init];
    for (int i = 1; i < 32; i ++) {
        
        [daysArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.messageArray addObject:daysArray];
    
    NSMutableArray *hourArray=[[NSMutableArray alloc]init];
    for (int i = 0; i < 24; i ++) {
        
        [hourArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.messageArray addObject:hourArray];
    
    NSMutableArray *minuteArray=[[NSMutableArray alloc]init];
    for (int i = 0; i < 60; i ++) {
        
        [minuteArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.messageArray addObject:minuteArray];
    
    //定位到当前的日期
    formatter.dateFormat=@"yyyy";
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"us"]];

    NSString *currentYear = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    [self.pickerV selectRow:[yearArray indexOfObject:currentYear] inComponent:0 animated:YES];
    //有01 02 03月 所以要转成inter
    formatter.dateFormat=@"MM";
    NSString *currentMonth = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
    
    [self.pickerV selectRow:[monthArray indexOfObject:currentMonth] inComponent:1 animated:YES];
    
    formatter.dateFormat=@"dd";
    NSString *currentDay = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
    [self.pickerV selectRow:[daysArray indexOfObject:currentDay] inComponent:2 animated:YES];
    
    formatter.dateFormat=@"HH";
    NSString *currentHour = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
    [self.pickerV selectRow:[hourArray indexOfObject:currentHour] inComponent:3 animated:YES];
//
    formatter.dateFormat=@"mm";
    NSString *currentMinute = [NSString stringWithFormat:@"%ld",(long)[[formatter stringFromDate:date]integerValue]];
    [self.pickerV selectRow:[minuteArray indexOfObject:currentMinute] inComponent:4 animated:YES];
    
}


-(void)createDateYM{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    formatter.dateFormat = @"yyyy";
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"us"]];

    NSString *year = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    int yearForArray = year.intValue;
    
    NSMutableArray *yearArray = [[NSMutableArray alloc] init];
    for (int i = yearForArray - 70; i <= yearForArray  ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.messageArray addObject:yearArray];
    
    NSMutableArray *monthArray = [[NSMutableArray alloc]init];
    for (int i = 1; i < 13; i ++) {
      
            [monthArray addObject:[NSString stringWithFormat:@"%d",i]];
       
    }
    [self.messageArray addObject:monthArray];
    

    //定位到当前的日期
    formatter.dateFormat=@"yyyy";
    NSString *currentYear = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    //默认18岁
    [self.pickerV selectRow:[yearArray indexOfObject:[NSString stringWithFormat:@"%ld",currentYear.integerValue ]] inComponent:0 animated:YES];
    //有01 02 03月 所以要转成inter
    formatter.dateFormat=@"MM";
    NSString *currentMonth = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    [self.pickerV selectRow:[monthArray indexOfObject:[NSString stringWithFormat:@"%ld",currentMonth.integerValue ]] inComponent:1 animated:YES];
    
}

-(void)createDateYMD{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    formatter.dateFormat = @"yyyy";
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"us"]];

    NSString *year = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    int yearForArray = year.intValue;
    
    NSMutableArray *yearArray = [[NSMutableArray alloc] init];
    for (int i = yearForArray - 70; i <= yearForArray  ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.messageArray addObject:yearArray];
    
    NSMutableArray *monthArray = [[NSMutableArray alloc]init];
    for (int i = 1; i < 13; i ++) {
        
        [monthArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.messageArray addObject:monthArray];
    
    NSMutableArray *daysArray = [[NSMutableArray alloc]init];
    for (int i = 1; i < 32; i ++) {
        
        [daysArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.messageArray addObject:daysArray];
    
    //定位到当前的日期
    formatter.dateFormat=@"yyyy";
    NSString *currentYear = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    //默认18岁
    [self.pickerV selectRow:[yearArray indexOfObject:[NSString stringWithFormat:@"%ld",currentYear.integerValue ]] inComponent:0 animated:YES];
    //有01 02 03月 所以要转成inter
    formatter.dateFormat=@"M";
    NSString *currentMonth = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    [self.pickerV selectRow:[monthArray indexOfObject:currentMonth] inComponent:1 animated:YES];
    
    formatter.dateFormat=@"d";
    NSString *currentDay = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    [self.pickerV selectRow:[daysArray indexOfObject:currentDay] inComponent:2 animated:YES];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    if (self.typeArray==meetDate || self.typeArray ==myArea ){
        UILabel *label=[[UILabel alloc] init];
        label.frame =CGRectMake(0, 0, 100, 25);
        label.textColor = kText262;
        label.textAlignment = NSTextAlignmentCenter;
        if (component == 0) {
            label.width= 110;
        } else if (component == 1) {
            label.width= 100;
        } else {
            label.width= 110;
        }
        
        label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
        label.font= kFont(16);
        return label;
    }else if (self.typeArray == cardType){
        UILabel *label=[[UILabel alloc] init];
        label.frame =CGRectMake(0, 0, 100, 25);
        label.textColor = kText262;
        label.textAlignment = NSTextAlignmentCenter;
        label.width= kScreenWidth;
        label.text=[self pickerView:pickerView titleForRow:row forComponent:component];
        label.font= kFont(16);
        return label;
    }  else{
        UILabel *label=[[UILabel alloc] init];
        label.textColor = kText262;
        label.frame =CGRectMake(0, 0, 100, 25);
        label.textAlignment = NSTextAlignmentCenter;
        label.width= kScreenWidth;
        label.text=[self pickerView:pickerView titleForRow:row forComponent:component];
        label.font= kFont(16);
        return label;
    }
    
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.typeArray==meetDate) {
        return (kScreenWidth-10)/5;
    }else{
        if (component == 0) {
            return 110;
        } else if (component == 1) {
            return 100;
        } else {
            return 110;
        }
    }
    
}


#pragma mark ***************************************
#pragma mark  pickerViewDataSource*******************

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.typeArray == myArea) {
        return 3;
    }else if (self.typeArray == country){
        return 1;
    }

    
    return self.messageArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (self.typeArray==myArea) {
        if (component == 0) {
            return self.provinceArray.count;
        } else if (component == 1) {
            return self.cityArray.count;
        } else {
            return self.townArray.count;
        }
    }
//    
//    if (self.typeArray == meetDate || self.typeArray == dateYMD) {
//        if (component==0) {
//            NSArray *arr = self.messageArray[0];//获取年数组
//            return arr.count;
//        }else if (component==1)
//        {
//            return 12;
//        }else if (component==2)
//        {
//            return 31;
//        }else if (component==3)
//        {
//            return 24;
//        }else
//        {
//            return 60;
//        }
//    }else if (self.typeArray == country){
//        return _countryModels.count;
//    }
    
    
    NSArray * arr = (NSArray *)[self.messageArray objectAtIndex:component];
    return arr.count;
    
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (self.typeArray==myArea) {
        if (component == 0) {
            return [self.provinceArray objectAtIndex:row];
        } else if (component == 1) {
            return [self.cityArray objectAtIndex:row];
        } else {
            return [self.townArray objectAtIndex:row];
        }
    }else if (self.typeArray == country){
        NSString *modelStr = [_countryModels objectAtIndex:row];
        NSArray *titleArr = [modelStr componentsSeparatedByString:@"&&"];
        if (titleArr.count > 0) {
            return titleArr[0];
        }
    }else if (self.typeArray == gameList){
         NSArray * arr = (NSArray *)[self.messageArray objectAtIndex:component];
        NSDictionary *dict = arr[row];
        
        return dict[@"name"];
        
    }
    
    if (self.typeArray == meetDate) {
        if (component == 3) {
            NSArray *arr = (NSArray *)[self.messageArray objectAtIndex:component];
            return [[arr objectAtIndex:row % arr.count] stringByAppendingString:@"时"];
        }else if (component == 4){
            NSArray *arr = (NSArray *)[self.messageArray objectAtIndex:component];
            return [[arr objectAtIndex:row % arr.count] stringByAppendingString:@"分"];
        }else{
            NSArray *arr = (NSArray *)[self.messageArray objectAtIndex:component];
            return [arr objectAtIndex:row % arr.count];
        }
    }
    
    NSArray *arr = (NSArray *)[self.messageArray objectAtIndex:component];
    return [arr objectAtIndex:row % arr.count];
    
    
}
- (void)cancelBtnClick{
    [self hideAnimation];
    
}


- (void)completeBtnClick{
    
    NSString *fullStr = [NSString string];
    for (int i = 0; i < self.messageArray.count; i++) {
        
        NSArray *arr = [self.messageArray objectAtIndex:i];
        
        NSString *str = [arr objectAtIndex:[self.pickerV selectedRowInComponent:i]];
        fullStr = [fullStr stringByAppendingString:str];
    }
    if (self.typeArray==myArea) {
        
        NSString *province=[self.provinceArray objectAtIndex:[self.pickerV selectedRowInComponent:0]];
        NSString *city = [self.cityArray objectAtIndex:[self.pickerV selectedRowInComponent:1]];
        NSString *region = [self.townArray objectAtIndex:[self.pickerV selectedRowInComponent:2]];
        NSString *str = @"";
        if ([LZJPublicUtility isBlankString:region]) {
            str =  [NSString stringWithFormat:@"%@-%@",province,city];
        }else{
            str =  [NSString stringWithFormat:@"%@-%@-%@",province,city,region];
        }
        
        fullStr=[fullStr stringByAppendingString:str];
    }
    if (self.typeArray== meetDate ) {
        for (int i = 0; i < self.messageArray.count; i++) {
            
            NSArray *arr = [self.messageArray objectAtIndex:i];
            
            NSString *str = [arr objectAtIndex:[self.pickerV selectedRowInComponent:i]];
            fullStr = [fullStr stringByAppendingString:str];
        }
        NSArray  *yearArray =  [self.messageArray objectAtIndex:0];
        NSString *year =  [yearArray objectAtIndex:[self.pickerV selectedRowInComponent:0]];
        NSArray *monthArray =  [self.messageArray objectAtIndex:1];
        NSString *month =  [monthArray objectAtIndex:[self.pickerV selectedRowInComponent:1]];
        NSArray *dayArray =  [self.messageArray objectAtIndex:2];
        NSString *day =  [dayArray objectAtIndex:[self.pickerV selectedRowInComponent:2]];
        NSArray *hourArray =  [self.messageArray objectAtIndex:3];
        NSString *hour =  [hourArray objectAtIndex:[self.pickerV selectedRowInComponent:3]];
        NSArray *minuteArray =  [self.messageArray objectAtIndex:4];
        NSString *minute =  [minuteArray objectAtIndex:[self.pickerV selectedRowInComponent:4]];
        
//        year = [year substringToIndex:year.length -1];
//        month = [month substringToIndex:month.length -1];
//        day = [day substringToIndex:day.length -1];
//        hour = [hour substringToIndex:hour.length -1];
//        minute = [minute substringToIndex:minute.length -1];
        if (month.intValue < 10) {
            month = [NSString stringWithFormat:@"0%@",month];
        }
        if (day.intValue < 10) {
            day = [NSString stringWithFormat:@"0%@",day];
        }
        fullStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
        NSLog(@"%@",fullStr);
        
    }else if (_typeArray == dateYM){
        
        NSArray  *yearArray =  [self.messageArray objectAtIndex:0];
        NSString *year =  [yearArray objectAtIndex:[self.pickerV selectedRowInComponent:0]];
        NSArray *monthArray =  [self.messageArray objectAtIndex:1];
        NSString *month =  [monthArray objectAtIndex:[self.pickerV selectedRowInComponent:1]];
        
        if (month.intValue < 10) {
            month = [NSString stringWithFormat:@"0%@",month];
        }
        
          fullStr = [NSString stringWithFormat:@"%@%@",year,month];
        
    }else if (_typeArray == dateYMD){
        
        NSArray  *yearArray =  [self.messageArray objectAtIndex:0];
        NSString *year =  [yearArray objectAtIndex:[self.pickerV selectedRowInComponent:0]];
        NSArray *monthArray =  [self.messageArray objectAtIndex:1];
        NSString *month =  [monthArray objectAtIndex:[self.pickerV selectedRowInComponent:1]];
        NSArray *dayArray =  [self.messageArray objectAtIndex:2];
        NSString *day =  [dayArray objectAtIndex:[self.pickerV selectedRowInComponent:2]];
        
        if (month.intValue < 10) {
            month = [NSString stringWithFormat:@"0%@",month];
        }
        
        if (day.intValue < 10) {
            day = [NSString stringWithFormat:@"0%@",day];
        }
        
        fullStr = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
        
    } else if (_typeArray == country){
 
        NSString *str = [_countryModels objectAtIndex:[self.pickerV selectedRowInComponent:0]];
        fullStr = str;
      
    }else if (self.typeArray == gameList){
        
        NSArray * arr = (NSArray *)[self.messageArray objectAtIndex:0];
        NSDictionary *dict =  [arr objectAtIndex:[self.pickerV selectedRowInComponent:0]];
        NSString *myId = dict[@"id"];
             
        fullStr = [NSString stringWithFormat:@"%@",myId];

    }
    
    
    if ([self.delegate respondsToSelector:@selector(pickerViewSelectStr::)]) {
        [self.delegate pickerViewSelectStr:fullStr : self];
    }
    [self hideAnimation];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{

    
    NSString *titleStr = @"";
      if (self.typeArray==myArea) {
        if (component == 0) {
            titleStr =  [self.provinceArray objectAtIndex:row];
        } else if (component == 1) {
            titleStr =  [self.cityArray objectAtIndex:row];
        } else {
            titleStr = [self.townArray objectAtIndex:row];
        }
    }else if (self.typeArray == country){
        NSString *modelStr = [_countryModels objectAtIndex:row];
        NSArray *titleArr = [modelStr componentsSeparatedByString:@"&&"];
        if (titleArr.count > 0) {
            titleStr = titleArr[0];
        }
    }else if (self.typeArray == gameList){
         NSArray * arr = (NSArray *)[self.messageArray objectAtIndex:component];
        NSDictionary *dict = arr[row];
        
        titleStr = dict[@"name"];
        
    }
    
    if (self.typeArray == meetDate) {
        if (component == 3) {
            NSArray *arr = (NSArray *)[self.messageArray objectAtIndex:component];
            titleStr =  [[arr objectAtIndex:row % arr.count] stringByAppendingString:@"时"];
        }else if (component == 4){
            NSArray *arr = (NSArray *)[self.messageArray objectAtIndex:component];
            titleStr = [[arr objectAtIndex:row % arr.count] stringByAppendingString:@"分"];
        }else{
            NSArray *arr = (NSArray *)[self.messageArray objectAtIndex:component];
            titleStr = [arr objectAtIndex:row % arr.count];
        }
    }
    
    NSArray *arr = (NSArray *)[self.messageArray objectAtIndex:component];
    titleStr =  [arr objectAtIndex:row % arr.count];
    
   
   
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:titleStr];
    NSRange range = [titleStr rangeOfString:titleStr];
    [attributedString addAttribute:NSForegroundColorAttributeName value:kMainColor range:range];
    
    return attributedString;
}

//让地址选择联动  让案件类别联动
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    if (self.typeArray == myArea) {
       
        if (component == 0) {
            NSMutableArray *myCityArray = [NSMutableArray array];
             NSMutableArray *myAreaArray = [NSMutableArray array];
            NSDictionary *dict = self.areaDict[@"data"][row];
            
            NSArray *cityArray = dict[@"cityList"];
            for (NSDictionary *dict in cityArray) {
                [myCityArray addObject:dict[@"city"]];
            }
            
            NSDictionary *areaDict = cityArray[0];
            NSArray *areaArray = areaDict[@"areasList"];
            for (NSDictionary *dict in areaArray) {
                [myAreaArray addObject:dict[@"area"]];
            }
            
            self.cityArray = myCityArray;
            self.townArray = myAreaArray;
            
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView reloadComponent:1];
            [pickerView selectedRowInComponent:2];
            [pickerView reloadComponent:2];
            
            _selectingProvinceIndex = row;
        }else if (component == 1){
            
            
            NSMutableArray *myCityArray = [NSMutableArray array];
            NSMutableArray *myAreaArray = [NSMutableArray array];
            
            NSDictionary *dict = self.areaDict[@"data"][_selectingProvinceIndex];
            
            NSArray *cityArray = dict[@"cityList"];
            for (NSDictionary *dict in cityArray) {
                [myCityArray addObject:dict[@"city"]];
                
            }
            
            NSDictionary *areaDict = cityArray[row];
            NSArray *areaArray = areaDict[@"areasList"];
            for (NSDictionary *dict in areaArray) {
                [myAreaArray addObject:dict[@"area"]];
            }
            
            self.cityArray = myCityArray;
            self.townArray = myAreaArray;
            
            [pickerView selectedRowInComponent:2];
            [pickerView reloadComponent:2];
        }
  
    }else if (_typeArray == dateYMD || _typeArray == dateYMDHM){
        
        //选择月份的时候
        if (component == 1 || component == 0) {
            
            NSArray  *yearArray =  [self.messageArray objectAtIndex:0];
            NSString *year =  [yearArray objectAtIndex:[self.pickerV selectedRowInComponent:0]];
            
            NSArray *monthArray =  [self.messageArray objectAtIndex:1];
            NSString *month =  [monthArray objectAtIndex:[self.pickerV selectedRowInComponent:1]];
            
            NSInteger days =  [self monthDayWithYear:year month:month] + 1;
            NSMutableArray *daysArray = [[NSMutableArray alloc]init];
            for (int i = 1; i <  days ; i ++) {
                
                [daysArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
            self.messageArray[2] = daysArray;
            
            [self.pickerV selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
            
        }
        
    }
  
}

//获取天数
// 根据年和月获取月份天数

-(NSInteger)monthDayWithYear:(NSString*) year month:(NSString*) month{

    // 字符串转日期

    NSString *dateStr = [NSString stringWithFormat:@"%@-%@",year,month];

    NSDateFormatter *format = [[NSDateFormatter alloc] init];

    format.dateFormat = @"yyyy-MM";

    NSDate *date = [format dateFromString:dateStr];

    // 当前日历

    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];

    NSLog(@"%ld",range.length)
    return range.length;

}

//隐藏动画
- (void)hideAnimation{
    if ([self.delegate respondsToSelector:@selector(pickerViewHide)]) {
        [self.delegate pickerViewHide];
    }
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

-(void)bgViewTap :(UITapGestureRecognizer *)tap{
    CGPoint tapPoint = [tap locationInView:self];
    
    if (CGRectContainsPoint(_bgV.frame, tapPoint)) {
        
    }else{
        
        [self hideAnimation];
        
    }
}

@end
