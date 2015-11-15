//
//  DataSyncHandleDatas.h
//  HNYDZF
//
//  Created by 张 仁松 on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ParserBlock)( NSInteger paramInteger);

@interface DataSyncHandleDatas : NSObject<NSXMLParserDelegate>
@property(nonatomic,retain)NSString *datasToParse;
-(id)initWithDatas:(NSString*)datas andParserTag:(NSInteger)tag completionHandler:(ParserBlock)handler;
-(void)parseAndSave;

@end
