//
//  AttributeLableCustomCell.h
//  Glass_Radar
//
//  Created by Krutik Vora on 1/22/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"
@interface AttributeLableCustomCell : UITableViewCell<OHAttributedLabelDelegate>
{
    OHAttributedLabel *lblTitle;
}
@property(nonatomic,retain)OHAttributedLabel *lblTitle;

@end
