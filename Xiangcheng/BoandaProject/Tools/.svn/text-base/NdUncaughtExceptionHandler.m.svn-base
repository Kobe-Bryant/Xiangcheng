//
//  NdUncaughtExceptionHandler.m
//  GuoToOA
//
//  Created by 张仁松 on 13-6-27.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "NdUncaughtExceptionHandler.h"
#import "SvUDIDTools.h"
#import "SystemConfigContext.h"
#import "ExceptionHelper.h"

NSString *applicationDocumentsDirectory() {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

void UncaughtExceptionHandler(NSException *exception)
{
   // NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString *url = [NSString stringWithFormat:@"异常崩溃报告\nname:\n%@\nreason:\n%@",
                     name,reason];
   
       
    NdUncaughtExceptionHandler *handle = [[NdUncaughtExceptionHandler alloc] init];
    [handle handleException:url];
    
    
}

NSString* getAppInfo()
{
    NSString *appInfo = [NSString stringWithFormat:@"App : %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\nUDID : %@\n",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         [UIDevice currentDevice].model,
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].systemVersion,
                         [SvUDIDTools UDID]];
    NSLog(@"Crash!!!! %@", appInfo);
    return appInfo;
}

@implementation NdUncaughtExceptionHandler
@synthesize exception;

+ (void)setDefaultHandler
{
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
    
}

+ (NSUncaughtExceptionHandler*)getHandler
{
    return NSGetUncaughtExceptionHandler();
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
    if (anIndex == 1)
    {
        NSString *plistpath = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"ErrLogFiles.plist"];
        NSMutableArray *arySendPlist = [NSMutableArray arrayWithContentsOfFile:plistpath];
        if(arySendPlist == nil)arySendPlist = [NSMutableArray arrayWithCapacity:2];
        
        NSDictionary *usrInfo = [[SystemConfigContext sharedInstance] getUserInfo];
        
        ExceptionHelper *helper = [[ExceptionHelper alloc] init];
        [helper saveOneException:exception LoginUser:[usrInfo objectForKey:@"userId"] SoftInfo:getAppInfo() SBBH:[SvUDIDTools UDID]];
        
    }
    dismissed = YES;
}

- (void)handleException:(NSString*)exceptionStr
{
    self.exception = exceptionStr;
   
    
    UIAlertView *alert =
    [[UIAlertView alloc]
      initWithTitle:NSLocalizedString(@"系统崩溃", nil)
      message:@"程序发生错误，即将退出，是否将错误日志上传到服务器？\n"
      delegate:self
      cancelButtonTitle:NSLocalizedString(@"退出", nil)
      otherButtonTitles:NSLocalizedString(@"发送错误消息", nil), nil];
    [alert show];
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    while (!dismissed)
    {
        for (NSString *mode in (__bridge NSArray *)allModes)
        {
            CFRunLoopRunInMode((__bridge CFStringRef)mode, 0.001, false);
        }
    }
    
    CFRelease(allModes);
}


@end
