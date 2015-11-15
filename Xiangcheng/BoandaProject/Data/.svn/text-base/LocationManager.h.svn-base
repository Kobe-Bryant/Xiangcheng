//
//  LocationManager.h
//  BoandaProject
//
//  Created by 张仁松 on 13-7-24.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationHelper.h"
#import "LocationItem.h"

@interface LocationManager : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    NSTimer *repterLocationTimer;
    LocationHelper *locationHelper ;
}

@property (nonatomic, assign) NSTimeInterval scheduleTime;

- (void)scheduledLocationWithTimeInterval:(NSTimeInterval)timeInterval;

@end
