//
//  YuQingViewController.h
//  GIS
//
//  Created by yushang on 10-10-17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "NSURLConnHelperDelegate.h"

@interface WebServiceHelper : NSObject  {
    NSInteger tagID;
    BOOL bConnected;
}

@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *method;
@property(nonatomic, copy) NSString *nameSpace;
@property(nonatomic, copy) NSString *parameters;
@property(nonatomic, assign) BOOL bConnected;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSURLConnection *theConnection;
@property(nonatomic,retain) MBProgressHUD *HUD;
@property(nonatomic, assign) id<NSURLConnHelperDelegate> delegate;


+ (NSString*) createParametersWithKey:(NSString*) aKey value:(NSString*) aValue, ...;

+ (NSString*)createParametersWithParams:(NSDictionary *)values;

- (WebServiceHelper*)initWithUrl:(NSString*) aUrl
						  method:(NSString*) aMethod
					   nameSpace:(NSString*) aNameSpace 
					  parameters:(NSString*) aParameters 
						delegate:(id) aDelegate;

- (WebServiceHelper*)initWithUrl:(NSString *)aUrl 
                          method:(NSString *)aMethod 
                       nameSpace:(NSString *)aNameSpace 
                        delegate:(id)aDelegate;

- (void)run;
- (void)cancel;
- (void)runAndShowWaitingView:(UIView*)parentView;
- (void)runAndShowWaitingView:(UIView*)parentView andTag:(NSInteger)tag;
//tip 提示界面上显示的文字
- (void)runAndShowWaitingView:(UIView*)parentView withTipInfo:(NSString*)tip  andTag:(NSInteger)tag;

@end
