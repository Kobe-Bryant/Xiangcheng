//
//  DataSyncHandleDatas.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataSyncHandleDatas.h"
#import "PDJSONKit.h"
#import "SqliteHelper.h"

@interface DataSyncHandleDatas(){
    ParserBlock completionHandle;
    NSInteger tagID;
}

@property (nonatomic, retain) NSMutableString *currentString;
@property (nonatomic,assign) BOOL storingCharacters;
@property(nonatomic,retain)NSMutableArray *aryFieldNames;
@property(nonatomic,retain)NSMutableArray *aryItems;
@property(nonatomic,retain)NSMutableDictionary *currentItemValues;
@property(nonatomic,copy)NSDictionary *curAttributeDict;
@property(nonatomic,copy)NSString *curTable;

@end

@implementation DataSyncHandleDatas
@synthesize datasToParse;
@synthesize currentString,storingCharacters;
@synthesize aryFieldNames,aryItems,currentItemValues,curTable,curAttributeDict;

-(id)initWithDatas:(NSString*)toParseData andParserTag:(NSInteger)tag completionHandler:(ParserBlock)handler{
    self = [super init];
    if (self) {
        self.datasToParse = toParseData;
        tagID = tag;
        completionHandle = handler;
    }
    return self;
}

-(void)parseAndSave{
    if(datasToParse == nil)return;
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[datasToParse dataUsingEncoding:NSUTF8StringEncoding]];
    xmlParser.delegate = self;
    self.currentString = [NSMutableString string];
    self.aryFieldNames = [NSMutableArray arrayWithCapacity:15];
    self.aryItems = [NSMutableArray arrayWithCapacity:30];
    [xmlParser parse];
}

static NSString *kName_table = @"table";
static NSString *kName_field = @"field";
static NSString *kName_dataitem = @"data-item";
static NSString *kName_datafield = @"data-field";


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *) qualifiedName attributes:(NSDictionary *)attributeDict {
    
    if([elementName isEqualToString:kName_dataitem] ){
        self.currentItemValues = [NSMutableDictionary dictionaryWithCapacity:15];
    }
    else if([elementName isEqualToString:kName_field] ){
        if(attributeDict){
            [aryFieldNames addObject:[attributeDict objectForKey:@"name"]];
        }
        
    }
    else if([elementName isEqualToString:kName_datafield] ){
        self.curAttributeDict = attributeDict;
        storingCharacters = YES;
    }
    else if ([elementName isEqualToString:kName_table]) {
        
        storingCharacters = YES;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:kName_table]){
        self.curTable = currentString;
    }else if([elementName isEqualToString:kName_dataitem] ){
        [aryItems addObject:[currentItemValues copy]];
        self.currentItemValues = nil;
    }else if([elementName isEqualToString:kName_datafield] ){
        if(curAttributeDict){
            if([currentString isEqualToString:@""])
                [currentString setString: @"null"];
            [currentItemValues setObject:[currentString copy] forKey:[curAttributeDict objectForKey:@"field"]];
        }
    }
    storingCharacters = NO;
    [currentString setString: @""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (storingCharacters) [currentString appendString:string];
}

/*
 A production application should include robust error handling as part of its parsing implementation.
 The specifics of how errors are handled depends on the application.
 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    // Handle errors as appropriate for your application.
    if (parseError) {
        //NSLog(@"%@",[parseError localizedDescription]);
        completionHandle(tagID);
        return ;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    /*
     NSLog(@"%@ %@",curTable,aryFieldNames);
     NSLog(@"%d",[aryItems count]);
     for(NSDictionary *dic in aryItems){
     NSLog(@"data: %@",dic);
     }
     */
    //插入数据到临时数据库中
    NSString *tmp_tbl = [NSString stringWithFormat:@"%@_TEMP", curTable];
    SqliteHelper *dbHelper = [[SqliteHelper alloc] init];
    [dbHelper insertTable:tmp_tbl andDatas:aryItems];
    completionHandle(tagID);
}


@end
