//
//  SortViewController.h
//  Glass_Radar
//
//  Created by Mina Shau on 1/29/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate>
{
    
    IBOutlet UITextField *txtKeyword;
    NSMutableArray *arrSortvalue;
    NSMutableArray *arrSortorder;
    IBOutlet UIPickerView *pickerViewsort;

    IBOutlet UIButton *btnApply;
    BOOL isSorting;
    NSString *strSotingString;

    
}
@property (strong, nonatomic) IBOutlet UILabel *lblKeyword;
- (IBAction)btnApplyClicked:(id)sender;
-(void)backClicked:(id)sender;
@end


