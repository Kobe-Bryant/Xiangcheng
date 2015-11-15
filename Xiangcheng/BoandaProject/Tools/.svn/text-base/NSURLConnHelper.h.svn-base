//
//  WebserviceHelper.h
//  tesgt
//
//  Created by  on 12-1-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "NSURLConnHelperDelegate.h"

@interface NSURLConnHelper : NSObject{
    NSInteger tagID;
}

@property(nonatomic,strong)NSMutableData *webData;
@property(nonatomic,weak) id<NSURLConnHelperDelegate> delegate;

@property(nonatomic,strong)MBProgressHUD *HUD;
@property(nonatomic,strong)NSURLConnection *mConnection;

-(void)cancel;

- (NSURLConnHelper*)initWithUrl:(NSString *)aUrl
                  andParentView:(UIView*)aView //aView==nil表示不显示等待画面
                       delegate:(id)aDelegate;

- (NSURLConnHelper*)initWithUrl:(NSString *)aUrl
                   andParentView:(UIView*)aView //aView==nil表示不显示等待画面
                        delegate:(id)aDelegate
                          tagID:(NSInteger)tag;//用来区分不同的服务请求,赋值要大于0

- (NSURLConnHelper*)initWithUrl:(NSString *)aUrl
                  andParentView:(UIView*)aView //aView==nil表示不显示等待画面
                       delegate:(id)aDelegate
                        tipInfo:(NSString*)tip //hud上显示的文字
                          tagID:(NSInteger)tag; //用来区分不同的服务请求,赋值要大于0
@end
