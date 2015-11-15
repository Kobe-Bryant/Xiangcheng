//
//  NSDateUtil.h
//  HNYDZF
//
//  Created by 张 仁松 on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateUtil : NSObject
+(NSString*)stringFromDate:(NSDate*)date;
+(NSString*)stringFromDate:(NSDate*)date andTimeFMT:(NSString*)fmt;
+(NSString*)todayDateString;
+(NSString*)todayDateStringWithFMT:(NSString*)fmt;
+(NSInteger)currentYear;
+(NSInteger)currentMonth;
+(NSDate*) dateFromString:(NSString*)dateStr andTimeFMT:(NSString*)fmt;
//返回本月第一天的日期
+(NSString *)firstDateThisMonth;
//返回某月第一天的日期
+(NSString *)firstDateOfMonth:(NSString *)amonth andYear:(NSString *)ayear;
//返回某月最后一天的日期
+(NSString *)lastDateOfMonth:(NSString *)amonth andYear:(NSString *)ayear;

//返回本年度第一天的日期
+(NSString*)firstDateThisYear;
//返回本年度第N季度第一天的日期
+(NSString *)firstDateOfFirstSeason;
+(NSString *)firstDateOfSecondSeason;
+(NSString *)firstDateOfThirdSeason;
+(NSString *)firstDateOfForthSeason;
//返回本年度第N季度最后一天的日期
+(NSString *)lastDateOfFirstSeason;
+(NSString *)lastDateOfSecondSeason;
+(NSString *)lastDateOfThirdSeason;
+(NSString *)lastDateOfForthSeason;
@end
