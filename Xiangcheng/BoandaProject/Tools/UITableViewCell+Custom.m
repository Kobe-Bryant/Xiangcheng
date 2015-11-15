//
//  NSString+MD5Addition.m
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import "UITableViewCell+Custom.h"
#import <CommonCrypto/CommonDigest.h>

@implementation UITableViewCell(Custom)



+(UITableViewCell*)makeSubCell:(UITableView *)tableView
					 withTitle:(NSString *)aTitle
						 value:(NSString *)aValue
                     andHeight:(CGFloat)theHeight
{
	UILabel* lblTitle = nil;
	UILabel* lblValue = nil;
    NSString *cellIdentifier = [NSString stringWithFormat:@"cellcustom_%.1f",theHeight];
	UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

	
	if (aCell.contentView != nil)
	{
		lblTitle = (UILabel *)[aCell.contentView viewWithTag:1];
		lblValue = (UILabel *)[aCell.contentView viewWithTag:2];
	}
	
	if (lblTitle == nil) {
		CGRect tRect2 = CGRectMake(0, 0, 150, theHeight);
		lblTitle = [[UILabel alloc] initWithFrame:tRect2]; //此处使用id定义任何控件对象
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setTextColor:[UIColor grayColor]];
		lblTitle.font = [UIFont fontWithName:@"Helvetica" size:19.0];
		lblTitle.textAlignment = UITextAlignmentRight;
		lblTitle.tag = 1;
        lblTitle.numberOfLines = 0;
		[aCell.contentView addSubview:lblTitle];

		
		CGRect tRect3 = CGRectMake(160, 0, 560, theHeight);
		lblValue = [[UILabel alloc] initWithFrame:tRect3]; //此处使用id定义任何控件对象
		[lblValue setBackgroundColor:[UIColor clearColor]];
		[lblValue setTextColor:[UIColor blackColor]];
		lblValue.font = [UIFont fontWithName:@"Helvetica" size:19.0];
		lblValue.textAlignment = UITextAlignmentLeft;
		lblValue.tag = 2;	
        lblValue.numberOfLines = 0;
		[aCell.contentView addSubview:lblValue];

	}
	if (aTitle == nil) aTitle = @"";
    if (aValue == nil) aValue = @"";
	if (lblTitle != nil)	[lblTitle setText:[NSString stringWithFormat:@"%@",aTitle]];
	if (lblValue != nil)	[lblValue setText:[NSString stringWithFormat:@"%@",aValue]];
	
    aCell.accessoryType = UITableViewCellAccessoryNone;
	return aCell;
}

+(UITableViewCell*)makeTextViewSubCell:(UITableView *)tableView
					 withTitle:(NSString *)aTitle
						 value:(NSString *)aValue
                     andHeight:(CGFloat)theHeight
{
	UILabel* lblTitle = nil;
	UITextView* txtValue = nil;
    NSString *cellIdentifier = [NSString stringWithFormat:@"cellcustomtext %.2f",theHeight];
	UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
	
	if (aCell.contentView != nil)
	{
		lblTitle = (UILabel *)[aCell.contentView viewWithTag:1];
		txtValue = (UITextView *)[aCell.contentView viewWithTag:2];
	}
	
	if (lblTitle == nil) {
		CGRect tRect2 = CGRectMake(5, 0, 160, theHeight);
		lblTitle = [[UILabel alloc] initWithFrame:tRect2]; //此处使用id定义任何控件对象
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setTextColor:[UIColor grayColor]];
		lblTitle.font = [UIFont fontWithName:@"Helvetica" size:19.0];
		lblTitle.textAlignment = UITextAlignmentRight;
		lblTitle.tag = 1;
        lblTitle.numberOfLines = 0;
		[aCell.contentView addSubview:lblTitle];

		
		CGRect tRect3 = CGRectMake(180, 0, 520, theHeight);
		txtValue = [[UITextView alloc] initWithFrame:tRect3]; //此处使用id定义任何控件对象
		[txtValue setBackgroundColor:[UIColor clearColor]];
		[txtValue setTextColor:[UIColor blackColor]];
		txtValue.font = [UIFont fontWithName:@"Helvetica" size:19.0];
		txtValue.textAlignment = UITextAlignmentLeft;
		txtValue.tag = 2;	
        txtValue.editable = NO;
		[aCell.contentView addSubview:txtValue];

	}
	if (aTitle == nil) aTitle = @"";
    if (aValue == nil) aValue = @"";
	if (lblTitle != nil)	[lblTitle setText:aTitle];
	if (txtValue != nil)	[txtValue setText:aValue];
	
    aCell.accessoryType = UITableViewCellAccessoryNone;
	return aCell;
}


+(UITableViewCell*)makeSubCell:(UITableView *)tableView 
                     withTitle:(NSString *)title
                     SubValue1:(NSString *)value1 
                     SubValue2:(NSString*) value2 
                     SubValue3:(NSString*)value3
                     andHeight:(CGFloat)height

{

    NSString *cellIdentifier = [NSString stringWithFormat:@"makeSubCell %.1f",height];
	UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
	UILabel* lblTitle = nil;
	UITextView* lbl1 = nil;
	UILabel* lbl2 = nil;
    UILabel* lbl3 = nil;
	
	if (aCell.contentView != nil)
	{
		lblTitle = (UILabel *)[aCell.contentView viewWithTag:1];
		lbl1 = (UITextView *)[aCell.contentView viewWithTag:2];
		lbl2 = (UILabel *)[aCell.contentView viewWithTag:3];
        lbl3 = (UILabel *)[aCell.contentView viewWithTag:4];
	}
	
	if (lblTitle == nil) {
		CGRect tRect1 = CGRectMake(5, 0, 300, 23);
		lblTitle = [[UILabel alloc] initWithFrame:tRect1]; //此处使用id定义任何控件对象
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setTextColor:[UIColor blackColor]];
		lblTitle.font = [UIFont fontWithName:@"Helvetica" size:20.0];
		lblTitle.textAlignment = UITextAlignmentLeft;
		lblTitle.numberOfLines = 2;
		lblTitle.tag = 1;
		[aCell.contentView addSubview:lblTitle];

		
		CGRect tRect2 = CGRectMake(10, 25, 700, height-25);
		lbl1 = [[UITextView alloc] initWithFrame:tRect2]; //此处使用id定义任何控件对象
		[lbl1 setBackgroundColor:[UIColor clearColor]];
		[lbl1 setTextColor:[UIColor blackColor]];
		lbl1.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        lbl1.editable = NO;
		lbl1.textAlignment = UITextAlignmentLeft;
		lbl1.tag = 2;
		[aCell.contentView addSubview:lbl1];

		
		
		CGRect tRect3 = CGRectMake(310, 0, 170, 23);
		lbl2 = [[UILabel alloc] initWithFrame:tRect3]; //此处使用id定义任何控件对象
		[lbl2 setBackgroundColor:[UIColor clearColor]];
		[lbl2 setTextColor:[UIColor grayColor]];
		lbl2.font = [UIFont fontWithName:@"Helvetica" size:18.0];
		lbl2.textAlignment = UITextAlignmentLeft;
		lbl2.tag = 3;
		[aCell.contentView addSubview:lbl2];

        
        CGRect tRect4 = CGRectMake(480, 0, 250, 23);
		lbl3 = [[UILabel alloc] initWithFrame:tRect4]; //此处使用id定义任何控件对象
		[lbl3 setBackgroundColor:[UIColor clearColor]];
		[lbl3 setTextColor:[UIColor grayColor]];
		lbl3.font = [UIFont fontWithName:@"Helvetica" size:18.0];
		lbl3.textAlignment = UITextAlignmentLeft;
		lbl3.tag = 4;
		[aCell.contentView addSubview:lbl3];

		
		lblTitle.backgroundColor = [UIColor clearColor];
		lbl1.backgroundColor = [UIColor clearColor];
		lbl2.backgroundColor = [UIColor clearColor];
        lbl3.backgroundColor = [UIColor clearColor];

	}
	
	if (lblTitle != nil)	[lblTitle setText:title];
	if (lbl1 != nil)	   [lbl1 setText: value1];
	if (lbl2 != nil)		[lbl2 setText:value2];
    if (lbl3 != nil)		[lbl3 setText:value3 ];

    return aCell;
}

+(UITableViewCell*)makeSubCell:(UITableView *)tableView
                     withTitle:(NSString *)title
                     SubValue1:(NSString *)value1
                     SubValue2:(NSString*) value2
                     SubValue3:(NSString*)value3
                     SubValue4:(NSString*)value4
                     andHeight:(CGFloat)height

{
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"makeSubCell %.1f",height];
	UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
	UILabel* lblTitle = nil;
	UITextView* lbl1 = nil;
	UILabel* lbl2 = nil;
    UILabel* lbl3 = nil;
    UITextView* lbl4 = nil;
	
	if (aCell.contentView != nil)
	{
		lblTitle = (UILabel *)[aCell.contentView viewWithTag:1];
		lbl1 = (UITextView *)[aCell.contentView viewWithTag:2];
		lbl2 = (UILabel *)[aCell.contentView viewWithTag:3];
        lbl3 = (UILabel *)[aCell.contentView viewWithTag:4];
        lbl4 = (UITextView *)[aCell.contentView viewWithTag:5];
	}
	
	if (lblTitle == nil) {
		CGRect tRect1 = CGRectMake(5, 0, 300, 23);
		lblTitle = [[UILabel alloc] initWithFrame:tRect1]; //此处使用id定义任何控件对象
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setTextColor:[UIColor blackColor]];
		lblTitle.font = [UIFont fontWithName:@"Helvetica" size:20.0];
		lblTitle.textAlignment = UITextAlignmentLeft;
		lblTitle.numberOfLines = 2;
		lblTitle.tag = 1;
		[aCell.contentView addSubview:lblTitle];
        
		
		CGRect tRect2 = CGRectMake(10, 25, 700, height-25);
		lbl1 = [[UITextView alloc] initWithFrame:tRect2]; //此处使用id定义任何控件对象
		[lbl1 setBackgroundColor:[UIColor clearColor]];
		[lbl1 setTextColor:[UIColor blackColor]];
		lbl1.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        lbl1.editable = NO;
		lbl1.textAlignment = UITextAlignmentLeft;
		lbl1.tag = 2;
		[aCell.contentView addSubview:lbl1];
        
		
		
		CGRect tRect3 = CGRectMake(310, 0, 170, 23);
		lbl2 = [[UILabel alloc] initWithFrame:tRect3]; //此处使用id定义任何控件对象
		[lbl2 setBackgroundColor:[UIColor clearColor]];
		[lbl2 setTextColor:[UIColor grayColor]];
		lbl2.font = [UIFont fontWithName:@"Helvetica" size:18.0];
		lbl2.textAlignment = UITextAlignmentLeft;
		lbl2.tag = 3;
		[aCell.contentView addSubview:lbl2];
        
        
        CGRect tRect4 = CGRectMake(480, 0, 250, 23);
		lbl3 = [[UILabel alloc] initWithFrame:tRect4]; //此处使用id定义任何控件对象
		[lbl3 setBackgroundColor:[UIColor clearColor]];
		[lbl3 setTextColor:[UIColor grayColor]];
		lbl3.font = [UIFont fontWithName:@"Helvetica" size:18.0];
		lbl3.textAlignment = UITextAlignmentLeft;
		lbl3.tag = 4;
		[aCell.contentView addSubview:lbl3];
        
        CGRect tRect5 = CGRectMake(10, 58, 700, 50);
		lbl4 = [[UITextView alloc] initWithFrame:tRect5]; //此处使用id定义任何控件对象
		[lbl4 setBackgroundColor:[UIColor clearColor]];
		[lbl4 setTextColor:[UIColor blackColor]];
		lbl4.font = [UIFont fontWithName:@"Helvetica" size:18.0];
		lbl4.textAlignment = UITextAlignmentLeft;
		lbl4.tag = 5;
        lbl4.editable = NO;
		[aCell.contentView addSubview:lbl4];
        
		
		lblTitle.backgroundColor = [UIColor clearColor];
		lbl1.backgroundColor = [UIColor clearColor];
		lbl2.backgroundColor = [UIColor clearColor];
        lbl3.backgroundColor = [UIColor clearColor];
        lbl4.backgroundColor = [UIColor clearColor];
        
	}
	
	if (lblTitle != nil)	[lblTitle setText:title];
	if (lbl1 != nil)	   [lbl1 setText: value1];
	if (lbl2 != nil)		[lbl2 setText:value2];
    if (lbl3 != nil)		[lbl3 setText:value3 ];
    if (lbl4 != nil)		[lbl4 setText:value4 ];
    
    return aCell;
}

//台账列表显示
+(UITableViewCell*)makeSubCell:(UITableView *)tableView
                     withTitle:(NSString *)title
                     SubValue1:(NSString *)value1
                     SubValue2:(NSString *)value2
                     SubValue3:(NSString *)value3
{
    
	UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cellcustom2"];
    if (aCell == nil) {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellcustom2"];
    }
	UILabel* lblTitle = nil;
	UILabel* lbl1 = nil;
	UILabel* lbl2 = nil;
    UILabel* lbl3 = nil;
	
	if (aCell.contentView != nil)
	{
		lblTitle = (UILabel *)[aCell.contentView viewWithTag:1];
		lbl1 = (UILabel *)[aCell.contentView viewWithTag:2];
		lbl2 = (UILabel *)[aCell.contentView viewWithTag:3];
        lbl3 = (UILabel *)[aCell.contentView viewWithTag:4];
	}
	
	if (lblTitle == nil) {
		CGRect tRect1 = CGRectMake(20, 2, 460, 48);
		lblTitle = [[UILabel alloc] initWithFrame:tRect1]; //此处使用id定义任何控件对象
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setTextColor:[UIColor blackColor]];
		lblTitle.font = [UIFont fontWithName:@"Helvetica" size:20.0];
		lblTitle.textAlignment = UITextAlignmentLeft;
        lblTitle.highlightedTextColor = [UIColor whiteColor];
		lblTitle.numberOfLines = 2;
		lblTitle.tag = 1;
		[aCell.contentView addSubview:lblTitle];

		
		CGRect tRect2 = CGRectMake(20, 38, 460, 40);
		lbl1 = [[UILabel alloc] initWithFrame:tRect2]; //此处使用id定义任何控件对象
		[lbl1 setBackgroundColor:[UIColor clearColor]];
		[lbl1 setTextColor:[UIColor grayColor]];
		lbl1.font = [UIFont fontWithName:@"Helvetica" size:17.0];
		lbl1.textAlignment = UITextAlignmentLeft;
        lbl1.numberOfLines = 2;
        lbl1.highlightedTextColor = [UIColor whiteColor];
		lbl1.tag = 2;
		[aCell.contentView addSubview:lbl1];

		
		
		CGRect tRect3 = CGRectMake(430, 8, 300, 40);
		lbl2 = [[UILabel alloc] initWithFrame:tRect3]; //此处使用id定义任何控件对象
		[lbl2 setBackgroundColor:[UIColor clearColor]];
		[lbl2 setTextColor:[UIColor grayColor]];
		lbl2.font = [UIFont fontWithName:@"Helvetica" size:17.0];
		lbl2.textAlignment = UITextAlignmentRight;
        lbl2.highlightedTextColor = [UIColor whiteColor];
		lbl2.tag = 3;
        lbl2.numberOfLines = 2;
		[aCell.contentView addSubview:lbl2];

        
        CGRect tRect4 = CGRectMake(430, 38, 300, 40);
		lbl3 = [[UILabel alloc] initWithFrame:tRect4]; //此处使用id定义任何控件对象
		[lbl3 setBackgroundColor:[UIColor clearColor]];
		[lbl3 setTextColor:[UIColor grayColor]];
		lbl3.font = [UIFont fontWithName:@"Helvetica" size:17.0];
		lbl3.textAlignment = UITextAlignmentRight;
        lbl3.highlightedTextColor = [UIColor whiteColor];
		lbl3.tag = 4;
        lbl3.numberOfLines = 2;
		[aCell.contentView addSubview:lbl3];

        
        
		
		lblTitle.backgroundColor = [UIColor clearColor];
		lbl1.backgroundColor = [UIColor clearColor];
		lbl2.backgroundColor = [UIColor clearColor];
        lbl3.backgroundColor = [UIColor clearColor];
	}
	
	if (lblTitle != nil)	[lblTitle setText:title];
	if (lbl1 != nil)        [lbl1 setText:value1];
	if (lbl2 != nil)		[lbl2 setText:value2];
    if (lbl3 != nil)		[lbl3 setText:value3];
    
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return aCell;
}


+(UITableViewCell*)makeWeekCell:(UITableView *)tableView
                      withTexts:(NSArray *)titleAry
                       andImage:(UIImage*)image
                    andPTRYHeight:(CGFloat)nHeight{
    
    UILabel* lblTitle[6] = {nil};

    UIImageView *imgView = nil;
    NSString *cellIdentifier = [NSString stringWithFormat:@"cellcustom_%.1f",nHeight];
	UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
	
	if (aCell.contentView != nil)
	{
        imgView = (UIImageView *)[aCell.contentView viewWithTag:1];
        for (int i =0; i < 6; i++)
            lblTitle[i] = (UILabel *)[aCell.contentView viewWithTag:i+2];

        
	}
	
	if (lblTitle[0] == nil) {
        CGRect tRect1 = CGRectMake(-5, -5, 110, 98);
		imgView = [[UIImageView alloc] initWithFrame:tRect1];
        imgView.tag = 1;
        [aCell.contentView addSubview:imgView];
        
        //cell left 70 width 680 height 180
		CGRect tRect[6]; //动态值 
        
        tRect[0] = CGRectMake(160, 0, 120, 24);        
        tRect[1] = CGRectMake(380, 0, 100, 24); 
        tRect[2] = CGRectMake(160, 26, 510, 24);
        tRect[3] = CGRectMake(160, 52, 510, 48);
        tRect[4] = CGRectMake(160, 102, 510, 48);
        tRect[5] = CGRectMake(160, 150, 510, nHeight);
    
        CGRect staticLabel[6];
        staticLabel[0] = CGRectMake(50, 0, 100, 24);//日期
        staticLabel[1] = CGRectMake(275, 0, 100, 24);//领导
        staticLabel[2] = CGRectMake(50, 26, 100, 24);//时间
        staticLabel[3] = CGRectMake(50, 52, 100, 48);//事件
        staticLabel[4] = CGRectMake(50, 102, 100, 48);//地点
        staticLabel[5] = CGRectMake(50, 150, 100, nHeight);//陪同人员
        
        NSArray *aryStaticTitles = [NSArray arrayWithObjects:@"日期:",@"厅领导:", @"时间:",@"活动内容:",@"地点:",@"陪同人员:",
                                    nil];
        for (int i =0; i < 6; i++) {
            lblTitle[i] = [[UILabel alloc] initWithFrame:tRect[i]]; //此处使用id定义任何控件对象
            [lblTitle[i] setBackgroundColor:[UIColor clearColor]];
            
            lblTitle[i].font = [UIFont fontWithName:@"Helvetica" size:18.0];
            lblTitle[i].textAlignment = UITextAlignmentLeft;
            [lblTitle[i] setTextColor:[UIColor blackColor]];
            if(i == 1)[lblTitle[i] setTextColor:[UIColor blueColor]];
            lblTitle[i].tag = i+2;
            lblTitle[i].numberOfLines =0;
            [aCell.contentView addSubview:lblTitle[i]];

        }
        
        for (int i =0; i < 6; i++) {
            UILabel *labelTmp = [[UILabel alloc] initWithFrame:staticLabel[i]]; //此处使用id定义任何控件对象
            [labelTmp setBackgroundColor:[UIColor clearColor]];
            
            labelTmp.font = [UIFont fontWithName:@"Helvetica" size:19.0];

            labelTmp.textAlignment = UITextAlignmentRight;
            labelTmp.textColor = [UIColor blueColor];
            if(i == 1)[labelTmp setTextColor:[UIColor blackColor]];
            labelTmp.text = [aryStaticTitles objectAtIndex:i];
            [aCell.contentView addSubview:labelTmp];
  
        }
        

	}

    for (int i =0; i < 6; i++){
        [lblTitle[i] setText:@""];

    }
    for (int i =0; i < [titleAry count]; i++){
        [lblTitle[i] setText:[titleAry objectAtIndex:i]];
        
    }
         

	if (imgView !=nil ) 
        [imgView setImage:image];
    aCell.accessoryType = UITableViewCellAccessoryNone;
	return aCell;

    
}

//一行四个label
+ (UITableViewCell*)makeSubCell:(UITableView *)tableView
                     withValue1:(NSString *)aTitle
                         value2:(NSString *)aTitle2
                         value3:(NSString *)aValue
                         value4:(NSString *)aValue2
                         height:(NSInteger)aHeight
{
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cellcustom6"];
    if (aCell == nil) {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellcustom6"];
    }
    
	UILabel* label1 = nil;
    UILabel* label2 = nil;
    UILabel* label3 = nil;
    UILabel* label4 = nil;
    
	if (aCell.contentView != nil)
	{
        label1 = (UILabel *)[aCell.contentView viewWithTag:1];
        label2 = (UILabel *)[aCell.contentView viewWithTag:2];
        label3 = (UILabel *)[aCell.contentView viewWithTag:3];
        label4 = (UILabel *)[aCell.contentView viewWithTag:4];
    }
	
	if (label1 == nil) {
		CGRect tRect = CGRectMake(0, 0, 150, aHeight);
        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:4];
        for(int i=0;i<4;i++){
            UILabel *tLabel = [[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
            [tLabel setBackgroundColor:[UIColor clearColor]];
            
            tLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
            if(i%2 == 0){
                tRect.origin.x += 158;
                tRect.size.width = 210;
                tLabel.textAlignment = UITextAlignmentRight;
                [tLabel setTextColor:[UIColor darkGrayColor]];
            }                
            else{
                 tRect.size.width = 150;
                tRect.origin.x += 210;
                tLabel.textAlignment = UITextAlignmentLeft;
                [tLabel setTextColor:[UIColor blackColor]];
            }
                
            tLabel.numberOfLines = 3;
            tLabel.tag = i+1;
            [aCell.contentView addSubview:tLabel];

            
            [ary addObject:tLabel];
        }
        label1 = [ary objectAtIndex:0];
        label2 = [ary objectAtIndex:1];
        label3 = [ary objectAtIndex:2];
        label4 = [ary objectAtIndex:3];
        
    }
    
    if (aTitle == nil) aTitle = @"";
    if (aValue == nil) aValue = @"";
    if (aTitle2 == nil) aTitle2 = @"";
    if (aValue2 == nil) aValue2 = @"";
    
    if (label1 != nil)  [label1 setText:[NSString stringWithFormat:@"%@",aTitle]];
    if (label2 != nil)  [label2 setText:[NSString stringWithFormat:@"%@",aValue]];
    if (label3 != nil) [label3 setText:[NSString stringWithFormat:@"%@",aTitle2]];
    if (label4 != nil) [label4 setText:[NSString stringWithFormat:@"%@",aValue2]];
    
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	return aCell;
}



+ (UITableViewCell *)makeSubCell:(UITableView *)tableView
                       withTitle:(NSString *)aTitle
                    andSubvalue1:(NSString *)aCode
                    andSubvalue2:(NSString *)aCDate
                    andSubvalue3:(NSString *)aEDate
                    andSubvalue4:(NSString *)aMode
{
    CGRect tRect1;
    CGRect tRect2;
    CGRect tRect3;
    CGRect tRect4;
    CGRect tRect5;
    NSString *cellIdentifier;
    
    
    tRect1 = CGRectMake(50, 3, 400, 45);
    tRect2 = CGRectMake(50, 48, 400, 24);
    tRect3 = CGRectMake(460, 48, 270, 24);
    tRect4 = CGRectMake(460, 25, 270, 22);
    tRect5 = CGRectMake(460, 2, 270, 22);
    cellIdentifier = @"cell_standingBook";
    
    
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
	UILabel* lblTitle = nil;
	UILabel* lblCode = nil;
	UILabel* lblCDate = nil;
    UILabel* lblEDate = nil;
    UILabel* lblMode = nil;
	
	if (aCell.contentView != nil)
	{
		lblTitle = (UILabel *)[aCell.contentView viewWithTag:1];
		lblCode = (UILabel *)[aCell.contentView viewWithTag:2];
		lblCDate = (UILabel *)[aCell.contentView viewWithTag:3];
        lblEDate = (UILabel *)[aCell.contentView viewWithTag:4];
        lblMode = (UILabel *)[aCell.contentView viewWithTag:5];
	}
	
    
	if (lblTitle == nil) {
		
		lblTitle = [[UILabel alloc] initWithFrame:tRect1]; //此处使用id定义任何控件对象
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setTextColor:[UIColor blackColor]];
		lblTitle.font = [UIFont fontWithName:@"Helvetica" size:20.0];
		lblTitle.textAlignment = UITextAlignmentLeft;
		lblTitle.numberOfLines = 2;
		lblTitle.tag = 1;
		[aCell.contentView addSubview:lblTitle];
		
		
		lblCode = [[UILabel alloc] initWithFrame:tRect2]; //此处使用id定义任何控件对象
		[lblCode setBackgroundColor:[UIColor clearColor]];
		[lblCode setTextColor:[UIColor grayColor]];
		lblCode.font = [UIFont fontWithName:@"Helvetica" size:16.0];
		lblCode.textAlignment = UITextAlignmentLeft;
		lblCode.tag = 2;
		[aCell.contentView addSubview:lblCode];

		lblCDate = [[UILabel alloc] initWithFrame:tRect3]; //此处使用id定义任何控件对象
		[lblCDate setBackgroundColor:[UIColor clearColor]];
		[lblCDate setTextColor:[UIColor grayColor]];
		lblCDate.font = [UIFont fontWithName:@"Helvetica" size:16.0];
		lblCDate.textAlignment = UITextAlignmentRight;
		lblCDate.tag = 3;
		[aCell.contentView addSubview:lblCDate];
        
        
		lblEDate = [[UILabel alloc] initWithFrame:tRect4]; //此处使用id定义任何控件对象
		[lblEDate setBackgroundColor:[UIColor clearColor]];
		[lblEDate setTextColor:[UIColor grayColor]];
		lblEDate.font = [UIFont fontWithName:@"Helvetica" size:16.0];
		lblEDate.textAlignment = UITextAlignmentRight;
		lblEDate.tag = 4;
		[aCell.contentView addSubview:lblEDate];
        
        
		lblMode = [[UILabel alloc] initWithFrame:tRect5]; //此处使用id定义任何控件对象
		[lblMode setBackgroundColor:[UIColor clearColor]];
		[lblMode setTextColor:[UIColor grayColor]];
		lblMode.font = [UIFont fontWithName:@"Helvetica" size:16.0];
		lblMode.textAlignment = UITextAlignmentRight;
		lblMode.tag = 5;
		[aCell.contentView addSubview:lblMode];

		lblTitle.backgroundColor = [UIColor clearColor];
		lblCode.backgroundColor = [UIColor clearColor];
		lblCDate.backgroundColor = [UIColor clearColor];
        lblEDate.backgroundColor = [UIColor clearColor];
        lblMode.backgroundColor = [UIColor clearColor];
	}
	
	if (lblTitle != nil)	[lblTitle setText:aTitle];
	if (lblCode != nil)     [lblCode setText:aCode];
	if (lblCDate != nil)	[lblCDate setText:aCDate];
    if (lblEDate != nil)	[lblEDate setText:aEDate];
    if (lblMode != nil)     [lblMode setText:aMode];
    
    return aCell;
}

+(UITableViewCell*)makeMultiLabelsCell:(UITableView *)tableView
                             withTexts:(NSArray *)valueAry
                     andTableviewWidth:(CGFloat)tablewidth
                             andHeight:(CGFloat)height
                         andIdentifier:(NSString *)identifier
{
    int labelCount = [valueAry count];
    if (labelCount <= 0 || labelCount > 20) {
        return nil;
    }
    UILabel *lblTitle[20];
    
    UITableViewCell *aCell;

    aCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (aCell == nil) {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
	
	if (aCell.contentView != nil)
	{
        for (int i =0; i < labelCount; i++)
            lblTitle[i] = (UILabel *)[aCell.contentView viewWithTag:i+1];
        
        
	}
	
	if (lblTitle[0] == nil) {
        CGFloat width = tablewidth/labelCount;
        CGRect tRect = CGRectMake(0, 0, 0, height);
        for (int i =0; i < labelCount; i++) {
            
            tRect.size.width = width;
            lblTitle[i] = [[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
            [lblTitle[i] setBackgroundColor:[UIColor clearColor]];
            [lblTitle[i] setTextColor:[UIColor blackColor]];
            lblTitle[i].font = [UIFont systemFontOfSize:20];
            lblTitle[i].textAlignment = UITextAlignmentCenter;
            lblTitle[i].numberOfLines =2;
            lblTitle[i].tag = i+1;
            [aCell.contentView addSubview:lblTitle[i]];
            tRect.origin.x += width;
        }
        
	}
    
    for (int i =0; i < labelCount; i++){
        [lblTitle[i] setText:@""];
        
    }
    for (int i =0; i < labelCount; i++){
        [lblTitle[i] setText:[valueAry objectAtIndex:i]];
        
    }
    
    aCell.accessoryType = UITableViewCellAccessoryNone;
	return aCell;
    
    
}

+ (UITableViewCell *)makeSubCell:(UITableView *)tableView
                       withTitle:(NSString *)aTitle
                    andSubvalue1:(NSString *)aCode
                    andSubvalue2:(NSString *)aCDate
                    andSubvalue3:(NSString *)aEDate
                    andSubvalue4:(NSString *)aMode
                    andNoteCount:(NSInteger)num
{
    CGRect tRect1;
    CGRect tRect2;
    CGRect tRect3;
    CGRect tRect4;
    CGRect tRect5;
    CGRect tRect0;
    NSString *cellIdentifier;
    
    tRect1 = CGRectMake(40, 3, 460, 48);
    tRect2 = CGRectMake(40, 48, 360, 24);
    tRect3 = CGRectMake(400, 48, 300, 24);
    tRect4 = CGRectMake(500, 25, 200, 24);
    tRect5 = CGRectMake(500, 2, 200, 24);
    tRect0 = CGRectMake(0, 3, 40, 72);
    
    cellIdentifier = @"cell_portraitTZList";
    
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
	UILabel* lblTitle = nil;
	UILabel* lblCode = nil;
	UILabel* lblCDate = nil;
    UILabel* lblEDate = nil;
    UILabel* lblMode = nil;
    UILabel* lblNum = nil;
	
	if (aCell.contentView != nil)
	{
		lblTitle = (UILabel *)[aCell.contentView viewWithTag:11];
		lblCode = (UILabel *)[aCell.contentView viewWithTag:12];
		lblCDate = (UILabel *)[aCell.contentView viewWithTag:13];
        lblEDate = (UILabel *)[aCell.contentView viewWithTag:14];
        lblMode = (UILabel *)[aCell.contentView viewWithTag:15];
        lblNum = (UILabel *)[aCell.contentView viewWithTag:16];
	}
	
	if (lblTitle == nil) {
		
		lblTitle = [[UILabel alloc] initWithFrame:tRect1]; //此处使用id定义任何控件对象
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setTextColor:[UIColor blackColor]];
		lblTitle.font = [UIFont fontWithName:@"Helvetica" size:20.0];
		lblTitle.textAlignment = UITextAlignmentLeft;
		lblTitle.numberOfLines = 2;
        lblTitle.highlightedTextColor = [UIColor whiteColor];
		lblTitle.tag = 11;
		[aCell.contentView addSubview:lblTitle];
	
		lblCode = [[UILabel alloc] initWithFrame:tRect2]; //此处使用id定义任何控件对象
		[lblCode setBackgroundColor:[UIColor clearColor]];
		[lblCode setTextColor:[UIColor grayColor]];
        lblCode.highlightedTextColor = [UIColor whiteColor];
		lblCode.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblCode.textAlignment = UITextAlignmentLeft;
		lblCode.tag = 12;
		[aCell.contentView addSubview:lblCode];

		lblCDate = [[UILabel alloc] initWithFrame:tRect3]; //此处使用id定义任何控件对象
		[lblCDate setBackgroundColor:[UIColor clearColor]];
		[lblCDate setTextColor:[UIColor grayColor]];
        lblCDate.highlightedTextColor = [UIColor whiteColor];
		lblCDate.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblCDate.textAlignment = NSTextAlignmentRight;
		lblCDate.tag = 13;
		[aCell.contentView addSubview:lblCDate];

		lblEDate = [[UILabel alloc] initWithFrame:tRect4]; //此处使用id定义任何控件对象
		[lblEDate setBackgroundColor:[UIColor clearColor]];
		[lblEDate setTextColor:[UIColor grayColor]];
        lblEDate.highlightedTextColor = [UIColor whiteColor];
		lblEDate.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblEDate.textAlignment = NSTextAlignmentRight;
		lblEDate.tag = 14;
		[aCell.contentView addSubview:lblEDate];
        
        
		lblMode = [[UILabel alloc] initWithFrame:tRect5]; //此处使用id定义任何控件对象
		[lblMode setBackgroundColor:[UIColor clearColor]];
		[lblMode setTextColor:[UIColor grayColor]];
        lblMode.highlightedTextColor = [UIColor whiteColor];
		lblMode.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblMode.textAlignment = NSTextAlignmentRight;
		lblMode.tag = 15;
		[aCell.contentView addSubview:lblMode];
        
        lblNum = [[UILabel alloc] initWithFrame:tRect0]; //此处使用id定义任何控件对象
		[lblNum setBackgroundColor:[UIColor clearColor]];
		[lblNum setTextColor:[UIColor blackColor]];
        lblNum.highlightedTextColor = [UIColor whiteColor];
		lblNum.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblNum.textAlignment = NSTextAlignmentCenter;
		lblNum.tag = 16;
		[aCell.contentView addSubview:lblNum];
        
		
		lblTitle.backgroundColor = [UIColor clearColor];
		lblCode.backgroundColor = [UIColor clearColor];
		lblCDate.backgroundColor = [UIColor clearColor];
        lblEDate.backgroundColor = [UIColor clearColor];
        lblMode.backgroundColor = [UIColor clearColor];
        lblNum.backgroundColor = [UIColor clearColor];
	}
	
	if (lblTitle != nil)	[lblTitle setText:aTitle];
	if (lblCode != nil)     [lblCode setText:aCode];
	if (lblCDate != nil)	[lblCDate setText:aCDate];
    if (lblEDate != nil)	[lblEDate setText:aEDate];
    if (lblMode != nil)     [lblMode setText:aMode];
    if (lblNum != nil)      [lblNum setText:[NSString stringWithFormat:@"%d",num+1]];
    
    return aCell;
}

@end
