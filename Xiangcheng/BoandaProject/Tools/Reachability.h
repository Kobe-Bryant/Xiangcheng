
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

typedef enum 
{
    //无连接
	NotReachable = 0,
	//WIFI连接
    ReachableViaWiFi,
    //比如EDGE、GPRS或者目前的3G
	ReachableViaWWAN
} NetworkStatus;

//通过宏可以在类以外传递消息
#define kReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"

@interface Reachability: NSObject
{
	BOOL localWiFiRef;
    //网络连接引用
	SCNetworkReachabilityRef reachabilityRef;
}

//是否能连通指定的域名
//reachabilityWithHostName- Use to check the reachability of a particular host name. 
+ (Reachability*) reachabilityWithHostName: (NSString*) hostName;

//是否能连通指定的IP地址
//reachabilityWithAddress- Use to check the reachability of a particular IP address. 
+ (Reachability*) reachabilityWithAddress: (const struct sockaddr_in*) hostAddress;

//reachabilityForInternetConnection- checks whether the default route is available.  
//  Should be used by applications that do not connect to a particular host
+ (Reachability*) reachabilityForInternetConnection;

//是否有可连接的WIFI
//reachabilityForLocalWiFi- checks whether a local wifi connection is available.
+ (Reachability*) reachabilityForLocalWiFi;

//Start listening for reachability notifications on the current run loop
- (BOOL) startNotifier;
- (void) stopNotifier;

- (NetworkStatus) currentReachabilityStatus;
//WWAN may be available, but not active until a connection has been established.
//WiFi may require a connection for VPN on Demand.
- (BOOL) connectionRequired;
@end


