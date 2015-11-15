//
//  ReplyNoticeViewController.h
//  GuangXiOA
//
//  Created by zhang on 12-9-26.
//
//

#import <UIKit/UIKit.h>

@interface ReplyNoticeViewController : UIViewController

@property(nonatomic,strong)IBOutlet UITextView *txtView;
@property(nonatomic,strong)NSString *tzbh;
@property(nonatomic,assign) BOOL showTingData;
-(IBAction)btnPressed:(id)sender;

@end
