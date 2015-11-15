//
//  FolderViewController.m
//  GuangXiOA
//
//  Created by apple on 13-1-16.
//
//

#import "FolderViewController.h"
#import "DetailViewController.h"
#import "PDFileManager.h"

@interface FolderViewController ()

@property (nonatomic, strong) PDFileManager *fileManager;

- (void)initDataDefualt;
- (void)loadSubviews;
- (void)addBackButton;
- (void)backButtonClick:(id)sender;
- (void)addRightButton;
- (void)addBarItems;
- (void)newButtonClick:(id)sender;
- (void)deleteButtonClick:(id)sender;
- (void)moveButtonClick:(id)sender;
- (void)initSuffixArray;
- (void)reloadDefaultRow;

@end

@implementation FolderViewController

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
    
    self.folderKeys = [[NSMutableArray alloc] init];
    self.fileManager = [[PDFileManager alloc] init];
    
    [self initDataDefualt];
    [self initSuffixArray];
    [self loadSubviews];
    [self reloadDefaultRow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void)loadSubviews
{
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 960) style:UITableViewStylePlain];
    [self.view addSubview:self.listTableView];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    
    [self addBackButton];
    [self addBarItems];
}

- (void)initDataDefualt
{
    //默认选中第一个文件夹
    self.didrow = 0;
}

- (void)addBackButton
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClick:)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)addRightButton
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStyleBordered target:self action:@selector(newButtonClick:)];
    self.navigationItem.rightBarButtonItem = backButton;
}

- (void)addBarItems
{
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"删除"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(deleteButtonClick:)];
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"新增"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(newButtonClick:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:newButton,deleteButton, nil];

}

- (void)backButtonClick:(id)sender
{
    UINavigationController *navController = self.detailViewController.mgSplitViewController.navigationController;
	[navController popViewControllerAnimated:YES];
}

- (void)newButtonClick:(id)sender
{
    //新增
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新建文件夹" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

- (void)moveButtonClick:(id)sender
{
    UIBarButtonItem *item = (UIBarButtonItem *)sender;
    [self.listTableView setEditing:!self.listTableView.editing animated:YES];
    if (self.listTableView.editing)
    {
        [item setTitle:@"完成"];
    }
    else
    {
        [item setTitle:@"移动"];
    }
}

- (void)deleteButtonClick:(id)sender
{
    UIBarButtonItem *item = (UIBarButtonItem *)sender;
    [self.listTableView setEditing:!self.listTableView.editing animated:YES];
    if (self.listTableView.editing)
    {
        [item setTitle:@"完成"];
    }
    else
    {
        [item setTitle:@"删除"];
    }
    
    /*if (self.didrow == -1)
    {
        return;
    }
    
    //NSArray *ary = [self.fileManager fileListAtPath:self.fileManager.basePath];
    NSString *dirName = [self.folderKeys objectAtIndex:self.didrow];
    NSString *dirPath = [self.fileManager.basePath stringByAppendingPathComponent:dirName];
    if([dirName isEqualToString:@"默认文件夹"])
    {
        return;
    }
    [self.fileManager removeDirectoryAtPath:dirPath];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObjectsFromArray:[self.fileManager directoryListAtPath:self.fileManager.basePath]];
    self.folderKeys = array;
    [self.listTableView reloadData];
    self.detailViewController.resultArray = nil;
    [self.detailViewController.resultTableView reloadData];*/
   /* //重新设置folderKeys
    NSMutableArray *tmpFolderKeys = [[NSUserDefaults standardUserDefaults] objectForKey:@"folderKeys"];
    NSString *key = [tmpFolderKeys objectAtIndex:self.didrow];
    if ([key isEqualToString:@"默认文件夹"])
    {
        return;
    }
    NSMutableArray * array = [[NSMutableArray alloc] initWithArray:tmpFolderKeys];
    [array removeObject:key];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"folderKeys"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    //reloadTable
    self.folderKeys = [[NSUserDefaults standardUserDefaults] objectForKey:@"folderKeys"];
    [self.listTableView reloadData];
    self.detailViewController.resultArray = nil;
    [self.detailViewController.resultTableView reloadData];*/
    
}

- (void)initSuffixArray
{
    [self.folderKeys removeAllObjects];
    //获取根目录下面的全部文件夹
    [self.folderKeys addObjectsFromArray:[self.fileManager directoryListAtPath:self.fileManager.basePath]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)reloadDefaultRow
{
    //获取默认文件夹下的所有文件
    NSString *selectedPath = [self.fileManager.basePath stringByAppendingPathComponent:[self.folderKeys objectAtIndex:self.didrow]];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObjectsFromArray:[self.fileManager fileListAtPath:selectedPath]];
    //设置详细列表的数据
    self.detailViewController.resultArray = array;
    self.detailViewController.row = 0;
    self.detailViewController.folderBasePath = selectedPath;
    self.detailViewController.edited = NO;
    self.detailViewController.firstTag = 1;
    self.detailViewController.folderKeys = self.folderKeys;
    [self.detailViewController reloadResultHeightAry];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.listTableView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionBottom];
}
#pragma mark - UITableViewDataSource,UITableViewDelegate

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果目录的名字的默认文件夹不允许删除
    NSString *dirName = [self.folderKeys objectAtIndex:indexPath.row];
    if([dirName isEqualToString:@"默认文件夹"])
    {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSString *dirName = [self.folderKeys objectAtIndex:indexPath.row];
        NSString *dirPath = [self.fileManager.basePath stringByAppendingPathComponent:dirName];
        [self.fileManager removeDirectoryAtPath:dirPath];
        if(![dirPath isEqualToString:self.fileManager.defaultFolderPath])
        {
            [self.folderKeys removeObjectAtIndex:indexPath.row];
        }
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.didrow = 0;
        [self reloadDefaultRow];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.folderKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (self.folderKeys.count > 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"wenjj.png"];
        cell.textLabel.text = [self.folderKeys objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.didrow = indexPath.row;
    //获取当前选中的文件的路径
    NSString *key = [self.folderKeys objectAtIndex:indexPath.row];
    NSString *currentSelectedPath = [self.fileManager.basePath stringByAppendingPathComponent:key];
    //获取路径下面的所有文件
    NSArray *subFiles = [self.fileManager fileListAtPath:currentSelectedPath];
    NSMutableArray *resultFileAry = [[NSMutableArray alloc] init];
    [resultFileAry addObjectsFromArray:subFiles];
    
    self.detailViewController.resultArray = resultFileAry;
    self.detailViewController.folderBasePath = currentSelectedPath;
    self.detailViewController.row = indexPath.row;
    self.detailViewController.edited = NO;
    self.detailViewController.firstTag = 1;
    self.detailViewController.folderKeys = self.folderKeys;
    [self.detailViewController reloadResultHeightAry];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
    {
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.row%2 == 0)
    {
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    }
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString *folderName = [[alertView textFieldAtIndex:0] text];
        if(folderName == nil || folderName.length == 0)
        {
            return;
        }
        NSString *folderPath = [self.fileManager.basePath stringByAppendingPathComponent:folderName];
        int ret = [self.fileManager createDirectoryAtPath:folderPath];
        if(ret < 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件夹已存在." delegate:nil cancelButtonTitle:@"" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObjectsFromArray:[self.fileManager directoryListAtPath:self.fileManager.basePath]];
        self.folderKeys = array;
        [self.listTableView reloadData];
    }
}

@end
