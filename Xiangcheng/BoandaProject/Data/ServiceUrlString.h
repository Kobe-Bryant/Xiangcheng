//
//  ServiceUrlString.h
//  HNYDZF
//
//  Created by 张 仁松 on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceUrlString : NSObject
+(NSString*)generateUrlByParameters:(NSDictionary*)params;
//生成厅里面的服务访问地址
+(NSString*)generateTingUrlByParameters:(NSDictionary*)params;
@end
