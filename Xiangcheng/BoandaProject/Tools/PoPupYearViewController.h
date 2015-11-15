//
//  PoPupYearViewController.h
//  GuangXiOA
//
//  Created by apple on 13-1-10.
//
//

#import <UIKit/UIKit.h>

@protocol PopupYearDelegate;

@interface PoPupYearViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate> {

}

@property (nonatomic,weak) id<PopupYearDelegate> delegate;
@property (nonatomic,strong) UIPickerView *pickView;
@property (nonatomic,strong) NSMutableArray *yearArray;
@property (nonatomic,strong) NSString *yearString;
@end

@protocol PopupYearDelegate

- (void)PopupYearController:(PoPupYearViewController *)controller Saved:(BOOL)bSaved selectedString:(NSString *)string;

@end
