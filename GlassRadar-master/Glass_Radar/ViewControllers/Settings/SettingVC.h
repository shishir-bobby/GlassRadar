//
//  SettingVC.h
//  Glass_Radar
//
//  Created by Krutik Vora on 1/22/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import  "OHAttributedLabel.h"
@interface SettingVC : UIViewController<UIAlertViewDelegate,OHAttributedLabelDelegate,QLPreviewControllerDelegate,QLPreviewControllerDataSource>
{
    NSMutableArray *objArray;
    int rowsel;

    NSString *version;
    IBOutlet UILabel *lbleVerNo;
    UISwitch *swFlurry;
    UILabel *lblflurrytxt;
    UILabel *lblflurrytxt2;
    UILabel *lblflurrytxt3;
    UILabel *lblflurryH;
    UILabel *lblVerNo;
    
    
    NSString *strDistance;
    
    
}
@property (strong, nonatomic) IBOutlet UITableView *tblSetting;

- (void)OnOffFlurry:(id)sender;
@end
