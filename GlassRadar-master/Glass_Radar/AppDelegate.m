//
//  AppDelegate.m
//  Glass_Radar
//
//  Created by Krutik Vora on 1/21/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//
#import "AppDelegate.h"
#import "ViewController.h"
#import "Flurry.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "WebServices.h"

@implementation UINavigationBar (image)

- (void)drawRect:(CGRect)rect {
    UIImage *img = [UIImage imageNamed:@"banner-background.png"];
    [img drawInRect:rect];
}
@end



@implementation AppDelegate
@synthesize objCurentCallLocation;
@synthesize isFromHistory;
@synthesize heightBottom;
@synthesize isMenuHidden;
@synthesize appDelLastIndex;
@synthesize isRadarSummery;
@synthesize isVhigh;
@synthesize ishigh;
@synthesize isMed;
@synthesize isAll;
@synthesize objappdelonsold;
@synthesize isIphone5;
@synthesize isSummary;
@synthesize selectedTag;
@synthesize strSortorder;
@synthesize isSortOrder;
@synthesize intValSlider;
@synthesize iSGpson;
@synthesize strSortingString;
@synthesize isLogin;
@synthesize strDelPostCode;
@synthesize locationManager,isOnline;
@synthesize strUsrname,strPassword;
@synthesize strCurrentLocation;
@synthesize strCurrency;
@synthesize strVehicleID;
@synthesize DelUserName;
@synthesize dicSelectedTag;
@synthesize isDelSale;
@synthesize StrSortKeyword;
@synthesize isFirstValuation;
@synthesize StrFlurryStatus;
@synthesize LoopStartTime;
@synthesize strDate;
@synthesize geoCoder;
@synthesize strMileageLocal;
@synthesize strRegistrationNo;
@synthesize isWithoutPostCode;
@synthesize strLastPostCode;
@synthesize isFirstTimeGPS;
@synthesize isFlurryOn;
@synthesize isFromBackground;
@synthesize isTestMode;
@synthesize UserAuthenticated;
@synthesize isFromPriceHistory;
@synthesize isWrongVehiclePressed;
@synthesize isFromSelectVehicle;

@synthesize isBackgroundWS,isActiveAdvertsReturned,isRemovedAdvertsReturned,isActivePriceHistoryReturned,isRemovedPriceHistoryReturned;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    isFromBackground = FALSE;
    
    
    //LIVE_SWITCH
    //self.isTestMode = TRUE; //is TEST Proxy
    self.isTestMode = FALSE; //is LIVE Proxy
    self.UserAuthenticated = FALSE;
    
    // check for internet connection with Reachability
    
    internetReachable = [Reachability reachabilityWithHostName:@"www.google.com"];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object: nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityChangedNotification object:nil];
    [internetReachable startNotifier];
    
    self.isBackgroundWS = FALSE;
    self.isActiveAdvertsReturned = FALSE;
    self.isRemovedAdvertsReturned = FALSE;
    self.isActivePriceHistoryReturned = FALSE;
    self.isRemovedPriceHistoryReturned = FALSE;
    self.isFromSelectVehicle = FALSE;
    
    isWithoutPostCode = FALSE;
    self.isFromHistory = FALSE;
    
    self.isFlurryOn = TRUE;
    
    //LIVE_SWITCH
    //HERE IS WHERE WE COMMENT OUT TESTFLIGHT.
    

    
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    [TestFlight takeOff:@"15d72b7a-34cc-49aa-baca-b41e72a82423"]; // Bamboo - com.glass.dev.GlassRadar
    //[TestFlight takeOff:@"eecd516d-fc48-43a4-8baf-9c6f29500d6f"]; //Bamboo - com.glass.GlassRadar
    
    //    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    
    // Start Flurry Session
    if (self.isTestMode) {
        
        [Flurry startSession:Flurry_API_Key];
    }
    else{
        
        [Flurry startSession:Flurry_API_Key_LIVE];
    }
    
    [Flurry setCrashReportingEnabled:TRUE];
    
    objSKDatabase = [[SKDatabase alloc] initWithFile:@"GlasssRadarDB.sqlite"];
    
    isFirstTimeGPS = TRUE;
    
//    [self performSelectorInBackground:@selector(getNewLocaiton) withObject:nil];
    
    
    appDel.intValSlider = [[NSUserDefaults standardUserDefaults] floatForKey:@"Distance"];
    
    dicSelectedTag = [[NSMutableDictionary alloc] init];
    
    [dicSelectedTag setObject:@"true" forKey:@"1"];
    [dicSelectedTag setObject:@"true" forKey:@"2"];
    [dicSelectedTag setObject:@"true" forKey:@"3"];
    [dicSelectedTag setObject:@"true" forKey:@"0"];
    [dicSelectedTag setObject:@"true" forKey:@"4"];
    
    self.isFirstValuation = TRUE;
    
    [self GetCurrency];
    
    
    isOnline = FALSE;
    
    /*Code For Setting Values in Application Pref Screen*/
    /***************************************************************************************************/
    
    
    /*
    NSString *version1 = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [[NSUserDefaults standardUserDefaults] setObject:version1 forKey:@"version_preference"];
    
    NSString *bPath = [[NSBundle mainBundle] bundlePath];
    NSString *settingsPath = [bPath stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *plistFile = [settingsPath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary *settingsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistFile];
    NSArray *preferencesArray = [settingsDictionary objectForKey:@"PreferenceSpecifiers"];
    
    
    NSDictionary *item;
    //NSString *textEntry_Key;
    //NSString *readOnly_Key;
    NSString *toogle_Key;
    //NSString *slider_Key;
    //NSString *colors_Key;
    
    for(item in preferencesArray)
    {
        //Get the key of the item.
        NSString *keyValue = [item objectForKey:@"Key"];
        
        //Get the default value specified in the plist file.
        id defaultValue = [item objectForKey:@"DefaultValue"];
        if([keyValue isEqualToString:@"toogle_key"])
            toogle_Key = defaultValue;
    }
    
    //Now that we have all the default values.
    //We will create it here.
    NSDictionary *appPrerfs = [NSDictionary dictionaryWithObjectsAndKeys:
                               toogle_Key, @"toogle_key",nil];
    //   NSLog(@"print app Pref arr:%@",appPrerfs);
    
    
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:appPrerfs];
    [[NSUserDefaults standardUserDefaults] synchronize];
     
     */
    
    selectedTag = 4;
    iSGpson = TRUE;
    isLogin = FALSE;
    strSortingString = @"Spot Price";
    
    
    isMenuHidden = FALSE;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.navigationeController=[[UINavigationController alloc]initWithRootViewController:self.viewController];
    self.window.rootViewController = self.navigationeController;
    
    self.isIphone5 = (([[UIDevice currentDevice] userInterfaceIdiom]
                       == UIUserInterfaceIdiomPhone) && (([UIScreen mainScreen].bounds.size.height *
                                                          [[UIScreen mainScreen] scale]) >= 1136));
    
    heightBottom = self.window.frame.size.height-64;
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (version >= 5.0)
    {
        // iPhone 5.0 code here
        [self.navigationeController.navigationBar setBackgroundImage:[UIImage imageNamed:@"banner-background.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    
    
    [self.window makeKeyAndVisible];
    return YES;
}



#pragma mark -
#pragma mark Exeption Handling

/*
 void uncaughtExceptionHandler(NSException *exception) {
 
 //    NSLog(@"************ uncaughtExceptionHandler ********");
 [Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
 }
 */


-(void)GetCurrency
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *code = [locale objectForKey:NSLocaleCurrencyCode];
    if([code length]>0)
    {
        self.strCurrency=code;
        
    }
    else
    {
        self.strCurrency=@"";
    }
    
}
-(NSString *)backImage
{
    if((fabs((double)[UIScreen mainScreen].bounds.size.height -
             (double)568) < DBL_EPSILON)==TRUE)
    {
        
    }
    return nil;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // issue 222 is done, just verify it
    
    
    
    // WS Call For Login
    BOOL isLogedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    
    if (isLogedIn) {
        
        [SVProgressHUD show];
        [SVProgressHUD showWithStatus:@"Please wait for authentication.."];
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self performSelector:@selector(CheckForNetwork) withObject:nil afterDelay:3];
        
    }
    
}

-(void)CheckForNetwork {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityChangedNotification object:nil];
    [internetReachable startNotifier];
    
    if (alertNoInternet) {
        
        [alertNoInternet dismissWithClickedButtonIndex:0 animated:NO];
        
    }
    if(self.isOnline)
    {
        self.isFromBackground = TRUE;
        
        
        [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(checkAuthenticationFromForeground) userInfo:nil repeats:NO];
    }
    else
    {
        appDel.UserAuthenticated = FALSE;
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        
        alertNoInternet = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertNoInternet show];
        
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
+ (UILabel *) navigationTitleLable:(NSString *)title {
    
	CGRect frame = CGRectMake(0, 0, 170, 44);
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:17];
    label.minimumFontSize = 12.0;
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
    
	label.text = NSLocalizedString(title, @"");
    
	return label;
}
+ (UILabel *) navigationTitleLablePrice:(NSString *)title {
    
	CGRect frame = CGRectMake(0, 0, 165, 44);
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:15];
    label.minimumFontSize = 12.0;
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
    
	label.text = NSLocalizedString(title, @"");
    
	return label;
}


-(void)loadSettingScreen
{
    self.objSettingVC=nil;
    self.objSettingVC = [[SettingVC alloc]initWithNibName:@"SettingVC" bundle:nil];
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
    
    
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
						   forView:self.navigationeController.view
							 cache:YES];
    [self.navigationeController pushViewController:self.objSettingVC animated:FALSE];
	[UIView commitAnimations];
}


#pragma mark -
#pragma mark Other Functions


-(BOOL)validateEmail :(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(NSString *)fetchDateFromTimestamp :(NSString *)timestamp {
    
    
    NSString *strDateLocal = timestamp;
    NSString *preString = [strDateLocal substringToIndex:[strDateLocal rangeOfString:@"("].location + 1];
    strDateLocal = [strDateLocal stringByReplacingOccurrencesOfString:preString withString:@""];
    
    NSString *subString = [strDateLocal substringFromIndex:[strDateLocal rangeOfString:@"+"].location];
    strDateLocal = [strDateLocal stringByReplacingOccurrencesOfString:subString withString:@""];
    double finalVal = [strDateLocal doubleValue]/1000;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:finalVal];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *_date=[_formatter stringFromDate:date];
    return _date;
}

-(NSString *)fetchDateFromTimestamp :(NSString *)timestamp withDateFormate : (NSString *) strDateFormate{
    
    
    NSString *strDateLocal = timestamp;
    NSString *preString = [strDateLocal substringToIndex:[strDateLocal rangeOfString:@"("].location + 1];
    strDateLocal = [strDateLocal stringByReplacingOccurrencesOfString:preString withString:@""];
    
    NSString *subString = [strDateLocal substringFromIndex:[strDateLocal rangeOfString:@"+"].location];
    strDateLocal = [strDateLocal stringByReplacingOccurrencesOfString:subString withString:@""];
    double finalVal = [strDateLocal doubleValue]/1000;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:finalVal];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:strDateFormate];
    NSString *_date=[_formatter stringFromDate:date];
    return _date;
}






#pragma mark -
#pragma mark Reachablity


- (void)updateNetwork:(Reachability*)curReach {
    
    if (curReach == NULL) {
        curReach = internetReachable;
    }
    
	NetworkStatus connection = [curReach currentReachabilityStatus];
	if(curReach == internetReachable){
        
		switch (connection)
		{
			case NotReachable:
            {
                
                self.isOnline = NO;
                
                break;
            }
            case ReachableViaWiFi:
            {
                
                self.isOnline = YES;
                
                break;
            }
            case ReachableViaWWAN:
            {
                
                self.isOnline = YES;
                break;
            }
                
		}
		
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:( UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
}

- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	[self updateNetwork:curReach];
	
}

#pragma mark-
#pragma mark Code For Location


-(void)getNewLocaiton :(id) objObserver
{
    NSLog(@"getNewLocaiton Called.......");
    
    self.objCurentCallLocation = nil;
    self.objCurentCallLocation = objObserver;
    
    [[NSNotificationCenter defaultCenter] addObserver:self.objCurentCallLocation selector:@selector(LocationCalledAndReturned) name:@"LocationCalledAndReturned" object:nil];
    
    
    
    self.locationManager = nil;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    
    
    if (! ([CLLocationManager locationServicesEnabled])
        || ( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)){
        
        
        [SVProgressHUD dismiss];
        
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Get Location failed, please ensure Location Services are turned on in IOS Settings > Privacy." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        
    }
    else{
        
        [self.locationManager startUpdatingLocation];
        
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    
    // change here
    
    [self reverseGeocodeLocation:newLocation];
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    
    if ([[error domain] isEqualToString: kCLErrorDomain] && [error code] == kCLErrorDenied) {
        // The user denied your app access to location information.
    }
    
    
    if(self.objCurentCallLocation)
    {
        if ([self.objCurentCallLocation respondsToSelector:@selector(LocationCalledAndReturned)]) {
            
            [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;

            [self.objCurentCallLocation performSelector:@selector(LocationCalledAndReturned)];
            self.objCurentCallLocation = nil;
        }
    }

}

- (void)reverseGeocodeLocation:(CLLocation *)location
{
    
    
    CLGeocoder* reverseGeocoder = [[CLGeocoder alloc] init];
    if (reverseGeocoder) {
        
        [reverseGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark* placemark = [placemarks firstObjectCommonWithArray:placemarks];
            if (placemark) {
                
                //Using blocks, get zip code
                NSString *zipCode = [placemark.addressDictionary objectForKey:(NSString*)kABPersonAddressZIPKey];
                
                if (zipCode.length > 0) {
                    
                    NSString *locatedAtpostcodeext = [NSString stringWithFormat:@"%@",zipCode];
                    
                    if ([[placemark.addressDictionary valueForKey:@"PostCodeExtension"] length] > 0) {
                        
                        locatedAtpostcodeext = [NSString stringWithFormat:@"%@%@",zipCode,[placemark.addressDictionary valueForKey:@"PostCodeExtension"]];
                        
                    }
                    
                    if (locatedAtpostcodeext.length > 0) {
                        
                       
                        NSString *strPostCode = [self formatIdentificationNumber:[appDel checkSpace:locatedAtpostcodeext]];
                        
                        if (strPostCode.length > 0) {
                            
                            self.strDelPostCode = [NSString stringWithFormat:@"%@",strPostCode];
                            
                            // change here
                            //                             self.strDelPostCode = @"KT11 3LB";

                            [self.locationManager stopUpdatingLocation];
                            self.locationManager = nil;
                            self.locationManager.delegate = nil;

                            if(self.objCurentCallLocation)
                            {

                                if ([self.objCurentCallLocation respondsToSelector:@selector(LocationCalledAndReturned)]) {

                                    [SVProgressHUD dismiss];
                                    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;

                                    [self.objCurentCallLocation performSelector:@selector(LocationCalledAndReturned)];
                                    self.objCurentCallLocation = nil;
                                }
                            }
                            
                        }
                        else{
                            
                            self.strDelPostCode = @"";
                        }
                        
                    }
                    
                    
                }
                
                else{
                    
                    if(self.objCurentCallLocation)
                    {
                        
                        if ([self.objCurentCallLocation respondsToSelector:@selector(LocationCalledAndReturned)]) {
                            
                            [SVProgressHUD dismiss];
                            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;

                            
                            [self.objCurentCallLocation performSelector:@selector(LocationCalledAndReturned)];
                            self.objCurentCallLocation = nil;
                        }
                    }

                    
                    NSDictionary *flurryParams =
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     [NSString stringWithFormat:@"Latitude - %f and Logitude - %f  failed to calculate postcode",location.coordinate.latitude,location.coordinate.longitude], NSLocalizedDescriptionKey,nil];
                    NSError *error;
                    error = [NSError errorWithDomain:@"Location - Error" code:200 userInfo:flurryParams];
                    [Flurry logError:@"Location - Error"  message:@"Location - Error" error:error];//m2806
                    
                    
                    
                }
                
            }
            
            
        }];
    }
    else{
        
        MKReverseGeocoder* rev = [[MKReverseGeocoder alloc] initWithCoordinate:location.coordinate];
        rev.delegate = self;//using delegate
        [rev start];
    }
    
}



- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    @try {
        
        MKPlacemark * myPlacemark = placemark;
        NSString *locatedAtzip = [myPlacemark.addressDictionary valueForKey:@"ZIP"];
        NSString *locatedAtpostcodeext = [myPlacemark.addressDictionary valueForKey:@"PostCodeExtension"];
        NSMutableString *strtemp=[NSMutableString stringWithString:@""];
        
        if(locatedAtzip.length>0)
        {
            
            [strtemp appendString:[NSString stringWithFormat:@"%@",locatedAtzip]];
        }
        else{
            
            // change here
            
            
        }
        if(locatedAtpostcodeext.length>0)
        {
            
            [strtemp appendString:[NSString stringWithFormat:@"%@",locatedAtpostcodeext]];
        }
        
        if ([myPlacemark.addressDictionary valueForKey:@"Country"]) {
            
            
            self.strCurrentLocation = [myPlacemark.addressDictionary valueForKey:@"Country"];
            
        }
        else{
            
            self.strCurrentLocation = @"";
            
            
        }
        
        NSString *strPostCode = [self formatIdentificationNumber:[appDel checkSpace:(NSString *)strtemp]];
        
        if (strPostCode.length > 0) {
            
            self.strDelPostCode = strPostCode;
            [self.locationManager stopUpdatingLocation];
            
            
        }
        else{
            
            self.strDelPostCode = @"";
        }
        
    }
    @catch (NSException *exception) {
        
    }
    
    @finally {
        
        if(self.objCurentCallLocation)
        {
            

            if ([self.objCurentCallLocation respondsToSelector:@selector(LocationCalledAndReturned)]) {
                
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;

                
                [self.objCurentCallLocation performSelector:@selector(LocationCalledAndReturned)];
                self.objCurentCallLocation = nil;
            }
        }
    }
    
}


// this delegate is called when the reversegeocoder fails to find a placemark
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    
    if(self.objCurentCallLocation)
    {

        if ([self.objCurentCallLocation respondsToSelector:@selector(LocationCalledAndReturned)]) {
            
            [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;

            [self.objCurentCallLocation performSelector:@selector(LocationCalledAndReturned)];
            self.objCurentCallLocation = nil;
        }
    }
    
}

#pragma mark Formating methods
-(NSString *)formateCommaSeperate :(NSString *)str /// 100,000 1,000 10,000
{
    NSNumber* number = [NSNumber numberWithDouble:[str doubleValue]];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
    [numberFormatter setGroupingSeparator:@","];
    NSString* commaString = [numberFormatter stringForObjectValue:number];
    
    return commaString;
}


-(NSString *) removeSpace:(NSString *)string
{
	NSCharacterSet * invalidNumberSet = [NSCharacterSet characterSetWithCharactersInString:@" "];
    
    NSString  * result  = @"";
    NSScanner * scanner = [NSScanner scannerWithString:string];
    NSString  * scannerResult;
    
    [scanner setCharactersToBeSkipped:nil];
    
    while (![scanner isAtEnd])
    {
        if([scanner scanUpToCharactersFromSet:invalidNumberSet intoString:&scannerResult])
        {
            result = [result stringByAppendingString:scannerResult];
        }
        else
        {
            if(![scanner isAtEnd])
            {
                [scanner setScanLocation:[scanner scanLocation]+1];
            }
        }
    }
    
    invalidNumberSet = nil;
    scanner = nil;
    scannerResult = nil;
    return result;
}


-(NSString *) formatIdentificationNumber:(NSString *)string
{
	NSCharacterSet * invalidNumberSet = [NSCharacterSet characterSetWithCharactersInString:@"\n_!@#$%^&*()[]{}'\\.,<>:;|\\/?+=\t~`-"];
    
    NSString  * result  = @"";
    NSScanner * scanner = [NSScanner scannerWithString:string];
    NSString  * scannerResult;
    
    [scanner setCharactersToBeSkipped:nil];
    
    while (![scanner isAtEnd])
    {
        if([scanner scanUpToCharactersFromSet:invalidNumberSet intoString:&scannerResult])
        {
            result = [result stringByAppendingString:scannerResult];
        }
        else
        {
            if(![scanner isAtEnd])
            {
                [scanner setScanLocation:[scanner scanLocation]+1];
            }
        }
    }
    
    invalidNumberSet = nil;
    scanner = nil;
    scannerResult = nil;
    return result;
}

-(NSString *)checkSpace :(NSString *)strPostCode
{
    if(strPostCode.length <= 4)
        return strPostCode;
    
    strPostCode = [strPostCode stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *trimmedString = [strPostCode substringWithRange:NSMakeRange([strPostCode length]-4, 1)];
    NSMutableString *newPostcode;
    newPostcode = [strPostCode mutableCopy];
    
    if(![trimmedString isEqualToString:@" "])
    {
        [newPostcode insertString:@" " atIndex:[newPostcode length]-3];
    }
    return newPostcode;
    
    
}
- (UIColor *) colorForHex:(NSString *)hexColor {
	hexColor = [[hexColor stringByTrimmingCharactersInSet:
				 [NSCharacterSet whitespaceAndNewlineCharacterSet]
				 ] uppercaseString];
	
    // String should be 6 or 7 characters if it includes '#'
    if ([hexColor length] < 6)
		return [UIColor blackColor];
	
    // strip # if it appears
    if ([hexColor hasPrefix:@"#"])
		hexColor = [hexColor substringFromIndex:1];
	
    // if the value isn't 6 characters at this point return
    // the color black
    if ([hexColor length] != 6)
		return [UIColor blackColor];
	
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
	
    NSString *rString = [hexColor substringWithRange:range];
	
    range.location = 2;
    NSString *gString = [hexColor substringWithRange:range];
	
    range.location = 4;
    NSString *bString = [hexColor substringWithRange:range];
	
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
	
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
	
}


#pragma mark - Check Login in Forground
-(NSString *) encryptDataAES:(NSString *)string
{
    
    NSData *initVector = [@"eurotaxglass.com" dataUsingEncoding:NSASCIIStringEncoding];
    NSData* key = [[GTMStringEncoding rfc4648Base64StringEncoding] decode:@"NjRCtCU04O7I3YglEFrMjSUNtEVALxN2wDZt1LaEpsY="];
    NSData *data = [string dataUsingEncoding: NSASCIIStringEncoding];
    
    CCCryptorStatus status = kCCSuccess;
    
    NSData *encrypted = [data dataEncryptedUsingAlgorithm:kCCAlgorithmAES128 key:key initializationVector:initVector options:kCCOptionPKCS7Padding error:&status];
    
    // NSLog(@"Result: %i", status);
    
    return [[GTMStringEncoding rfc4648Base64StringEncoding] encode:encrypted];
    
    //Softweb Encryption End
}


-(void)checkAuthenticationFromForeground
{
    
    WebServices *objWebServices = [[WebServices alloc] init];
    // [objWebServices setDelegate:self];
    
    
    //Softweb Comment - Start
    //Here we are try to Decode and encrypt UserName and Password
    
    KeychainItemWrapper *wrapper= [[KeychainItemWrapper alloc] initWithIdentifier:@"Password" accessGroup:nil];
    
    NSString *strUserNameWra = [wrapper objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *strPasswordWra = [wrapper objectForKey:(__bridge id)(kSecValueData)];
    
    if(strUserNameWra.length == 0 || strPasswordWra.length == 0)
    {
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        [self.navigationeController popToRootViewControllerAnimated:NO];
        return;
        
    }
    
    appDel.strUsrname = [self encryptDataAES:strUserNameWra];
    appDel.strPassword = [self encryptDataAES:strPasswordWra];
    
    if(appDel.isFlurryOn)
    {
        [Flurry logEvent:@"WS-GS-AuthenticateUserWithProduct" timed:YES];
    }
    
    
    NSMutableDictionary *dicreceivedData;
    if (appDel.isTestMode) {
        
        dicreceivedData = [objWebServices Call_LoginWebService:Login_URL UserName:appDel.strUsrname Password:appDel.strPassword];
        
    }
    else{
        
        dicreceivedData = [objWebServices Call_LoginWebService:Login_URL_LIVE UserName:appDel.strUsrname Password:appDel.strPassword];
    }
    
    if ([dicreceivedData count] > 0) {
        
        [Flurry endTimedEvent:@"WS-GS-AuthenticateUserWithProduct" withParameters:nil];
        
        UIAlertView *art;
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
        
        NSString *strValidField = [NSString stringWithFormat:@"%@",[dicreceivedData valueForKey:@"validField"]];
        if([[dicreceivedData valueForKey:@"glassTokenField"] isEqualToString:@"00000000-0000-0000-0000-000000000000"] && [strValidField isEqualToString:@"0"])
        {
            // Invalid username and password
            appDel.UserAuthenticated = FALSE;
            
            art = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@ %@",systemError,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [art show];
            
        }
        else if(![[dicreceivedData valueForKey:@"glassTokenField"] isEqualToString:@"00000000-0000-0000-0000-000000000000"] && [strValidField isEqualToString:@"0"])
        {
            
            appDel.UserAuthenticated = FALSE;
            
            AccessDeniedViewController *objAccessDeniedViewController = [[AccessDeniedViewController alloc] initWithNibName:@"AccessDeniedViewController" bundle:nil];
            [self.navigationeController pushViewController:objAccessDeniedViewController animated:YES];
            
        }
        
        else if(![[dicreceivedData valueForKey:@"glassTokenField"] isEqualToString:@"00000000-0000-0000-0000-000000000000"] && [strValidField isEqualToString:@"1"])
        {
            
            appDel.UserAuthenticated = TRUE;
            
            [self storeAndRedirect:dicreceivedData];
        }
        
    }
    else{
        
        [Flurry endTimedEvent:@"WS-GS-AuthenticateUserWithProduct" withParameters:nil];
        
        [SVProgressHUD dismiss];
        appDel.UserAuthenticated = FALSE;
        
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        UIAlertView *art = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@ %@",ErrorInResponse,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [art show];
        
        
    }
    
}

-(void)storeAndRedirect :(NSMutableDictionary *)dicreceivedData
{
    
    // Check for the Active run and Redirect to the VRM Search or Summary screen
    appDel.isLogin = TRUE;
    
    KeychainItemWrapper *wrapper= [[KeychainItemWrapper alloc] initWithIdentifier:@"Password" accessGroup:nil];
    NSString *strUserNameWra = [wrapper objectForKey:(__bridge id)(kSecAttrAccount)];
    
    
    NSDictionary *dicUser = [objSKDatabase lookupRowForSQL:[NSString stringWithFormat:@"select * from tblUser where username = '%@'",strUserNameWra]];
    
    if ([dicUser count] > 0) {
        
    }
    else{
        
        [objSKDatabase deleteWhereAllRecord:@"tblHistory"];
        
    }
    
    [objSKDatabase deleteWhereAllRecord:@"tblUser"];
    
    NSMutableDictionary *dicToInsert = [[NSMutableDictionary alloc] init];
    [dicToInsert setObject:[dicreceivedData valueForKey:@"userNameField"] forKey:@"username"];
    [dicToInsert setObject:[dicreceivedData valueForKey:@"glassTokenField"] forKey:@"GlassToken"];
    
    [objSKDatabase insertDictionary:dicToInsert forTable:@"tblUser"];
    
    
    BOOL isActiveRun = [self checkForActiveRun];
    
    if (isActiveRun) {
        
        
        if ([self.navigationeController.topViewController isKindOfClass:[ViewController class]]) {
            
            appDel.isSummary = TRUE;
            NSString *strPostcode = [objSKDatabase lookupColForSQL:[NSString stringWithFormat:@"select CustomPostCode from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
            
            NSString *strRegistrationNo1 = [objSKDatabase lookupColForSQL:[NSString stringWithFormat:@"select RegistrationNo from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
            
            if (strRegistrationNo1.length > 0) {
                
                appDel.isRadarSummery = FALSE;
                
            }
            else{
                
                appDel.isRadarSummery = TRUE;
            }
            
            
            //appDel.isRadarSummery
            
            
            if (strPostcode.length > 0) {
                
                appDel.strLastPostCode = strPostcode;
            }
            
            if(appDel.isIphone5)
            {
                
                SummaryViewController *objSummaryViewController=[[SummaryViewController alloc]initWithNibName:@"SummaryViewController_i5" bundle:Nil];
                [appDel.navigationeController pushViewController:objSummaryViewController animated:YES];
            }
            else
            {
                SummaryViewController *objSummaryViewController=[[SummaryViewController alloc] initWithNibName:@"SummaryViewController" bundle:Nil];
                [appDel.navigationeController pushViewController:objSummaryViewController animated:YES];
                
            }
            
        }
        
    }
    else {
        
        NSArray *arrVehicle = [objSKDatabase lookupAllForSQL:@"select * from tblVehicle"];
        if ([arrVehicle count] ==  0) {
            
            appDel.appDelLastIndex = 0;
            appDel.isSummary = FALSE;
            
            NSArray *arr  = [self.navigationeController viewControllers];
            
            if ([[arr objectAtIndex:[arr count] -1 ] isKindOfClass:[SummaryViewController class]] || [[arr objectAtIndex:[arr count] -1 ] isKindOfClass:[OnSaleViewController class]] || [[arr objectAtIndex:[arr count] -1 ] isKindOfClass:[OnSoldViewController class]] || [[arr objectAtIndex:[arr count] -1 ] isKindOfClass:[ViewController class]]) {
                
                
                if ([[arr objectAtIndex:[arr count] -1 ] isKindOfClass:[VRMSearchViewController class]]) {
                    
                    [self.navigationeController popToViewController:[arr objectAtIndex:[arr count]-1] animated:NO];
                }
                
                else{
                    
                    VRMSearchViewController *objVRMSearchViewController=[[VRMSearchViewController alloc]initWithNibName:@"VRMSearchViewController" bundle:nil];
                    [self.navigationeController pushViewController:objVRMSearchViewController animated:NO];
                    
                    
                }
                
                
            }
            else
                return;
            
        }
        else{
            
            return;
        }
        
        
    }
    
}


-(BOOL)checkForActiveRun {
    
    NSString *strVehicleIDLocal = [[NSUserDefaults standardUserDefaults] objectForKey:@"GlassCarCode"];
    if (strVehicleIDLocal.length > 0) {
        
        
        NSArray *arrVehicleData = [objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",strVehicleIDLocal]];
        
        if ([arrVehicleData count] > 0) {
            
            strVehicleIDLocal = [NSString stringWithFormat:@"%@",[[arrVehicleData objectAtIndex:0] objectForKey:@"GlassCarCode"]];
            
            int days;
            NSString *strDateLocal = [[arrVehicleData objectAtIndex:0] objectForKey:@"ActiveRun"];
            NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
            [_formatter setDateFormat:@"dd-MM-yyyy"];
            
            
            NSString *str = [_formatter stringFromDate:[NSDate date]];
            
            NSArray *aryActiveRun = [strDateLocal componentsSeparatedByString:@" "];
            NSArray *aryCurrentDate = [str componentsSeparatedByString:@" "];
            
            
            if([[aryActiveRun objectAtIndex:0] isEqualToString:[aryCurrentDate objectAtIndex:0]])
                days = 0;
            else
                days = -1;
            
            
            NSString *strQuery = [NSString stringWithFormat:@"select t1.* , t2.* from tblOnSale t1 , tblOnSold t2 where t1.GlassCarCode = '%@' AND t2.GlassCarCode = '%@'",strVehicleIDLocal,strVehicleIDLocal];
            
            NSArray *arrLastRecord = [objSKDatabase lookupAllForSQL:strQuery];
            
            if ([arrLastRecord count] > 0 && days == 0){
                
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
                appDel.strVehicleID = [[arrVehicleData objectAtIndex:0] objectForKey:@"GlassCarCode"];
                return YES;
                
            }
            else if (days == -1) {
                
                return NO;
            }
            
        }
        return NO;
    }
    else{
        
        return NO;
        
    }
    
}



@end
