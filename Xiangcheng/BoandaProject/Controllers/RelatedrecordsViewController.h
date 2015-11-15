//
//  RelatedrecordsViewController.h
//  BoandaProject
//
//  Created by BOBO on 14-2-12.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RelatedrecordsViewController : BaseViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (nonatomic,copy) NSString *serviceType;
@property (nonatomic,copy) NSString *xczfbh;
@property (nonatomic,copy) NSString *wrymc;

@end
