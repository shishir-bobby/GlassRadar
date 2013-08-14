//
//  VehicalSearchTreeViewController.h
//  Glass_Radar
//
//  Created by Krutik Vora on 1/21/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    
	DoneYear,
    DonePlate,
    DoneMake,
    DoneModel,
    DoneBodyType,
    DoneRestAPICalls,
    DoneValuation
    
} SearchTreeStatus;


@interface VehicalSearchTreeViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    IBOutlet UIView *viewPicker;
    IBOutlet UIPickerView *pickerView;
    IBOutlet UIButton *btnYear;
    IBOutlet UIButton *btnPlate;
    
    IBOutlet UITextField *txtMileage;
    IBOutlet UIButton *btnAverageMilage;
    
    NSMutableArray *aryPickerData;
    int selectedItemIndex;
    NSString *strSelectedItem;
    
    IBOutlet UILabel *lblPlate;
    IBOutlet UILabel *lblYear;

    NSMutableDictionary *dicSelectedData;
    
    IBOutlet UIBarButtonItem *btnBarNext;
    IBOutlet UIBarButtonItem *btnBarPrev;
    IBOutlet UIView *viewInner;
    
    CGRect CurrentFrame , UpdatedFrame , DefaultFrame;
    
    BOOL isKeyboardVisible;
    
    NSMutableArray *arrYears, *arrPlates, *arrBodyType,*arrListTypeEx;
    NSMutableArray *arrMakeValue , *arrModels;
    
    NSMutableDictionary *dicMakeValue;
    NSMutableDictionary *dicModelValue;
    NSMutableDictionary *dicBodyTypeValue;
    
    WebServicesjson *objWebServicesjson;
    IBOutlet UIButton *btnFind;
    IBOutlet UILabel *lbluseavgMileage;
    
    NSMutableArray *arrDerivativeValue;
    
    NSString *strGYear;
    NSString  *strGPlate;
    NSString *strNationCarCode;
    NSMutableArray *aryData;
    
    NSMutableDictionary *dicWithSelectedCode;
    NSString *strCurrentVehicleCode;
    
    int selectedVehicleRow;
    UIAlertView *alertNoPostcode;
    
    NSMutableDictionary *dicAllVehicleData;
    
    
    /*mina*/
    IBOutlet UILabel *lblEngineSize;
    IBOutlet UILabel *lblmake;
    IBOutlet UILabel *lblBodytype;
    IBOutlet UILabel *lblmodel;
    IBOutlet UILabel *lblderivative;
    IBOutlet UILabel *lblTransmission;
    IBOutlet UILabel *lblFuelType;
    
    IBOutlet UIButton *btnmake;
    IBOutlet UIButton *btnmodel;
    IBOutlet UIButton *btnbodytype;
    IBOutlet UIButton *btnderivative;
    IBOutlet UIButton *btnfueltype;
    IBOutlet UIButton *btntransmission;
    IBOutlet UIButton *btnenginesize;
    
    NSMutableArray *arrVehicleCode;
    
    NSMutableArray *arrFinalResult;
    
    int pickSelectedIndex;
    
    
}

@property (nonatomic , readwrite) NSMutableArray *arrPlates;
@property (nonatomic , retain) NSMutableArray *arrFinalResult;
@property (nonatomic,readwrite) SearchTreeStatus status;
@property (nonatomic , retain) NSString *strSelectedItem;

- (IBAction)btnPrevClick:(id)sender;
- (IBAction)btnModelClicked:(id)sender;
- (IBAction)btnMakeClicked:(id)sender;
- (IBAction)btnTransmissionClicked:(id)sender;
- (IBAction)btnFualTypeClicked:(id)sender;
- (IBAction)btnBodyTypeClicked:(id)sender;
- (IBAction)btnPlateClecked:(id)sender;
- (IBAction)btnDoneClicked:(id)sender;
- (IBAction)btnCancleClicked:(id)sender;

- (IBAction)btnEngineSizeClicked:(id)sender;
- (IBAction)btnDerivativeClicked:(id)sender;
-(IBAction)btnMilageClicked:(id)sender;
-(IBAction)actionFind:(id)sender;
- (IBAction)btnYearClicked:(id)sender;
-(void)backClicked:(id)sender;
-(void)CalculateBodyTypeValue;
-(void)CalculateDerivative;

@end
