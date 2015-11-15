//
//  WebDataParserHelper.h
//  网络数据解析处理，需要实现WebDataParserDelegate这个协议
//  在项目中一般返回的数据是XML或者是JSON这两种格式，也有是返回的XML数据其中嵌套着JSON格式的数据
//  Created by 曾静 on 13-8-7.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebDataParserDelegate;

@interface WebDataParserHelper : NSObject <NSXMLParserDelegate>

@property (assign, nonatomic) NSInteger serviceTag;
@property (copy, nonatomic) NSString *resultFieldName;
@property (assign, nonatomic) BOOL isGotJsonString;
@property (strong, nonatomic) NSMutableString *curParsedData;
@property (weak, nonatomic) id<WebDataParserDelegate> delegate;

- (id)initWithFieldName:(NSString *)name andWithJSONDelegate:(id)aDelegate andTag:(NSInteger)tag;

- (id)initWithFieldName:(NSString *)name andWithJSONDelegate:(id)aDelegate;

- (id)initWithJSONDelegate:(id)aDelegate;

//解析XML数据
- (void)parseXMLData:(NSData *)webData;

//解析JSON数据
- (void)parseJSONData:(NSData *)webData;


@end

@protocol WebDataParserDelegate <NSObject>

@optional

- (void)parseJSONString:(NSString *)jsonStr andTag:(NSInteger)tag;

- (void)parseJSONString:(NSString *)jsonStr;

@optional
- (void)parseWithError:(NSString *)errorString;

@end
