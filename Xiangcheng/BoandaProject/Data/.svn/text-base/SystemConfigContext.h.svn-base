//
//  SystemConfigContext.h
//  HBBXXPT
//
//  Created by 张仁松 on 13-6-21.
//  Copyright (c) 2013年 zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemConfigContext : NSObject
{
    //当前用户信息
    NSMutableDictionary *userInfo;
}

+(SystemConfigContext *)sharedInstance;
-(NSString *)getString:(NSString *)key;
-(NSArray *)getResultItems:(NSString *)key;
-(NSArray*)getMenuConfigs;
-(NSDictionary*)getNextItems;

//userId password userName userDepartID
-(NSMutableDictionary *)getUserInfo;

-(void)setUser:(NSMutableDictionary *)userinfo;

-(NSString*)getSeviceHeader;

-(NSString*)getAppVersion;

-(NSString*)getDeviceID;

-(void)readSettings;

@end
