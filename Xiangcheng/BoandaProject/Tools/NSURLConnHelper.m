 //
//  WebserviceHelper.m
//  tesgt
//
//  Created by  on 12-1-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSURLConnHelper.h"

@interface NSURLConnHelper ()

@end

@implementation NSURLConnHelper
@synthesize webData,delegate,HUD,mConnection;

- (NSURLConnHelper*)initWithUrl:(NSString *)aUrl
                  andParentView:(UIView*)aView
                       delegate:(id)aDelegate{
    return  [self initWithUrl:aUrl
                andParentView:aView
                     delegate:aDelegate
                        tagID:0];
}

- (NSURLConnHelper*)initWithUrl:(NSString *)aUrl 
                  andParentView:(UIView*)aView
                       delegate:(id)aDelegate
                          tagID:(NSInteger)tag{
    self = [super init]; 
    if (self) {
        self.delegate = aDelegate;
        tagID =tag;
        webData = [[NSMutableData alloc] initWithLength:100];

        NSURL *url = [NSURL URLWithString:aUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData  timeoutInterval:40];
        
        
        self.mConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        if (aView != nil) {
            HUD = [[MBProgressHUD alloc] initWithView:aView];
            [aView addSubview:HUD];
            
            HUD.labelText = @"正在请求数据，请稍候...";
            [HUD show:YES];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        
    }
    return self;
    
}

- (NSURLConnHelper*)initWithUrl:(NSString *)aUrl
                  andParentView:(UIView*)aView //aView==nil表示不显示等待画面
                       delegate:(id)aDelegate
                        tipInfo:(NSString*)tip
                          tagID:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.delegate = aDelegate;
        tagID = tag;
        webData = [[NSMutableData alloc] initWithLength:100];
        
        NSURL *url = [NSURL URLWithString:aUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData  timeoutInterval:40];
        self.mConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        if (aView != nil) {
            HUD = [[MBProgressHUD alloc] initWithView:aView];
            [aView addSubview:HUD];
            
            HUD.labelText = tip;
            [HUD show:YES];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        
    }
    return self;
}

-(void)cancel{
    if(mConnection) [mConnection cancel];
    if(HUD)  [HUD hide:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    if(HUD)  [HUD hide:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(delegate && [delegate respondsToSelector:@selector(processWebData:andTag:)])
        [delegate processWebData:webData andTag:tagID];
    else
        [delegate processWebData:webData];

}

//服务器上配置的是self-signed certificate
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
}

- (void)connection:(NSURLConnection *) connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    if([challenge previousFailureCount] == 0) {
        NSURLProtectionSpace *protectionSpace = [challenge protectionSpace];
        NSString *authMethod = [protectionSpace authenticationMethod];
        if(authMethod == NSURLAuthenticationMethodServerTrust ) {
            [[challenge sender] useCredential:[NSURLCredential credentialForTrust:[protectionSpace serverTrust]] forAuthenticationChallenge:challenge];
        }
    }
}


@end
