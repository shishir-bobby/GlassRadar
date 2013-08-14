//
//  LocationViewController.h
//  Glass_Radar
//
//  Created by Krutik Vora on 1/22/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapKit/MapKit.h"
#import "CoreLocation/CoreLocation.h"
@interface LocationViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    IBOutlet UIImageView *imgBG;
    int rowsel;
    NSMutableArray *arr;
    CLLocationManager *locationManager;
    
    IBOutlet UIButton *btnDefaultDis;
    
    
}
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UILabel *lblLocationText;
@property (strong, nonatomic) IBOutlet UIButton *btnLocationType;
@property (strong, nonatomic) IBOutlet UITextField *txtPostCode;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIPickerView *objPicker;
@property (strong, nonatomic) IBOutlet UIView *viewPicker;
@property (strong, nonatomic) IBOutlet CLGeocoder *geoCoder;


- (IBAction)btnSaveClick:(id)sender;
- (IBAction)btnDoneClick:(id)sender;
- (IBAction)btnUseGPSClick:(id)sender;
- (IBAction)btnCancelClick:(id)sender;
-(void)backClicked:(id)sender;
- (IBAction)btnDefaultDisClick:(id)sender;




@end
