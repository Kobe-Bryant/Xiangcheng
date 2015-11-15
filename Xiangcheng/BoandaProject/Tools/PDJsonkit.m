//
//  PDJsonkit.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-1.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "PDJsonkit.h"


@implementation NSString (PDJSONKitSerializing)

//Creating a JSON Object
- (id)objectFromJSONString{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
     
}

//Creating JSON Data
// Invokes JSONDataWithOptions:JKSerializeOptionNone   includeQuotes:YES
- (NSData *)JSONData{
    
    return [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
}

- (NSString *)JSONString{ // Invokes
    NSString *str = [[NSString alloc] initWithData: [self JSONData] encoding:NSUTF8StringEncoding] ;
    return str;
    
}

@end

@implementation NSData (PDJSONKitSerializing)

//Creating a JSON Object
- (id)objectFromJSONString{
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:nil];
}


@end


@implementation NSDictionary (PDJSONKitSerializing)

//Creating JSON Data
- (NSData *)JSONData{
    return [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
}

- (NSString *)JSONString{ // Invokes
    NSString *str = [[NSString alloc] initWithData: [self JSONData] encoding:NSUTF8StringEncoding] ;
    return str;
}
@end

@implementation NSArray (PDJSONKitSerializing)

//Creating JSON Data
- (NSData *)JSONData{
    return [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
}

- (NSString *)JSONString{ // Invokes
    NSString *str = [[NSString alloc] initWithData: [self JSONData] encoding:NSUTF8StringEncoding] ;
    return str;
}
@end

