//
//  UISelectPersonVC.h
//  HNYDZF
//
//  Created by zhang on 12-12-13.
//
//

#import <UIKit/UIKit.h>

#import "DepartUsersDataModel.h"

#define kPersonType_Master 1
#define kPersonType_Helper 2
#define kPersonType_Reader 3

#define kTableData_Depart      1
#define kTableData_DepartUsrs   2
#define kTableData_WorkflowUsrs 3

@protocol UISelPeronViewDelegate

-(void)returnSelectedPersons:(NSArray*)ary andPersonType:(NSInteger)personType;

@end


@interface UISelectPersonVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)id<UISelPeronViewDelegate> delegate;
@property(nonatomic,copy)NSArray *aryWorkflowUsrs;
@property(nonatomic,strong) DepartUsersDataModel *departUserModel;
@property(nonatomic,assign)BOOL multiUsr;//能否多选
@property(nonatomic,assign)NSInteger toSelPersonType;//选择何种类型的数据
@property(nonatomic,retain)IBOutlet UITableView *myTableView;
@property(nonatomic,assign)NSInteger tableDataType;
@end
