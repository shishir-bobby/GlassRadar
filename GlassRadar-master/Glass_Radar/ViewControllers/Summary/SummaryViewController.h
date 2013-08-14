//
//  SummaryViewController.h
//  Glass_Radar
//
//  Created by Nirmalsinh Rathod on 1/23/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SummaryViewController : UIViewController
{
    BottomTabBarView *objBottomView;
    IBOutlet UISlider *milesSlider;
    IBOutlet UIImageView *imgViewPlate;
    IBOutlet UILabel *lblPlateNo;
    IBOutlet UIButton *btnLoc;
    IBOutlet UIButton *btnVHigh;
    IBOutlet UIButton *btnAll;
    IBOutlet UIButton *btnHigh;
    IBOutlet UIButton *btnMed;
    
    IBOutlet UIButton *btnVHighSold;
    IBOutlet UIButton *btnAllSold;
    IBOutlet UIButton *btnHighsSold;
    IBOutlet UIButton *btnMedSold;
    IBOutlet UIButton *btnPostcode;
    
    IBOutlet UIView *viewSlider;

    NSString *strPrefPostcode;
    
    IBOutlet UILabel *lblModelDesc;
    NSDictionary *dicVehicleDetail;
    
    IBOutlet UILabel *lblAverageSellingDay;
    
    IBOutlet UILabel *lblTradePrice;
    IBOutlet UILabel *lblSpotPrice;

    IBOutlet UILabel *lblTradePriceDate;
    
    IBOutlet UIButton *btnCounterVHigh;
    IBOutlet UIButton *btnCounterHigh;
    IBOutlet UIButton *btnCounterMedium;
    IBOutlet UIButton *btnCounterAll;
    
    IBOutlet UIButton *btnSoldConterVHigh;
    IBOutlet UIButton *btnSoldConterAll;
    IBOutlet UIButton *btnSoldConterMed;
    IBOutlet UIButton *btnSoldConterHigh;

    IBOutlet UIImageView *imgCalendar;
    
    IBOutlet UILabel *lblSpotPriceColor;
    IBOutlet UIView *viewMain;
    UISwipeGestureRecognizer *swipeGestureLeftObjectViewSummery;
    UISwipeGestureRecognizer *swipeGestureRightObjectViewVRM;
    
    float sliderDBValue;
    
    
    IBOutlet UILabel *lblCounterVHigh;
    IBOutlet UILabel *lblCounterHigh;
    IBOutlet UILabel *lblCounterMed;
    IBOutlet UILabel *lblCounterAll;
    
    
    IBOutlet UILabel *lblSoldCounterVHigh;
    IBOutlet UILabel *lblSoldCounterAll;
    IBOutlet UILabel *lblSoldCounterHigh;
    IBOutlet UILabel *lblSoldCounterMed;
}



@property (strong, nonatomic) IBOutlet UILabel *lblMiles;
@property (strong, nonatomic) IBOutlet UIButton *btnWrongvehicle;

@property (strong, nonatomic) IBOutlet UILabel *lblDistancefrom;
@property (strong, nonatomic) IBOutlet UILabel *btnViewSale;
@property (strong, nonatomic) IBOutlet UILabel *btnViewSold;


- (IBAction)btnLocClicked:(id)sender;
- (IBAction)btnWrongVehicleClicked:(id)sender;
- (IBAction)btnOnSaleClicked:(id)sender;
- (IBAction)btnOnSoldClicked:(id)sender;

-(void)setToogleButton :(id) sender;
-(void)swipeRightSummery_Clicked;
-(void)swipeLeftSummery_Clicked;

- (IBAction)btnOnSaleClickedButton:(id)sender;
- (IBAction)btnOnSoldClickedButton:(id)sender;
- (IBAction)touchUpSlider:(id)sender;


@end
