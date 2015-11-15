//
//  ShowHtmlController.h
//  HNYDZF
//
//  Created by 张 仁松 on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HtmlTableGenerator : NSObject

+(NSArray*)genContentWithValue:(NSDictionary*)params;

+(NSString*)genContentWithTitle:(NSString*)aTitle andParaMeters:(NSDictionary*)params
                        andType:(NSString*)serviceKey;

+(NSString*)genContentWithTitle1:(NSString*)aTitle andParaMeters:(NSDictionary*)params
                         andType:(NSString*)serviceKey;
@end
