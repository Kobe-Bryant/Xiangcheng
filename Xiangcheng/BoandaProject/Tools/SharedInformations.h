//
//  SharedInformations.h
//  GMEPS_HZ
//
//  Created by chen on 11-10-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SharedInformations : NSObject
+(NSString*)getJJCDFromInt:(NSInteger) num;//紧急程度
+(NSString*)getBMJBFromInt:(NSInteger) num;//保密级别
+(NSString*)getGKLXFromInt:(NSInteger) num;//公开类型
+(NSString*)getFWLXFromStr:(NSString*) type;//发文类型
+(NSString*)getLWLXFromStr:(NSString*) type;//来文类型
+(NSString*)getAJLYFromInt:(NSInteger) num; //案件来源
+(NSString *)getNBSXCodeFromType:(NSString *)type;
+(NSString*)getXCOALWLXFromStr:(NSString*) type;//相城oa来文类型
+(NSString*)getXCOAFWLXFromStr:(NSString*) type;//相城oa发文类型
+(NSString *)getCGFSFromType:(NSInteger)type;//采购方式
+(NSString *)getCGLXFromType:(NSInteger)type;//采购类型

+(NSString *)getQJLXFromType:(NSInteger)type;//请假类型

@end
