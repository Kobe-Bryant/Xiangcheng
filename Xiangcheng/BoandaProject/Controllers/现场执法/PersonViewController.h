//
//  PersonViewController.h
//  BoandaProject
//
//  Created by BOBO on 14-1-2.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PopupDateViewController.h"

@interface PersonViewController : BaseViewController<PopupDateDelegate>
- (IBAction)searchBtnPressed:(id)sender;
@end
