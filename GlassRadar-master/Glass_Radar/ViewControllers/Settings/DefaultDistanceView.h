//
//  DefaultDistanceView.h
//  Glass_Radar
//
//  Created by Pankti on 10/05/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultDistanceView : UIViewController
{

    
    IBOutlet UIButton *btnSave;
    NSArray *arrDistance;

    IBOutlet UIPickerView *pickerDistance;
}
- (IBAction)btnSaveClicked:(id)sender;
@end
