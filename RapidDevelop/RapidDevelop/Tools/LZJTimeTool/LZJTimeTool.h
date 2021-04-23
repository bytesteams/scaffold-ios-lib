//
//  LZJTimeTool.h
//  IM_HuanXin
//
//  Created by 林志军 on 16/12/7.
//  Copyright © 2016年 naoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZJTimeTool : NSObject
//时间戳转NSDate
+ (NSDate *)getLocateTime:(long long)timeStamp ;

+(NSString *)formatTime:(long long)timestamp;

+(NSString * )timeYYYYMMDD :(long long)timestamp;

//返回当前时间的时间戳
+ (NSString *)timestamp;
//日期转时间戳

+(NSString *)timeForSeconds :(NSString *)formatDate;

+(NSString *)timeYYYYMMDDHH:(long long)timestamp;

+(NSString *)timeFormatter:(long long)timestamp format:(NSString *)format;

//时间字符串转时间戳
+(NSString *)dateStringToSecondsFormate : (NSString *)formate dateString : (NSString *)dateString;

+(NSString *)currentDataFormat:(NSString *)format;

+(NSString *)dateFormatToFormat :(NSString *)currentDate  AndFormat:(NSString *)currentFormat toFormat:(NSString *)format;

+(NSString *)getPreviousDateFormDate:(NSString *)currentDate AndFormat:(NSString *)format;
//根据当前时间获取前一天时间
+(NSString *)getNextDateFormDate:(NSString *)currentDate AndFormat:(NSString *)format;
//根据当前时间获取下一天时间

//获取当前时间开始 后面的某天时间
+(NSString *)getNextSomeDate :(NSInteger)days FormDate:(NSString *)currentDate AndFormat:(NSString *)format;

+(NSString *)getPreSomeDate :(NSInteger)days FormDate:(NSString *)currentDate AndFormat:(NSString *)format;

//计算2个日期相差多少天
+(NSString *)calculateBetweenFromDate:(NSString *)fromDate toDate:(NSString *)toDate Andformat:(NSString *)format;
@end
