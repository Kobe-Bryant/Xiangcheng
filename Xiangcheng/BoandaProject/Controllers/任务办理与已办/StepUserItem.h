//
//  StepUserItem.h
//  GuangXiOA
//
//  Created by zhang on 12-9-17.
//
//

#import <Foundation/Foundation.h>

@interface StepUserItem : NSObject
@property(nonatomic,copy) NSString *userId;//拼音名字
@property(nonatomic,copy) NSString *userHanzi; //汉字名字
@property(nonatomic,copy) NSString *stepID;
@property(nonatomic,copy) NSString *processType;
@end
