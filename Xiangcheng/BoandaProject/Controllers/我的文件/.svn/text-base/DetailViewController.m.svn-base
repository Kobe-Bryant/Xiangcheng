//
//  DetailViewController.m
//  GuangXiOA
//
//  Created by apple on 13-1-16.
//
//

#import "DetailViewController.h"
#import "BECheckBox.h"
#import "NSStringUtil.h"
#import "ZipFileBrowserController.h"
#import "ShowLocalFileController.h"
#import "PDFileManager.h"

@interface DetailViewController ()
- (void)initDataDefault;
- (void)loadSubViews;
- (void)addBarItems;
- (void)addEditItem;
- (void)moveButtonClick:(id)sender;
- (void)deleteButtonClick:(id)sender;
- (void)sendButtonClick:(id)sender;
- (void)editButtonClick:(id)sender;
- (void)hideEditedItems;
- (void)showEditedItems;
@end

@implementation DetailViewController

@synthesize mgSplitViewController = _mgSplitViewController,folderViewController = _folderViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fileManager = [[PDFileManager alloc] init];
    [self initDataDefault];
    [self loadSubViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void)initDataDefault
{
    self.resultArray = [[NSMutableArray alloc] init];
    self.resultHeightAry = [[NSMutableArray alloc] init];
    self.checkArray = [[NSMutableArray alloc] init];
    self.boxArray = [[NSMutableArray alloc] init];
    self.edited = NO;
}

- (void)loadSubViews
{
    self.resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 440, 960) style:UITableViewStylePlain];
    [self.view addSubview:self.resultTableView];
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    [self addEditItem];
}

- (void)addEditItem
{
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(editButtonClick:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:editButton,nil];
}

- (void)addBarItems
{
    UIBarButtonItem *moveButton = [[UIBarButtonItem alloc] initWithTitle:@"移动" style:UIBarButtonItemStyleBordered target:self action:@selector(moveButtonClick:)];
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteButtonClick:)];
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleBordered target:self action:@selector(sendButtonClick:)];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(editButtonClick:)];
     self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:editButton,sendButton,deleteButton,moveButton, nil];
}

- (void)moveButtonClick:(id)sender
{
    if (self.resultArray.count <=0)
    {
        return;
    }
    UIBarButtonItem *btn = (UIBarButtonItem *)sender;
    if (self.popVc)
    {
        [self.popVc dismissPopoverAnimated:YES];
    }
    self.moveVc = [[MovePopViewController alloc] init];
    NSMutableArray *folderKeys = [[NSMutableArray alloc] init];
    [folderKeys addObjectsFromArray:[self.fileManager directoryListAtPath:self.fileManager.basePath]];
    self.moveVc.resultArray = folderKeys;
    self.moveVc.delegate = self;
    self.popVc = [[UIPopoverController alloc] initWithContentViewController:_moveVc];
    [self.popVc presentPopoverFromBarButtonItem:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)deleteButtonClick:(id)sender
{
    //删除文件
    for (int i = 0; i < self.boxArray.count; i++)
    {
        BECheckBox *box = [self.boxArray objectAtIndex:i];
        if([box isChecked])
        {
            NSString *path = [self.folderBasePath stringByAppendingPathComponent:[self.resultArray objectAtIndex:i]];
            [self.fileManager removeFileAtPath:path];
        }
    }
    //重新获得文件列表
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObjectsFromArray:[self.fileManager fileListAtPath:self.folderBasePath]];
    self.resultArray = array;
    [self reloadResultHeightAry];
}

- (void)sendButtonClick:(id)sender
{
    if (![MFMailComposeViewController canSendMail])
    {
        NSString *recipients = @"mailto:first@example.com&subject=my email!";
        NSString *body = @"&body=email body!";
        NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
        email = [email stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
    }
    else
    {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        for (int i = 0; i < self.resultArray.count; i++)
        {
            BECheckBox *box = [self.boxArray objectAtIndex:i];
            if([box isChecked])
            {
                NSString *string = [self.resultArray objectAtIndex:i];
                NSString *path = [self.folderBasePath stringByAppendingPathComponent:string];
                NSData *myData = [NSData dataWithContentsOfFile:path];
                NSString *mimeType = @"";
                NSString *pathExt = [string pathExtension];
                if([pathExt compare:@"pdf" options:NSCaseInsensitiveSearch] == NSOrderedSame )
                    mimeType = @"application/pdf";
                else if([pathExt compare:@"doc" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                    mimeType = @"application/msword";
                else if([pathExt compare:@"xls" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                    mimeType = @"application/vnd.ms-excel";
                else
                    mimeType = @"image/png";
                [picker addAttachmentData:myData mimeType:mimeType fileName:string];
                [picker setSubject:string];
            }
        }
        [self presentModalViewController:picker animated:YES];
    }
    
}

- (void)editButtonClick:(id)sender
{
    self.edited = !self.edited;
    if (self.edited)
    {
        [self showEditedItems];
        UIBarButtonItem *editItem = [self.navigationItem.rightBarButtonItems objectAtIndex:0];
        [editItem setTitle:@"完成"];
        [self reloadResultHeightAry];
    }
    else
    {
        [self hideEditedItems];
        UIBarButtonItem *editItem = [self.navigationItem.rightBarButtonItems objectAtIndex:0];
        [editItem setTitle:@"编辑"];
        [self reloadResultHeightAry];
    }
}

- (void)hideEditedItems
{
    self.navigationItem.rightBarButtonItems = nil;
    [self addEditItem];
}

- (void)showEditedItems
{
    self.navigationItem.rightBarButtonItems = nil;
    [self addBarItems];
}

- (void)reloadResultHeightAry
{
    if (self.firstTag == 1)
    {
        if (self.navigationItem.rightBarButtonItems.count > 0)
        {
            [self hideEditedItems];
        }
    }
    self.firstTag ++ ;
    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:6];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
    for (NSString *string in self.resultArray)
    {
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:string byFont:font andWidth:400]+20;
        if(cellHeight < 60) cellHeight = 60.0f;
        [aryTmp addObject:[NSNumber numberWithFloat:cellHeight]];
    }
    self.resultHeightAry = aryTmp;
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:20];
    for (int i = 0; i < self.resultHeightAry.count; i++)
    {
        BECheckBox *box = [[BECheckBox alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [ary addObject:box];
    }
    self.boxArray = ary;
    [self.resultTableView reloadData];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.resultArray.count > 0)
    {
        return [[self.resultHeightAry objectAtIndex:indexPath.row] floatValue];
    }
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
        //设置自适应高度
        cell.textLabel.numberOfLines =0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
    }
    if (self.resultArray.count > 0)
    {
        if (self.edited)
        {
            cell.accessoryView = [self.boxArray objectAtIndex:indexPath.row];
        }
        else
        {
            cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        //NSArray *keys = [[self.resultArray objectAtIndex:indexPath.row] allKeys];
        //NSString *string = [keys objectAtIndex:0];
        cell.textLabel.text = [self.resultArray objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.edited)
    {
        return;
    }
    NSString *string = [self.resultArray objectAtIndex:indexPath.row];
    NSString *path = [self.folderBasePath stringByAppendingPathComponent:string];
    NSString *pathExt = [path pathExtension];
    if([pathExt compare:@"rar" options:NSCaseInsensitiveSearch] ==NSOrderedSame || [pathExt compare:@"zip" options:NSCaseInsensitiveSearch] ==NSOrderedSame)
    {
        ZipFileBrowserController *detailViewController = [[ZipFileBrowserController alloc] initWithStyle:UITableViewStylePlain andZipFile:path];
        [self.mgSplitViewController.navigationController pushViewController:detailViewController animated:YES];
    }
    else
    {
        ShowLocalFileController *detailViewController = [[ShowLocalFileController alloc] initWithNibName:@"ShowLocalFileController" bundle:nil];
        detailViewController.fullPath = path;
        detailViewController.fileName = string;
        [self.mgSplitViewController.navigationController pushViewController:detailViewController animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

#pragma mark - MovePopViewControllerDelegate

- (void)didSelectedRow:(NSInteger)row
{
    if (row == self.row)
    {
        [self.popVc dismissPopoverAnimated:YES];
        return;
    }
    //获取选择的目录的路径
    NSMutableArray *folderKeys = [[NSMutableArray alloc] init];
    [folderKeys addObjectsFromArray:[self.fileManager directoryListAtPath:self.fileManager.basePath]];
    NSString *string = [folderKeys objectAtIndex:row];
    NSString *selectedRowPath = [self.fileManager.basePath stringByAppendingPathComponent:string];
    //移动文件
    for (int i = 0; i < self.boxArray.count; i++)
    {
        BECheckBox *box = [self.boxArray objectAtIndex:i];
        if([box isChecked])
        {
            NSString *fromPath = [self.folderBasePath stringByAppendingPathComponent:[self.resultArray objectAtIndex:i]];
            NSString *toPath = [selectedRowPath stringByAppendingPathComponent:[self.resultArray objectAtIndex:i]];
            [self.fileManager copyItemFromPath:fromPath toPath:toPath];
            [self.fileManager removeFileAtPath:fromPath];
        }
    }
    //刷新数据
    NSArray *array = [self.fileManager fileListAtPath:self.folderBasePath];
    NSMutableArray *array1 = [[NSMutableArray alloc] initWithArray:array];
    self.resultArray = array1;
    [self reloadResultHeightAry];
    [self.popVc dismissPopoverAnimated:YES];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	NSString *message;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			message = @"发送邮件已取消。";
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

@end
