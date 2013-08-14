//
//  OnSoldViewController.h
//  Glass_Radar
//
//  Created by Mina Shau on 1/31/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServicesjson.h"
#import <CoreLocation/CoreLocation.h>
@interface OnSoldViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
     BottomTabBarView *objBottomView;
    IBOutlet UITableView *tblView;
    IBOutlet UITableViewCell *cellList;
    IBOutlet UIButton *btnAll;
    IBOutlet UIButton *btnLoc;
    IBOutlet UIButton *btnVHigh;
    IBOutlet UIButton *btnHigh;
    IBOutlet UIButton *btnMed;
    IBOutlet UIImageView *imgGB;
    float tableHeight;
    IBOutlet UISlider *milesSlider;
    IBOutlet UILabel *lblSortedValue;
    IBOutlet UILabel *lblSortOrder;
    IBOutlet UIButton *btnPostcode;
    
    NSMutableArray *arrSoldAdvertisements;
    WebServicesjson *objWebServicesjson;
    
    IBOutlet UIButton *btnCounterVHigh;
    IBOutlet UIButton *btnCounterHigh;
    IBOutlet UIButton *btnCounterMedium;
    IBOutlet UIButton *btnCounterAll;
    
    IBOutlet UIImageView *imgCalendar;
    IBOutlet UILabel *lblAverageDaysToSell;
    
    
    IBOutlet UIView *viewMain;
    NSDictionary *dicAllVehicleDetail;
    NSMutableDictionary *dicSoldPriceData;
    
    float sliderDBValue;
    
}
@property (strong, nonatomic) IBOutlet UILabel *lblSortedBy;
@property (strong, nonatomic) IBOutlet UILabel *lblDistanefrom;
@property (strong, nonatomic) IBOutlet UILabel *lblMiles;


- (IBAction)btnLocClicked:(id)sender;
-(IBAction)buttonsortClick:(id)sender;
-(void)buttonmenuClick:(id)sender;
- (IBAction)btntooggleClicked:(id)sender;
-(void)swipeLeft_Clicked;
-(void)swipeRightonsold_Clicked;
-(void)UpdateLayout;

-(void)reloadAllViewWhileServiceComplete; // This is method is comman for reloading view in Summar, Sale and Sold

@end
