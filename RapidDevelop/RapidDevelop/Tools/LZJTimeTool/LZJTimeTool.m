//
//  LZJTimeTool.m
//  IM_HuanXin
//
//  Created by 林志军 on 16/12/7.
//  Copyright © 2016年 naoxin. All rights reserved.
//

#import "LZJTimeTool.h"

@implementation LZJTimeTool

+ (NSDate *)getLocateTime:(long long )timeStamp {
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeStamp/1000];
    
    return confromTimesp;
    
}

+(NSString *)formatTime:(long long)timestamp{
    //返回时间格式
    
    
    //currentDate 2015-09-28 16:28:09 +0000
    //msgDate 2015-09-28 10:36:22 +0000
    NSCalendar   *calendar = [NSCalendar currentCalendar];
    //1.获取当前的时间
    NSDate *currentDate = [NSDate date];
    
    // 获取年，月，日
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:currentDate];
    NSInteger currentYear = components.year;
//    NSInteger currentMonth = components.month;
//    NSInteger currentDay = components.day;
//    NSInteger currentHour= components.hour;
//    NSInteger currentMinute= components.minute;
    //    NSLog(@"currentYear %ld",components.year);
    //    NSLog(@"currentMonth %ld",components.month);
    //    NSLog(@"currentDay %ld",components.day);
    
    
    //2.获取消息发送时间--网络时间
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    // 获取年，月，日
    components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:msgDate];
    CGFloat msgYead = components.year;
//    CGFloat msgMonth = components.month;
//    CGFloat msgDay = components.day;
//    CGFloat msgHour =components.hour;
//    CGFloat msgMinute =components.minute;
//    NSLog(@"msgYear %ld",components.year);
//    NSLog(@"msgMonth %ld",components.month);
//    NSLog(@"msgDay %ld",components.day);
    
    
    //3.判断:
    /*今天：(HH:mm)
     *昨天: (昨天 HH:mm)
     *昨天以前:（2015-09-26 15:27）
     */
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    if (currentYear == msgYead){
         //今年
        dateFmt.dateFormat= @"MM-dd HH:mm";
    }
    else{//昨天以前
        dateFmt.dateFormat= @"yyyy-MM-dd HH:mm";
    }
    
    
    return [dateFmt stringFromDate:msgDate];

}

+(NSString *)timeYYYYMMDD:(long long)timestamp;{

    

    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];

    
    dateFmt.dateFormat= @"yyyy年MM月dd日";
    
    
    
    return [dateFmt stringFromDate:msgDate];
    

}

+(NSString *)timeYYYYMMDDHH:(long long)timestamp;{
    
    
    
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    
    dateFmt.dateFormat= @"yyyy年MM月dd日 HH时";
    
    
    
    return [dateFmt stringFromDate:msgDate];
    
    
}
//时间转时间戳
+(NSString *)timeForSeconds:(NSString *)formatDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //指定时间显示样式: HH表示24小时制 hh表示12小时制
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setLocale:[NSLocale currentLocale]];
    NSDate *lastDate = [formatter dateFromString:formatDate];
    //以 1970/01/01 GMT为基准，得到lastDate的时间戳
     long firstStamp = [lastDate timeIntervalSince1970]; //返回秒
    firstStamp = firstStamp * 1000;
   
    
    return [NSString stringWithFormat:@"%ld",firstStamp];
 
}

+ (NSString *)timestamp {
    return [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970] *1000];
}

//timestamp毫秒  dateWithTimeIntervalSince1970:(秒)
+(NSString *)timeFormatter:(long long)timestamp format:(NSString *)format{

    
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    //指定时间显示样式: HH表示24小时制 hh表示12小时制
    [formatter setDateFormat:format];
    NSString *dataString = [formatter stringFromDate:msgDate];
    return [NSString stringWithFormat:@"%@",dataString];
    
}


//时间字符串转时间戳
+(NSString *)dateStringToSecondsFormate : (NSString *)formate dateString : (NSString *)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //指定时间显示样式: HH表示24小时制 hh表示12小时制
    [formatter setDateFormat:formate];
    NSDate *lastDate = [formatter dateFromString:dateString];
    //以 1970/01/01 GMT为基准，得到lastDate的时间戳
    long firstStamp = [lastDate timeIntervalSince1970];
    firstStamp = firstStamp * 1000;
    
    return [NSString stringWithFormat:@"%ld",firstStamp];
}


+(NSString *)currentDataFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //指定时间显示样式: HH表示24小时制 hh表示12小时制
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    
    NSDate *date1 = [NSDate date];
    NSString *dateString = [formatter stringFromDate:date1 ];
   
    return dateString;
    
}

+(NSString *)dateFormatToFormat:(NSString *)currentDate  AndFormat :(NSString *)currentFormat toFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //先转时间戳
    [formatter setDateFormat:currentFormat];
     [formatter setLocale:[NSLocale currentLocale]];
    
    NSDate *lastDate = [formatter dateFromString:currentDate];
    //以 1970/01/01 GMT为基准，得到lastDate的时间戳
    long long firstStamp = [lastDate timeIntervalSince1970];
    firstStamp = firstStamp * 1000;
    
    return [self timeFormatter:firstStamp  format:format];
    
}

+(NSString *)getPreviousDateFormDate:(NSString *)currentDate AndFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
   
    [formatter setDateFormat:format];
     [formatter setLocale:[NSLocale currentLocale]];
    
    NSDate *date = [formatter dateFromString:currentDate];
    
    NSDate *yesterday = [NSDate dateWithTimeInterval:-60 * 60 * 24 sinceDate:date];
    
    return [formatter stringFromDate:yesterday];
}

+(NSString *)getNextDateFormDate:(NSString *)currentDate AndFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
     [formatter setLocale:[NSLocale currentLocale]];
    
    NSDate *date = [formatter dateFromString:currentDate];
    
    NSDate *tomorrow = [NSDate dateWithTimeInterval:60 * 60 * 24 sinceDate:date];
    
    return [formatter stringFromDate:tomorrow];
}

+(NSString *)getNextSomeDate :(NSInteger)days FormDate:(NSString *)currentDate AndFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
//    [formatter setLocale:[NSLocale currentLocale]];
    
    NSDate *date = [formatter dateFromString:currentDate];
    
    NSDate *tomorrow = [NSDate dateWithTimeInterval:60 * 60 * 24*days sinceDate:date];
    
    return [formatter stringFromDate:tomorrow];
}

+(NSString *)getPreSomeDate :(NSInteger)days FormDate:(NSString *)currentDate AndFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
//    [formatter setLocale:[NSLocale currentLocale]];
    
    NSDate *date = [formatter dateFromString:currentDate];
    
    NSDate *yesterday = [NSDate dateWithTimeInterval:- 60 * 60 * 24*days sinceDate:date];
    
    return [formatter stringFromDate:yesterday];
}


+(NSString *)calculateBetweenFromDate:(NSString *)fromDate toDate:(NSString *)toDate Andformat:(NSString *)format{
    //创建两个日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *startDate = [dateFormatter dateFromString:fromDate];
    NSDate *endDate = [dateFormatter dateFromString:toDate];

    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /**
     * 要比较的时间单位,常用如下,可以同时传：
     *    NSCalendarUnitDay : 天
     *    NSCalendarUnitYear : 年
     *    NSCalendarUnitMonth : 月
     *    NSCalendarUnitHour : 时
     *    NSCalendarUnitMinute : 分
     *    NSCalendarUnitSecond : 秒
     */
    NSCalendarUnit unit = NSCalendarUnitDay;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];


    //获取其中的"天"
    return [NSString stringWithFormat:@"%d",delta.day];
}
@end
