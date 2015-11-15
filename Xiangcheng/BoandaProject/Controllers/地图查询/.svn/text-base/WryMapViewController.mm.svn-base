//
//  WryMapViewController.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WryMapViewController.h"
#import "ServiceUrlString.h"
#import "JSONKit.h"
#import "MapPinButton.h"
#import "WryBMKPointAnnotation.h"
#import "WRYInfoViewController.h"


@interface WryMapViewController ()<UIScrollViewDelegate>
@property(nonatomic,retain)NSMutableArray *aryAnnotations;
@property(nonatomic,assign)NSInteger currentPage;
@end

@implementation WryMapViewController
@synthesize baiduMapView,urlConnHelper,aryWryItems,listTableView;
@synthesize mcField,mcLabel,dzField,dzLabel,searchBtn,roundField,roundLabel,CLController,userCoordinate;
@synthesize bHaveShow,aryAnnotations;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // 要使用百度地图，请先启动BaiduMapManager
       
    }
    return self;
}

-(IBAction)searchWry:(id)sender{
    self.currentPage = 1;
    self.isEnd = NO;
    [self requestData];
}

-(void)requestData{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:10];
    [params setObject:@"QUERY_WRY_LIST" forKey:@"service"];
    [params setObject:[NSString stringWithFormat:@"%d",ONE_PAGE_SIZE] forKey:@"pagesize"];
    [params setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"current"];
    if ([mcField.text length] > 0) {
        [params setObject:mcField.text forKey:@"wrymc"];
    }
    if ([dzField.text length] > 0) {
        [params setObject:dzField.text forKey:@"dwdz"];
    }
    if ([roundField.text length] > 0) {
        CGFloat jd = userCoordinate.longitude;
        CGFloat wd = userCoordinate.latitude;
        if (jd > 0 && wd > 0) {
            [params setObject:roundField.text forKey:@"round"];
            [params setObject:[NSString stringWithFormat:@"%f",jd] forKey: @"jd"];
            [params setObject:[NSString stringWithFormat:@"%f",wd] forKey: @"wd"];
        }
        
    }
    
    //NSString *jsonStr = [params JSONString];
    
    NSString *urlStr = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"^^^^^^^^%@",urlStr);
    
    self.urlConnHelper = [[NSURLConnHelper alloc] initWithUrl:urlStr andParentView:self.view delegate:self];
}
-(void)wryList:(id)sender{
    
    [UIView animateWithDuration:0.2 animations:
     ^{
         if(listTableView.frame.origin.x == 768){
             listTableView.frame = CGRectMake(768-240, 0, 240, 960);
             
             [listTableView reloadData];
         }else {
             listTableView.frame = CGRectMake(768, 0, 240, 960);
         }
         
     }
     ];
}


- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    mcField.hidden = NO;
    mcLabel.hidden = NO;
    dzField.hidden = NO;
    dzLabel.hidden = NO;
    roundField.hidden = NO;
    roundLabel.hidden = NO;        
    searchBtn.hidden = NO;
}


- (void)showSearchBar:(id)sender {
    listTableView.frame = CGRectMake(768, 0, 240, 960);
    
    UIBarButtonItem *aItem = (UIBarButtonItem *)sender; 
    if(bHaveShow)
    {
        [mcField resignFirstResponder];
        [dzField resignFirstResponder];
        [roundField resignFirstResponder];
        
        bHaveShow = NO;
        aItem.title = @"开启查询";
        mcField.hidden = YES;
        mcLabel.hidden = YES;
        dzField.hidden = YES;
        dzLabel.hidden = YES;
        roundField.hidden = YES;
        roundLabel.hidden = YES;        
        searchBtn.hidden = YES;
        
        [UIView beginAnimations:@"kshowSearchBarAnimation" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        baiduMapView.frame = CGRectMake(0, 0, 768, 960);        
        [UIView commitAnimations];
        
    }
    else{
        aItem.title = @"关闭查询";
        bHaveShow = YES;

        [UIView beginAnimations:@"kshowSearchBarAnimation" context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        baiduMapView.frame = CGRectMake(0, 120, 768, 960);
        [UIView commitAnimations];
        
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"污染源地图查询";
    
//    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 768, 500)];
//    [bgView setImage:[UIImage imageNamed:@"mapbg.jpg"]];
//    [self.view insertSubview:bgView atIndex:0];
    //导航栏按钮
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem *item2 = [[UIBarButtonItem  alloc] initWithTitle:@"开启查询" style:UIBarButtonItemStyleBordered  target:self action:@selector(showSearchBar:)];
    
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"污染源列表" style:UIBarButtonItemStyleBordered target:self action:@selector(wryList:)];
    
    
    toolBar.items = [NSArray arrayWithObjects:item3,flexItem,item2,nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolBar];
    

    aryWryItems = [[NSMutableArray alloc]initWithCapacity:0];
    // Do any additional setup after loading the view from its nib.
    // 设置mapView的Delegate
    baiduMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
	baiduMapView.delegate = self;
	[self.view addSubview:baiduMapView];
    
    
    
    [self.view bringSubviewToFront:listTableView];
    listTableView.frame = CGRectMake(768, 0, 240, 960);
    baiduMapView.showsUserLocation = YES;
    
    CLLocationCoordinate2D suzhouCoor;
    suzhouCoor.latitude = 31.37;
    suzhouCoor.longitude = 120.63;
    

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(suzhouCoor, 100000,100000);
   
    [baiduMapView setRegion:region animated:YES];
    baiduMapView.centerCoordinate = suzhouCoor;
    baiduMapView.showsUserLocation = YES;
    //roundField.text = @"1000";
    
    self.currentPage = 1;
    bHaveShow = YES;
    [self showSearchBar:item2];
    self.aryAnnotations = [[NSMutableArray alloc]init];

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_WRY_LIST" forKey:@"service"];
    [params setObject:@"100000" forKey:@"round"];
//    苏州相城区经纬度
    [params setObject:@"120.63" forKey: @"jd"];
    [params setObject:@"31.37" forKey: @"wd"];
    [params setObject:[NSString stringWithFormat:@"%d",ONE_PAGE_SIZE] forKey:@"pagesize"];
    [params setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"current"];
    CLController = [[CoreLocationController alloc] init];

	CLController.delegate = self;
    [CLController.locMgr startUpdatingLocation];
    
    NSString *urlStr = [ServiceUrlString generateUrlByParameters:params];
    NSLog(@"^^^^^^%@",urlStr);
    
    if (urlConnHelper)
        [urlConnHelper cancel];
    
    self.urlConnHelper =[[NSURLConnHelper alloc] initWithUrl:urlStr andParentView:self.view delegate:self];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)locationUpdate:(CLLocation *)location {
	userCoordinate = location.coordinate;
    baiduMapView.centerCoordinate = location.coordinate;
    [CLController.locMgr stopUpdatingLocation];
}


- (void)locationError:(NSError *)error {

}

- (void)viewWillDisappear:(BOOL)animated
{
    if (urlConnHelper)
        [urlConnHelper cancel];
    if (CLController) {
       [CLController.locMgr stopUpdatingLocation];
    }
    [super viewWillDisappear:animated];
}

#pragma mark - URLConnHelper delegate
-(void)processWebData:(NSData*)webData
{
    NSString *resultJSON =[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *ary = [resultJSON componentsSeparatedByString:@"data"];
    NSString *str = [ary objectAtIndex:1];
    resultJSON = [NSString stringWithFormat:@"{\"data\"%@",str];
    NSDictionary *dicData = [resultJSON objectFromJSONString];
    NSArray *dataArray = [dicData objectForKey:@"data"];
    if (self.currentPage == 1) {
        [aryWryItems removeAllObjects];
        [baiduMapView removeAnnotations:aryAnnotations];
        [aryAnnotations removeAllObjects];
    }
    if (dataArray.count < ONE_PAGE_SIZE) {
        self.isEnd = YES;
    }
    if (dataArray && dataArray.count) {
        [aryWryItems addObjectsFromArray:dataArray];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未查到相关污染源" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    for (NSDictionary *dic in dataArray)
    {
        NSString *jdStr = [dic objectForKey:@"JD"];
        NSString *wdStr = [dic objectForKey:@"WD"];
        if ([jdStr length] >0 && [wdStr length] > 0)
        {
            // 添加一个PointAnnotation
            WryBMKPointAnnotation* annotation = [[WryBMKPointAnnotation alloc]init];

            annotation.latitude = [NSNumber numberWithDouble:[wdStr doubleValue]];
            annotation.longitude = [NSNumber numberWithDouble:[jdStr doubleValue]];
            annotation.title = [dic objectForKey:@"WRYMC"] ;
            annotation.infoItem = dic;
           // annotation.subtitle = nil;
            [baiduMapView addAnnotation:annotation];
            [aryAnnotations addObject:annotation];
        }
    }
    [listTableView reloadData];
    
    for (UIView* vi in [self.view subviews])
    {
        if ([vi isKindOfClass:[UITextField class]])
        {
            UITextField* tv = (UITextField*)vi;
            [tv resignFirstResponder];
        }
    }
}

-(void)processError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:@"" 
                          delegate:self 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
    return;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSDictionary *item =  [(MapPinButton*)control infoItem];
    WRYInfoViewController *detail = [[WRYInfoViewController alloc] init];
    detail.wrybh = [item objectForKey:@"WRYBH"];
    detail.wrymc = [item objectForKey:@"WRYMC"];
    detail.infoDic = item;
    [self.navigationController pushViewController:detail animated:YES];
}



// Override
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[WryBMKPointAnnotation class]])
    {
		MKAnnotationView *newAnnotation = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
 
		newAnnotation.draggable = NO;
        
        UIImage *flagImage = [UIImage imageNamed:@"wry_pin.png"];
        
        // size the flag down to the appropriate size
        CGRect resizeRect;
        resizeRect.size = flagImage.size;
        CGSize maxSize = CGRectInset(self.view.bounds,
                                     10.0f,
                                     10.0f).size;
        maxSize.height -= self.navigationController.navigationBar.frame.size.height + 40.0f;
        if (resizeRect.size.width > maxSize.width)
            resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
        if (resizeRect.size.height > maxSize.height)
            resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
        
        resizeRect.origin = CGPointMake(0.0, 0.0);
        UIGraphicsBeginImageContext(resizeRect.size);
        [flagImage drawInRect:resizeRect];
        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        newAnnotation.image = resizedImage;
        newAnnotation.opaque = NO;

        newAnnotation.canShowCallout = YES;
		MapPinButton *btn = [[MapPinButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        btn.infoItem = [(WryBMKPointAnnotation*)annotation infoItem];

        [btn setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
        newAnnotation.rightCalloutAccessoryView = btn;
        
        CLLocationCoordinate2D suCoor;
        suCoor.latitude = [[btn.infoItem objectForKey:@"WD"]doubleValue];
        suCoor.longitude = [[btn.infoItem objectForKey:@"JD"]doubleValue];
        
        baiduMapView.centerCoordinate = suCoor;
        //[CLController.locMgr startUpdatingLocation];

		return newAnnotation;   
	}
	return nil;
}


-(NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"污染源列表(%d)个",[aryWryItems count]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [aryWryItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.numberOfLines =2;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    NSDictionary *dic = [aryWryItems objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"WRYMC"];
    return cell;
}


#pragma mark - Table view delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *item = [aryWryItems objectAtIndex:indexPath.row];


    WRYInfoViewController *detail = [[WRYInfoViewController alloc] init];
    detail.wrymc = [item objectForKey:@"WRYMC"];
    detail.wrybh = [item objectForKey:@"WRYBH"];
    detail.infoDic = item;
    [self.navigationController pushViewController:detail animated:YES];
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

@end
