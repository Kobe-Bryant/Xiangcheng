//
//  StatisticTableViewCell.m
//  BoandaProject
//
//  Created by BOBO on 14-1-2.
//  Copyright (c) 2014年 szboanda. All rights reserved.
//

#import "StatisticTableViewCell.h"

@implementation StatisticTableViewCell
@synthesize label1,label2,label3,label4,label5;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
