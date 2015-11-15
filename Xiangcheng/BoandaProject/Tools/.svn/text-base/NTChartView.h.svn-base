//
//  NTChartView.h
//  chart
//
//  Created by lee jory on 09-10-15.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NTChartView : UIView {
	

	NSMutableArray *groupData;
	NSMutableArray *groupNames;
	
	//最大值，最小值, 列宽度, 
	float maxValue,minValue,columnWidth,sideWidth,maxScaleValue,maxScaleHeight;
	float groupWidth;//组之间的间隔
    float curDrawColumnHeight;
	BOOL showNumStr;
}

@property(retain,nonatomic) NSMutableArray *groupData;
@property(retain,nonatomic) NSMutableArray *groupNames;

- (void)clearItems;
- (void)showNumStrInCol:(BOOL)show;
- (void)addGroupArray:(NSArray*)itemAry withGroupName:(NSString*)name;
- (void)addGroupString:(NSString*)itemStr withGroupName:(NSString*)name;
@end
