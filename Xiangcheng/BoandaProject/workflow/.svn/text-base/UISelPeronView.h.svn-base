//
//  UISelPeronView.h
//  TaskTransfer
//
//  Created by zhang on 12-11-23.
//  Copyright (c) 2012年 zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DepartUsersDataModel.h"

#define kPersonType_Master 1
#define kPersonType_Helper 2
#define kPersonType_Reader 3

@protocol UISelPeronViewDelegate 

-(void)returnSelectedPersons:(NSArray*)ary andPersonType:(NSInteger)personType;

@end

@interface UISelPeronView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)id<UISelPeronViewDelegate> delegate;
@property(nonatomic,copy)NSArray *aryWorkflowUsrs;
@property(nonatomic,strong) DepartUsersDataModel *departUserModel;
@property(nonatomic,assign)BOOL multiUsr;//能否多选
@property(nonatomic,assign)NSInteger toSelPersonType;//选择何种类型的数据
-(void)showView:(BOOL)isShow;
@end
