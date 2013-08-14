//
//  AttributeLableCustomCell.m
//  Glass_Radar
//
//  Created by Krutik Vora on 1/22/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "AttributeLableCustomCell.h"

@implementation AttributeLableCustomCell
@synthesize lblTitle;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lblTitle=[[OHAttributedLabel alloc]init];
        [lblTitle setFont:[UIFont boldSystemFontOfSize:20]];
        [lblTitle setTextColor:[UIColor purpleColor]];//[UIColor colorWithRed:87.0f/255.0f green:213.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
        lblTitle.frame=CGRectMake(10, 10, 280, 19);
        lblTitle.backgroundColor=[UIColor clearColor];
        lblTitle.userInteractionEnabled=TRUE;
        lblTitle.opaque=TRUE;
        lblTitle.onlyCatchTouchesOnLinks=YES;
        [self addSubview:lblTitle];
        
        
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
