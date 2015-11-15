//
//  WebDataParserHelper.h
//  网络数据解析处理，需要实现WebDataParserDelegate这个协议
//  在项目中一般返回的数据是XML或者是JSON这两种格式，也有是返回的XML数据其中嵌套着JSON格式的数据
//  Created by 曾静 on 13-8-7.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "WebDataParserHelper.h"

@implementation WebDataParserHelper

@synthesize curParsedData, isGotJsonString, delegate, resultFieldName;

- (id)initWithFieldName:(NSString *)name andWithJSONDelegate:(id)aDelegate
{
    if(self = [super init])
    {
        self.resultFieldName = name;
        self.delegate = aDelegate;
    }
    return self;
}

- (id)initWithFieldName:(NSString *)name andWithJSONDelegate:(id)aDelegate andTag:(NSInteger)tag
{
    if(self = [super init])
    {
        self.resultFieldName = name;
        self.delegate = aDelegate;
        self.serviceTag = tag;
    }
    return self;
}

- (id)initWithJSONDelegate:(id)aDelegate
{
    if(self = [super init])
    {
        self.resultFieldName = nil;
        self.delegate = aDelegate;
    }
    return self;
}

- (void)parseXMLData:(NSData *)webData
{
    if(webData.length <=0)
    {
        if ([self.delegate respondsToSelector:@selector(parseWithError:)])
        {
            [self.delegate parseWithError:@"数据为空,无法解析!"];
        }
        return;
    }
    else if (self.resultFieldName == nil || self.resultFieldName.length <= 0)
    {
        if ([self.delegate respondsToSelector:@selector(parseWithError:)])
        {
            [self.delegate parseWithError:@"数据字段为空,无法解析!"];
        }
        return;
    }
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:webData];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
}

- (void)parseJSONData:(NSData *)webData
{
    NSString *json = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSMutableString *modifyStr = [NSMutableString stringWithString:json];
    //去掉字符串首尾空格
    [modifyStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //使用正则表达式将连续的空格替换为一个空格
	[modifyStr replaceOccurrencesOfString:@"[ ]+" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, [modifyStr length])];
    
//    //去掉反斜杠 和 tab键
//    [modifyStr replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifyStr length])];
    
      
    [modifyStr replaceOccurrencesOfString:@"null" withString:@"\"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifyStr length])];
    
    if ([self.delegate respondsToSelector:@selector(parseJSONString:andTag:)])
    {
        [self.delegate parseJSONString:modifyStr andTag:self.serviceTag];
    }
    else {
        [self.delegate parseJSONString:modifyStr];
    }

    
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:self.resultFieldName])
        self.isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.isGotJsonString)
        [self.curParsedData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (self.isGotJsonString && [elementName isEqualToString:self.resultFieldName])
    {
        //解析JSON格式数据
        if ([self.delegate respondsToSelector:@selector(parseJSONString:andTag:)])
        {
            NSMutableString *modifyStr = [NSMutableString stringWithString:curParsedData];
            
            //去掉字符串首尾空格
            [modifyStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            //使用正则表达式将连续的空格替换为一个空格
            [modifyStr replaceOccurrencesOfString:@"[ ]+" withString:@" " options:NSRegularExpressionSearch range:NSMakeRange(0, [modifyStr length])];
            
//            //去掉反斜杠 和 tab键
//            [modifyStr replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifyStr length])];
            
            
            [modifyStr replaceOccurrencesOfString:@"null" withString:@"\"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifyStr length])];

            [self.delegate parseJSONString:modifyStr andTag:self.serviceTag];
            
        }
        else if ([self.delegate respondsToSelector:@selector(parseJSONString:)])
        {
            NSMutableString *modifyStr = [NSMutableString stringWithString:curParsedData];
            [modifyStr replaceOccurrencesOfString:@"  " withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifyStr length])];
            [self.delegate parseJSONString:modifyStr];
        }
    }
    self.isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}

@end
