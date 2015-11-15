//
//  PDJsonkit.h
//  BoandaProject
//
//  Created by 张仁松 on 13-7-1.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//  封转NSJSONSerialization, 需要版本5.0以上

#import <Foundation/Foundation.h>

@interface NSString (PDJSONKitSerializing)

//Creating a JSON Object
- (id)objectFromJSONString;

//Creating JSON Data
- (NSData *)JSONData;     // Invokes JSONDataWithOptions:JKSerializeOptionNone   includeQuotes:YES

- (NSString *)JSONString; // Invokes

@end

@interface NSData (PDJSONKitSerializing)

//Creating a JSON Object
- (id)objectFromJSONString;


@end


@interface NSDictionary (PDJSONKitSerializing)

//Creating JSON Data
- (NSData *)JSONData;     // Invokes JSONDataWithOptions:JKSerializeOptionNone   includeQuotes:YES

- (NSString *)JSONString; // Invokes

@end

@interface NSArray (PDJSONKitSerializing)

//Creating JSON Data
- (NSData *)JSONData;     // Invokes JSONDataWithOptions:JKSerializeOptionNone   includeQuotes:YES

- (NSString *)JSONString; // Invokes

@end


