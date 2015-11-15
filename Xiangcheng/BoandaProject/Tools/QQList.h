//
//  QQList.h
//  TQQTableView
//
//  Created by Futao on 11-6-21.
//  Copyright 2011 ftkey.com. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface QQPerson : NSObject {
	int m_nListID;

    NSDictionary *m_dataDic;
    
	NSString *m_strPersonName;

	NSString *m_strDept; 
    
    UIColor *m_color;
	//NSString *xxxx;
}

@property (nonatomic, assign) int m_nListID;

@property (nonatomic, retain) NSDictionary *m_dataDic;

@property (nonatomic, retain) NSString *m_strPersonName;

@property (nonatomic, retain) NSString *m_strDept;

@property (nonatomic, retain) UIColor *m_color;

@end

@interface QQListBase : NSObject {
	int m_nID;
	NSString *m_strGroupName;
	NSMutableArray * m_arrayPersons;
}
@property (nonatomic, assign) int m_nID;
@property (nonatomic, retain) NSString *m_strGroupName;
@property (nonatomic, retain) NSMutableArray *m_arrayPersons;
@end


@interface QQList : QQListBase {
	BOOL opened;
	NSMutableArray *indexPaths;
}
@property (assign) BOOL opened; // 是否为展开
@property (nonatomic,retain) NSMutableArray *indexPaths; // 临时保存indexpaths




@end