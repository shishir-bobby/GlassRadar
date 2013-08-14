//
//  AppDelegate.h
//  Glass_Radar
//
//  Created by Krutik Vora on 1/21/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//PANKTI CODE......

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "CoreLocation/CoreLocation.h"
#import "SettingVC.h"
#import "OnSoldViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"
#import "AccessDeniedViewController.h"
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,MKReverseGeocoderDelegate>
{
    BOOL isOnline;
    Reachability *internetReachable,*hostReachable;
    
    //SettingVC *objSettingVC;
    float heightBottom;
    BOOL isMenuHidden;
    int appDelLastIndex;
    BOOL isSummary;
    BOOL isRadarSummery;
    BOOL isVhigh;
    BOOL ishigh;
    BOOL isMed;
    BOOL isAll;
    BOOL isIphone5;
    BOOL isFromSearchTree;
    
    OnSoldViewController *objappdelonsold;
    int selectedTag; /// Vhig h, high , midd, All
    NSString *strSortorder;
    BOOL isSortOrder;
    float  intValSlider;
    BOOL iSGpson;
    NSString *strSortingString;
    BOOL isLogin;
    
    NSString *strCurrentLocation;
    NSString *strDelPostCode;
    CLLocationManager *locationManager;
    MKReverseGeocoder *geoCoder;
    
    ViewController *objViewController;
    NSString *strUsrname, *strPassword;
    NSString *strCurrency;
    
    NSString *strVehicleID;
     NSString *DelUserName;
    
    NSMutableDictionary *dicSelectedTag;
    
    BOOL isDelSale;
    NSString *StrSortKeyword;
    
    BOOL isFirstValuation;

    NSString *StrFlurryStatus;
    NSDate *LoopStartTime;
    NSTimeInterval strDate;
    
    BOOL isWithoutPostCode;
    NSString *strRegistrationNo , *strMileageLocal;
    BOOL isFromHistory;
    NSString *strLastPostCode;
    BOOL isFirstTimeGPS;
    
    BOOL isFlurryOn;
    
    
    // Status about background service
    BOOL isBackgroundWS;
    BOOL isActiveAdvertsReturned;
    BOOL isRemovedAdvertsReturned;
    BOOL isActivePriceHistoryReturned;
    BOOL isRemovedPriceHistoryReturned;
    
    BOOL isFromBackground;
    UIAlertView *alertNoInternet;
    
    BOOL isTestMode;
    BOOL UserAuthenticated;
    BOOL isFromPriceHistory;
    BOOL isWrongVehiclePressed;
    
    id objCurentCallLocation;

}
@property (nonatomic,strong)id objCurentCallLocation;
@property (nonatomic)BOOL isFromSelectVehicle;
@property (nonatomic)BOOL isWrongVehiclePressed;
@property (nonatomic)BOOL isFromPriceHistory;
@property (nonatomic)BOOL UserAuthenticated;
@property (nonatomic)BOOL isTestMode;
@property (nonatomic)BOOL isFromBackground;
@property (nonatomic)BOOL isBackgroundWS;
@property (nonatomic)BOOL isActiveAdvertsReturned;
@property (nonatomic)BOOL isRemovedAdvertsReturned;
@property (nonatomic)BOOL isActivePriceHistoryReturned;
@property (nonatomic)BOOL isRemovedPriceHistoryReturned;

@property (nonatomic) BOOL isFlurryOn;
@property (nonatomic) BOOL isFirstTimeGPS;
@property BOOL isFromHistory;
@property BOOL isWithoutPostCode;

@property (nonatomic , retain) NSString *strLastPostCode;
@property (nonatomic , retain)  NSString *strRegistrationNo , *strMileageLocal;
@property (nonatomic,retain)    NSDate *LoopStartTime;
@property (nonatomic)  NSTimeInterval strDate;
@property (nonatomic,retain)    NSString *StrFlurryStatus;


@property BOOL isFirstValuation;
@property  BOOL isDelSale;
@property (nonatomic , retain) NSMutableDictionary *dicSelectedTag;
@property (nonatomic , retain) NSString *strVehicleID;
@property (nonatomic , retain) NSString *strCurrentLocation;
@property (nonatomic , retain) NSString *strCurrency;
@property (nonatomic , retain) NSString *StrSortKeyword;

@property(nonatomic,retain)NSString *strUsrname, *strPassword;
@property (nonatomic)BOOL isOnline;

@property(nonatomic)BOOL isLogin;
@property(nonatomic,retain)NSString *strSortingString;
@property (nonatomic, readwrite)int selectedTag;
@property(nonatomic,retain)OnSoldViewController *objappdelonsold;
@property BOOL isSummary;
@property BOOL isSortOrder;
@property BOOL iSGpson;
@property(nonatomic,retain)NSString *strDelPostCode;
@property (nonatomic,retain)    NSString *DelUserName;


@property float intValSlider;

@property BOOL isRadarSummery;
@property BOOL isVhigh;
@property BOOL ishigh;
@property BOOL isMed;
@property BOOL isAll;
@property BOOL isIphone5;
@property (nonatomic)BOOL isMenuHidden;
@property (readwrite)float heightBottom;
@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)SettingVC *objSettingVC;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) NSString *strSortorder;
@property int appDelLastIndex;
@property (strong, nonatomic) UINavigationController *navigationeController;

/*Location*/
@property (nonatomic, retain)  MKReverseGeocoder *geoCoder;
@property (nonatomic, retain) CLLocationManager *locationManager;


void uncaughtExceptionHandler(NSException *exception);
-(NSString *)fetchDateFromTimestamp :(NSString *)timestamp;
-(NSString *)fetchDateFromTimestamp :(NSString *)timestamp withDateFormate : (NSString *) strDateFormate;
+ (UILabel *) navigationTitleLable:(NSString *)title;
+ (UILabel *) navigationTitleLablePrice:(NSString *)title;
-(void)loadSettingScreen;
-(BOOL)validateEmail :(NSString *)email;
-(NSString *) formatIdentificationNumber:(NSString *)string;
- (UIColor *) colorForHex:(NSString *)hexColor;
-(NSString *) removeSpace:(NSString *)string;
-(NSString *)checkSpace :(NSString *)strPostCode;
-(void)GetCurrency;
-(void)getNewLocaiton :(id) objObserver;
-(NSString *)formateCommaSeperate :(NSString *)str;


-(void)checkAuthenticationFromForeground;
-(NSString *) encryptDataAES:(NSString *)string;


@end
