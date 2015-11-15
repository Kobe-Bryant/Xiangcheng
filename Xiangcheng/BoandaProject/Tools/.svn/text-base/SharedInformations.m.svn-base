//
//  SharedInformations.m
//  GMEPS_HZ
//
//  Created by chen on 11-10-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SharedInformations.h"



@implementation SharedInformations

+(NSString*)getJJCDFromInt:(NSInteger) num{
    if (num == 0) return @"一般";
    else if (num == 1) return @"紧急";
    else if (num == 2) return @"特急";
    else return @" ";
}

+(NSString*)getAJLYFromInt:(NSInteger) num{

    if (num == 1) return @"现场发现";
    else if (num == 2) return @"投诉转办";
    else if (num == 3) return @"信访";
    else if (num == 4) return @"上级交办";
    else if (num == 5) return @"领导批示";
    else if (num == 6) return @"公众举报";
    else if (num == 7) return @"媒体曝光";
    else  return @"其它";
}


+(NSString*)getBMJBFromInt:(NSInteger) num{
    if (num == 2) return @"秘密";
    else if (num == 3) return @"机密";
    else  if (num == 4) return @"绝密";
    else return @"无密";
        
}

+(NSString*)getGKLXFromInt:(NSInteger) num{
    if (num == 1) return @"主动公开";
    else if (num == 2) return @"依申请公开";
    else  if (num == 3) return @"不予公开";
    else return @"内部公开";
    
}


+(NSString*)getFWLXFromStr:(NSString*) type{//发文类型
    NSArray * itemAry = [NSArray arrayWithObjects:@"阳环函",@"办公室下行文",@"办公室上行文",@"环保局下行文",@"环保局上行文", nil];
    
    
    NSArray *typeAry = [NSArray arrayWithObjects:@"10",@"15",@"20",@"25",@"30",nil];
    int index = 0;
    for(NSString *str in typeAry)
    {
        if ([str isEqualToString:type])
        {
            index = [typeAry indexOfObject:str];
            return [itemAry objectAtIndex:index];
        }
        
    }
    return @"";
}
+(NSString*)getXCOAFWLXFromStr:(NSString*) type
{
    if ([type isEqualToString:@"15"])
    {
        return @"苏相环信";
    }
    return @"苏相环";
}
+(NSString*)getXCOALWLXFromStr:(NSString*) type
{
    NSArray *itemAry = [NSArray arrayWithObjects:@"通报",@"急件",@"会议通知",@"电话记录",@"电话通知",@"会议",@"参阅文件",@"征求意见函",@"领导批示",@"会议纪要",@"简报",@"通知",@"预备通知",@"函",@"参阅文件",nil];
    
    NSArray *typeAry = [NSArray arrayWithObjects:@"70",@"10",@"20",@"30",@"40",@"50",@"3c27192b-0738-4636-a584-2012f14ab341",@"5bbd2c0c-0d26-4bb8-b4ff-de9e64cc9065",@"624cb4a5-f143-423b-8434-e1b37f704639",@"989a0005-4975-4202-b36b-0b92c69f7204",@"b31e6b68-a098-4d82-a13e-b12d5d9aba86",@"b8cd8cfe-8dfa-44d7-9624-a64f7f93f7e0",@"ba1b44c1-ab7b-4680-a6fe-1039d1f83c16",@"d8e9e33d-5419-4f51-a69d-08bec3fcc257",@"e77761c4-b59d-4200-9628-4d76c96ac5e9", nil];
    int index = 0;
    for(NSString *str in typeAry){
        if ([str isEqualToString:type]) {
            return [itemAry objectAtIndex:index];
        }
        index++;
    }
    return @"";
}
+(NSString*)getLWLXFromStr:(NSString*) type{//来文类型
    NSArray *itemAry = [NSArray arrayWithObjects:@"厅来文",@"厅发文",@"厅通知公告",@"其他单位来文",@"会议",@"电话记录",@"其他",nil];
    
    NSArray *typeAry = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
    int index = 0;
    for(NSString *str in typeAry){
        if ([str isEqualToString:type]) {
            return [itemAry objectAtIndex:index];
        }
        index++;
    }
    return @"";
}

+(NSString *)getNBSXCodeFromType:(NSString *)type
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:@"CGSQ" forKey:@"43000000010"];
    [dict setObject:@"CCSQ" forKey:@"5eb534db-e207-4a80-b035-e92a854278f6"];
    [dict setObject:@"YCSQ" forKey:@"43000000011"];
    [dict setObject:@"WYSQ" forKey:@"43000000012"];
    [dict setObject:@"QJSQ" forKey:@"8ef70a5b-73db-4e68-b70a-9d0871de3734"];
    if([dict objectForKey:type] == nil)
    {
        return @"";
    }
    else
    {
        return [dict objectForKey:type];
    }
}

//采购方式
+(NSString *)getCGFSFromType:(NSInteger)type{
    if(type == 1)
        return @"网购";
    else
        return @"实体";
}

+(NSString *)getCGLXFromType:(NSInteger)type{
    if(type == 1)
        return @"日常办公用品";
    else if(type == 2)
        return @"耗材";
    else if(type == 3)
        return @"配件";
    else 
        return @"其他";
}

+(NSString *)getQJLXFromType:(NSInteger)type
{
    if(type == 1)
    {
        return @"事假";
    }
    if(type == 2)
    {
        return @"病假";
    }
    else
    {
        return @"公休";
    } 
}

@end
