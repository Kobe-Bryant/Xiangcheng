//
//  NTChartView.m
//  chart
//
//  Created by lee jory on 09-10-15.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NTChartView.h"
#import "ChartItem.h"
static int MARGIN_LEFT = 60;
static int MARGIN_BOTTOM = 120;
static int MARGIN_TOP = 20;
static int SHOW_SCALE_NUM = 5; 
static int GROUP_GAP = 20;

#define TIMER_COUNT 20

@interface NTChartView()
-(void)drawColumn:(CGContextRef)context rect:(CGRect)_rect;
-(void)drawScale:(CGContextRef)context rect:(CGRect)_rect;
-(void)calcScales:(CGRect)_rect;
@property(nonatomic,retain)NSTimer *timerDraw;
@property(nonatomic,assign)BOOL bModified;
@end

@implementation NTChartView
@synthesize groupData,groupNames,timerDraw,bModified;



-(id) initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        showNumStr = YES;
        bModified = YES;
    }
    return self;
}

- (void)clearItems 
{
	if( groupData ) {
		[groupData removeAllObjects];	
	}
	
	if( groupNames ) {
		[groupNames removeAllObjects];	
	}
    bModified = YES;
}

- (void)showNumStrInCol:(BOOL)show{
    showNumStr = show;
}

- (void)removeItemNames:(NSMutableArray *)groupName{
    groupNames = groupName;
    [groupNames removeAllObjects];
}

- (void)addGroupArray:(NSArray*)itemAry withGroupName:(NSString*)name
{
	
	if( !groupData ) {
		groupData = [[NSMutableArray alloc] initWithCapacity:3];
		groupNames= [[NSMutableArray alloc] initWithCapacity:3];
	}
	
	[groupData addObject:itemAry];
//    NSLog(@"itemAry----------%@",itemAry);
//    NSLog(@"groupData----------%@",groupData);
	if (name) {
		[groupNames addObject:name];
	}
	else {
		[groupNames addObject:@""];
	}
    bModified = YES;
	

}

- (void)addGroupString:(ChartItem *)itemStr withGroupName:(NSString*)name
{
	
	if( !groupData ) {
		groupData = [[NSMutableArray alloc] initWithCapacity:3];
		groupNames= [[NSMutableArray alloc] initWithCapacity:3];
	}
	
	[groupData addObject:itemStr];
	if (name) {
		[groupNames addObject:name];
	}
	else {
		[groupNames addObject:@""];
	}
    bModified = YES;
	
    
}

-(void)drawRect:(CGRect)_rect{
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [UIColor colorWithRed:(0xf2/255.0f) green:(0xf0/255.0f) blue:(0xec/255.0f) alpha:1.0].CGColor);
	CGContextFillRect(context, _rect);
	
	//计算刻度
    if(bModified){
        [self calcScales:_rect];
 
        bModified = NO;
    }
	
	//画刻度
    [self drawScale:context rect:_rect];
    //画柱
    [self drawColumn:context rect:_rect];
	
}

-(void)drawScale:(CGContextRef)context rect:(CGRect)_rect{
	CGPoint points[3];
	points[0] = CGPointMake(MARGIN_LEFT - 10, MARGIN_TOP);
	points[1] = CGPointMake(MARGIN_LEFT -10, _rect.size.height - MARGIN_BOTTOM + 1);
	points[2] = CGPointMake(_rect.size.width - 10, _rect.size.height - MARGIN_BOTTOM + 1);
	CGContextSetAllowsAntialiasing(context, NO);
	CGContextAddLines(context, points, 3);
	
	
	CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor); 
	
	for(int i=0;i<SHOW_SCALE_NUM + 1; i++){
		maxScaleHeight = (_rect.size.height - MARGIN_BOTTOM) * ( i ) / (SHOW_SCALE_NUM + 1);
		int vScal = ceil(1.0 * maxScaleValue / (SHOW_SCALE_NUM ) * (i ));
		float y = (_rect.size.height - MARGIN_BOTTOM) -
			maxScaleHeight;
		
		NSString *scaleStr = [NSString stringWithFormat:@"%d",vScal];
		[scaleStr
			drawAtPoint:CGPointMake(MARGIN_LEFT - 20 - [scaleStr sizeWithFont:[UIFont systemFontOfSize:12]].width, y - 10) withFont:[UIFont systemFontOfSize:12]];
		points[0] = CGPointMake(MARGIN_LEFT - 10, y);
		points[1] = CGPointMake(MARGIN_LEFT - 13, y);
		CGContextSetLineDash(context, 0, NULL, 0);
		CGContextAddLines(context, points, 2);
		CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);

		CGContextDrawPath(context, kCGPathStroke);

		
		points[0] = CGPointMake(MARGIN_LEFT - 10, y);
		points[1] = CGPointMake(_rect.size.width - 10 , y);
		float partren[] = {2,3};
		CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1].CGColor);

		CGContextSetLineDash(context, 0,partren , 2);
		CGContextAddLines(context, points, 2);
		CGContextDrawPath(context, kCGPathStroke);
		
	}
	
	CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);

	CGContextDrawPath(context, kCGPathStroke);
	CGContextSetAllowsAntialiasing(context, YES);

	
}

-(void)drawColumn:(CGContextRef)context rect:(CGRect)_rect{
	int vNumber = 0,gNumber = 0;
	int baseGroundY = _rect.size.height - MARGIN_BOTTOM, baseGroundX = MARGIN_LEFT;
	CGPoint points[4];
	

	BOOL bGrouped = [groupData count] > 1;
	BOOL bDrawItemLable = NO;
	for(NSArray *g in groupData){
		//如果分组 那么就在整个柱子分组下面画分组的名字 
		if (bGrouped) {
			NSString *str = [groupNames objectAtIndex:gNumber];
			CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
			CGRect txtRect = CGRectMake(baseGroundX + (columnWidth +sideWidth) * vNumber+gNumber*GROUP_GAP, baseGroundY+10,groupWidth-5, 80);
            
			[str drawInRect:txtRect withFont:[UIFont fontWithName:@"Helvetica-Bold" size:18] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
			
		}

		for(ChartItem *aItem in g){

			float columnHeight = aItem.value / maxScaleValue * maxScaleHeight ;
			if(columnHeight < curDrawColumnHeight){

                //减一个定时刻度 如果大于说明还有一点高度需要画出
            }
            else
                columnHeight = curDrawColumnHeight;
            
			//值为0也要画
			if(columnHeight < 3){
				//vNumber++;
				//continue;
				columnHeight = 3;
			}
			//画正面
			CGRect rect = CGRectMake(baseGroundX + (columnWidth +sideWidth) * vNumber+gNumber*GROUP_GAP
									 , baseGroundY - columnHeight 
									 , columnWidth
									 , columnHeight);
			CGContextSetFillColorWithColor(context, aItem.color);
			CGContextAddRect(context,rect );
			CGContextDrawPath(context, kCGPathFill);
			//NSLog(@"columnHeight:%f, (_rect.size.height - MARGIN_TOP - MARGIN_BOTTOM ):%f",columnHeight,(_rect.size.height - MARGIN_TOP - MARGIN_BOTTOM ));

	
			
			
			//画右侧面
			const float* rgba = CGColorGetComponents(aItem.color);
			UIColor *rightColor = [UIColor colorWithRed:rgba[0]*0.9 green:rgba[1]*0.9 blue:rgba[2]*0.9 alpha:1];
			CGContextSetFillColorWithColor(context, rightColor.CGColor);
			points[0] = CGPointMake(gNumber*GROUP_GAP + baseGroundX + (columnWidth +sideWidth) * vNumber + columnWidth, baseGroundY - columnHeight -10);
			points[1] = CGPointMake(gNumber*GROUP_GAP + baseGroundX + (columnWidth +sideWidth) * vNumber + columnWidth + sideWidth, baseGroundY - columnHeight -10 );
			points[2] = CGPointMake(gNumber*GROUP_GAP + baseGroundX + (columnWidth +sideWidth) * vNumber + columnWidth + sideWidth, baseGroundY );
			points[3] = CGPointMake(gNumber*GROUP_GAP + baseGroundX + (columnWidth +sideWidth) * vNumber + columnWidth, baseGroundY );
			
			CGContextAddLines(context, points, 4);
			CGContextDrawPath(context, kCGPathFill);
			
			//画上面
			UIColor *topColor = [UIColor colorWithRed:rgba[0] green:rgba[1]*0.4 blue:rgba[2]*0.4 alpha:1];
			CGContextSetFillColorWithColor(context, topColor.CGColor);
			points[0] = CGPointMake(gNumber*GROUP_GAP + baseGroundX + (columnWidth +sideWidth) * vNumber , baseGroundY - columnHeight );
			points[1] = CGPointMake(gNumber*GROUP_GAP + baseGroundX + (columnWidth +sideWidth) * vNumber + sideWidth, baseGroundY - columnHeight -10 );
			points[2] = CGPointMake(gNumber*GROUP_GAP + baseGroundX + (columnWidth +sideWidth) * vNumber + columnWidth + sideWidth , baseGroundY - columnHeight -10 );
			points[3] = CGPointMake(gNumber*GROUP_GAP + baseGroundX + (columnWidth +sideWidth) * vNumber + columnWidth, baseGroundY - columnHeight );
			
			CGContextAddLines(context, points, 4);
			CGContextDrawPath(context, kCGPathFill);
			
			//画数值
            if(showNumStr){
                NSString *valStr = [NSString stringWithFormat:@"%d",(int)aItem.value];
                CGRect valRect = CGRectMake(gNumber*GROUP_GAP + baseGroundX + (columnWidth +sideWidth)* vNumber + 5, baseGroundY - columnHeight-30, columnWidth, 20);
                [valStr drawInRect:valRect withFont:[UIFont systemFontOfSize:12] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
            }
			
             
			//如果没有分组 那么就在柱子下面画各个柱子的label	
			if (!bGrouped) {
				CGRect txtRect = CGRectMake(rect.origin.x, baseGroundY+10, columnWidth, 100);
				[aItem.name drawInRect:txtRect withFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
                //NSLog(@"columnWidth--------%f",columnWidth);
			}
			else {
				if (!bDrawItemLable) {//只画一次
					CGContextSetFillColorWithColor(context, aItem.color);
					CGContextFillRect(context, CGRectMake(baseGroundX+vNumber*200, baseGroundY+10+80, 40, 20));
					CGContextDrawPath(context, kCGPathFill);
					[aItem.name drawAtPoint:CGPointMake(baseGroundX + vNumber*200+50, baseGroundY+10+80) withFont:[UIFont systemFontOfSize:16]];
					
				}
			}

			vNumber++;
		}
		bDrawItemLable = YES;
		gNumber++;
	}
	

	
}

-(void)calcScales:(CGRect)_rect{
	int columnCount = 0;
	int groupCount = 0;
    maxValue = 0;
    minValue = 0;
	for(NSArray *g in groupData){
		groupCount++;
		for(ChartItem *aItem in g){
			if(maxValue< aItem.value) maxValue = aItem.value;
			if(minValue> aItem.value) minValue = aItem.value;
			columnCount++;
		}
	}
	
	maxScaleValue = ((int)ceil(maxValue) + (SHOW_SCALE_NUM - (int)ceil(maxValue) % SHOW_SCALE_NUM));
	
	/*
	columnWidth = (_rect.size.width - MARGIN_LEFT * 2) / (columnCount + 1);
	sideWidth = columnWidth *.2;
	columnWidth *= .8;	*/
	
	columnWidth = (_rect.size.width - MARGIN_LEFT * 2-GROUP_GAP*groupCount) / ( columnCount);
    
  //  if (columnWidth > ((_rect.size.width - MARGIN_LEFT * 2)/16))
  //      columnWidth = (_rect.size.width - MARGIN_LEFT * 2)/16;
    groupWidth = (_rect.size.width - MARGIN_LEFT * 2)/groupCount;
 //   if (groupWidth > ((_rect.size.width - MARGIN_LEFT * 2)/16))
  //      groupWidth = (_rect.size.width - MARGIN_LEFT * 2)/16;
    
	sideWidth = columnWidth *.2;
	columnWidth *= .8;
    curDrawColumnHeight = 0.0;
    printf("%f %f\n",columnWidth,groupWidth);
    self.timerDraw = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(animationTurn) userInfo:nil repeats:YES];

}

-(void)animationTurn{
    if (curDrawColumnHeight >= maxScaleHeight) {
        [timerDraw invalidate];
        return;
    }
    
    float addScale = maxScaleHeight/TIMER_COUNT;
    curDrawColumnHeight += addScale;
    [self setNeedsDisplay];
    
}

@end
