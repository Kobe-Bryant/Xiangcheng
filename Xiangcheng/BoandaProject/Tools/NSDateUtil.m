//
//  NSDateUtil.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSDateUtil.h"

@implementation NSDateUtil

+(NSString*)stringFromDate:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *dateString = [dateFormatter stringFromDate:date]; 
    return dateString;
}

+(NSString*)stringFromDate:(NSDate*)date andTimeFMT:(NSString*)fmt{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:fmt];
    NSString *dateString = [dateFormatter stringFromDate:date]; 
    return dateString;
}

+(NSString*)todayDateString{
    NSDate *date = [NSDate date];
    return [self stringFromDate:date];
}

+(NSString*)todayDateStringWithFMT:(NSString*)fmt{
    NSDate *date = [NSDate date];
    return [self stringFromDate:date andTimeFMT:fmt];
}

+(NSInteger)currentYear{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:date]; 
    NSInteger year = [dateString integerValue];
    return year;
}

+(NSInteger)currentMonth
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSInteger month = [dateString integerValue];
    return month;
}

+(NSDate*) dateFromString:(NSString*)dateStr andTimeFMT:(NSString*)fmt{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:fmt];
    NSDate *date = [dateFormatter dateFromString:dateStr];

    return date;
}

+(NSString*)firstDateThisMonth{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSString *dateString = [dateFormatter stringFromDate:date];

    return [NSString stringWithFormat:@"%@-01",dateString];
}

+(NSString *)firstDateOfMonth:(NSString *)amonth andYear:(NSString *)ayear
{
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-01",ayear,amonth];
    return dateStr;
}

+(NSString *)lastDateOfMonth:(NSString *)amonth andYear:(NSString *)ayear
{
    int yearCount = [ayear intValue];
    BOOL bLeapYear;
    
    if ((yearCount%4==0&&yearCount%100!=0)||yearCount%400==0)
        bLeapYear = YES;
    else
        bLeapYear = NO;
    
    int monthCount = [amonth intValue];
    
    NSString *dayStr = nil;
    
    switch (monthCount) {
        case 1:
            dayStr = @"31";
            break;
        case 2:
            if (bLeapYear)
                dayStr = @"29";
            else
                dayStr = @"28";
            break;
        case 3:
            dayStr = @"31";
            break;
        case 4:
            dayStr = @"30";
            break;
        case 5:
            dayStr = @"31";
            break;
        case 6:
            dayStr = @"30";
            break;
        case 7:
            dayStr = @"31";
            break;
        case 8:
            dayStr = @"31";
            break;
        case 9:
            dayStr = @"30";
            break;
        case 10:
            dayStr = @"31";
            break;
        case 11:
            dayStr = @"30";
            break;
        case 12:
            dayStr = @"31";
            break;
            
        default:
            break;
    }
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",ayear,amonth,dayStr];
    
    return dateStr;
}


+(NSString*)firstDateThisYear{
    NSInteger year = [NSDateUtil currentYear];
    return [NSString stringWithFormat:@"%d-01-01",year];
}

+(NSString *)firstDateOfFirstSeason
{
    NSInteger year = [NSDateUtil currentYear];
    return [NSString stringWithFormat:@"%d-01-01",year];
    
}

+(NSString *)firstDateOfSecondSeason
{   
    NSInteger year = [NSDateUtil currentYear];
    return [NSString stringWithFormat:@"%d-04-01",year];
}

+(NSString *)firstDateOfThirdSeason
{
    NSInteger year = [NSDateUtil currentYear];
    return [NSString stringWithFormat:@"%d-07-01",year];

}

+(NSString *)firstDateOfForthSeason
{
    NSInteger year = [NSDateUtil currentYear];
    return [NSString stringWithFormat:@"%d-10-01",year];
}

+(NSString *)lastDateOfFirstSeason
{
    NSInteger year = [NSDateUtil currentYear];
    return [NSString stringWithFormat:@"%d-03-31",year];

}

+(NSString *)lastDateOfSecondSeason
{
    NSInteger year = [NSDateUtil currentYear];
    return [NSString stringWithFormat:@"%d-06-30",year];
    
}

+(NSString *)lastDateOfThirdSeason
{    
    NSInteger year = [NSDateUtil currentYear];
    return [NSString stringWithFormat:@"%d-09-30",year];
}

+(NSString *)lastDateOfForthSeason;
{

    NSInteger year = [NSDateUtil currentYear];
    return [NSString stringWithFormat:@"%d-12-31",year];
    
}

@end
