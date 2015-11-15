//
//  MovePopViewController.h
//  GuangXiOA
//
//  Created by apple on 13-1-17.
//
//

#import <UIKit/UIKit.h>

@protocol MovePopViewControllerDelegate;

@interface MovePopViewController : UITableViewController

@property (nonatomic,strong) NSMutableArray *resultArray;
@property (nonatomic,weak) id<MovePopViewControllerDelegate> delegate;
@end

@protocol MovePopViewControllerDelegate <NSObject>

- (void)didSelectedRow:(NSInteger)row;

@end