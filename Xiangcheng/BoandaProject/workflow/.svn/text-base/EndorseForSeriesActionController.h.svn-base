//
//  EndorseForSeriesActionController.h
//  BoandaProject
//
//  Created by Alex Jean on 13-9-16.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "HandleGWProtocol.h"
#import "CommenWordsViewController.h"

@interface EndorseForSeriesActionController : UIViewController <NSURLConnHelperDelegate,WordsDelegate>

@property (nonatomic, copy) NSString *bzbh;
@property (nonatomic, assign) BOOL canSignature;
@property (nonatomic, assign) id<HandleGWDelegate> delegate;

@property (nonatomic, strong) UIPopoverController* wordsPopoverController;
@property (nonatomic, strong) CommenWordsViewController* wordsSelectViewController;
@property (strong, nonatomic) IBOutlet UITextView *opinionView;
@property (strong, nonatomic) IBOutlet UITextView *nextStepTasker;

-(IBAction)endorse:(id)sender;
-(IBAction)btnPersonShortCutPressed:(id)sender;
-(IBAction)btnStepShortCutPressed:(id)sender;

@end
