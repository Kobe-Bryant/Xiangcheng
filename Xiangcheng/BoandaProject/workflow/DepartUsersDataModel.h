//
//  DepartUsersDataModel.h
//  GuangXiOA
//
//  Created by zhang on 12-11-5.
//
//

#import <Foundation/Foundation.h>


@interface DepartUsersDataModel : NSObject

-(id)initWithTarget:(NSObject*)target andParentView:(UIView*)inView;

-(void)requestDepartUsers;

-(NSInteger)getLevelByDepartID:(NSString*)depID;

-(void)cancelRequest;

@property(nonatomic,retain) NSMutableArray *aryDeparts;
@end
