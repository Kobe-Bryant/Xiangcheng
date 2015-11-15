//
//  BaseViewController.h
//  BoandaProject
//
//  Created by 张仁松 on 13-7-2.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//  所以UIViewController的基类，默认是竖屏的

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "NSURLConnHelperDelegate.h"

@interface BaseViewController : UIViewController<NSURLConnHelperDelegate>

@property (nonatomic,strong) NSURLConnHelper *webHelper;
@property (nonatomic,strong) UISwipeGestureRecognizer *swipe;

-(void) showAlertMessage:(NSString *) msg;
-(void)showText:(NSString *)text;
@end
