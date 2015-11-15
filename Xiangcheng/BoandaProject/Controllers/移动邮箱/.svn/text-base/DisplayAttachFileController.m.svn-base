//
//  DisplayAttachFileController.m
//  GuangXiOA
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DisplayAttachFileController.h"
#import "FileUtil.h"

@implementation DisplayAttachFileController

@synthesize webView,progress,labelTip, attachURL,attachName,networkQueue,showZipFile;
@synthesize aryFiles,tmpUnZipDir,listTableView;
//@synthesize newPath;
//@synthesize folderViewController = _folderViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil fileURL:(NSString *)fileUrl andFileName:(NSString*)fileName
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self)
    {
        self.attachURL = fileUrl;
        self.attachName = fileName;
        showZipFile = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)downloadFile
{
    NSString * userDocPath=[ NSSearchPathForDirectoriesInDomains ( NSDocumentDirectory , NSUserDomainMask , YES ) objectAtIndex : 0 ];
    NSString *docsDir = [NSString stringWithFormat:@"%@/files/",userDocPath];
    NSFileManager *fm = [NSFileManager defaultManager ];
    BOOL isDir;
    if(![fm fileExistsAtPath:docsDir isDirectory:&isDir])
        [fm createDirectoryAtPath:docsDir withIntermediateDirectories:NO attributes:nil error:nil];
    NSString *path=[docsDir stringByAppendingPathComponent :attachName];
    
    //self.newPath = path;
    if([fm fileExistsAtPath:path])
    {
        [fm removeItemAtPath:path error:nil];
    }
    
  //  NSString *tmpPath = [NSTemporaryDirectory() stringByAppendingPathComponent :attachName];

    //////////////////////////// 任务队列 /////////////////////////////
    if(!networkQueue)
    {
        self.networkQueue = [[ASINetworkQueue alloc] init];
    }

    [networkQueue reset];// 队列清零
    [networkQueue setShowAccurateProgress:YES]; // 进度精确显示
    [networkQueue setDelegate:self ]; // 设置队列的代理对象
    ASIHTTPRequest *request;
    
    ///////////////// request for file1 //////////////////////
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:attachURL]]; // 设置文件 1 的 url
    [request setDownloadProgressDelegate:progress]; // 文件 1 的下载进度条
    [request setDownloadDestinationPath:path];
    // [request setTemporaryFileDownloadPath:tmpPath];
    
    [request setCompletionBlock :^( void ){
        // 使用 complete 块，在下载完时做一些事情
        NSString *pathExt = [path pathExtension];
        if([pathExt compare:@"rar" options:NSCaseInsensitiveSearch] == NSOrderedSame || [pathExt compare:@"zip" options:NSCaseInsensitiveSearch] ==NSOrderedSame)
        {
            /*
            ZipFileBrowserController *detailViewController = [[ZipFileBrowserController alloc] initWithStyle:UITableViewStylePlain andZipFile:path];
            [self.navigationController popViewControllerAnimated:NO];
            [self.navigationController pushViewController:detailViewController animated:NO];
            
             showZipFile = YES;// 从ZipFileBrowserController返回时，直接pop到上一级
            */
            [self handleZipRarFile:path];
            
        }
        else
        {
            self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
            webView.scalesPageToFit = YES;
            [self.view addSubview:webView];
            
            NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
            [webView loadRequest:[NSURLRequest requestWithURL:url]];
        }
    }];
    [request setFailedBlock :^( void ){
        // 使用 failed 块，在下载失败时做一些事情
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
        webView.scalesPageToFit = YES;
        [self.view addSubview:webView];
        [webView loadHTMLString:@"下载文件失败！" baseURL:nil];
    }];
    

    [ networkQueue addOperation :request];
    [ networkQueue go ]; // 队列任务开始
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _didTag = NO;
    
    //添加到某个文件夹
    /*UIBarButtonItem *aItem = [UICustomBarButtonItem woodBarButtonItemWithText:@"添加到"];
    self.navigationItem.rightBarButtonItem = aItem;
    UIButton* rightButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [rightButton addTarget:self action:@selector(addTo:) forControlEvents:UIControlEventTouchUpInside];*/
    
    self.title = attachName;
    if([attachName length])
    {
        [self downloadFile];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   /* if(showZipFile)
    {
        [self.navigationController popViewControllerAnimated:NO];
    }*/
}

-(void)viewWillDisappear:(BOOL)animated
{
    [networkQueue cancelAllOperations];
    /*if (_didTag == NO)
    {
        NSMutableArray *folderKeys = [[NSUserDefaults standardUserDefaults] objectForKey:@"folderKeys"];
        NSMutableArray *folderArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"folderArray"];
        if (folderKeys.count > 0 && folderArray.count > 0)
        {
            for (int i = 0;i<folderKeys.count;i++)
            {
                NSString *string = [folderKeys objectAtIndex:i];
                if ([string isEqualToString:@"默认文件夹"])
                {
                    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:string];
                    NSMutableArray *array1 = [[NSMutableArray alloc] initWithArray:array];
                    [array1 addObject:[NSDictionary dictionaryWithObject:self.newPath forKey:attachName]];
                    NSString *key1 = [folderKeys objectAtIndex:i];
                    [[NSUserDefaults standardUserDefaults] setObject:array1 forKey:key1];
                    [[NSUserDefaults standardUserDefaults] setObject:folderArray forKey:@"folderArray"];
                }
            }
        }
    }*/
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - 文件处理

- (void)addTo:(id)sender
{
    /*UIButton *btn = (UIButton *)sender;
    if (_popVc)
    {
        [_popVc dismissPopoverAnimated:YES];
    }
    
    _moveVc = [[MovePopViewController alloc] init];
    NSMutableArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"folderKeys"];
    _moveVc.resultArray = array;
    _moveVc.delegate = self;
    _popVc = [[UIPopoverController alloc] initWithContentViewController:_moveVc];
    [_popVc presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//    [_popVc presentPopoverFromBarButtonItem:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];*/
}

/*- (void)didSelectedRow:(NSInteger)row
{
    _didTag = YES;
    NSMutableArray *folderKeys = [[NSUserDefaults standardUserDefaults] objectForKey:@"folderKeys"];
    NSMutableArray *folderArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"folderArray"];
    NSString *string = [folderKeys objectAtIndex:row];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:string];
    NSMutableArray *array1 = [[NSMutableArray alloc] initWithArray:array];
    [array1 addObject:[NSDictionary dictionaryWithObject:self.newPath forKey:attachName]];
    NSString *key1 = [folderKeys objectAtIndex:row];
    [[NSUserDefaults standardUserDefaults] setObject:array1 forKey:key1];
    [[NSUserDefaults standardUserDefaults] setObject:folderArray forKey:@"folderArray"];
    [_popVc dismissPopoverAnimated:YES];
}*/

-(void)decompressZipFile:(NSString*)path
{
    /*ZipArchive *zipper = [[ZipArchive alloc] init];
    [zipper UnzipOpenFile:path];
    [zipper UnzipFileTo:tmpUnZipDir overWrite:YES];
    [zipper UnzipCloseFile];*/
}

-(void)decompressRarFile:(NSString*)path
{    
   /* Unrar4iOS *unrar = [[Unrar4iOS alloc] init];
    
    NSFileManager *fm = [NSFileManager defaultManager ];
    BOOL isDir;
    if(![fm fileExistsAtPath:tmpUnZipDir isDirectory:&isDir])
        [fm createDirectoryAtPath:tmpUnZipDir withIntermediateDirectories:NO attributes:nil error:nil];
    
    BOOL ok = [unrar unrarOpenFile:path];
	if (ok)
    {
        [unrar unrarFileTo:tmpUnZipDir overWrite:YES];
        [unrar unrarCloseFile];
    }*/
}

-(void)handleZipRarFile:(NSString*)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDictionary *dicAttr = [manager attributesOfItemAtPath:path error:nil];
    NSNumber *numSize = [dicAttr objectForKey:NSFileSize];
    if([numSize integerValue] > 0)
    {
        self.tmpUnZipDir = [NSTemporaryDirectory()  stringByAppendingPathComponent:[path lastPathComponent]];
        NSString *pathExt = [path pathExtension];
        if([pathExt compare:@"rar" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            //[self decompressRarFile:path];
        }
        else if([pathExt compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            [self decompressZipFile:path];
        }
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:20];
    NSArray *aryTmp = [fm contentsOfDirectoryAtPath:tmpUnZipDir error:nil];
    [ary addObjectsFromArray:aryTmp];
    [ary removeObject:@".DS_Store"];
    [ary removeObject:@"__MACOSX"];
    self.aryFiles = ary;
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 768, 960) style:UITableViewStylePlain];
    listTableView.dataSource = self;
    listTableView.delegate = self;
    [self.view addSubview:listTableView];
    [listTableView reloadData];
}

#pragma mark - UIWebView Delegate Method

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webview didFailLoadWithError:(NSError *)error
{

	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [webView loadHTMLString:@"对不起，您所访问的文件不存在" baseURL:nil];
}

#pragma mark - UITableView Delegate Method

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [aryFiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        cell.textLabel.numberOfLines = 2;
        
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;
    }
    NSString *fileName = [aryFiles objectAtIndex:indexPath.row];
    cell.textLabel.text = fileName;
    NSString *path = [NSString stringWithFormat:@"%@/%@",tmpUnZipDir,fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err;
    NSDictionary *dicAttr = [fm attributesOfItemAtPath:path error:&err];
    if([[dicAttr objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory])
    {
        cell.imageView.image = [UIImage imageNamed:@"folder.png"];
    }
    else
    {
        NSString *pathExt = [fileName pathExtension];
        cell.imageView.image = [FileUtil imageForFileExt:pathExt];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fileName = [aryFiles objectAtIndex:indexPath.row];
    NSString *path = [NSString stringWithFormat:@"%@/%@",tmpUnZipDir,fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err;
    NSDictionary *dicAttr = [fm attributesOfItemAtPath:path error:&err];
    if([[dicAttr objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory])
    {
        ZipFileBrowserController *detailViewController = [[ZipFileBrowserController alloc] initWithStyle:UITableViewStylePlain andParentDir:path];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else
    {
        ShowFileController *detailViewController = [[ShowFileController alloc] initWithNibName:@"ShowFileController" bundle:nil];
        detailViewController.fullPath = path;
        detailViewController.fileName = fileName;
        detailViewController.bCanSendEmail = NO;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
    
}*/


@end
