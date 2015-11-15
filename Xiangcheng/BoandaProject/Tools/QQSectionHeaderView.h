//
//  QQSectionHeaderView.h
//  TQQTableView
//
//  Created by Futao on 11-6-22.
//  Copyright 2011 ftkey.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define type_oa 1
#define type_xfcf 2

@protocol QQSectionHeaderViewDelegate;

@interface QQSectionHeaderView : UIView {

}
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *disclosureButton;
@property (nonatomic, retain) UIImageView *background;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) BOOL opened;

@property (nonatomic, assign) id <QQSectionHeaderViewDelegate> delegate;
-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber opened:(BOOL)isOpened delegate:(id<QQSectionHeaderViewDelegate>)delegate;

-(void)setBackgroundWithPortrait:(NSString *)pName andLandscape:(NSString *)lName;

-(void)setDisclosureImageWithClosed:(NSString *)cName andOpened:(NSString *)oName;

@end

@protocol QQSectionHeaderViewDelegate <NSObject> 

@optional
-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section;

-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section;
@end
