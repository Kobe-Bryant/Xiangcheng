//
//  QQList.m
//  TQQTableView
//
//  Created by Futao on 11-6-21.
//  Copyright 2011 ftkey.com. All rights reserved.
//

#import "QQList.h"



@implementation QQPerson
@synthesize m_nListID;
@synthesize m_dataDic;
@synthesize m_strPersonName;
@synthesize m_strDept,m_color;

- (void)dealloc
{
	[m_strPersonName release];
    [m_dataDic release];
    [m_strDept release];
	
    [super dealloc];
}
@end

@implementation QQListBase
@synthesize m_nID;
@synthesize m_strGroupName;
@synthesize m_arrayPersons;

- (void)dealloc
{
    [m_strGroupName release];
	[m_arrayPersons release];
    [super dealloc];
}
@end

@implementation QQList
@synthesize opened,indexPaths;
- (void)dealloc
{
	[indexPaths release];
    [super dealloc];
}
@end

