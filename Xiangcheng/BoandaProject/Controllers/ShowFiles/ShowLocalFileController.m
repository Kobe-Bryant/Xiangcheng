//
//  ShowLocalFileController.m
//  GuangXiOA
//
//  Created by 张 仁松 on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShowLocalFileController.h"


@interface ShowLocalFileController ()

@end

@implementation ShowLocalFileController
@synthesize webView,fileName,fullPath,bCanSendEmail;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        bCanSendEmail = YES;
    }
    return self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // 调用系统配置mail界面, 不传入收件人和抄送人信息
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:"]];
    
}

-(void)SendEmail:(id)sender{
    
    if (![MFMailComposeViewController canSendMail])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还未设置发件人邮箱地址，程序将会跳转到设置邮箱界面" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return ;
        
    }
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    picker.mailComposeDelegate = self;
	
	[picker setSubject:fileName];
	
    [[UINavigationBar appearance] setTitleTextAttributes:
     nil];
    
	// Attach an image to the email

    NSData *myData = [NSData dataWithContentsOfFile:fullPath];
    NSString *mimeType = @"";
    NSString *pathExt = [fileName pathExtension];
    if([pathExt compare:@"pdf" options:NSCaseInsensitiveSearch] == NSOrderedSame )
        mimeType = @"application/pdf";
    else if([pathExt compare:@"doc" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        mimeType = @"application/msword";
    else if([pathExt compare:@"xls" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        mimeType = @"application/vnd.ms-excel";
	else
        mimeType = @"image/png";
	[picker addAttachmentData:myData mimeType:mimeType fileName:fileName];
	// Fill out the email body text
//	NSString *emailBody = @"It is raining in sunny California!";
//	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];

    
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
	NSString *message;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			message = @"发送邮件取消。";
			break;
		case MFMailComposeResultSaved:
			message = @"邮件已保存。";
			break;
		case MFMailComposeResultSent:
			message = @"邮件发送成功。";
			break;
		case MFMailComposeResultFailed:
			message = @"邮件发送失败。";
			break;
		default:
			message = @"邮件未发送。";
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:fullPath];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
/*
    if (bCanSendEmail) {

        
        UIBarButtonItem *aItem = [[UIBarButtonItem alloc] initWithTitle:@"发送邮件" style:UIBarButtonItemStyleDone target:self action:@selector(SendEmail:)];
        self.navigationItem.rightBarButtonItem = aItem;
        
        
    }*/
    

    // Do any additional setup after loading the view from its nib.
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


@end
