//
//  ZipFileBrowserController.m
//  GuangXiOA
//
//  Created by zhang on 12-9-20.
//
//

#import "ZipFileBrowserController.h"
#import <Unrar4iOS/Unrar4iOS.h>
#import "ZipArchive.h"
#import "ShowLocalFileController.h"


@interface ZipFileBrowserController ()
@property(nonatomic,copy)NSString *filePath;
@property(nonatomic,copy)NSArray *aryFiles;
@property(nonatomic,copy)NSString *tmpUnZipDir;//解压缩后的临时目录
@property(nonatomic,copy)NSString *parentDir;
@end

@implementation ZipFileBrowserController
@synthesize filePath,aryFiles,tmpUnZipDir,parentDir;

-(id)initWithStyle:(UITableViewStyle)style andZipFile:(NSString*)afilePath{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        NSFileManager *manager = [NSFileManager defaultManager];
        NSDictionary *dicAttr = [manager attributesOfItemAtPath:afilePath error:nil];
        NSNumber *numSize = [dicAttr objectForKey:NSFileSize];
        if([numSize integerValue] > 0){
            self.filePath = afilePath;
            
            self.tmpUnZipDir = [NSTemporaryDirectory()  stringByAppendingPathComponent:[afilePath lastPathComponent]];
            
            NSString *pathExt = [filePath pathExtension];
            if([pathExt compare:@"rar" options:NSCaseInsensitiveSearch] ==NSOrderedSame){
                [self decompressRarFile];
            }else if([pathExt compare:@"zip" options:NSCaseInsensitiveSearch] ==NSOrderedSame){
                [self decompressZipFile];
            }
        }
        
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style andParentDir:(NSString*)aParentDir
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.parentDir = aParentDir;
    }
    return self;
}


-(void)reloadFiles{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    
    NSMutableArray *ary = [NSMutableArray arrayWithCapacity:20];
    NSArray *aryTmp = [fm contentsOfDirectoryAtPath:parentDir error:nil];
    [ary addObjectsFromArray:aryTmp];
    [ary removeObject:@".DS_Store"];
    [ary removeObject:@"__MACOSX"];
    self.aryFiles = ary;

}

-(void)decompressZipFile{

    ZipArchive *zipper = [[ZipArchive alloc] init];
    [zipper UnzipOpenFile:filePath];
    [zipper UnzipFileTo:tmpUnZipDir overWrite:YES];
    [zipper UnzipCloseFile];

    self.parentDir = tmpUnZipDir;
}

-(void)decompressRarFile{
    
    Unrar4iOS *unrar = [[Unrar4iOS alloc] init];

    NSFileManager *fm = [NSFileManager defaultManager ];
    BOOL isDir;
    if(![fm fileExistsAtPath:tmpUnZipDir isDirectory:&isDir])
        [fm createDirectoryAtPath:tmpUnZipDir withIntermediateDirectories:NO attributes:nil error:nil];
    
    BOOL ok = [unrar unrarOpenFile:filePath];

	if (ok)
    {
        [unrar unrarFileTo:tmpUnZipDir overWrite:YES];
        [unrar unrarCloseFile];
    }

    self.parentDir = tmpUnZipDir;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadFiles];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [aryFiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        cell.textLabel.numberOfLines = 2;
        
        UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
        bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
        cell.selectedBackgroundView = bgview;

        
    }
    NSString *fileName = [aryFiles objectAtIndex:indexPath.row];
    cell.textLabel.text = fileName;
    NSString *path = [NSString stringWithFormat:@"%@/%@",parentDir,fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err;
    NSDictionary *dicAttr = [fm attributesOfItemAtPath:path error:&err];
    if([[dicAttr objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory]){
        cell.imageView.image = [UIImage imageNamed:@"folder.png"];
    }
    else{
        NSString *pathExt = [fileName pathExtension];
        if([pathExt compare:@"pdf" options:NSCaseInsensitiveSearch] == NSOrderedSame )
            cell.imageView.image = [UIImage imageNamed:@"pdf_file.png"];
        else if([pathExt compare:@"doc" options:NSCaseInsensitiveSearch] == NSOrderedSame)
            cell.imageView.image = [UIImage imageNamed:@"doc_file.png"];
        else if([pathExt compare:@"xls" options:NSCaseInsensitiveSearch] == NSOrderedSame)
            cell.imageView.image = [UIImage imageNamed:@"xls_file.png"];
        else if([pathExt compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame || [pathExt compare:@"rar" options:NSCaseInsensitiveSearch] == NSOrderedSame)
            cell.imageView.image = [UIImage imageNamed:@"rar_file.png"];
        else
            cell.imageView.image = [UIImage imageNamed:@"default_file.png"];
    }
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *fileName = [aryFiles objectAtIndex:indexPath.row];
    NSString *path = [NSString stringWithFormat:@"%@/%@",parentDir,fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err;
    NSDictionary *dicAttr = [fm attributesOfItemAtPath:path error:&err];
    if([[dicAttr objectForKey:NSFileType] isEqualToString:NSFileTypeDirectory]){

        ZipFileBrowserController *detailViewController = [[ZipFileBrowserController alloc] initWithStyle:UITableViewStylePlain andParentDir:path];
        
        [self.navigationController pushViewController:detailViewController animated:YES];

    }
    else{
        ShowLocalFileController *detailViewController = [[ShowLocalFileController alloc] initWithNibName:@"ShowLocalFileController" bundle:nil];
        detailViewController.fullPath = path;
        detailViewController.fileName = fileName;
        detailViewController.bCanSendEmail = NO;
        // ...
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];

    }
    
    
}

@end
