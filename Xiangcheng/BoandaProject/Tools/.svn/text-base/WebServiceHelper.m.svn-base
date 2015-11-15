//
//  WebServiceHelper.m
//  GIS
//
//  Created by yushang on 10-10-17.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WebServiceHelper.h"
#import "OperateLogHelper.h"
#import "SystemConfigContext.h"

@implementation WebServiceHelper
@synthesize bConnected;
@synthesize url;
@synthesize method;
@synthesize nameSpace;
@synthesize parameters;

@synthesize webData;
@synthesize xmlParser;
@synthesize theConnection;

@synthesize delegate,HUD;

+(NSString*) createParametersWithKey:(NSString*) aKey value:(NSString*) aValue, ...
{
	id k, v;
	va_list argumentList;
	NSString* ret = [NSString stringWithFormat:@"<%@>%@</%@>", aKey, aValue, aKey];
	
	va_start(argumentList, aValue);
	while ((k = va_arg(argumentList, id)) && (v = va_arg(argumentList, id))) {
		ret = [NSString stringWithFormat:@"%@<%@>%@</%@>", ret, k, v, k];		
	}
	va_end(argumentList);
	return ret;
}

+ (NSString*)createParametersWithParams:(NSDictionary *)values
{
    NSMutableString * ret = [[NSMutableString alloc] init];
    NSArray *keyArray = [values allKeys];
	for (NSString *key in keyArray)
    {
        NSString *value = [values objectForKey:key];
        if(value == nil || [value length] == 0)
        {
            value = @"";
        }
        [ret appendFormat:@"<%@>%@</%@>", key, value, key];
    }
	return ret;
}

- (WebServiceHelper*)initWithUrl:(NSString*) aUrl
						  method:(NSString*) aMethod
					   nameSpace:(NSString*) aNameSpace 
					  parameters:(NSString*) aParameters 
						delegate:(id<NSURLConnHelperDelegate>) aDelegate
                          
{
	self.url = aUrl;
	self.method = aMethod;
	self.nameSpace = aNameSpace;
	self.parameters = aParameters;
	self.delegate = aDelegate;

	return self;
}

- (WebServiceHelper*)initWithUrl:(NSString*) aUrl
						  method:(NSString*) aMethod
					   nameSpace:(NSString*) aNameSpace
						delegate:(id<NSURLConnHelperDelegate>) aDelegate
{
	self.url = aUrl;
	self.method = aMethod;
	self.nameSpace = aNameSpace;
    self.parameters = nil;
	self.delegate = aDelegate;

	return self;
}



#pragma mark -

-(void)cancel{
    if (theConnection) {
        [theConnection cancel];
        bConnected = NO;
        if(HUD)  [HUD hide:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
}

- (void)run
{
	if (bConnected)	return;
	bConnected = YES;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

	//url
	NSURL *nsurl = [NSURL URLWithString:url];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:nsurl];

	//content-type
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	
	//SOAPAction
	NSString *lastChar;
	NSString *slashUsed;
	lastChar = [self.nameSpace substringFromIndex:self.nameSpace.length -1];	
	if([lastChar isEqualToString:@"/"]){
		slashUsed = @"";
	} else {
		slashUsed = @"/";		
	}	
	NSString* soapAction = [NSString stringWithFormat:@"%@%@%@", nameSpace, slashUsed, method];	
	[theRequest addValue: soapAction forHTTPHeaderField:@"SOAPAction"];
    
	
	//httpMethod
	[theRequest setHTTPMethod:@"POST"];
	
	//httpbody
    NSString *soapMessage;
    if (self.parameters != nil) {
        soapMessage = [NSString stringWithFormat:
                       @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                       "<soap:Body>"
                       "<%@ xmlns=\"%@\">"
                       "%@"
                       "</%@>"
                       "</soap:Body>"
                       "</soap:Envelope>",
                       method, nameSpace, parameters, method
                       ];
    } else {
        soapMessage = [NSString stringWithFormat:
                       @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                       "<soap:Body>"
                       "<%@ xmlns=\"%@\">"
                       "</%@>"
                       "</soap:Body>"
                       "</soap:Envelope>",
                       method, nameSpace, method
                       ];
    }
	//NSLog(@"%@",soapMessage);
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	//length
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];	
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	
    OperateLogHelper *helper = [[OperateLogHelper alloc] init];
    NSString *userid = [[[SystemConfigContext sharedInstance] getUserInfo] objectForKey:@"userId"];
    [helper saveOperate:method andUserID:userid];
	//请求
	self.theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if(theConnection)
	{
//		webData = [[NSMutableData data] retain];
        webData = [[NSMutableData alloc] initWithCapacity:0];
	}
	else
	{
		NSLog(@"theConnection is NULL");
	}	
}

- (void)runAndShowWaitingView:(UIView*)parentView{
    return [self runAndShowWaitingView:parentView andTag:0];
}

- (void)runAndShowWaitingView:(UIView*)parentView  andTag:(NSInteger)tag{
    
    if (parentView != nil) {
        HUD = [[MBProgressHUD alloc] initWithView:parentView];
        [parentView addSubview:HUD];
        tagID = tag;
        HUD.labelText = @"正在请求数据，请稍候...";
        [HUD show:YES];
    }
    
    [self run];
}

- (void)runAndShowWaitingView:(UIView*)parentView withTipInfo:(NSString*)tip  andTag:(NSInteger)tag{
    if (parentView != nil) {
        HUD = [[MBProgressHUD alloc] initWithView:parentView];
        [parentView addSubview:HUD];
        tagID = tag;
        HUD.labelText = tip;
        [HUD show:YES];
    }
    
    [self run];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    bConnected = NO;
	NSLog(@"ERROR with theConenction");
    if(HUD) [HUD hide:YES];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(delegate && [delegate respondsToSelector:@selector(processError:andTag:)])
        [delegate processError:error andTag:tagID];
    else if(delegate && [delegate respondsToSelector:@selector(processError:)])
        [delegate processError:error] ;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    bConnected = NO;
    if(HUD)  [HUD hide:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(delegate && [delegate respondsToSelector:@selector(processWebData:andTag:)])
        [delegate processWebData:webData andTag:tagID];
    else
        [delegate processWebData:webData];
}


@end
