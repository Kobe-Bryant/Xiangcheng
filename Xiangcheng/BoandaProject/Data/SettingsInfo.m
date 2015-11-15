//
//  SettingsInfo.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingsInfo.h"


@implementation SettingsInfo
@synthesize ipHeader;

static SettingsInfo *_sharedSingleton = nil;
+ (SettingsInfo *) sharedInstance
{
    @synchronized(self)
    {
        if(_sharedSingleton == nil)
        {
            _sharedSingleton = [[SettingsInfo alloc] init];
        }
    }
    
    return _sharedSingleton;
}


#define  kServiceIpKey @"ip_preference"


-(void)readPreference{
    NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kServiceIpKey];
	if (testValue == nil)
	{
		NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
        if(!settingsBundle) {
            NSLog(@"Could not find Settings.bundle");
            return;
        }
        
        NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
        NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
        
        NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
        for(NSDictionary *prefSpecification in preferences) {
            NSString *key = [prefSpecification objectForKey:@"Key"];
            if(key) {
                [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
            }
        }
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
        [[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	// we're ready to go, so lastly set the key preference values
	self.ipHeader = [[NSUserDefaults standardUserDefaults] stringForKey:kServiceIpKey];
    NSLog(@"%@",ipHeader);

}

-(void)readSettings{
    [self readPreference];
    
}

@end


