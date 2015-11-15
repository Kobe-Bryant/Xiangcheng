//
//  S7GraphView.m
//  S7Touch
//
//  Created by Aleks Nesterow on 9/27/09.
//  aleks.nesterow@gmail.com
//
//  Thanks to http://snobit.habrahabr.ru/ for releasing sources for his
//  Cocoa component named GraphView.
//
//  Copyright © 2009, 7touchGroup, Inc.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  * Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  * Neither the name of the 7touchGroup, Inc. nor the
//  names of its contributors may be used to endorse or promote products
//  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY 7touchGroup, Inc. "AS IS" AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL 7touchGroup, Inc. BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "S7GraphView.h"

@interface S7GraphView (PrivateMethods)

- (void)initializeComponent;

@end

@implementation S7GraphView

- (UIColor *)colorByIndex:(NSInteger)index {
	
	UIColor *color;
	
	switch (index) {
		case 0: color = RGB(5, 141, 191);
			break;
		case 1: color = RGB(80, 180, 50);
			break;
		case 2: color = RGB(255, 102, 0);
			break;
		case 3: color = RGB(255, 158, 1);
			break;
		case 4: color = RGB(252, 210, 2);
			break;
		case 5: color = RGB(248, 255, 1);
			break;
		case 6: color = RGB(176, 222, 9);
			break;
		case 7: color = RGB(106, 249, 196);
			break;
		case 8: color = RGB(178, 222, 255);
			break;
		case 9: color = RGB(4, 210, 21);
			break;
		default: color = RGB(204, 204, 204);
			break;
	}
	
	return color;
}

@synthesize dataSource, xValuesFormatter, yValuesFormatter;
@synthesize drawAxisX = _drawAxisX, drawAxisY = _drawAxisY, drawGridX = _drawGridX, drawGridY = _drawGridY;
@synthesize xValuesColor = _xValuesColor, yValuesColor = _yValuesColor, gridXColor = _gridXColor, gridYColor = _gridYColor;
@synthesize drawInfo = _drawInfo, info = _info, infoColor = _infoColor;
@synthesize  yHighLimit, yLowLimit;
@synthesize curValueLabel,markerLineView;
@synthesize yMaxValue;

- (id)initWithFrame:(CGRect)frame {
	
    if (self = [super initWithFrame:frame]) {
		[self initializeComponent];
		/*
         markerLineView = [[[UIView alloc] initWithFrame:CGRectMake(60, 30, 1, frame.size.height-30)] autorelease];
         markerLineView.backgroundColor = [UIColor blackColor];
         markerLineView.alpha = 0.0;
         [self addSubview:markerLineView];
         
         curValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(150.0f, 5.0f, frame.size.width-150.0f, 20.0f)];
         curValueLabel.alpha = 0.0;
         curValueLabel.textAlignment = UITextAlignmentRight;
         //curValueLabel.backgroundColor = [UIColor blueColor];
         [self addSubview:curValueLabel];
         */
		
    }
	
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	
	if (self = [super initWithCoder:decoder]) {
		[self initializeComponent];
	}
	
	return self;
}


- (void)drawRect:(CGRect)rect {
	
	CGContextRef c = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(c, self.backgroundColor.CGColor);
	CGContextFillRect(c, rect);
	
	NSUInteger numberOfPlots = [self.dataSource graphViewNumberOfPlots:self];
	
	if (!numberOfPlots) {
		return;
	}
	
	CGFloat offsetX = _drawAxisY ? 60.0f : 10.0f;
	CGFloat offsetY = (_drawAxisX || _drawInfo) ? 30.0f : 10.0f;
	
	UIFont *font = [UIFont systemFontOfSize:11.0f];
    
    CGFloat minY = 0.0;
    CGFloat maxY = yHighLimit;
	
	for (NSUInteger plotIndex = 0; plotIndex < numberOfPlots; plotIndex++) {
		
		NSArray *values = [self.dataSource graphView:self yValuesForPlot:plotIndex];
		
		for (NSUInteger valueIndex = 0; valueIndex < values.count; valueIndex++) {
			
			if ([[values objectAtIndex:valueIndex] floatValue] > maxY) {
				maxY = [[values objectAtIndex:valueIndex] floatValue];
			}
		}
	}
    
    if(maxY < 1){
        maxY = 1;
    }
    if(yMaxValue > 0){
        maxY = yMaxValue;
    }else{
        if(maxY <= 10){
            maxY = maxY *5;
        }
        if (maxY >10 && maxY <= 100) {
            maxY = ceil(maxY / 10) * 10;
        }
        
        if (maxY > 100 && maxY <= 1000) {
            maxY = ceil(maxY / 100) * 100;
        }
        
        if (maxY > 1000 && maxY <= 10000) {
            maxY = ceil(maxY / 1000) * 1000;
        }
        
        if (maxY > 10000 && maxY <= 100000) {
            maxY = ceil(maxY / 10000) * 10000;
        }
    }
    
	CGFloat step = (maxY - minY) / 5;
	CGFloat stepY = (self.frame.size.height - (offsetY * 2)) / maxY;
    
	//画上下限横线
	if (yHighLimit -0.0f > 0.000001) {
		float yHighLimitPos = self.frame.size.height - yHighLimit * stepY - offsetY;
		CGContextMoveToPoint(c, offsetX, yHighLimitPos);
		CGContextAddLineToPoint(c, self.frame.size.width - offsetX, yHighLimitPos);
		CGContextClosePath(c);
		CGContextSetStrokeColorWithColor(c, [UIColor redColor].CGColor);
		CGContextStrokePath(c);
		
	}
	
	if (yLowLimit -0.0f > 0.000001) {
		float yLowLimitPos = self.frame.size.height - yLowLimit * stepY - offsetY;
		CGContextMoveToPoint(c, offsetX, yLowLimitPos);
		CGContextAddLineToPoint(c, self.frame.size.width - offsetX, yLowLimitPos);
		CGContextClosePath(c);
		CGContextSetStrokeColorWithColor(c, [UIColor redColor].CGColor);
		CGContextStrokePath(c);
	}
	//画时间
	
	
	for (NSUInteger i = 0; i < 6; i++) {
        
		CGFloat y = (i * step) * stepY;
		CGFloat value = i * step;
		
        //        NSLog(@"y---------- %f",y);
        //        NSLog(@"value-------- %f",value);
        
		if (_drawGridY) {
			
			CGFloat lineDash[2];
			lineDash[0] = 6.0f;
			lineDash[1] = 6.0f;
			
			CGContextSetLineDash(c, 0.0f, lineDash, 2);
			CGContextSetLineWidth(c, 0.3f);
			
			CGPoint startPoint = CGPointMake(offsetX, self.frame.size.height - y - offsetY);
			CGPoint endPoint = CGPointMake(self.frame.size.width - offsetX, self.frame.size.height - y - offsetY);
			
			CGContextMoveToPoint(c, startPoint.x, startPoint.y);
			CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
			CGContextClosePath(c);
			
			CGContextSetStrokeColorWithColor(c, self.gridYColor.CGColor);
			CGContextStrokePath(c);
		}
		
		if (i > 0 && _drawAxisY) {
			
			NSNumber *valueToFormat = [NSNumber numberWithInt:value];
			NSString *valueString;
			
			if (self.yValuesFormatter) {
				valueString = [self.yValuesFormatter stringForObjectValue:valueToFormat];
			} else {
				valueString = [valueToFormat stringValue];
			}
			
			[self.yValuesColor set];
			CGRect valueStringRect = CGRectMake(-3.0f, self.frame.size.height - y - offsetY-5, 50.0f, 20.0f);
			
			[valueString drawInRect:valueStringRect withFont:font
					  lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
		}
	}
	
	float maxStep;
	
	NSArray *xValues = [self.dataSource graphViewXValues:self];
	NSUInteger xValuesCount = xValues.count;
	
	if (xValuesCount > 5) {
		
		NSUInteger stepCount = 5;
		NSUInteger count = xValuesCount - 1;
		
		for (NSUInteger i = 4; i < 8; i++) {
			if (count % i == 0) {
				stepCount = i;
			}
		}
		
		step = xValuesCount / stepCount;
		maxStep = stepCount + 1;
		
	} else {
		
		step = 1;
		maxStep = xValuesCount;
	}
	
	CGFloat stepX = (self.frame.size.width - (offsetX * 2)) / (xValuesCount - 1);
	
	for (NSUInteger i = 0; i < maxStep; i++) {
		
		float x = (i * step) * stepX;
		
		if (x > self.frame.size.width - (offsetX * 2)) {
			x = self.frame.size.width - (offsetX * 2);
		}
		
		float index = i * step;
		
		if (index >= xValuesCount) {
			index = xValuesCount - 1;
		}
		
		if (_drawGridX || i == 0) {
			
			CGFloat lineDash[2];
			
			lineDash[0] = 6.0f;
			lineDash[1] = 6.0f;
			
			CGContextSetLineDash(c, 0.0f, lineDash, 2);
			CGContextSetLineWidth(c, 0.3f);
			
			CGPoint startPoint = CGPointMake(x + offsetX, offsetY);
			CGPoint endPoint = CGPointMake(x + offsetX, self.frame.size.height - offsetY);
			
			CGContextMoveToPoint(c, startPoint.x, startPoint.y);
			CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
			CGContextClosePath(c);
			
			CGContextSetStrokeColorWithColor(c, self.gridXColor.CGColor);
			CGContextStrokePath(c);
		}
		
		if (_drawAxisX) {
			/*
             id valueToFormat = [xValues objectAtIndex:index];
             NSString *valueString ;
             
             if (_xValuesFormatter) {
             valueString = [_xValuesFormatter stringForObjectValue:valueToFormat];
             } else {
             valueString = [NSString stringWithFormat:@"%@", valueToFormat];
             }*/
			NSString *valueString = [xValues objectAtIndex:index];
			[self.xValuesColor set];
			[valueString drawInRect:CGRectMake(x, self.frame.size.height - 20.0f, 120.0f, 20.0f) withFont:font
					  lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
		}
	}
	
	stepX = (self.frame.size.width - (offsetX * 2)) / (xValuesCount - 1);
	
	CGContextSetLineDash(c, 0, NULL, 0);
	
	for (NSUInteger plotIndex = 0; plotIndex < numberOfPlots; plotIndex++) {
		
		NSArray *values = [self.dataSource graphView:self yValuesForPlot:plotIndex];
		BOOL shouldFill = NO;
		
		if ([self.dataSource respondsToSelector:@selector(graphView:shouldFillPlot:)]) {
			shouldFill = [self.dataSource graphView:self shouldFillPlot:plotIndex];
		}
		
		UIColor* plotColor = [UIColor colorWithRed:5/255.0f green:141/255.0f blue:191/255.0f alpha:1.0f];
        
		if (values.count)
		for (NSUInteger valueIndex = 0; valueIndex < values.count - 1; valueIndex++) {
			
			float x = valueIndex * stepX;
			float y = [[values objectAtIndex:valueIndex] floatValue] * stepY;
			
			CGContextSetLineWidth(c, 1.5f);
			
			CGPoint startPoint = CGPointMake(x + offsetX, self.frame.size.height - y - offsetY);
			
			x = (valueIndex + 1) * stepX;
			y = [[values objectAtIndex:valueIndex + 1] floatValue] * stepY;
			
			CGPoint endPoint = CGPointMake(x + offsetX, self.frame.size.height - y - offsetY);
			
			CGContextMoveToPoint(c, startPoint.x, startPoint.y);
			CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
			CGContextClosePath(c);
			
			CGContextSetStrokeColorWithColor(c, plotColor.CGColor);
			CGContextStrokePath(c);
			
			if (shouldFill) {
				
				CGContextMoveToPoint(c, startPoint.x, self.frame.size.height - offsetY);
				CGContextAddLineToPoint(c, startPoint.x, startPoint.y);
				CGContextAddLineToPoint(c, endPoint.x, endPoint.y);
				CGContextAddLineToPoint(c, endPoint.x, self.frame.size.height - offsetY);
				CGContextClosePath(c);
				if ([[values objectAtIndex:valueIndex] floatValue] > self.yHighLimit || [[values objectAtIndex:valueIndex] floatValue] < self.yHighLimit)
                    CGContextSetFillColorWithColor(c, [UIColor redColor].CGColor);
                else
                    CGContextSetFillColorWithColor(c, plotColor.CGColor);
				CGContextFillPath(c);
			}
		}
	}
	
	if (_drawInfo) {
		
		font = [UIFont boldSystemFontOfSize:13.0f];
		[self.infoColor set];
		[_info drawInRect:CGRectMake(0.0f, 5.0f, 150.0f, 20.0f) withFont:font
			lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
	}
}

- (void)reloadData {
	markerLineView = [[UIView alloc] initWithFrame:CGRectMake(60, 30, 1, self.frame.size.height-30)];
    markerLineView.backgroundColor = [UIColor blackColor];
    markerLineView.alpha = 0.0;
    [self addSubview:markerLineView];
    
    curValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 5, self.frame.size.width-300, 20)];
    curValueLabel.alpha = 0.0;
    curValueLabel.textAlignment = UITextAlignmentCenter;
    //curValueLabel.backgroundColor = [UIColor blueColor];
    [self addSubview:curValueLabel];
    
	[self setNeedsDisplay];
}

#pragma mark PrivateMethods

- (void)initializeComponent {
	
	_drawAxisX = YES;
	_drawAxisY = YES;
	_drawGridX = YES;
	_drawGridY = YES;
	
	self.xValuesColor = [UIColor blackColor];
	self.yValuesColor = [UIColor blackColor] ;
	
	self.gridXColor = [UIColor blackColor];
	self.gridYColor = [UIColor blackColor];
	
	_drawInfo = YES;
	self.infoColor = [UIColor blackColor];
}

-(NSString *)valueStringForPoint:(CGPoint)pt{
	
	NSArray *xValues = [self.dataSource graphViewXValues:self];
	NSArray *yValues = [self.dataSource graphView:self yValuesForPlot:0];
	NSUInteger xValuesCount = xValues.count;
    if (xValuesCount <=0 ) {
        return @"";
    }
	CGFloat offsetX = _drawAxisY ? 60.0f : 10.0f;
	CGFloat stepX = (self.frame.size.width - (offsetX * 2)) / (xValuesCount - 1);
	float index = (pt.x - offsetX) / stepX;
	
	if (index >= xValuesCount) {
		index = xValuesCount - 1;
	}
    
	NSString *valStr = [NSString stringWithFormat:@"时间：%@ 值：%.2f%@",
						[xValues objectAtIndex:index],[[yValues  objectAtIndex:index] floatValue],_info];
	return valStr;
}

- (void)moveMarkerForTouch:(UITouch *)touch
{
	static float origX = 0.0f;
	CGPoint pt = [touch locationInView:self];
    
	if (pt.x < 60 || pt.x > self.bounds.size.width -60) {
		return;
	}
	markerLineView.alpha = 1.0;
	curValueLabel.alpha = 1.0;
	curValueLabel.text = [self valueStringForPoint:pt];
	if (pt.x - origX > 5.0f || origX - pt.x > 5.0f) {
		markerLineView.frame = CGRectMake(pt.x, 30.0f, 1.0f, self.bounds.size.height-60.0f);
	}
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	UITouch *touch = [touches anyObject];
	[self moveMarkerForTouch:touch];
	
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	UITouch *touch = [touches anyObject];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[self moveMarkerForTouch:touch];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[UIView beginAnimations:@"fadeout" context:nil];
	markerLineView.alpha = 0.0;
	curValueLabel.alpha = 0.0;
	[UIView commitAnimations];
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[UIView beginAnimations:@"fadeout" context:nil];
	markerLineView.alpha = 0.0;
	[UIView commitAnimations];
}

@end
