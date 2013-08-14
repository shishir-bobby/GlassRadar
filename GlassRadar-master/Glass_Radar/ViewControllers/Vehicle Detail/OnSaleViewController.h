//
//  OnSaleViewController.h
//  Glass_Radar
//
//  Created by Nirmalsinh Rathod on 1/23/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServicesjson.h"
#import <CoreLocation/CoreLocation.h>
#import "ServiceCallTemp.h"

@interface OnSaleViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    
    BottomTabBarView *objBottomView;
    IBOutlet UITableView *tblView;
    IBOutlet UITableViewCell *cellList;
    SummaryViewController *objSummaryViewController;
    IBOutlet UIButton *btnAll;
    
    IBOutlet UILabel *lblSortedValue;
    IBOutlet UIImageView *imgBG;
    IBOutlet UIButton *btnVHigh;
    IBOutlet UIButton *btnHigh;
    IBOutlet UIButton *btnMed;
    float tableHeight;
    IBOutlet UISlider *milesSlider;
    IBOutlet UILabel *lblSortorder;
    
    IBOutlet UIButton *btnPostcode;
    WebServicesjson *objWebServicesjson;
    
    NSMutableArray *arrAdvertisements;
    NSMutableDictionary *dicVehicleDetail;
    IBOutlet UILabel *lblAverageDaysToSell;
    
    IBOutlet UIButton *btnCounterVHigh;
    IBOutlet UIButton *btnCounterHigh;
    IBOutlet UIButton *btnCounterMedium;
    IBOutlet UIButton *btnCounterAll;

    IBOutlet UIImageView *imgCalendar;
    
    float initValueOfSlider;
    UISwipeGestureRecognizer *swipeGestureRightObjectViewsold;
    UISwipeGestureRecognizer *swipeGestureLeftObjectViewonsale;
  
    IBOutlet UIView *viewSlider;
    NSDictionary *dicAllVehicleDetail;
    NSMutableDictionary *dicPriceData;
    
    float sliderDBValue;
    
    // Object of bar button
    UIBarButtonItem *btnmenu;
    
    
}
@property (nonatomic,readwrite) VRMStatus status;
@property (strong, nonatomic) IBOutlet UILabel *lblMiles;
@property (strong, nonatomic) IBOutlet UILabel *lblSortedBy;
@property (strong, nonatomic) IBOutlet UILabel *lblDistanefrom;
@property (strong, nonatomic) IBOutlet UIButton *btnLoc;
@property(nonatomic,retain)    IBOutlet UIView *vWsale;

-(void)swipeRight_Clicked;
- (IBAction)btnLocClicked:(id)sender;
-(IBAction)buttonsortClick:(id)sender;
-(void)buttonmenuClick:(id)sender;
- (IBAction)btntooggleClicked:(id)sender;
-(void)buttonPriceClicked:(id)sender;
-(void)swipeLeftonsale_Clicked;
-(void)reloadAllViewWhileServiceComplete; // This is method is comman for reloading view in Summar, Sale and Sold
-(void)UpdateLayout;

@end
