//
//  LocationManager.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-24.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "LocationManager.h"
#import "SystemConfigContext.h"

@implementation LocationManager

- (void)scheduledLocationWithTimeInterval:(NSTimeInterval)timeInterval
{
    //先定位一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self performSelector:@selector(getUserLocation)];
    });
    //每隔一段时间获取一次定位信息
    repterLocationTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(getUserLocation) userInfo:nil repeats:YES];
}

//获取位置信息
- (void)getUserLocation
{
    if([CLLocationManager locationServicesEnabled])
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 200.0f;
        [locationManager startUpdatingLocation];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"系统定位服务暂时无法使用,请进入设置开启服务." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSString *lat = [NSString stringWithFormat:@"%3.5f", newLocation.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%3.5f", newLocation.coordinate.longitude];
    [self saveLatitude:lat Longitude:lon];
}

- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
    [manager stopUpdatingLocation];
    if([error code] == kCLErrorDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务拒绝使用,请到系统隐私设置开启系统定位服务." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        //取消定时更新
        [repterLocationTimer invalidate];
        return;
    }
}


- (void)saveLatitude:(NSString *)lat Longitude:(NSString *)lon
{
    LocationItem *item = [[LocationItem alloc] init];
    item.userId = [[[SystemConfigContext sharedInstance] getUserInfo] objectForKey:@"userId"];
    item.lat = lat;
    item.lon = lon;
    item.createTime = [self getCurrentTime];
    locationHelper = [[LocationHelper alloc] init];
    [locationHelper addLocation:item];
    //NSLog(@"%@ %@", lat, lon);
}

- (NSString *)getCurrentTime
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *str = [df stringFromDate:[NSDate date]];
    return str;
}

@end
