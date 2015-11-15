//
//  LoginViewController.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-1.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "LoginViewController.h"
#import "MainMenuViewController.h"
#import "ServiceUrlString.h"
#import "SystemConfigContext.h"
#import "PDJsonkit.h"

@interface LoginViewController()
@property(nonatomic,strong)UITextField *usrField;
@property(nonatomic,strong)UITextField *pwdField;

@end


@implementation LoginViewController

@synthesize usrField,pwdField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

-(void)addUIViews
{
    UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBg"]];
    [self.view addSubview:bgImgView];
    
    UILabel *usrLabel = [[UILabel alloc] initWithFrame:CGRectMake(246, 443, 92, 37)];
    usrLabel.backgroundColor = [UIColor clearColor];
    usrLabel.textColor = [UIColor blackColor];
    usrLabel.font = [UIFont systemFontOfSize:22.0];
    usrLabel.text = @"用户名：";
    [self.view addSubview:usrLabel];
    
    UILabel *pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(246, 488, 92, 37)];
    pwdLabel.backgroundColor = [UIColor clearColor];
    pwdLabel.textColor = [UIColor blackColor];
    pwdLabel.font = [UIFont systemFontOfSize:22.0];
    pwdLabel.text = @"密   码 ：";
    [self.view addSubview:pwdLabel];
    
    self.usrField = [[UITextField alloc]  initWithFrame:CGRectMake(332, 446, 190, 31)];
    usrField.borderStyle = UITextBorderStyleRoundedRect;
    usrField.autocapitalizationType = UITextAutocapitalizationTypeNone;//设置首字母不自动大写
    usrField.autocorrectionType = UITextAutocorrectionTypeNo;//设置不自动更正
    [self.view addSubview:usrField];
    self.pwdField = [[UITextField alloc] initWithFrame:CGRectMake(332, 492, 190, 31)];
    pwdField.borderStyle = UITextBorderStyleRoundedRect;
    pwdField.secureTextEntry = YES;
    [self.view addSubview:pwdField];
    
    UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnLogin setTitle:@"登    录" forState:UIControlStateNormal];
    btnLogin.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [btnLogin addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    btnLogin.frame = CGRectMake(246, 557, 276, 38);
    //[btnLogin setBackgroundImage:[UIImage imageNamed:@"loginBtn.jpg"] forState:UIControlStateNormal];
    [self.view addSubview:btnLogin];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addUIViews];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *usr = [defaults objectForKey:KUserName];
    NSString * password = [defaults objectForKey:KUserPassword];
	if (usr == nil || password ==nil) {
        usr= @"";
      password = @"";
    }
	usrField.text = usr;
    pwdField.text = password;

}

-(void)login:(id)sender
{
    NSString *msg = @"";
    if ([usrField.text isEqualToString:@""] || usrField.text.length <= 0)
    {
        msg = @"用户名不能为空";
    }
    else if([pwdField.text isEqualToString:@""]  || pwdField.text.length <= 0)
    {
        msg = @"密码不能为空";
    }
    if([msg length] > 0)
    {
        [self showAlertMessage:msg];
		return;
    }
    
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"SYSTEM_USER_LOGIN" forKey:@"service"];
    NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithCapacity:5];
    [dicUser setObject:pwdField.text forKey:@"password"];
    if ([usrField.text rangeOfString:@" "].location == NSNotFound) {
        [dicUser setObject:usrField.text forKey:@"userId"];
    }
    else{
        [self showAlertMessage:@"用户名或密码错误"];
        return;
    }
    [dicUser setObject:usrField.text forKey:@"user_login_id"];
    [[SystemConfigContext sharedInstance] setUser:dicUser];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    NSString *strUrl2 = [NSString stringWithFormat:@"%@&user_login_id=%@",strUrl,usrField.text];
    //NSString *strUrl = @"http://222.92.101.82:8008/xcoa_test/invoke?version=1.0&imei=356242050024965&clientType=IPAD&userid=GF&password=1&P_PAGESIZE=25&service=SYSTEM_USER_LOGIN&user_login_id=GF";
    
    NSLog(@"登录链接为***%@",strUrl2);
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl2 andParentView:self.view delegate:self tipInfo:@"正在登录中..." tagID:2] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)processWebData:(NSData *)webData andTag:(NSInteger)tag
{
        if([webData length] <=0 )
        {
            NSString *msg = @"登录失败";
            [self showAlertMessage:msg];
            return;
        }
        NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
        BOOL bFailed = NO;
        id obj = [resultJSON objectFromJSONString];
        NSString *msg = [obj objectForKey:@"MSG"] ;
        if(msg && [msg length] > 0)
        {
            [self showAlertMessage:msg];
            return;
        }
    
        //NSLog(@"登录返回数据===%@",obj);
        
        if([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dic = [resultJSON objectFromJSONString];
            NSDictionary *userDic = [dic objectForKey:@"user"];
            NSString *usr = [userDic objectForKey:@"YHID"];
            NSString *department = [userDic objectForKey:@"DEPARTMENT"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:usr forKey:KUserName];
            [defaults setObject:department forKey:KUserDepartment];
            
            NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithCapacity:5];
            [dicUser setObject:pwdField.text forKey:@"password"];
            [dicUser setObject:usrField.text forKey:@"userId"];
            [defaults setObject:pwdField.text forKey:KUserPassword];
            [defaults synchronize];

            [[SystemConfigContext sharedInstance] setUser:dicUser];
            
      
            
            //跳转到主菜单界面
            MainMenuViewController *menuController= [[MainMenuViewController alloc] init];
            //menuController.dicBadgeInfo = dicBadgeInfo;
            [self.navigationController pushViewController:menuController animated:YES];
            
        }
        
        else
        {
            
            NSArray *jsonAry = [resultJSON objectFromJSONString];
            if (jsonAry && [jsonAry count] > 0)
            {
                NSDictionary *dicInfo = [jsonAry objectAtIndex:0];
                int status = [[dicInfo objectForKey:@"status"] intValue];
                if (status == 1)
                {
                    NSString *usr = usrField.text;
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:usr forKey:KUserName];
                    [defaults synchronize];
                    if(dicInfo)
                    {
                        NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithCapacity:5];
                        [dicUser setObject:pwdField.text forKey:@"password"];
                        [dicUser setObject:usr forKey:@"userId"];
                        [dicUser setObject:[dicInfo objectForKey:@"uname"] forKey:@"uname"];
                        [dicUser setObject:[dicInfo objectForKey:@"depart"] forKey:@"depart"];
                        [dicUser setObject:[dicInfo objectForKey:@"orgid"] forKey:@"orgid"];
                        [[SystemConfigContext sharedInstance] setUser:dicUser];
                    }
                    
                    //获取待办事项个数
                    NSArray *aryDatas = [dicInfo objectForKey:@"datas"];
                    NSMutableDictionary *dicBadgeInfo = [NSMutableDictionary dictionaryWithCapacity:5];
                    if([aryDatas count] > 0)
                    {
                        for(NSDictionary *dicItem in aryDatas)
                        {
                            NSString *lx = [dicItem objectForKey:@"LX"];
                            NSString *num = [NSString stringWithFormat:@"%@",[dicItem objectForKey:@"NUM"]];
                            if([lx isEqualToString:@"LW"])
                            {
                                [dicBadgeInfo setObject:num forKey:@"来文"];
                            }
                            else if([lx isEqualToString:@"FW"])
                            {
                                [dicBadgeInfo setObject:num forKey:@"发文"];
                            }
                            else if([lx isEqualToString:@"ALL"])
                            {
                                [dicBadgeInfo setObject:num forKey:@"待办任务"];
                            }
                            else if([lx isEqualToString:@"TZGG"])
                            {
                                [dicBadgeInfo setObject:num forKey:@"通知公告"];
                            }
                        }
                    }
                    
                    //跳转到主菜单界面
                    MainMenuViewController *menuController= [[MainMenuViewController alloc] init];
                    menuController.dicBadgeInfo = dicBadgeInfo;
                    [self.navigationController pushViewController:menuController animated:YES];
                    
                }
                else if(status == -1)
                {
                    UILabel *udidLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 600, 468, 120)];
                    udidLabel.backgroundColor = [UIColor clearColor];
                    udidLabel.textColor = [UIColor redColor];
                    udidLabel.font = [UIFont systemFontOfSize:22.0];
                    udidLabel.numberOfLines = 0;
                    udidLabel.text = [NSString stringWithFormat: @"此设备未与所登录的用户绑定。如需绑定，请联系维护人员并提供以下设备号：\n   %@", [[SystemConfigContext sharedInstance] getDeviceID]];
                    [self.view addSubview:udidLabel];
                    
                    return;
                }
                else if(status == 0 )
                {
                    
                    NSString *msg = [dicInfo objectForKey:@"description"];
                    [self showAlertMessage:msg];
                    bFailed = YES;
                }
            }
            else
            {
                bFailed = YES;
            }
            if (bFailed)
            {
                [self showAlertMessage:@"用户名或密码错误"];
                return;
            }
        }

}

-(void)processError:(NSError *)error{
    [self showAlertMessage:@"请求数据失败,请检查网络"];
    return;
}

//-(void)gotoMainMenu{
//    MainMenuViewController *menuController = [[MainMenuViewController alloc] init];
//    [self.navigationController pushViewController:menuController animated:YES];
//}

@end
