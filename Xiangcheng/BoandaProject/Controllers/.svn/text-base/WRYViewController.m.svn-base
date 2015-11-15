//
//  WRYViewController.m
//  BoandaProject
//
//  Created by BOBO on 14-1-3.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "WRYViewController.h"
#import "ServiceUrlString.h"
#import "JSONKit.h"
#import "UITableViewCell+Custom.h"
#import "WRYInfoViewController.h"

@interface WRYViewController ()

@property (nonatomic,strong)IBOutlet UITextField *dwmcFie;
@property (strong, nonatomic) IBOutlet UITextField *dwdzFie;
@property (nonatomic,strong)IBOutlet UIButton *searchBtn;
@property (nonatomic,strong)IBOutlet UITableView *listTableView;
@property (nonatomic,copy) NSString *pageCount;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) BOOL isEnd;

@property (nonatomic,strong)NSMutableArray *valueAry;
- (IBAction)searchBtnPressed:(id)sender;
@end

@implementation WRYViewController

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
    self.title = @"污染源查询";
    [self.view addGestureRecognizer:self.swipe];
//    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
//    bgImage.image = [UIImage imageNamed:@"wrybg.jpg"];
//    [self.view insertSubview:bgImage atIndex:0];
//    
//    self.listTableView.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
    self.valueAry = [[NSMutableArray alloc]init];
    self.currentPage = 1;
    
    [self requestData];
    
}
-(void)requestData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"QUERY_WRY_LIST" forKey:@"service"];
    [params setObject:self.dwmcFie.text forKey:@"wrymc"];
    [params setObject:self.dwdzFie.text forKey:@"wrydz"];
    [params setObject:[NSString stringWithFormat:@"%d",ONE_PAGE_SIZE] forKey:@"pagesize"];
    [params setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"current"];

    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"^^^^^%@",strUrl);
    self.pageCount = @"0";
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}
- (IBAction)searchBtnPressed:(id)sender
{
    self.currentPage = 1;
    self.isEnd = NO;
    for (UIView* vi in [self.view subviews])
    {
        if ([vi isKindOfClass:[UITextField class]])
        {
            UITextField* tv = (UITextField*)vi;
            [tv resignFirstResponder];
        }
    }
    if (self.valueAry.count>0)
    {
        [self.valueAry removeAllObjects];
    }
    
    [self requestData];
}

#pragma mark - Network Handler Methods

- (void)processWebData:(NSData *)webData
{
    BOOL bParsedError = NO;
    if(webData.length > 0)
    {
        NSString *jsonStr = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        NSArray *ary = [jsonStr componentsSeparatedByString:@"data"];
        NSString *str = [ary objectAtIndex:1];
        jsonStr = [NSString stringWithFormat:@"{\"data\"%@",str];
        NSDictionary *detailDict = [jsonStr objectFromJSONString];
        NSArray *dataArray = [detailDict objectForKey:@"data"];
        NSString *countStr = [ary objectAtIndex:0];
        NSArray *countAry = [countStr componentsSeparatedByString:@"ZS:"];
        countStr = [countAry objectAtIndex:1];
        self.pageCount = [countStr substringToIndex:countStr.length-2];
        if (self.currentPage == 1) {
            [self.valueAry removeAllObjects];
        }
        if (dataArray.count < ONE_PAGE_SIZE) {
            self.isEnd = YES;
        }
        if (dataArray && dataArray.count)
        {

            [self.valueAry addObjectsFromArray:dataArray];
        }
        else
        {
            bParsedError = YES;
        }
    }
    
    if(bParsedError)
    {
        [self showAlertMessage:@"查询不到数据"];
    }
    [self.listTableView reloadData];
}

- (void)processError:(NSError *)error
{
    [self showAlertMessage:@"获取数据出错!"];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
		if (!self.isEnd) {
            self.currentPage++;
            [self requestData];
        }
        else{
            [self showText:kNETLAST_MESSAGE];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.valueAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSDictionary *tmpDic = [self.valueAry objectAtIndex:indexPath.row];
    //现场检查人  询问人
    NSString *person = [NSString stringWithFormat:@"法人代表：%@",[tmpDic objectForKey:@"FRDB"]];
    
    NSString *dwdz = [tmpDic objectForKey:@"DWDZ"];
    
    cell = [UITableViewCell makeSubCell:tableView withTitle:[tmpDic objectForKey:@"WRYMC"] andSubvalue1:[NSString stringWithFormat:@"单位地址：%@",dwdz] andSubvalue2:person andSubvalue3:@"" andSubvalue4:@"" andNoteCount:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"查询结果%@条",self.pageCount];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDic = [self.valueAry objectAtIndex:indexPath.row];
    WRYInfoViewController *infoVC = [[WRYInfoViewController alloc]init];
    infoVC.wrybh = [tmpDic objectForKey:@"WRYBH"];
    infoVC.wrymc = [tmpDic objectForKey:@"WRYMC"];
    infoVC.infoDic = tmpDic;
    [self.navigationController pushViewController:infoVC animated:YES];

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (void)viewDidUnload {
    [self setDwdzFie:nil];
    [super viewDidUnload];
}
@end
