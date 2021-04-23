//
//  MDLocationTool.m
//  MDHealth
//
//  Created by 林志军 on 2020/8/7.
//  Copyright © 2020 startgo. All rights reserved.
//

#import "MDLocationTool.h"
#import <CoreLocation/CoreLocation.h>

@interface MDLocationTool ()<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *locationManager;

@end

@implementation MDLocationTool

static id instance;
//单例模式
+ (MDLocationTool * )sharedManager{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[MDLocationTool alloc] init];
    });
    return instance;
}

-(void)getLocation{
    if ([CLLocationManager locationServicesEnabled]) {
          // 开启定位
          [self.locationManager startUpdatingLocation];
      }else{
          NSLog(@"系统定位尚未打开，请到【设置-隐私-定位服务】中手动打开");
      }
}

#pragma mark -定位设置
-(CLLocationManager *)locationManager{
    if (!_locationManager) {
        // 创建CoreLocation管理对象
        CLLocationManager *locationManager = [[CLLocationManager alloc]init];
        // 定位权限检查
        [locationManager requestWhenInUseAuthorization];
        // 设定定位精准度
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        // 设置代理
        locationManager.delegate = self;
        
        _locationManager = locationManager;
    }
    return _locationManager;
    
}

#pragma mark -代理方法，定位权限检查
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:{
            NSLog(@"用户还未决定授权");
            // 主动获得授权
            [self.locationManager requestWhenInUseAuthorization];
            break;
        }
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            // 主动获得授权
            [self.locationManager requestWhenInUseAuthorization];
            break;
        }
        case kCLAuthorizationStatusDenied:{
            // 此时使用主动获取方法也不能申请定位权限
            // 类方法，判断是否开启定位服务
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"定位服务开启，被拒绝");
            } else {
                NSLog(@"定位服务关闭，不可用");
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:{
            NSLog(@"获得前后台授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:{
            NSLog(@"获得前台授权");
            break;
        }
        default:
            break;
    }
}
#pragma mark -获取位置
- (void)locationManager:(CLLocationManager *)manager
   didUpdateLocations:(NSArray *)locations{
    
    CLLocation * newLocation = [locations lastObject];
    // 判空处理
    if (newLocation.horizontalAccuracy < 0) {
        NSLog(@"定位失败，请检查手机网络以及定位");
        return;
    }
    //停止定位
    [self.locationManager stopUpdatingLocation];
    // 获取定位经纬度
//    CLLocationCoordinate2D coor2D = newLocation.coordinate;
//    NSLog(@"纬度为:%f, 经度为:%f", coor2D.latitude, coor2D.longitude);
    
    // 创建编码对象，获取所在城市
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    // 反地理编码
    
    //中国地区
    NSLocale *cnLocal = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-CN"];
    
    if (@available(iOS 11.0, *)) {
        [geocoder reverseGeocodeLocation:newLocation preferredLocale:cnLocal completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error != nil || placemarks.count == 0) {
                return ;
            }
            // 获取地标
            CLPlacemark *placeMark = [placemarks firstObject];
            //        NSLog(@"%@",placeMark.addressDictionary)
            NSLog(@"获取地标 = %@\n %@\n",    placeMark.locality , placeMark.subLocality );
            
            if (self->_locationSuccess) {
                self->_locationSuccess( placeMark.administrativeArea, placeMark.locality , placeMark.subLocality);
            }
            
        }];
    } else {
            [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
                if (error != nil || placemarks.count == 0) {
                    return ;
                }
                // 获取地标
                CLPlacemark *placeMark = [placemarks firstObject];
                //        NSLog(@"%@",placeMark.addressDictionary)
                NSLog(@"获取地标 = %@\n %@\n",    placeMark.locality , placeMark.subLocality );
                
                if (self->_locationSuccess) {
                    self->_locationSuccess( placeMark.administrativeArea, placeMark.locality , placeMark.subLocality);
                }
            }];
    }

}
#pragma mark -定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
//     NSLog(@"定位失败,请检查手机网络以及定位");
}
@end
