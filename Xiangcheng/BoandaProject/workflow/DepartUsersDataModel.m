//
//  AirDataModel.m
//  GuangXiOA
//
//  Created by zhang on 12-11-5.
//
//

#import "DepartUsersDataModel.h"
#import "NSURLConnHelper.h"
#import "PDJsonkit.h"
#import "ServiceUrlString.h"

@interface DepartUsersDataModel()
@property(nonatomic,retain) NSURLConnHelper *webHelper;
@property(nonatomic,retain) UIView *parentView;

@property(nonatomic,retain) NSObject* target;
@property(nonatomic,retain) NSDictionary *dicDepartLevel;
@end

@implementation DepartUsersDataModel
@synthesize webHelper,parentView,aryDeparts,target,dicDepartLevel;

-(id)initWithTarget:(NSObject*)atarget andParentView:(UIView*)inView{
    self = [super init];
    if(self){
        self.parentView = inView;
        self.target = atarget;
    }
    return self;
}


-(void)requestDepartUsers{
    if (self.aryDeparts == nil)
    {
        self.aryDeparts = [[NSMutableArray alloc]init];
    }
    
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"QUERY_ALL_USERS" forKey:@"service"];
    
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    
    
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.parentView delegate:self];
}

-(NSInteger)getLevelByDepartID:(NSString*)depID{
    NSNumber *num = [dicDepartLevel objectForKey:depID];
    if(num)
        return [num intValue]*2;
    return 1;
    
}

-(void)cancelRequest{
    if(webHelper)
        [webHelper cancel];
}

-(void)calcLevels{
    NSMutableDictionary *dicTmp = [NSMutableDictionary dictionaryWithCapacity:5];
    [dicTmp setObject:[NSNumber numberWithInt:1] forKey:@"ROOT"];
    
    NSMutableArray *aryUnCalced = [NSMutableArray arrayWithArray:self.aryDeparts];
    
    while ([aryUnCalced count] > 0) {
        NSArray *aryTmp = [NSArray arrayWithArray:aryUnCalced];
        for(NSDictionary *dic in aryTmp){
            NSString *strParentID = [dic objectForKey:@"parentId"];
            if([strParentID length]>0 ){
                NSNumber *parentNum = [dicTmp objectForKey:strParentID];
                if(parentNum)
                {
                    NSNumber *num = [NSNumber numberWithInt:[parentNum intValue]+1];
                    NSString *strDeptID = [dic objectForKey:@"deptId"];
                    [dicTmp setObject:num forKey:strDeptID];
                    [aryUnCalced removeObject:dic];
                    
                }
            }else{
                 [aryUnCalced removeObject:dic];
            }
        }
    }
    self.dicDepartLevel = dicTmp;
}

-(void)reorderDepartAry{
    NSMutableArray *aryUnOrdered = [NSMutableArray arrayWithArray:aryDeparts];
    NSMutableArray *aryOrdered = [NSMutableArray arrayWithCapacity:30];
    
    int numValue = 1;
    BOOL unfind = YES;
    while (true) {
        
        NSArray *aryTmp = [NSArray arrayWithArray:aryUnOrdered];
        for(NSDictionary *dic in aryTmp){
            NSString *strDeptID = [dic objectForKey:@"deptId"];
            NSString *strParentID = [dic objectForKey:@"parentId"];
            if([strParentID length]<=0)
            {
                [aryOrdered addObject:dic];
                [aryUnOrdered removeObject:dic];
                unfind=NO;
                break;
            }
            
            NSNumber *num = [dicDepartLevel objectForKey:strDeptID];
            if ([num intValue] == numValue) {
                int index = 0;
                BOOL findParent = NO;
                BOOL inserted = NO;
                for(NSDictionary *dicOrderItem in aryOrdered){
                    
                    NSString *strTmpDeptID = [dicOrderItem objectForKey:@"deptId"];
                    if([strTmpDeptID isEqualToString:strParentID]){
                        findParent = YES;
                    }else{
                        if(findParent){
                            [aryOrdered insertObject:dic atIndex:index];
                            [aryUnOrdered removeObject:dic];
                            inserted = YES;
                            break;
                        }
                    }
                    
                    index++;
                }
                if(inserted == NO){
                    [aryOrdered addObject:dic];
                    [aryUnOrdered removeObject:dic];
                }
                
                unfind = NO;
            }
        }
        numValue++;
        if(unfind)
            break;
        unfind=YES;
    }
    self.aryDeparts = aryOrdered;
    NSLog(@"-------%d",self.aryDeparts.count);
    
    for (int i = 0;i<self.aryDeparts.count;i++)
    {
        NSDictionary* dic = [self.aryDeparts objectAtIndex:i];
        NSString *departName = [dic objectForKey:@"deptName"];
        NSLog(@"~~~~%@",departName);
        if ([departName isEqualToString:@"苏州市相城区环保局"]||[departName isEqualToString:@"环评单位"]||[departName isEqualToString:@"环保办"]||[departName isEqualToString:@"其他"]||[departName isEqualToString:@"环科学会"])
        {
            [self.aryDeparts removeObject:dic];i--;
            NSLog(@"-------%d",self.aryDeparts.count);
        }
    }
    
    if ([target  respondsToSelector:@selector(departsDataReceived:)]) {
        [target performSelector:@selector(departsDataReceived:) withObject:self.aryDeparts];
    }

}

-(void)processWebData:(NSData*)webData{
    if([webData length] <=0 ){
        NSString *msg = @"获取数据失败";
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:msg
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    NSDictionary *dicTmp = [resultJSON objectFromJSONString];
    if (dicTmp ) {

        if (self.aryDeparts.count > 0)
        {
            [self.aryDeparts removeAllObjects];
        }
        
        [self.aryDeparts addObjectsFromArray:[dicTmp objectForKey:@"departments"]];
        
        
        

        [self calcLevels];
        [self reorderDepartAry];
        }
}

-(void)processError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"请求数据失败."
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];

    return;
}


@end
