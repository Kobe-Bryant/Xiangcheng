//
//  RecordDetailsViewController.h
//  BoandaProject
//
//  Created by BOBO on 13-12-30.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RecordDetailsViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic,copy) NSString *wrymc;
@end
