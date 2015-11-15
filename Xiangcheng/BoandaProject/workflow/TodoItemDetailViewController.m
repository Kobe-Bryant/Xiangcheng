//
//  TodoItemDetailViewController.m
//  TaskTransfer
//
//  Created by zhang on 12-11-14.
//  Copyright (c) 2012年 zhang. All rights reserved.
//

#import "TodoItemDetailViewController.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"

#import "FinishActionController.h"
#import "TransitionActionControllerNew.h"
#import "CounterSignActionController.h"
#import "FeedbackActionController.h"
#import "EndorseActionController.h"
#import "ReturnBackViewController.h"
//#import "ToDoDetailDataModel.h"

@interface TodoItemDetailViewController ()
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,strong)  NSURLConnHelper *baseWebHelper;
@property (nonatomic,strong) NSDictionary *dicActionInfo;

@property(nonatomic,strong) NSArray *aryAttachFiles;//附件
@end

@implementation TodoItemDetailViewController
@synthesize baseWebHelper,isLoading,dicActionInfo,params,webView,typeStr,aryAttachFiles,filesTableView;
@synthesize showAction;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.showAction = YES;
    }
    return self;
}



-(void)detailDataReceived:(NSDictionary*)dicResult{
    NSString *html = [dicResult objectForKey:@"html"];
    NSArray *aryTmp = [dicResult objectForKey:@"attach"];
    if ([aryTmp count] > 0) {
        filesTableView.hidden = NO;
        self.aryAttachFiles = aryTmp;
        [self.filesTableView reloadData];
    }
    else
        filesTableView.hidden = YES;
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
}

-(void)requestActionsData{
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"QUERY_TASK_STATE" forKey:@"service"];
    [dicParams setObject:[params objectForKey:@"BZBH"] forKey:@"BZBH"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    
    isLoading = YES;
    
    self.baseWebHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

-(void)finishAction:(id)sender{
    FinishActionController *controller = [[FinishActionController alloc] initWithNibName:@"FinishActionController" bundle:nil];
     controller.bzbh = [params objectForKey:@"BZBH"];
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [self.navigationController pushViewController:controller animated:YES];

}

-(void)transitionAction:(id)sender{
    TransitionActionControllerNew *controller = [[TransitionActionControllerNew alloc] initWithNibName:@"TransitionActionControllerNew" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [self.navigationController pushViewController:controller animated:YES];

}

-(void)countersignAction:(id)sender{
  /*  CounterSignActionController *controller = [[CounterSignActionController alloc] initWithNibName:@"CounterSignActionController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];*/
}


-(void)sendBackAction:(id)sender{
     ReturnBackViewController *controller = [[ReturnBackViewController alloc] initWithNibName:@"ReturnBackViewController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [self.navigationController pushViewController:controller animated:YES];

}

-(void)feedbackAction:(id)sender{
    FeedbackActionController *controller = [[FeedbackActionController alloc] initWithNibName:@"FeedbackActionController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [self.navigationController pushViewController:controller animated:YES];

}

-(void)endorseAction:(id)sender{
    EndorseActionController *controller = [[EndorseActionController alloc] initWithNibName:@"EndorseActionController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [self.navigationController pushViewController:controller animated:YES];

}


-(void)processWebData:(NSData*)webData{
    isLoading = NO;
    if([webData length] <=0 )
        return;

    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    self.dicActionInfo = [resultJSON objectFromJSONString];
    BOOL resultFailed = NO;
    if (dicActionInfo == nil) {
        
        resultFailed = YES;
    }
    else{
        NSString *tmp = [dicActionInfo objectForKey:@"result"];
        if(![tmp isEqualToString:@"success"])
            resultFailed = YES;
    }
    if(resultFailed){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"获取数据出错。"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];

        return;
    }
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 350, 44)];
    NSMutableArray *aryBarItems = [NSMutableArray arrayWithCapacity:5];
    UIBarButtonItem *flexItem = [[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [aryBarItems addObject:flexItem];
    
    NSString *isFirstStep = [dicActionInfo objectForKey:@"isFirstStep"];
    NSString *canFinish = [dicActionInfo objectForKey:@"canFinish"];
    if([canFinish isEqualToString:@"true"]&& [isFirstStep isEqualToString:@"false"]){
        
        UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"   结  束   " style:UIBarButtonItemStyleBordered target:self action:@selector(finishAction:)];
        [aryBarItems addObject:aBarItem];

    }
    
    NSString *canTransition = [dicActionInfo objectForKey:@"canTransition"];
    if([canTransition isEqualToString:@"true"]){

        UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"手工流转" style:UIBarButtonItemStyleBordered target:self action:@selector(transitionAction:)];
        [aryBarItems addObject:aBarItem];

    }
    
    NSString *canSendback = [dicActionInfo objectForKey:@"canSendback"];
    if([canSendback isEqualToString:@"true"]){
        
        UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"   退  回   " style:UIBarButtonItemStyleBordered target:self action:@selector(sendBackAction:)];
        [aryBarItems addObject:aBarItem];
        
    }
    
    NSString *canCountersign = [dicActionInfo objectForKey:@"canCountersign"];
    if([canCountersign isEqualToString:@"true"]){
/*
        UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"   会  签   " style:UIBarButtonItemStyleBordered target:self action:@selector(countersignAction:)];
        [aryBarItems addObject:aBarItem];*/

    }
    
    NSString *isCanFeedback = [dicActionInfo objectForKey:@"isCanFeedback"];
    if([isCanFeedback isEqualToString:@"true"]){
        UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"   反  馈   " style:UIBarButtonItemStyleBordered target:self action:@selector(feedbackAction:)];
        [aryBarItems addObject:aBarItem];

    }
    
    NSString *isCanEndorse = [dicActionInfo objectForKey:@"isCanEndorse"];
    if([isCanEndorse isEqualToString:@"true"]){
        UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"   加  签   " style:UIBarButtonItemStyleBordered target:self action:@selector(endorseAction:)];
        [aryBarItems addObject:aBarItem];
        
    }
   // [aryBarItems addObject:flexItem];
    toolBar.items = aryBarItems;
    
    //[self.view addSubview:toolBar];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolBar];


}

-(void)processError:(NSError *)error{
    isLoading = NO;
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"请求数据失败."
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];

    return;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    filesTableView.hidden = YES;
    self.title = [params  objectForKey:@"DWMC"];
    if (showAction) {
        [self requestActionsData];
    }
    
    /*
    self.detailDataModel = [[ToDoDetailDataModel
                              alloc] initWithTarget:self andParentView:self.view];
    
    
    [detailDataModel requestDataWithBH:[params objectForKey:@"YWBH"] andTitle:[params  objectForKey:@"DWMC"] andDataType:typeStr];*/
    
}

-(void)viewWillDisappear:(BOOL)animated{
    if (baseWebHelper) {
        [baseWebHelper cancel];
    }
  //  if(detailDataModel)
 //       [detailDataModel cancelRequest];
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"  附件";
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	return [aryAttachFiles count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *WryXmspListCellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WryXmspListCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:WryXmspListCellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.numberOfLines =3;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        cell.detailTextLabel.numberOfLines = 2;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
        
	}
    
    NSDictionary *tmpDic = [aryAttachFiles objectAtIndex:indexPath.row];
    NSString *name = [NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"WDMC"]];
    cell.textLabel.text = name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
    
}


#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
