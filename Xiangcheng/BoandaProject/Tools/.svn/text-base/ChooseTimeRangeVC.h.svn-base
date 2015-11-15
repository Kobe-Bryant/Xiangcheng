//
//  ChooseTimeRangeVC.h
//  MonitorPlatform
//
//  Created by 王哲义 on 12-9-27.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChooseTimeRangeDelegate

@optional
-(void)choosedFromTime:(NSString *)fromTime andEndTime:(NSString *)endTime andType:(NSString *)type;

-(void)choosedFromTime:(NSDate *)fromTime andEndTime:(NSDate *)endTime;

@required
-(void)cancelSelectTimeRange;
@end

@interface ChooseTimeRangeVC : UIViewController


@property (nonatomic,assign) id<ChooseTimeRangeDelegate> delegate;

@property (nonatomic,strong)  UIDatePicker *theDP;
@property (nonatomic,strong)  UIDatePicker *theSP;
@property (nonatomic,assign)  UIDatePickerMode datePickerMode;
@property (nonatomic,strong)  NSDate *startDate;
@property (nonatomic,strong)  NSDate *endDate;
@property (nonatomic,strong) UISegmentedControl *segCtrl;
@property (nonatomic,assign) BOOL segCtrlHidden;

- (id)initWithStartDate:(NSDate *)startDate andEndDtate:(NSDate *)endDate andDatePickerMode:(UIDatePickerMode)datePickerMode;

@end
