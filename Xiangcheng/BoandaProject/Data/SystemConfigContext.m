//
//  SystemConfigContext.m
//  HBBXXPT
//
//  Created by 张仁松 on 13-6-21.
//  Copyright (c) 2013年 zhang. All rights reserved.
//

#import "SystemConfigContext.h"
#import "SettingsInfo.h"
//#import "UIDevice+IdentifierAddition.h"
#import "SvUDIDTools.h"

@implementation SystemConfigContext

static NSMutableDictionary *config;
static SystemConfigContext *_sharedSingleton = nil;

+ (SystemConfigContext *) sharedInstance
{
    @synchronized(self)
    {
        if(_sharedSingleton == nil)
        {
            _sharedSingleton = [[SystemConfigContext alloc] init];
            
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
            config = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        }
    }
    
    return _sharedSingleton;
}


-(NSString *)getString:(NSString *)key{
    return [config objectForKey:key];
}

-(NSArray *)getResultItems:(NSString *)key{
    return [config objectForKey:key];
}

-(NSMutableDictionary *)getUserInfo{
    return userInfo;
}

-(void)setUser:(NSMutableDictionary *)userinfo{
    userInfo = userinfo;
}

-(NSString*)getSeviceHeader{
     SettingsInfo   *settings = [SettingsInfo sharedInstance];
    return settings.ipHeader;
}

-(NSString*)getAppVersion{
     return [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
}

-(NSString*)getDeviceID{
    
    return @"356242050024965";
    //return [SvUDIDTools UDID];
}

-(void)readSettings{
    [[SettingsInfo sharedInstance] readSettings];
}

-(NSArray*)getMenuConfigs{
    return [config objectForKey:@"MenuItems"];
}

-(NSDictionary*)getNextItems{
    return [config objectForKey:@"NextItems"];
}

@end
