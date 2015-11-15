//
//  StatisticsViewController.m
//  BoandaProject
//
//  Created by BOBO on 14-1-2.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "StatisticsViewController.h"
#import "ServiceUrlString.h"
#import "JSONKit.h"
#import "StatisticTableViewCell.h"
#import "ChartItem.h"
#import "NTChartView.h"

@interface StatisticsViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)IBOutlet UILabel *qssjLab;
@property (nonatomic,strong)IBOutlet UILabel *jzsjLab;
@property (nonatomic,strong)IBOutlet UITextField *qssjFie;
@property (nonatomic,strong)IBOutlet UITextField *jzsjFie;
@property (nonatomic,strong)IBOutlet UIButton *searchBtn;
@property (nonatomic,strong)IBOutlet UITableView *listTableView;
@property (nonatomic,strong)IBOutlet UIButton *hisgramBtn;
@property (nonatomic,strong)IBOutlet UIView *hisgramView;

@property (nonatomic,strong) PopupDateViewController *dateController;
@property (nonatomic,strong) UIPopoverController *popController;
@property (nonatomic,strong) UIScrollView *scrView;
@property (nonatomic,assign) int currentTag;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign)BOOL isDisplay;//图表是否展示
@property (nonatomic,strong)NSMutableArray *valueAry;
@property (nonatomic,strong)NSArray *listAry;
@property (nonatomic,strong)NSMutableArray *ezdAry;
@property (nonatomic,strong)NSMutableArray *jcddAry;//监察大队
@property (nonatomic,strong)NSMutableArray *yzdAry;
@property (nonatomic,strong)NSMutableArray *qtAry;
@property (nonatomic,strong)NSString *yearStr;
@end

@implementation StatisticsViewController

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
    [self.view addGestureRecognizer:self.swipe];
    // Do any additional setup after loading the view from its nib.
    self.title = @"全局执法统计";
    
    [self initDefaultData];
    [self requestData];
}
#pragma mark - 初始化
- (void)initDefaultData
{
    self.valueAry = [[NSMutableArray alloc]init];
    self.listAry = [[NSArray alloc]initWithObjects:@"现场检查笔录",@"总体状况",@"水污染",@"废气污染",@"危险品及固废",@"噪声污染",@"现场采样记录",@"行政处理通知书",@"行政处罚意见书",@"询问笔录",@"附件管理",@"约见通知单",@"行政建议书",@"行政提示书",@"行政警示书",@"行政纠错书",@"处罚案件回访表",@"行政警示回访表",@"环境监察意见书",@"重点项目行政辅导书",@"挂牌督办",@"环境违法行为立案审批表",@"合计",nil];
    self.jcddAry = [[NSMutableArray alloc]initWithCapacity:0];
    self.yzdAry = [[NSMutableArray alloc]initWithCapacity:0];
    self.ezdAry = [[NSMutableArray alloc]initWithCapacity:0];
    self.qtAry = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self.qssjFie addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    [self.jzsjFie addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    PopupDateViewController *date = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = date;
	self.dateController.delegate = self;
	
	UINavigationController *navDate = [[UINavigationController alloc] initWithRootViewController:self.dateController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navDate];
	self.popController = popover;
    
    NSDate *nowDate = [NSDate date];
    NSDate *beforData = [NSDate dateWithTimeInterval:-60*60*24*30 sinceDate:nowDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.jzsjFie.text = [dateFormatter stringFromDate:nowDate];
    self.qssjFie.text = [dateFormatter stringFromDate:beforData];
    
    [self.hisgramBtn addTarget:self action:@selector(hisgramBtnClick) forControlEvents:UIControlEventTouchUpInside];

}

- (void)requestData
{
    self.isLoading = YES;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"QUERY_XCZFBL_CHART" forKey:@"service"];
    [params setObject:self.qssjFie.text forKey:@"startdate"];
    [params setObject:self.jzsjFie.text forKey:@"enddate"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"^^^^^%@",strUrl);
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    
}


- (void)touchFromDate:(id)sender
{
    UITextField *tfd =(UITextField*)sender;
    self.currentTag = tfd.tag;
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd"];
    if (self.currentTag == 1) {
        NSDate *data = [matter dateFromString:self.qssjFie.text];
        self.dateController.date = data;
    }
    else if (self.currentTag == 2){
        NSDate *data = [matter dateFromString:self.jzsjFie.text];
        self.dateController.date = data;
    }
	[self.popController presentPopoverFromRect:[tfd bounds] inView:tfd permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (IBAction)searchBtnPressed:(id)sender
{

    if (self.valueAry.count>0)
    {
        [self.valueAry removeAllObjects];
    }
    if (self.jcddAry.count>0)
    {
        [self.jcddAry removeAllObjects];
    }
    if (self.yzdAry.count>0)
    {
        [self.yzdAry removeAllObjects];
    }
    if (self.ezdAry.count>0)
    {
        [self.ezdAry removeAllObjects];
    }
    if (self.qtAry.count>0)
    {
        [self.qtAry removeAllObjects];
    }
    

    [self requestData];
    
}


#pragma mark - Network Handler Methods

- (void)processWebData:(NSData *)webData
{
    for (UIView* vi in [self.view subviews])
    {
        if ([vi isKindOfClass:[UITextField class]])
        {
            UITextField* tv = (UITextField*)vi;
            [tv resignFirstResponder];
        }
    }
    
    self.isLoading = NO;
    if(webData.length > 0)
    {
        NSString *jsonStr = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
        
        NSArray *tmpAry = [jsonStr objectFromJSONString];
        if(tmpAry != nil && tmpAry.count)
        {
            
           [self.valueAry addObjectsFromArray:tmpAry];
            for(NSDictionary *dic in self.valueAry)
            {
                NSString *dcbm = [dic objectForKey:@"调查部门"];
                if ([dcbm isEqualToString:@"环境监察大队"])
                {
                    for (int i=0; i<self.listAry.count; i++)
                    {
                        NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:[self.listAry objectAtIndex:i]]];
                        NSLog(@"监察大队%@",str);
                        [self.jcddAry addObject:str];
                    }
                }
                if ([dcbm isEqualToString:@"监察一中队"])
                {
                    for (int i=0; i<self.listAry.count; i++)
                    {
                        NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:[self.listAry objectAtIndex:i]]];
                        NSLog(@"一中队%@",str);
                        [self.yzdAry addObject:str];
                    }
                }
                if ([dcbm isEqualToString:@"监察二中队"])
                {
                    for (int i=0; i<self.listAry.count; i++)
                    {
                        NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:[self.listAry objectAtIndex:i]]];
                        NSLog(@"二中队%@",str);
                        [self.ezdAry addObject:str];
                    }
                }
                if ([dcbm isEqualToString:@"监察三中队"])
                {
                    for (int i=0; i<self.listAry.count; i++)
                    {
                        NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:[self.listAry objectAtIndex:i]]];
                        NSLog(@"监察三中队%@",str);
                        [self.qtAry addObject:str];
                    }
                }
            }
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"查询不到数据"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
    }
    [self.listTableView reloadData];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0 ];
    [self.listTableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionNone];
    self.isDisplay = YES;
    [self openHistogram];
}

- (void)processError:(NSError *)error
{
    self.isLoading = NO;
    [self showAlertMessage:@"获取数据出错"];
}

-(void)hisgramBtnClick
{
    if (self.isDisplay == NO)
    {
        [self openHistogram];
    }
    else
    {
        [self closeHistogram];
    }
    self.isDisplay = !self.isDisplay;
}
-(void)openHistogram
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.hisgramView.frame = CGRectMake(0, 500, 768, 460);
    self.listTableView.frame = CGRectMake(0, 85, 768, 835-420);
    [UIView commitAnimations];
    [self addChartView:self.valueAry];
    
}
-(void)addChartView:(NSArray *)array{
    if (self.scrView) {
        [self.scrView removeFromSuperview];
    }
    self.scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, 768, 420)];
    [self.hisgramView addSubview:self.scrView];
    self.scrView.contentSize = CGSizeMake(768, 460);
    NTChartView *chartView = [[NTChartView alloc] initWithFrame:CGRectMake(0, 0, 768, self.hisgramView.frame.size.height)];
	[self.scrView addSubview:chartView];
    UILabel *unitLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
    unitLab.text = @"单位：1";
    unitLab.backgroundColor = [UIColor clearColor];
    [self.scrView addSubview:unitLab];
    
    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
    
    ChartItem *aItem;
    UIColor *aColor;
    
    float sub = 0;
    NSString *name = nil;
    float value = 0;
    
    if (array.count) {
    
        for (int i=0; i<= [array count]; i++)
        {
            aColor = [[ChartItem makeColorArray]objectAtIndex:i];
            if (i == array.count) {
                name = @"合计";
                value = sub;
            }
            else{
                NSMutableDictionary *itemDic = [array objectAtIndex:i];
                value = [[itemDic objectForKey:@"合计"]floatValue];
                sub += value;
                name = [itemDic objectForKey:@"调查部门"];
            }
            
            if ([name isEqualToString:@"环境监察大队"]||[name isEqualToString:@"监察一中队"]||[name isEqualToString:@"监察二中队"]||[name isEqualToString:@"合计"]||[name isEqualToString:@"监察三中队"])
            {
                aItem = [ChartItem itemWithValue:value Name:name Color:aColor.CGColor];
                [itemArray addObject:aItem];
            }
        
        }
    }
    
    [chartView addGroupArray:itemArray withGroupName:@"group"];
    [chartView setNeedsDisplay];
}

-(void)closeHistogram
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.hisgramView.frame = CGRectMake(0, 400+520, 768, 460);
    self.listTableView.frame = CGRectMake(0, 85, 768, 835);
    [UIView commitAnimations];
}
#pragma mark - Choose Date delegate

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date {
    [self.popController dismissPopoverAnimated:YES];
	if (bSaved) {
        if (self.currentTag == 1)
        {
            NSDateFormatter *matter = [[NSDateFormatter alloc]init];
            [matter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [matter stringFromDate:date];
            NSDate *jzsjDate = [matter dateFromString:self.jzsjFie.text];
            NSTimeInterval qssj = [date timeIntervalSince1970];
            NSTimeInterval jzsj = [jzsjDate timeIntervalSince1970];
            if (jzsj>qssj) {
               self.qssjFie.text = dateString; 
            }
            else{
                [self showAlertMessage:@"起始时间不能晚于截止时间"];
            }
        }
        else if (self.currentTag == 2)
        {
            NSDateFormatter *matter = [[NSDateFormatter alloc]init];
            [matter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [matter stringFromDate:date];
            NSDate *qssjDate = [matter dateFromString:self.qssjFie.text];
            NSTimeInterval jzsj = [date timeIntervalSince1970];
            NSTimeInterval qssj = [qssjDate timeIntervalSince1970];
            if (jzsj>qssj) {
                self.jzsjFie.text = dateString;
            }
            else{
                [self showAlertMessage:@"截止时间不能早于起始时间"];
            }
        }
        
    }
}

#pragma mark - 列表数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.jcddAry.count;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"   调查记录               环境监察大队            监察一中队         监察二中队             监察三中队";
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    StatisticTableViewCell *cell = (StatisticTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell)
    {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"StatisticTableViewCell" owner:nil options:nil];
        for (id obj in arr)
        {
            if ([obj isKindOfClass:[StatisticTableViewCell class]])
            {
                cell = (StatisticTableViewCell *)obj;
                break;
            }
        }
    }
    
    NSString *listName = [self.listAry objectAtIndex:indexPath.row];
    cell.label1.text = listName;
    if(self.jcddAry != nil && self.jcddAry.count > 0)
    {
        cell.label2.text = [NSString stringWithFormat:@"%@", [self.jcddAry objectAtIndex:indexPath.row]];
    }
    else
    {
        cell.label2.text = @"-";
    }
    if(self.yzdAry != nil && self.yzdAry.count > 0)
    {
        cell.label3.text = [NSString stringWithFormat:@"%@",[self.yzdAry objectAtIndex:indexPath.row]];
    }
    else
    {
        cell.label3.text = @"-";
    }
    
    if(self.ezdAry != nil && self.ezdAry.count > 0)
    {
        cell.label4.text = [NSString stringWithFormat:@"%@",[self.ezdAry objectAtIndex:indexPath.row]];
    }
    else
    {
        cell.label4.text = @"-";
    }
    
    if(self.qtAry != nil && self.qtAry.count > 0)
    {
        cell.label5.text = [NSString stringWithFormat:@"%@",[self.qtAry objectAtIndex:indexPath.row]];
    }
    else
    {
        cell.label5.text = @"-";
    }
   
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *arrayData = [[NSMutableArray alloc]init];
    
    for (int i=0; i<4; i++) {
        NSString *velue = nil;
        NSString *name = nil;
        NSMutableArray *array = nil;
        switch (i) {
            case 0:
                array = self.jcddAry;
                name = @"环境监察大队";
                break;
            case 1:
                array = self.yzdAry;
                name = @"监察一中队";
                break;
            case 2:
                array = self.ezdAry;
                name = @"监察二中队";
                break;
            case 3:
                array = self.qtAry;
                name = @"监察三中队";
                break;
        }
        if (array.count) {
            velue = [array objectAtIndex:indexPath.row];
            NSMutableDictionary *dicData = [[NSMutableDictionary alloc]init];
            [dicData setObject:velue forKey:@"合计"];
            [dicData setObject:name forKey:@"调查部门"];
            [arrayData addObject:dicData];
        }
    }
    [self addChartView:arrayData];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
