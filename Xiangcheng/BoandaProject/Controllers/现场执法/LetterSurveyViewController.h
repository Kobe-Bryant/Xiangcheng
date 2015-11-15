//
//  LetterSurveyViewController.h
//  BoandaProject
//
//  Created by PowerData on 14-5-26.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LetterSurveyViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,copy) NSString *wrymc;
@property (nonatomic,copy) NSString *xfbh;
@end
