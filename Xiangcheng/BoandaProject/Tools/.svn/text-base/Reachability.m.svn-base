
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#import <CoreFoundation/CoreFoundation.h>

#import "Reachability.h"

#define kShouldPrintReachabilityFlags 1

static void PrintReachabilityFlags(SCNetworkReachabilityFlags flags, const char* comment)
{
    NSString *head = @"当前网络连接状况\n";
    NSString *str1 = @"kSCNetworkReachabilityFlagsIsWWAN:                   %c\n";
    NSString *str2 = @"kSCNetworkReachabilityFlagsReachable:                %c\n";
    NSString *str3 = @"kSCNetworkReachabilityFlagsTransientConnection:      %c\n";
    NSString *str4 = @"kSCNetworkReachabilityFlagsConnectionRequired:       %c\n";
    NSString *str5 = @"kSCNetworkReachabilityFlagsConnectionOnTraffic:      %c\n";
    NSString *str6 = @"kSCNetworkReachabilityFlagsInterventionRequired:     %c\n";
    NSString *str7 = @"kSCNetworkReachabilityFlagsConnectionOnDemand:       %c\n";
    NSString *str8 = @"kSCNetworkReachabilityFlagsIsLocalAddress:           %c\n";
    NSString *str9 = @"kSCNetworkReachabilityFlagsIsDirect:                 %c\n";
    NSString *foot = @"Current Test Connection Type:                        %s\n";
    
    NSString *strTemplate = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@", head, str1, str2, str3, str4, str5, str6, str7, str8, str9, foot];
    
#if kShouldPrintReachabilityFlags
//    NSLog(@"Reachability Flag Status: %c%c %c%c%c%c%c%c%c %s\n",
//          (flags & kSCNetworkReachabilityFlagsIsWWAN)				  ? 'W' : '-',
//          (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
//          
//          (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
//          (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
//          (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
//          (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
//          (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
//          (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
//          (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-',
//          comment
//          );
    
    NSLog(strTemplate,
          (flags & kSCNetworkReachabilityFlagsIsWWAN)				  ? 'Y' : 'N',
          (flags & kSCNetworkReachabilityFlagsReachable)            ? 'Y' : 'N',
          (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 'Y' : 'N',
          (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'Y' : 'N',
          (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'Y' : 'N',
          (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'Y' : 'N',
          (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'Y' : 'N',
          (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'Y' : 'N',
          (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'Y' : 'N',
          comment
          );
#endif

}


@implementation Reachability

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info)
{
#pragma unused (target, flags)
	NSCAssert(info != NULL, @"info was NULL in ReachabilityCallback");
	NSCAssert([(NSObject*) info isKindOfClass: [Reachability class]], @"info was wrong class in ReachabilityCallback");
    
	//We're on the main RunLoop, so an NSAutoreleasePool is not necessary, but is added defensively
	// in case someon uses the Reachablity object in a different thread.
	NSAutoreleasePool* myPool = [[NSAutoreleasePool alloc] init];

	Reachability* noteObject = (Reachability*) info;
	// Post a notification to notify the client that the network reachability changed.
	[[NSNotificationCenter defaultCenter] postNotificationName: kReachabilityChangedNotification object: noteObject];
	
	[myPool release];
}

//开始监听网络变更
- (BOOL) startNotifier
{
	BOOL retVal = NO;
	SCNetworkReachabilityContext context = {0, self, NULL, NULL, NULL};
    //Returns TRUE if the notification client was successfully set.
	if(SCNetworkReachabilitySetCallback(reachabilityRef, ReachabilityCallback, &context))
	{
        //Returns TRUE if the target is scheduled successfully;FALSE otherwise.
		if(SCNetworkReachabilityScheduleWithRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode))
		{
			retVal = YES;
		}
	}
    
	return retVal;
}

//停止监听网络变更
- (void) stopNotifier
{
	if(reachabilityRef != NULL)
	{
		SCNetworkReachabilityUnscheduleFromRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	}
}

- (void) dealloc
{
	[self stopNotifier];
	if(reachabilityRef != NULL)
	{
		CFRelease(reachabilityRef);
	}
    
	[super dealloc];
}

#pragma mark - 创建原生太SCNetworkReachabilityRef

//根据目标服务器地址来创建一个测试与其连接的引用。
+ (Reachability*) reachabilityWithHostName: (NSString*) hostName;
{
	Reachability *retVal = NULL;
    
    //创建一个指向特定网络主机或节点的引用，这个引用可被稍后用来监控与目标主机的连通性。
    //Creates a reference to the specified network host or node name.  
    //This reference can be used later to monitor the reachability of the target host.
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
	if(reachability!= NULL)
	{
		retVal = [[[self alloc] init] autorelease];
		if(retVal != NULL)
		{
			retVal->reachabilityRef = reachability;
			retVal->localWiFiRef = NO;
		}
	}

	return retVal;
}

//根据主机地址来创建一个测试与其连接的引用。
+ (Reachability*) reachabilityWithAddress: (const struct sockaddr_in*) hostAddress;
{
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)hostAddress);
	Reachability* retVal = NULL;
	if(reachability!= NULL)
	{
		retVal= [[[self alloc] init] autorelease];
		if(retVal!= NULL)
		{
			retVal->reachabilityRef = reachability;
			retVal->localWiFiRef = NO;
		}
	}
    
	return retVal;
}

//创建一个测试与网络连接的引用。
+ (Reachability*) reachabilityForInternetConnection;
{
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	return [self reachabilityWithAddress: &zeroAddress];
}

//创建一个测试与本地WIFI连接的引用。
+ (Reachability*) reachabilityForLocalWiFi;
{
	struct sockaddr_in localWifiAddress;
	bzero(&localWifiAddress, sizeof(localWifiAddress));
	localWifiAddress.sin_len = sizeof(localWifiAddress);
	localWifiAddress.sin_family = AF_INET;
	// IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
	localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
	Reachability* retVal = [self reachabilityWithAddress: &localWifiAddress];
	if(retVal!= NULL)
	{
		retVal->localWiFiRef = YES;
	}
    
	return retVal;
}

#pragma mark Network Flag Handling

    /*    
     kSCNetworkReachabilityFlagsTransientConnection	= 1<<0,
     kSCNetworkReachabilityFlagsReachable		= 1<<1,
     kSCNetworkReachabilityFlagsConnectionRequired	= 1<<2,
     kSCNetworkReachabilityFlagsConnectionOnTraffic	= 1<<3,
     kSCNetworkReachabilityFlagsInterventionRequired	= 1<<4,
     kSCNetworkReachabilityFlagsConnectionOnDemand	= 1<<5,	// __OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_3_0)
     kSCNetworkReachabilityFlagsIsLocalAddress	= 1<<16,
     kSCNetworkReachabilityFlagsIsDirect		= 1<<17,
     #if	TARGET_OS_IPHONE
     kSCNetworkReachabilityFlagsIsWWAN		= 1<<18,
     #endif	// TARGET_OS_IPHONE
     
     kSCNetworkReachabilityFlagsConnectionAutomatic
     */

    /*!
     @enum SCNetworkReachabilityFlags
     该枚举用于指明:特定的网络或者节点名称或者地址是否可连通，必要的连接操作是否需要，建立连接的过程中是否需要人工干预。
     @discussion Flags that indicate whether the specified network
     nodename or address is reachable, whether a connection is
     required, and whether some user intervention may be required
     when establishing a connection.
     --------------------------------------------------------------------------------------
     1、kSCNetworkReachabilityFlagsTransientConnection:用于指明通过一个瞬时连接能够连接到特定的节点或地址。例如PPP连接。
     @constant kSCNetworkReachabilityFlagsTransientConnection
     This flag indicates that the specified nodename or address can
     be reached via a transient connection, such as PPP.
     --------------------------------------------------------------------------------------
     2、kSCNetworkReachabilityFlagsReachable:用于指明通过当前的网络配置能够连接到特定的节点或地址。
     @constant kSCNetworkReachabilityFlagsReachable
     This flag indicates that the specified nodename or address can
     be reached using the current network configuration.
     --------------------------------------------------------------------------------------
     3、kSCNetworkReachabilityFlagsConnectionRequired:用于指明当前的网络配置能够连接到网络，但前提是必须先建立连接,即网络连接暂时处于未激活状态。
     例如需要进行拨号连接的情况。
     @constant kSCNetworkReachabilityFlagsConnectionRequired
     This flag indicates that the specified nodename or address can
     be reached using the current network configuration, but a
     connection must first be established.
     
     As an example, this status would be returned for a dialup
     connection that was not currently active, but could handle
     network traffic for the target system.
     --------------------------------------------------------------------------------------
     4、kSCNetworkReachabilityFlagsConnectionOnTraffic:用于指明通过当前网络配置能够连接到网络，但前提是必须先建立连接,
     同时任何试图与网络进行通信的动作都会导致自动的去发起连接。
     @constant kSCNetworkReachabilityFlagsConnectionOnTraffic
     This flag indicates that the specified nodename or address can
     be reached using the current network configuration, but a
     connection must first be established.  Any traffic directed
     to the specified name or address will initiate the connection.
     
     Note: this flag was previously named kSCNetworkReachabilityFlagsConnectionAutomatic
     --------------------------------------------------------------------------------------
     5、kSCNetworkReachabilityFlagsInterventionRequired:用于指明通过当前网络配置能够连接到网络，但前提是必须先建立连接,
     同时在建立连接的过程中会需要用户的干预,例如输入密码或者token验证
     @constant kSCNetworkReachabilityFlagsInterventionRequired
     This flag indicates that the specified nodename or address can
     be reached using the current network configuration, but a
     connection must first be established.  In addition, some
     form of user intervention will be required to establish this
     connection, such as providing a password, an authentication
     token, etc.
     
     Note: At the present time, this flag will only be returned
     in the case where you have a dial-on-traffic configuration
     (ConnectionOnTraffic), where an attempt to connect has
     already been made, and where some error (e.g. no dial tone,
     no answer, bad password, ...) was encountered during the
     automatic connection attempt.  In this case the PPP controller
     will stop attempting to establish a connection until the user
     has intervened.
     --------------------------------------------------------------------------------------
     6、kSCNetworkReachabilityFlagsConnectionOnDemand:用于指明通过当前网络配置能够连接到网络，但前提是必须先建立连接。
     这种连接会在有需要连接网络时被CFSocketStream APIs来创建,其他的APIs不能建立该连接。
     @constant kSCNetworkReachabilityFlagsConnectionOnDemand
     This flag indicates that the specified nodename or address can
     be reached using the current network configuration, but a
     connection must first be established.
     The connection will be established "On Demand" by the
     CFSocketStream APIs.
     Other APIs will not establish the connection.
     --------------------------------------------------------------------------------------
     7、kSCNetworkReachabilityFlagsIsLocalAddress:用于指明指定的节点或地址已经关联到了当前的系统中。(翻译可能太不准确)
     @constant kSCNetworkReachabilityFlagsIsLocalAddress
     This flag indicates that the specified nodename or address
     is one associated with a network interface on the current
     system.
     --------------------------------------------------------------------------------------
     8、kSCNetworkReachabilityFlagsIsDirect:用于指明该种网络流量无需通过网关,而是直接到达。
     @constant kSCNetworkReachabilityFlagsIsDirect
     This flag indicates that network traffic to the specified
     nodename or address will not go through a gateway, but is
     routed directly to one of the interfaces in the system.
     --------------------------------------------------------------------------------------
     9、kSCNetworkReachabilityFlagsIsWWAN:判断是否通过蜂窝网覆盖的连接,比如EDGE、GPRS或者目前的3G。主要是用于区别通过WiFi的连接。
                                       测试用户使用的是运营商的网络。
     #if	TARGET_OS_IPHONE
     @constant kSCNetworkReachabilityFlagsIsWWAN
     This flag indicates that the specified nodename or address can
     be reached via an EDGE, GPRS, or other "cell" connection.
     #endif	// TARGET_OS_IPHONE
     -------------------------------------------------------------------------------------------------------------
     */




    /*
     iphone4 网络接入介绍
     
     默认的是先使用WiFi网络，在WiFi断开的时候使用手机流量。
     另，左上角信号旁边的标识决定使用的网络：
     1、扇形：WiFi网络（速度由带宽、信号强度决定）
     2、3G：联通卡是HSDPA高速3G通道（无WiFi情况下最快）
     3、E：EDGE网络（一般是移动网络，速度一般，能够达到256kbps（约32kb/s））（对于中国移动，使用该网络采用的是cmnet）
     4、圈：GPRS（这个移动比较常见、联通在信号不好或者无3G覆盖区域的时候使用该网络，速度最慢）
     
     iphone4优先使用wifi网络其次才是3G或者GPRS
     */


//通过Flags来辨识当前WIFI状态
- (NetworkStatus) localWiFiStatusForFlags: (SCNetworkReachabilityFlags) flags
{
	PrintReachabilityFlags(flags, "localWiFiStatusForFlags"); 
	BOOL retVal = NotReachable;
    //若满足kSCNetworkReachabilityFlagsReachable及kSCNetworkReachabilityFlagsIsDirect,则可认为WIFI连接是通的。
	if((flags & kSCNetworkReachabilityFlagsReachable) && (flags & kSCNetworkReachabilityFlagsIsDirect))
	{
		retVal = ReachableViaWiFi;	
	}
    
	return retVal;
}

//通过Flags来辨识当前网络状态
- (NetworkStatus) networkStatusForFlags: (SCNetworkReachabilityFlags) flags
{
	PrintReachabilityFlags(flags, "networkStatusForFlags");
	if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
	{
		// if target host is not reachable
		return NotReachable;
	}
    
	BOOL retVal = NotReachable;
	
	if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
	{
		// if target host is reachable and no connection is required
		//  then we'll assume (for now) that your on Wi-Fi
		retVal = ReachableViaWiFi;
	}
	
	if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
	{
        // ... and the connection is on-demand (or on-traffic) if the
        //     calling application is using the CFSocketStream or higher APIs
        
        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            // ... and no [user] intervention is needed
            retVal = ReachableViaWiFi;
        }
    }
	
    /*This flag indicates that the specified nodename or address can
     be reached via an EDGE, GPRS, or other "cell" connection.*/
	if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
	{
        //http://o0o0o0o.iteye.com/blog/1042527
        //纯 C 的 socket 不能激活 GPRS,而 Apple 自带的 API 可以。
		// ... but WWAN connections are OK if the calling application
		//     is using the CFNetwork (CFSocketStream?) APIs.
		retVal = ReachableViaWWAN;
	}
    
	return retVal;
}

- (BOOL) connectionRequired;
{
	NSAssert(reachabilityRef != NULL, @"connectionRequired called with NULL reachabilityRef");
	SCNetworkReachabilityFlags flags;
	if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
	{
		return (flags & kSCNetworkReachabilityFlagsConnectionRequired);
	}
    
	return NO;
}


//获取当前网络连接状态
- (NetworkStatus) currentReachabilityStatus
{
	NSAssert(reachabilityRef != NULL, @"currentNetworkStatus called with NULL reachabilityRef");
	NetworkStatus retVal = NotReachable;
	SCNetworkReachabilityFlags flags;
    
    //如果能获得状态则返回TRUE,否则返回FALSE
	if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
	{
        /*从这里看出WIFI的辨识和其他网络的辨识不一样*/
		if(localWiFiRef)
		{
			retVal = [self localWiFiStatusForFlags: flags];
		}
		else
		{
			retVal = [self networkStatusForFlags: flags];
		}
	}
    
	return retVal;
}
@end
