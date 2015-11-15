//
//  PopupDateViewController.h
//  EPad
//
//  Created by chen on 11-4-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopupDateViewController;

@protocol PopupDateDelegate

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date;

@end

@interface PopupDateViewController : UIViewController {

}

@property (nonatomic, weak) id<PopupDateDelegate> delegate;
@property (nonatomic, retain) UIDatePicker *myPicker;
@property (nonatomic) UIDatePickerMode datePickerMode;
@property (nonatomic, retain) NSDate *date;

-(id)initWithPickerMode:(UIDatePickerMode) mode;

@end
