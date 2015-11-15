//
//  MenuControl.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-2.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "MenuControl.h"
#import "CustomBadge.h"

@interface MenuControl()
@property(nonatomic,strong) CustomBadge *badge;
@end

@implementation MenuControl
@synthesize menuInfo,badge;

-(id)initWithFrame:(CGRect)frame andMenuInfo:(NSDictionary*)info{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.menuInfo = info;
        UIButton *btn = [[UIButton alloc] initWithFrame:
                          CGRectMake(5,5,110,110)];
        
		btn.backgroundColor = [UIColor clearColor];
		NSString *imgName = [menuInfo objectForKey:@"MenuIcon"];
		[btn setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:btn];

		UILabel *btnLabel = [[UILabel alloc] initWithFrame:
                             CGRectMake(0,100,120, 45)];
		btnLabel.lineBreakMode = UILineBreakModeCharacterWrap;
		btnLabel.numberOfLines = 2;
		btnLabel.text = [menuInfo objectForKey:@"MenuTitle"];
		btnLabel.textAlignment = UITextAlignmentCenter;
		btnLabel.backgroundColor = [UIColor clearColor];
        btnLabel.contentMode =  UIViewContentModeTop;
		[self addSubview:btnLabel];
        
        self.badge = [CustomBadge customBadgeWithString:@""
                                                 withStringColor:[UIColor whiteColor]
                                                  withInsetColor:[UIColor redColor]
                                                  withBadgeFrame:YES
                                             withBadgeFrameColor:[UIColor whiteColor]
                                                       withScale:1.0
                                                     withShining:YES];
        
        [self.badge setFrame:CGRectMake(frame.size.width-40, -badge.frame.size.height*1/3+5, badge.frame.size.width, badge.frame.size.height)];

        [self addSubview:badge];
        badge.hidden = YES;

    }
    return self;
}

//此处代码让control本身来处理UIControlEventTouchUpInside消息
//如果设置btn.userInteractionEnabled = NO; btn没有点击状态 不好看
-(void)btnPressed:(id)sender{
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)showIconBadge:(NSString *)valueBadge{
    if([valueBadge length] <= 0 || [valueBadge isEqualToString:@"0"])
        badge.hidden = YES;
    else{
        badge.hidden = NO;
        [badge autoBadgeSizeWithString:valueBadge];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
