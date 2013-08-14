//
//  InternationalViewController.h
//  Glass_Radar
//
//  Created by Krutik Vora on 1/22/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"
@interface InternationalViewController : UIViewController<OHAttributedLabelDelegate>
{
    NSMutableArray *objArray;

    IBOutlet UIImageView *imgBG;
    
    NSString *Countrystr;
    NSString *Currstr;
    NSString *Lang;
    NSString *Dist;
}
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UITableView *tblInternational;
- (IBAction)btnSaveClick:(id)sender;
-(void)backClicked:(id)sender;
@end
