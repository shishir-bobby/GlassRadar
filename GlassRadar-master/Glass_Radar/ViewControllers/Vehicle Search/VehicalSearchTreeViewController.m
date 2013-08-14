//
//  VehicalSearchTreeViewController.m
//  Glass_Radar
//
//  Created by Krutik Vora on 1/21/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "VehicalSearchTreeViewController.h"
#import "SelectCarViewController.h"
@interface VehicalSearchTreeViewController ()

@end

@implementation VehicalSearchTreeViewController
@synthesize strSelectedItem;
@synthesize arrFinalResult;
@synthesize arrPlates;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:lblYear.text forKey:@"yr"];
    [defaults setObject:lblPlate.text forKey:@"prefPlate"];
    [defaults setObject:lblmake.text forKey:@"prefMake"];
    [defaults setObject:lblmodel.text forKey:@"prefModel"];
    [defaults setObject:lblBodytype.text forKey:@"prefBodytype"];
    [defaults setObject:lblderivative.text forKey:@"prefDerivative"];
    [defaults setObject:lblFuelType.text forKey:@"prefFuelType"];
    [defaults setObject:lblTransmission.text forKey:@"prefTrasmission"];
    [defaults setObject:lblEngineSize.text forKey:@"prefEngineSize"];
    
    if (txtMileage.text.length > 0) {
        
        [defaults setValue:txtMileage.text forKey:@"TreeMileage"];
    }
    else{
        
        [defaults setValue:@"0" forKey:@"TreeMileage"];
        
    }
    
    [defaults synchronize];
    
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad
{
    
    NSString *UseAverageMileagestr = NSLocalizedString(@"UseAverageMileageKey", nil);
    NSString *FindValueKeystr = NSLocalizedString(@"FindValueKey", nil);
    lbluseavgMileage.text=UseAverageMileagestr;
    [btnFind setTitle:FindValueKeystr forState:UIControlStateNormal];
    NSString *VRMBackstr = NSLocalizedString(@"VRMBackkey", nil);
    NSString *VehicleSearchtreeNavstr = NSLocalizedString(@"VehicleSearchtreeNavKey", nil);
    objWebServicesjson = [[WebServicesjson alloc]init];
    
    if (!appDel.isIphone5) {
        
        CurrentFrame = CGRectMake(0, 0, 320, 418);
    }
    else{
        CurrentFrame = CGRectMake(0, 0, 320, 528);
    }
    DefaultFrame = self.view.frame;
    isKeyboardVisible = FALSE;
    
    /*for back button*/
    txtMileage.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, 44, 30)];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back-button-icon@2x.png"] forState:UIControlStateNormal];
    [btnBack setTitle:VRMBackstr forState:UIControlStateNormal];
    [btnBack setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    btnBack.titleLabel.textColor = [UIColor whiteColor];
    [btnBack.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [btnBack addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBack=[[UIBarButtonItem alloc]initWithCustomView:btnBack];
    [self.navigationItem setLeftBarButtonItem:barBack];
    
    self.navigationItem.titleView=[AppDelegate navigationTitleLable:VehicleSearchtreeNavstr];
    
    UIButton *buttonLogout=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonLogout setFrame:CGRectMake(0, 0, 30, 30)];
    [buttonLogout setBackgroundImage:[UIImage imageNamed:@"settings-icon@2x.png"] forState:UIControlStateNormal];
    
    [buttonLogout addTarget:self action:@selector(btnSettingClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSetting=[[UIBarButtonItem alloc]initWithCustomView:buttonLogout];
    
    [self.navigationItem setRightBarButtonItem:btnSetting];
    
    
    if(aryPickerData != nil)
        aryPickerData = nil;
    aryPickerData = [[NSMutableArray alloc] init];
    
    viewPicker.hidden = TRUE;
    btnAverageMilage.selected = FALSE;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    // Do any additional setup after loading the view from its nib.
    
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.backgroundColor=[UIColor redColor];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButton:)],
                           nil];
    [numberToolbar sizeToFit];
    txtMileage.inputAccessoryView = numberToolbar;
    txtMileage.inputAccessoryView.backgroundColor=[UIColor redColor];
    dicSelectedData = [[NSMutableDictionary alloc] init];
    
    [super viewDidLoad];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == alertNoPostcode) {
        
        appDel.isWithoutPostCode = TRUE;
        LocationViewController *objLocationViewController=[[LocationViewController alloc]initWithNibName:@"LocationViewController" bundle:nil];
        [appDel.navigationeController pushViewController:objLocationViewController animated:YES];
        
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    if(appDel.isFlurryOn)
    {
        [Flurry logEvent:@"Vehicle Search Tree"];
        
    }
    int rowsel = [[NSUserDefaults standardUserDefaults] integerForKey:@"UseGPS"];
    
    if (rowsel== 0) {
        
        appDel.strLastPostCode = appDel.strDelPostCode;
        
    }
    else
    {
        appDel.strLastPostCode = [[NSUserDefaults standardUserDefaults] valueForKey:@"Postcode"];
    }
    
    
    [self resetAllData];
    
    [super viewWillAppear:animated];
}

#pragma mark
#pragma mark Webservice Call

-(void)CallLoginAPI
{
    
    if (appDel.isOnline) {
        
        WebServices *objWebServices = [[WebServices alloc]init];
        [objWebServices setDelegate:self];
        
        KeychainItemWrapper *wrapper= [[KeychainItemWrapper alloc] initWithIdentifier:@"Password" accessGroup:nil];
        NSString *strUserNameWra = [wrapper objectForKey:(__bridge id)(kSecAttrAccount)];
        NSString *strPasswordWra = [wrapper objectForKey:(__bridge id)(kSecValueData)];
        
        appDel.strUsrname = [appDel encryptDataAES:strUserNameWra];
        appDel.strPassword = [appDel encryptDataAES:strPasswordWra];
        
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
                [self.navigationController pushViewController:objAccessDeniedViewController animated:YES];
                
            }
            
            else if(![[dicreceivedData valueForKey:@"glassTokenField"] isEqualToString:@"00000000-0000-0000-0000-000000000000"] && [strValidField isEqualToString:@"1"])
            {
                
                appDel.UserAuthenticated = TRUE;
                [SVProgressHUD show];
                [self CalucaltePrimaryFields];
            }
            
        }
        else{
            
            [Flurry endTimedEvent:@"WS-GS-AuthenticateUserWithProduct" withParameters:nil];
            
            appDel.UserAuthenticated = FALSE;
            [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            UIAlertView *art = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@ %@",ErrorInResponse,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [art show];
            
            
        }
        
    }
    
    else{
        
        appDel.UserAuthenticated = FALSE;
        UIAlertView *alertNoInternet = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertNoInternet show];
        alertNoInternet = nil;
        
    }
    
}




#pragma mark
#pragma mark Other Methods




-(void) setStatus:(SearchTreeStatus)status {
    
    
    
    
    if (status == DoneYear) {
        
        // This will called when Year values are fetched
        
        btnPlate.enabled = TRUE;
        
        
        lblPlate.text = @"Plate";
        lblmake.text = @"Make";
        lblmodel.text = @"Model";
        lblBodytype.text = @"Body Type";
        lblderivative.text = @"Derivative";
        lblFuelType.text = @"Fuel Type";
        lblTransmission.text = @"Transmission";
        lblEngineSize.text = @"Engine Size";
        
        
    }
    else if (status == DonePlate) {
        
        // This will called when Plate values are fetched
        for (int i = btnPlate.tag + 1; i <= 9; i++) {
            
            UIButton *btn = (UIButton *)[viewInner viewWithTag:i];
            [btn setEnabled:FALSE];
            
        }
        
        btnmake.enabled=TRUE;
        
        lblmake.text = @"Make";
        lblmodel.text = @"Model";
        lblBodytype.text = @"Body Type";
        lblderivative.text = @"Derivative";
        lblFuelType.text = @"Fuel Type";
        lblTransmission.text = @"Transmission";
        lblEngineSize.text = @"Engine Size";
        
        
    }
    else if (status == DoneMake){
        
        // This will called when Make values are fetched
        for (int i = btnmake.tag + 1; i <= 9; i++) {
            
            UIButton *btn = (UIButton *)[viewInner viewWithTag:i];
            [btn setEnabled:FALSE];
        }
        
        
        btnmodel.enabled = TRUE;
        
        lblmodel.text = @"Model";
        lblBodytype.text = @"Body Type";
        lblderivative.text = @"Derivative";
        lblFuelType.text = @"Fuel Type";
        lblTransmission.text = @"Transmission";
        lblEngineSize.text = @"Engine Size";
        
        
    }
    else if (status == DoneModel){
        
        // This will called when Model values are fetched
        
        for (int i = btnmodel.tag + 1; i <= 9; i++) {
            
            UIButton *btn = (UIButton *)[viewInner viewWithTag:i];
            [btn setEnabled:FALSE];
        }
        
        btnbodytype.enabled = TRUE;
        
        lblBodytype.text = @"Body Type";
        lblderivative.text = @"Derivative";
        lblFuelType.text = @"Fuel Type";
        lblTransmission.text = @"Transmission";
        lblEngineSize.text = @"Engine Size";
        
        
        
    }
    else if (status == DoneBodyType) {
        
        // This will called when Bidy Type values are fetched
        
        for (int i = btnbodytype.tag + 1; i <= 9; i++) {
            
            UIButton *btn = (UIButton *)[viewInner viewWithTag:i];
            [btn setEnabled:FALSE];
        }
        
        
        btnderivative.enabled = TRUE;
        lblderivative.text = @"Derivative";
        lblFuelType.text = @"Fuel Type";
        lblTransmission.text = @"Transmission";
        lblEngineSize.text = @"Engine Size";
        
        
        
    }
    else if (status == DoneRestAPICalls){
        
        // This will called when GetListType Execution done
        
        [SVProgressHUD showWithStatus:@"Please Wait..."];
        [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(CalculateDerivative) userInfo:nil repeats:NO];
        
        
        
    }
    else if (status == DoneValuation){
        
        // This will called when Valuation WS completes its execution
        
        appDel.isRadarSummery = TRUE;
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
        
        
        int rowsel = [[NSUserDefaults standardUserDefaults] integerForKey:@"UseGPS"];
        
        if (rowsel== 0) {
            
            //Call Location API
            [appDel getNewLocaiton:self];
            
            
        }
        else
        {
            
            appDel.strLastPostCode = [[NSUserDefaults standardUserDefaults] valueForKey:@"Postcode"];
            [self LocationCalledAndReturned];
        }
        
    }
    
}

-(void)LocationCalledAndReturned {

    int rowsel = [[NSUserDefaults standardUserDefaults] integerForKey:@"UseGPS"];
    
    if (rowsel == 0) {
        
        appDel.strLastPostCode = appDel.strDelPostCode;
    }
    
    if (appDel.strLastPostCode.length == 0 ) {
        
        alertNoPostcode = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry postcode could not be calculated, please enter your postcode manually." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertNoPostcode show];
        
    }
    
    else{
        
        // Call for WS Flow starts from here with Spot Price
        NSArray *arr = [objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
        
        if ([arr count] > 0) {
            
            ServiceCallTemp *objVRMServiceCall = [[ServiceCallTemp alloc] init];
            
            for (NSDictionary *dicToInsert in arr) {
                
                NSMutableDictionary *dic = (NSMutableDictionary *)[objSKDatabase lookupRowForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
                
                appDel.isFirstTimeGPS = FALSE;
                
                [objVRMServiceCall getSpotPrice:dic];
            }
            
            arr = nil;
        }
        
        else{
            
            [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
            
            
        }
        
    }


}


-(void)CalucaltePrimaryFields {
    
    @try {
        
        NSMutableDictionary *dicPreferences = [[NSMutableDictionary alloc] init];
        
        /************************CALCULATE YEAR*************************************/
        
        if (appDel.isOnline){
            
            
            if(appDel.isFlurryOn)
            {
                
                [Flurry logEvent:@"WS-P-GetListImmatriculationYear" timed:YES];
            }
            
            
            NSMutableDictionary *DictReqYear = [[NSMutableDictionary alloc] init];
            
            if (appDel.isTestMode) {
                
                [DictReqYear setObject:Proxy_WS_ClientCode forKey:@"ClientCode"];
                [DictReqYear setObject:Proxy_WS_AccountName forKey:@"AccountName"];
                [DictReqYear setObject:Proxy_WS_Password forKey:@"Password"];
                
            }
            
            else{
                
                [DictReqYear setObject:Proxy_WS_ClientCode_LIVE forKey:@"ClientCode"];
                [DictReqYear setObject:Proxy_WS_AccountName_LIVE forKey:@"AccountName"];
                [DictReqYear setObject:Proxy_WS_Password_LIVE forKey:@"Password"];
                
            }
            [DictReqYear setObject:@"GB" forKey:@"ISOCountryCode"];
            [DictReqYear setObject:@"GBP" forKey:@"ISOCurrencyCode"];
            [DictReqYear setObject:@"EN" forKey:@"ISOLanguageCode"];
            
            
            NSMutableDictionary *dicResponse;
            if (appDel.isTestMode) {
                
                dicResponse = [objWebServicesjson callJsonAPI:GetListImmatriculationYear_URL withDictionary:DictReqYear];
                
            }
            else{
                
                dicResponse = [objWebServicesjson callJsonAPI:GetListImmatriculationYear_URL_LIVE withDictionary:DictReqYear];
                
            }
            
            if (dicResponse) {
                
                if ([dicResponse count]> 0) {
                    
                    [Flurry endTimedEvent:@"WS-P-GetListImmatriculationYear" withParameters:nil];
                    
                    
                    for (NSDictionary * dicValues in dicResponse) {
                        
                        if ([dicValues count] > 0 && [dicValues objectForKey:@"Name"]) {
                            
                            NSString *strYearFilter=[NSString stringWithFormat:@"%@",[dicValues objectForKey:@"Name"]];
                            int i=[strYearFilter intValue];
                            
                            if(i>1998)
                            {
                                [arrYears addObject:strYearFilter];
                                
                            }
                        }
                    }
                    
                    if ([arrYears count] > 0) {
                        
                        
                        lblYear.text = [arrYears objectAtIndex:0];
                        [dicPreferences setObject:arrYears forKey:@"ArrYear"];
                        
                        NSMutableDictionary *dicTemp = [[NSMutableDictionary alloc] init];
                        [dicTemp setObject:lblYear.text forKey:@"Year"];
                        dicTemp = nil;
                        
                        
                    }
                    
                    [SVProgressHUD dismiss];
                    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    
                }
                
                else{
                    
                    /*severerr*/
                    /*Error_Event*/
                    NSDictionary *flurryParams =
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"WS-P-GetListImmatriculationYear", @"ErrorLocation", 
                     @"No Result Found", @"Error",
                     nil];
                    if(appDel.isFlurryOn)
                    {
                        NSError *error;
                        error = [NSError errorWithDomain:@"Vehicle Search Tree - GetListImmatriculationYear - No Result Found" code:200 userInfo:flurryParams];
                        
                        [Flurry logError:@"Vehicle Search Tree - GetListImmatriculationYear - No Result Found"   message:@"Vehicle Search Tree - Error"  error:error];
                    }
                    
                    
                    [Flurry endTimedEvent:@"WS-P-GetListImmatriculationYear" withParameters:nil];
                    [SVProgressHUD dismiss];
                    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                    
                    UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message: [NSString stringWithFormat:@"%@ %@.",ErrorConnection,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertError show];
                    alertError = nil;
                    return;
                    
                }
                
                
            }
            else{
                /*severerr*/
                /*Error_Event*/
                NSDictionary *flurryParams =
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"WS-P-GetListImmatriculationYear", @"ErrorLocation", 
                 @"Server Error", @"Error",
                 nil];
                
                if(appDel.isFlurryOn)
                {
                    NSError *error;
                    error = [NSError errorWithDomain:@"Vehicle Search Tree - GetListImmatriculationYear - Server Error" code:200 userInfo:flurryParams];
                    
                    [Flurry logError:@"Vehicle Search Tree - GetListImmatriculationYear - Server Error"   message:@"Vehicle Search Tree - Error"  error:error];
                }
                
                //arrYears
                [Flurry endTimedEvent:@"WS-P-GetListImmatriculationYear" withParameters:nil];
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
                UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message: [NSString stringWithFormat:@"%@ %@.",ErrorInResponse,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertError show];
                alertError = nil;
                return;
                
            }
            
            
        }
        else{
            
            [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
            
            UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertError show];
            alertError = nil;
            
            return;
            
        }
        
        
        [dicPreferences setObject:[NSDate date] forKey:@"lastTimestamp"];
        [[NSUserDefaults standardUserDefaults] setObject:dicPreferences forKey:@"TreeValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
    @catch (NSException *exception) {
        
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
        
        NSLog(@"exception : %@",exception);
        

        /*****@catch*****/
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"WS-P-GetListImmatriculationYear", @"ErrorLocation",
         exception.description, @"Error",
         nil];
        
        if(appDel.isFlurryOn)
        {
            //[Flurry logEvent:@"GetOwnVehicleSpotPrice" withParameters:flurryParams];
            NSError *error;
            error = [NSError errorWithDomain:@"Vehicle Search Tree - GetListImmatriculationYear - Exception" code:200 userInfo:flurryParams];
            
            [Flurry logError:@"Vehicle Search Tree - GetListImmatriculationYear - Exception"   message:@"Vehicle Search Tree - GetListImmatriculationYear - Exception"  error:error];//m2806
        }
        
        
        /*****@catch*****/
      [Flurry endTimedEvent:@"WS-P-GetListImmatriculationYear" withParameters:nil];
       
   
    
    
    }
    @finally {
        
    }
}
-(void)CalculatePlateValue {
    
    // Calculate Plate value from selected year
    
    NSArray *arrLastPlates = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefdictPlateValue"];
    NSString *strLastYear = [[NSUserDefaults standardUserDefaults] objectForKey:@"yr"];
    
    if (arrLastPlates && [arrLastPlates count] > 0  && [lblYear.text isEqualToString:strLastYear]) {
        
        arrPlates = [arrLastPlates mutableCopy];
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        
        return;
        
    }
    else if([arrLastPlates count] == 0 || ([arrLastPlates count] > 0  && ![lblYear.text isEqualToString:strLastYear]) ){
        
        if ([self.arrPlates count] > 0) {
            
            self.arrPlates = nil;
            self.arrPlates = [[NSMutableArray alloc] init];
        }
        
        int Year = [lblYear.text intValue];
        
        if (Year < 2002) {
            
            if (Year == 1999) {
                
                [self.arrPlates addObject:@"S"];
                [self.arrPlates addObject:@"T"];
                [self.arrPlates addObject:@"V"];
            }
            else if (Year == 2000){
                
                [self.arrPlates addObject:@"V"];
                [self.arrPlates addObject:@"W"];
                [self.arrPlates addObject:@"X"];
                
            }
            else if (Year == 2001){
                
                [self.arrPlates addObject:@"X"];
                [self.arrPlates addObject:@"Y"];
                [self.arrPlates addObject:@"51"];
                
            }
            
            else if (Year == 2002){
                
                [self.arrPlates addObject:@"51"];
                [self.arrPlates addObject:@"02"];
                [self.arrPlates addObject:@"52"];
            }
            else if (Year == 2005)
            {
                [self.arrPlates addObject:@"54"];
                [self.arrPlates addObject:@"05"];
                [self.arrPlates addObject:@"55"];
                
            }
            
            
        }
        else{
            int value1 = (Year-2000)+49;
            [self.arrPlates addObject:[NSString stringWithFormat:@"%02d",value1]];
            int value2 = (Year-2000);
            [self.arrPlates addObject:[NSString stringWithFormat:@"%02d",value2]];
            int value3 = (Year-2000)+50;
            [self.arrPlates addObject:[NSString stringWithFormat:@"%02d",value3]];
        }
        
        
        [[NSUserDefaults standardUserDefaults] setObject:self.arrPlates forKey:@"prefdictPlateValue"];
        
    }
    
    [self setStatus:DonePlate];
    
}

-(void)CalculateBodyTypeValue
{
    
    @try {
        
        // This will call WS call to get All Body Type value
        // Values will be fetched with Selected Make and Model criteria
        
        NSArray *arrLastBodyType = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefdictBodytype"];
        NSString *strLastModel = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefModel"];
        NSString *strLastMake = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefMake"];
        
        
        if (arrLastBodyType && [arrLastBodyType count] > 0  && [lblmodel.text isEqualToString:strLastModel] && [lblmake.text isEqualToString:strLastMake]) {
            
            
            arrBodyType = [arrLastBodyType mutableCopy];
            dicBodyTypeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefdictBodytypeCode"];
            
            
            if ([arrBodyType count] > 0) {
                
                NSSortDescriptor * dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
                [arrBodyType sortUsingDescriptors:[NSArray arrayWithObjects:dateDescriptor,nil]];
                aryPickerData = nil;
                aryPickerData = [[NSMutableArray alloc] init];
                aryPickerData = [arrBodyType mutableCopy];
                [pickerView reloadAllComponents];
                
                NSString *str = [NSString stringWithFormat:@"%@",lblBodytype.text];
                if ([arrBodyType containsObject:str]) {
                    
                    int selectedRowIndex = [arrBodyType indexOfObject:str];
                    [pickerView selectRow:selectedRowIndex inComponent:0 animated:NO];
                    self.strSelectedItem = str;
                }
                else{
                    
                    self.strSelectedItem = [aryPickerData objectAtIndex:0];
                    [pickerView selectRow:0 inComponent:0 animated:NO];
                }
                
                
                viewPicker.hidden = FALSE;
                
                [btnderivative setEnabled:TRUE];
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
                
                
            }
            
            NSString *modelCode;
            if ([dicModelValue count] > 0) {
                
                //    NSString *strSelectedModel = btnModel.titleLabel.text;
                
                NSString *strSelectedModel = lblmodel.text;
                
                for (NSDictionary *dic in dicModelValue) {
                    
                    if ([[dic objectForKey:@"Name"] isEqualToString:strSelectedModel]) {
                        
                        modelCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Code"]];
                        [dicWithSelectedCode setObject:modelCode forKey:@"Model"];
                        break;
                    }
                    
                }
                
            }
            
        }
        else if([arrLastBodyType count] == 0 || ([arrLastBodyType count] > 0  && (![lblmodel.text isEqualToString:strLastModel] || ![lblmake.text isEqualToString:strLastMake])) ){
            
            if ([arrBodyType count] > 0) {
                
                arrBodyType = nil;
                arrBodyType = [[NSMutableArray alloc] init];
            }
            
            
            if (appDel.isOnline) {
                
                NSString *modelCode;
                if ([dicModelValue count] > 0) {
                    
                    NSString *strSelectedModel = lblmodel.text;
                    
                    for (NSDictionary *dic in dicModelValue) {
                        
                        if ([[dic objectForKey:@"Name"] isEqualToString:strSelectedModel]) {
                            
                            modelCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Code"]];
                            [dicWithSelectedCode setObject:modelCode forKey:@"Model"];
                            break;
                        }
                        
                    }
                    
                }
                
                
                NSString *strMonth = nil;
                int currentPlateIndex;
                
                for(int i=0;i<[self.arrPlates count];i++)
                {
                    if([lblPlate.text isEqualToString:[self.arrPlates objectAtIndex:i]])
                    {
                        currentPlateIndex = i;
                        break;
                    }
                }
                if([lblYear.text intValue]<=2000)
                {
                    if(currentPlateIndex == 0)
                        strMonth = @"01";
                    else if(currentPlateIndex == 1)
                        strMonth = @"05";
                    else
                        strMonth = @"11";
                }
                else
                {
                    if(currentPlateIndex == 0)
                        strMonth = @"01";
                    else if(currentPlateIndex == 1)
                        strMonth = @"06";
                    else
                        strMonth = @"12";
                    
                }
                
                
                //            WS-P-GetListBodyType
                
                if(appDel.isFlurryOn)
                {
                    
                    [Flurry logEvent:@"WS-P-GetListBodyType" timed:YES];
                }
                
                
                NSString *strProductionPeriodDate = [NSString stringWithFormat:@"%@-%@",lblYear.text,strMonth];
                
                //[dicWithSelectedCode setObject:strProductionPeriodDate forKey:@"Plate"];
                
                //            NSString *strProductionPeriodDate = [NSString stringWithFormat:@"%@-%@",lblYear.text,lblPlate.text];
                NSMutableDictionary *DictRequest = [[NSMutableDictionary alloc] init];
                
                if (appDel.isTestMode) {
                    [DictRequest setObject:Proxy_WS_ClientCode forKey:@"ClientCode"];
                    [DictRequest setObject:Proxy_WS_AccountName forKey:@"AccountName"];
                    [DictRequest setObject:Proxy_WS_Password forKey:@"Password"];
                    
                }
                
                else{
                    
                    [DictRequest setObject:Proxy_WS_ClientCode_LIVE forKey:@"ClientCode"];
                    [DictRequest setObject:Proxy_WS_AccountName_LIVE forKey:@"AccountName"];
                    [DictRequest setObject:Proxy_WS_Password_LIVE forKey:@"Password"];
                    
                }
                [DictRequest setObject:@"GB" forKey:@"ISOCountryCode"];
                [DictRequest setObject:@"GBP" forKey:@"ISOCurrencyCode"];
                [DictRequest setObject:@"EN" forKey:@"ISOLanguageCode"];
                [DictRequest setObject:@"10" forKey:@"VehicleTypeCode"];
                [DictRequest setObject:modelCode forKey:@"ModelCode"];
                
                [DictRequest setObject:strProductionPeriodDate forKey:@"RequestedProductionDate"];
                // [DictRequest setObject:@"2004-11" forKey:@"RequestedProductionDate"];//ask
                
                
                NSMutableDictionary *dicResponse;
                if (appDel.isTestMode) {
                    
                    dicResponse = [objWebServicesjson callJsonAPI:GetListBodyType_URL withDictionary:DictRequest];
                    
                }
                else{
                    
                    dicResponse = [objWebServicesjson callJsonAPI:GetListBodyType_URL_LIVE withDictionary:DictRequest];
                    
                }
                
                NSString *bodytype;
                
                if (aryData) {
                    
                    aryData = nil;
                    
                }
                
                aryData = [[NSMutableArray alloc] init];
                
                if (dicResponse) {
                    if ([dicResponse count]> 0) {
                        
                        [Flurry endTimedEvent:@"WS-P-GetListBodyType" withParameters:nil];
                        
                        if (dicBodyTypeValue) {
                            dicBodyTypeValue = nil;
                        }
                        
                        dicBodyTypeValue = [dicResponse mutableCopy];
                        
                        for (NSDictionary * dicValues in dicResponse) {
                            
                            if ([dicValues count] > 0 && [dicValues objectForKey:@"Name"]) {
                                
                                [arrBodyType addObject:[NSString stringWithFormat:@"%@",[dicValues objectForKey:@"Name"]]];
                            }
                            
                            bodytype = [NSString stringWithFormat:@"%@",[dicValues objectForKey:@"Code"]];
                            
                            // [self CalculateGetListTypeEx:bodytype];
                        }
                        
                        if ([arrBodyType count] > 0) {
                            
                            NSSortDescriptor * dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
                            [arrBodyType sortUsingDescriptors:[NSArray arrayWithObjects:dateDescriptor,nil]];
                            aryPickerData = nil;
                            aryPickerData = [[NSMutableArray alloc] init];
                            aryPickerData = [arrBodyType mutableCopy];
                            [pickerView reloadAllComponents];
                            
                            NSString *str = [NSString stringWithFormat:@"%@",lblBodytype.text];
                            if ([arrBodyType containsObject:str]) {
                                
                                int selectedRowIndex = [arrBodyType indexOfObject:str];
                                [pickerView selectRow:selectedRowIndex inComponent:0 animated:NO];
                                self.strSelectedItem = str;
                            }
                            else{
                                
                                self.strSelectedItem = [aryPickerData objectAtIndex:0];
                                [pickerView selectRow:0 inComponent:0 animated:NO];
                            }
                            
                            //                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            //                            [defaults setObject:self.strSelectedItem  forKey:@"prefBodytype"];
                            //                            [defaults synchronize];
                            
                            
                            
                            /*Store Model Val*/
                            [[NSUserDefaults standardUserDefaults] setObject:arrBodyType forKey:@"prefdictBodytype"];
                            [[NSUserDefaults standardUserDefaults] setObject:dicBodyTypeValue forKey:@"prefdictBodytypeCode"];
                            /*Store Model Val*/
                            //                        /*mshau*/
                            //
                            viewPicker.hidden = FALSE;
                            
                            
                            [SVProgressHUD dismiss];
                            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                            
                            
                            
                        }
                        
                        [self setStatus:DoneBodyType];
                        
                    }
                    
                    else{
                        /*severerr*/
                        /*Error_Event*/
                        NSDictionary *flurryParams =
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"WS-P-GetListBodyType", @"ErrorLocation", 
                         @"No Result Found", @"Error",
                         nil];
                        
                        if(appDel.isFlurryOn)
                        {
                            //   [Flurry logEvent:@"Vehicle Search Tree - Error" withParameters:flurryParams];
                            NSError *error;
                            error = [NSError errorWithDomain:@"Vehicle Search Tree - GetListBodyType - No Result Found" code:200 userInfo:flurryParams];
                            
                            [Flurry logError:@"Vehicle Search Tree - GetListBodyType - No Result Found"   message:@"Vehicle Search Tree - GetListBodyType - No Result Found"  error:error];//m2806
                        }
                        /*Error_Event*/
                        
                        [Flurry endTimedEvent:@"WS-P-GetListBodyType" withParameters:nil];
                        viewPicker.hidden = TRUE;
                        viewInner.frame = CurrentFrame;
                        [SVProgressHUD dismiss];
                        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                        
                        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message: [NSString stringWithFormat:@"%@ %@.",ErrorConnection,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertError show];
                        alertError = nil;
                        
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictGetListType"];
                        
                        lblderivative.text = @"Derivative";
                        lblFuelType.text = @"Fuel Type";
                        lblTransmission.text = @"Transmission";
                        lblEngineSize.text = @"Engine Size";
                        
                        [btnderivative setEnabled:FALSE];
                        [btnfueltype setEnabled:FALSE];
                        [btntransmission setEnabled:FALSE];
                        [btnenginesize setEnabled:FALSE];
                        
                        
                        
                    }
                    
                }
                else{
                    /*severerr*/
                    /*Error_Event*/
                    NSDictionary *flurryParams =
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"WS-P-GetListBodyType", @"ErrorLocation", 
                     @"Server Error", @"Error",
                     nil];
                    if(appDel.isFlurryOn)
                    {
                        //[Flurry logEvent:@"Vehicle Search Tree - Error" withParameters:flurryParams];
                        NSError *error;
                        error = [NSError errorWithDomain:@"Vehicle Search Tree - GetListBodyType - Server Error" code:200 userInfo:flurryParams];
                        [Flurry logError:@"Vehicle Search Tree - GetListBodyType - Server Error"   message:@"Vehicle Search Tree - GetListBodyType - Server Error"   error:error];//m2806
                    }
                    /*Error_Event*/
                    
                    [Flurry endTimedEvent:@"WS-P-GetListBodyType" withParameters:nil];
                    viewPicker.hidden = TRUE;
                    viewInner.frame = CurrentFrame;
                    [SVProgressHUD dismiss];
                    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                    
                    UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message: [NSString stringWithFormat:@"%@ %@.",ErrorInResponse,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertError show];
                    alertError = nil;
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictGetListType"];
                    
                    lblderivative.text = @"Derivative";
                    lblFuelType.text = @"Fuel Type";
                    lblTransmission.text = @"Transmission";
                    lblEngineSize.text = @"Engine Size";
                    
                    [btnderivative setEnabled:FALSE];
                    [btnfueltype setEnabled:FALSE];
                    [btntransmission setEnabled:FALSE];
                    [btnenginesize setEnabled:FALSE];
                    
                    
                }
                
                
                
                
            }
            else{
                
                viewPicker.hidden = TRUE;
                viewInner.frame = CurrentFrame;
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
                UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertError show];
                alertError = nil;
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictGetListType"];
                
                lblderivative.text = @"Derivative";
                lblFuelType.text = @"Fuel Type";
                lblTransmission.text = @"Transmission";
                lblEngineSize.text = @"Engine Size";
                
                [btnderivative setEnabled:FALSE];
                [btnfueltype setEnabled:FALSE];
                [btntransmission setEnabled:FALSE];
                [btnenginesize setEnabled:FALSE];
                
            }
            
            
        }
        
    }
    @catch (NSException *exception) {
        
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"WS-P-GetListBodyType", @"ErrorLocation", 
         exception.description, @"Error",
         nil];
        
        
        if(appDel.isFlurryOn)
        {
            //[Flurry logEvent:@"Vehicle Search Tree - Body Type" withParameters:flurryParams];
            NSError *error;
            error = [NSError errorWithDomain:@"Vehicle Search Tree - GetListBodyType - Exception" code:200 userInfo:flurryParams];
            
            [Flurry logError:@"Vehicle Search Tree - GetListBodyType - Exception"   message:@"Vehicle Search Tree - GetListBodyType - Exception"  error:error];//m2806
        }
        
        [Flurry endTimedEvent:@"WS-P-GetListBodyType" withParameters:nil];
        
        NSLog(@"exception : %@",exception);
    }
    @finally {
        
    }
    
}

-(void)CalculateGetListTypeEx
{
    
    // This will call WS call to get All Derivative,Fuel,Transmission and Engine size value
    // Values will be fetched with Selected criteria for Make and Model and body type
    
    @try {
        
        NSArray *arrLastGetListType;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:@"prefdictGetListType"];
        
        if (data) {
            
            arrLastGetListType = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        NSString *strLastBodyType = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefBodytype"];
        NSString *strLastModel = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefModel"];
        NSString *strLastMake = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefMake"];
        
        
        if (arrLastGetListType && [arrLastGetListType count] > 0  && [lblBodytype.text isEqualToString:strLastBodyType] && [lblmake.text isEqualToString:strLastMake] && [lblmodel.text isEqualToString:strLastModel]) {
            
            self.arrFinalResult =  [arrLastGetListType mutableCopy];
            
            [self setStatus:DoneRestAPICalls];
            
            
            
        }
        else if([arrLastGetListType count] == 0 || ([arrLastGetListType count] > 0  && (![lblBodytype.text isEqualToString:strLastBodyType] || ![lblmake.text isEqualToString:strLastMake] || ![lblmodel.text isEqualToString:strLastModel])) ){
            
            if (appDel.isOnline) {
                
                
                if (self.arrFinalResult) {
                    
                    self.arrFinalResult = nil;
                    self.arrFinalResult = [[NSMutableArray alloc] init];
                }
                
                if ([dicWithSelectedCode count] > 0) {
                    
                    NSString *makeCode = [dicWithSelectedCode objectForKey:@"Make"];
                    NSString *modelCode = [dicWithSelectedCode objectForKey:@"Model"];
                    
                    NSString *BodyCode;
                    for (NSDictionary *dic in dicBodyTypeValue) {
                        
                        if ([[dic objectForKey:@"Name"] isEqualToString:lblBodytype.text]) {
                            
                            BodyCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Code"]];
                            [dicWithSelectedCode setObject:BodyCode forKey:@"BodyType"];
                            break;
                        }
                        
                    }
                    
                    NSString *strBodyType = BodyCode;
                    
                    if(arrDerivativeValue)
                    {
                        arrDerivativeValue=nil;
                    }
                    
                    NSString *strMonth = nil;
                    int currentPlateIndex;
                    for(int i=0;i<[self.arrPlates count];i++)
                    {
                        if([lblPlate.text isEqualToString:[self.arrPlates objectAtIndex:i]])
                        {
                            currentPlateIndex = i;
                            break;
                        }
                    }
                    if([lblYear.text intValue]<=2000)
                    {
                        if(currentPlateIndex == 0)
                            strMonth = @"1";
                        else if(currentPlateIndex == 1)
                            strMonth = @"5";
                        else
                            strMonth = @"11";
                    }
                    else
                    {
                        if(currentPlateIndex == 0)
                            
                            strMonth = @"1";
                        
                        else if(currentPlateIndex == 1)
                            strMonth = @"6";
                        else
                            strMonth = @"12";
                        
                    }
                    
                    if(appDel.isFlurryOn)
                    {
                        
                        [Flurry logEvent:@"WS-P-GetListTypeEx" timed:YES];
                    }
                    
                    
                    NSString *strProductionPeriodDate = [NSString stringWithFormat:@"%@-%@",lblYear.text,strMonth];
                    
                    NSMutableDictionary *DictReq1 = [[NSMutableDictionary alloc] init];
                    
                    if (appDel.isTestMode) {
                        
                        [DictReq1 setObject:Proxy_WS_ClientCode forKey:@"ClientCode"];
                        [DictReq1 setObject:Proxy_WS_AccountName forKey:@"AccountName"];
                        [DictReq1 setObject:Proxy_WS_Password forKey:@"Password"];
                        
                    }
                    
                    else{
                        
                        [DictReq1 setObject:Proxy_WS_ClientCode_LIVE forKey:@"ClientCode"];
                        [DictReq1 setObject:Proxy_WS_AccountName_LIVE forKey:@"AccountName"];
                        [DictReq1 setObject:Proxy_WS_Password_LIVE forKey:@"Password"];
                        
                    }
                    
                    [DictReq1 setObject:@"GB" forKey:@"ISOCountryCode"];
                    [DictReq1 setObject:@"GBP" forKey:@"ISOCurrencyCode"];
                    [DictReq1 setObject:@"EN" forKey:@"ISOLanguageCode"];
                    
                    [DictReq1 setObject:strBodyType  forKey:@"BodyStyleCode"];
                    [DictReq1 setObject:@"-1"  forKey:@"DriveTypeCode"];
                    [DictReq1 setObject:@"-1"  forKey:@"FuelTypeCode"];
                    [DictReq1 setObject:makeCode forKey:@"MakeCode"];
                    [DictReq1 setObject:modelCode forKey:@"ModelCode"];
                    [DictReq1 setObject:strProductionPeriodDate forKey:@"ProductionPeriodDate"];
                    
                    [DictReq1 setObject:@"-1" forKey:@"TransmissionCode"];
                    [DictReq1 setObject:@"10" forKey:@"VehicleTypeCode"];
                    
                    NSArray *aryResponse;
                    if (appDel.isTestMode) {
                        
                        aryResponse = [objWebServicesjson callJsonAPIForAryReponse:GetListTypeEx_URL withDictionary:DictReq1];
                        
                    }
                    else{
                        
                        aryResponse = [objWebServicesjson callJsonAPIForAryReponse:GetListTypeEx_URL_LIVE withDictionary:DictReq1];
                        
                    }
                    
                    if (aryResponse) {
                        
                        if ([aryResponse count]> 0) {
                            
                            self.arrFinalResult = [aryResponse mutableCopy];
                            
                            
                            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:aryResponse];
                            [[NSUserDefaults standardUserDefaults ] setObject:data forKey:@"prefdictGetListType"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            [SVProgressHUD dismiss];
                            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                            
                            
                            [self setStatus:DoneRestAPICalls];
                            
                        }
                        
                        else{
                            
                            
                            lblFuelType.text = @"Fuel Type";
                            lblTransmission.text = @"Transmission";
                            lblEngineSize.text = @"Engine Size";
                            
                            [btnfueltype setEnabled:FALSE];
                            [btntransmission setEnabled:FALSE];
                            [btnenginesize setEnabled:FALSE];
                            
                            
                            [btnfueltype setEnabled:FALSE];
                            [btnenginesize setEnabled:FALSE];
                            [btntransmission setEnabled:FALSE];
                            
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictGetListType"];
                            
                            NSDictionary *flurryParams =
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"WS-P-GetListTypeEx", @"ErrorLocation",
                             @"No Result Found", @"Error",
                             nil];
                            
                            if(appDel.isFlurryOn)
                            {
                                NSError *error;
                                error = [NSError errorWithDomain:@"Vehicle Search Tree - GetListTypeEx - No Result Found"  code:200 userInfo:flurryParams];
                                
                                [Flurry logError:@"Vehicle Search Tree - GetListTypeEx - No Result Found"   message:@"Vehicle Search Tree - GetListTypeEx - No Result Found"  error:error];
                            }
                            
                            
                            [Flurry endTimedEvent:@"WS-P-GetListTypeEx" withParameters:nil];
                            
                            viewPicker.hidden = TRUE;
                            
                            viewInner.frame = CurrentFrame;
                            [SVProgressHUD dismiss];
                            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                            
                            UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message: [NSString stringWithFormat:@"%@ %@.",ErrorConnection,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [alertError show];
                            alertError = nil;
                            return;
                            
                        }
                        
                    }
                    else{
                        
                        lblFuelType.text = @"Fuel Type";
                        lblTransmission.text = @"Transmission";
                        lblEngineSize.text = @"Engine Size";
                        
                        [btnfueltype setEnabled:FALSE];
                        [btntransmission setEnabled:FALSE];
                        [btnenginesize setEnabled:FALSE];
                        
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictGetListType"];
                        
                        NSDictionary *flurryParams =
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"WS-P-GetListTypeEx", @"ErrorLocation",
                         @"Server Error", @"Error",
                         nil];
                        
                        if(appDel.isFlurryOn)
                        {
                            NSError *error;
                            error = [NSError errorWithDomain:@"Vehicle Search Tree - GetListTypeEx - Server Error" code:200 userInfo:flurryParams];
                            
                            [Flurry logError:@"Vehicle Search Tree - GetListTypeEx - Server Error"   message:@"Vehicle Search Tree - GetListTypeEx - Server Error" error:error];
                        }
                        
                        /*Error_Event*/
                        [Flurry endTimedEvent:@"WS-P-GetListTypeEx" withParameters:nil];
                        /*Server Error*/
                        viewPicker.hidden = TRUE;
                        viewInner.frame = CurrentFrame;
                        [SVProgressHUD dismiss];
                        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                        
                        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message: [NSString stringWithFormat:@"%@ %@.",ErrorInResponse,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertError show];
                        alertError = nil;
                        return;
                        
                    }
                }
                
            }
            else{
                
                lblFuelType.text = @"Fuel Type";
                lblTransmission.text = @"Transmission";
                lblEngineSize.text = @"Engine Size";
                
                [btnfueltype setEnabled:FALSE];
                [btntransmission setEnabled:FALSE];
                [btnenginesize setEnabled:FALSE];
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictGetListType"];
                
                
                viewPicker.hidden = TRUE;
                viewInner.frame = CurrentFrame;
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
                UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertError show];
                alertError = nil;
                
                return;
                
            }
            
        }
        
    }
    @catch (NSException *exception) {
        
        [Flurry endTimedEvent:@"WS-P-GetListTypeEx" withParameters:nil];
        [SVProgressHUD dismiss];
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"WS-P-GetListTypeEx", @"ErrorLocation", 
         exception.description, @"Error",
         nil];
        if(appDel.isFlurryOn)
        {
            // [Flurry logEvent:@"Vehicle Search Tree - GetListTypeEx" withParameters:flurryParams];
            
            NSError *error;
            error = [NSError errorWithDomain:@"Vehicle Search Tree - GetListTypeEx - Exception" code:200 userInfo:flurryParams];
            
            [Flurry logError:@"Vehicle Search Tree - GetListTypeEx - Exception"   message:@"Vehicle Search Tree - GetListTypeEx - Exception"  error:error];//m2806
        }
        
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
        
        
    }
    
}

-(void)CalculateDerivative
{
    
    // This will Filter All Derivative values from array
    // All Null Derivative will also get consider
    
    
    @try {
        
        arrDerivativeValue = [[NSMutableArray alloc] init];
        
        for (NSDictionary * dicValues in self.arrFinalResult) {
            
            if(![[dicValues objectForKey:@"typeField"] isKindOfClass:[NSNull class]])
            {
                
                NSString *strDerivative = [NSString stringWithFormat:@"%@",[[dicValues objectForKey:@"typeField"] objectForKey:@"trimLineNameField"]];
                
                if ([[[dicValues objectForKey:@"typeField"] objectForKey:@"trimLineNameField"] isKindOfClass:[NSNull class]])
                {
                    strDerivative = @"N/A";
                }
                
                if (![arrDerivativeValue containsObject:strDerivative]) {
                    
                    [arrDerivativeValue addObject:strDerivative];
                }
                
            }
        }
        
        
        if ([arrDerivativeValue count] > 0) {
            
            NSSortDescriptor * dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
            
            NSArray * descriptors = [NSArray arrayWithObjects:dateDescriptor, nil];
            arrDerivativeValue = (NSMutableArray *)[arrDerivativeValue sortedArrayUsingDescriptors:descriptors];
            
            aryPickerData = [[NSMutableArray alloc] init];
            aryPickerData = [arrDerivativeValue mutableCopy];
            
            if ([aryPickerData containsObject:@"N/A"]) {
                
                [aryPickerData removeObject:@"N/A"];
            }
            
            [pickerView reloadAllComponents];
            
            if ([aryPickerData count] > 0) {
                
                NSString *str = [NSString stringWithFormat:@"%@",lblderivative.text];
                if ([aryPickerData containsObject:str]) {
                    
                    int selectedRowIndex = [aryPickerData indexOfObject:str];
                    [pickerView selectRow:selectedRowIndex inComponent:0 animated:NO];
                    self.strSelectedItem = str;
                    
                    
                    
                }
                else{
                    
                    self.strSelectedItem = [aryPickerData objectAtIndex:0];
                    
                    
                    [pickerView selectRow:0 inComponent:0 animated:NO];
                    
                }
                NSDictionary *flurryParams =
                [NSDictionary dictionaryWithObjectsAndKeys:
                 self.strSelectedItem, @"Derivative", 
                 nil];
                if(appDel.isFlurryOn)
                {
                    [Flurry logEvent:@"Vehicle Search Tree - Derivative" withParameters:flurryParams];
                }
                lblderivative.text=self.strSelectedItem;
                viewPicker.hidden = FALSE;
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
                
            }
            else{
                /*Error_Event*/
                NSDictionary *flurryParams =
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"WS-P-Derivative", @"ErrorLocation", 
                 @"No Result Found", @"Error",
                 nil];
                
                if(appDel.isFlurryOn)
                {
                    //[Flurry logEvent:@"Vehicle Search Tree - Error" withParameters:flurryParams];
                    NSError *error;
                    error = [NSError errorWithDomain:@"Vehicle Search Tree - Derivative - No Result Found" code:200 userInfo:flurryParams];
                    
                    [Flurry logError:@"Vehicle Search Tree - Derivative - No Result Found"   message:@"Vehicle Search Tree - Derivative - No Result Found"  error:error];//m2806
                }
                
                /*Error_Event*/
                
                [SVProgressHUD showErrorWithStatus:@"No Derivative Found"];
                
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
            }
            
            if ([arrDerivativeValue count] > 0) {
                
                btnderivative.enabled = TRUE;
                btnfueltype.enabled = TRUE;
                btntransmission.enabled = TRUE;
                btnenginesize.enabled = TRUE;
                
                viewPicker.hidden = FALSE;
                btnFind.enabled = TRUE;
                
            }
            
            
        }
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"exception : %@",exception);
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
        
        
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"WS-P-Derivative", @"ErrorLocation", 
         exception.description, @"Error",
         nil];
        
        
        if(appDel.isFlurryOn)
        {
            NSError *error;
            error = [NSError errorWithDomain:@"Vehicle Search Tree - Derivative - Exception" code:200 userInfo:flurryParams];
            
            [Flurry logError:@"Vehicle Search Tree - Derivative - Exception"   message:@"Vehicle Search Tree - Derivative - Exception"  error:error];
        }
    }
    @finally {
        
    }
    
    
}
-(void)CalculateFuel
{
    @try {
        
        // This will Filter All Fuel values from array, Filtered by Selected Derivative
        // All Null Derivative AND Fuel will also get consider

        
        NSMutableArray *arrFuelValue = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dicResult in self.arrFinalResult) {
            
            if (![[[dicResult objectForKey:@"typeField"] objectForKey:@"trimLineNameField"] isKindOfClass:[NSNull class]] ) {
                
                if ([[[dicResult objectForKey:@"typeField"] objectForKey:@"trimLineNameField"] isEqualToString:lblderivative.text]) {
                    
                    if (![[[[dicResult objectForKey:@"engineField"] objectForKey:@"fuelField"]objectForKey:@"nameExField"] isKindOfClass:[NSNull class]]) {
                        
                        NSString *strFuel = [NSString stringWithFormat:@"%@",[[[dicResult objectForKey:@"engineField"] objectForKey:@"fuelField"]objectForKey:@"nameExField"]];
                        
                        if (![arrFuelValue containsObject:strFuel]) {
                            
                            [arrFuelValue addObject:strFuel];
                            
                        }
                        
                    }
                    
                }
                
            }
            else{
                
                if (![[[[dicResult objectForKey:@"engineField"] objectForKey:@"fuelField"]objectForKey:@"nameExField"] isKindOfClass:[NSNull class]]) {
                    
                    NSString *strFuel = [NSString stringWithFormat:@"%@",[[[dicResult objectForKey:@"engineField"] objectForKey:@"fuelField"]objectForKey:@"nameExField"]];
                    
                    if (![arrFuelValue containsObject:strFuel]) {
                        
                        [arrFuelValue addObject:strFuel];
                        
                    }
                    
                }
                
            }
            
        }
        
        
        if ([arrFuelValue count] > 0) {
            
            NSSortDescriptor * dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
            NSArray * descriptors = [NSArray arrayWithObjects:dateDescriptor, nil];
            NSArray *arrSortedFuel = [arrFuelValue sortedArrayUsingDescriptors:descriptors];
            
            aryPickerData = [[NSMutableArray alloc] init];
            
            //            NSSortDescriptor * dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
            //            [arrFuelValue sortUsingDescriptors:[NSArray arrayWithObjects:dateDescriptor,nil]];
            
            aryPickerData = [arrSortedFuel mutableCopy];
            [pickerView reloadAllComponents];
            
            NSString *str = [NSString stringWithFormat:@"%@",lblFuelType.text];
            if ([arrSortedFuel containsObject:str]) {
                
                int selectedRowIndex = [arrSortedFuel indexOfObject:str];
                [pickerView selectRow:selectedRowIndex inComponent:0 animated:NO];
                self.strSelectedItem = str;
                
                
                
                
            }
            else{
                
                self.strSelectedItem = [aryPickerData objectAtIndex:0];
                
                
                [pickerView selectRow:0 inComponent:0 animated:NO];
            }
            
            //            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //            [defaults setObject:self.strSelectedItem  forKey:@"prefFuelType"];
            //            [defaults synchronize];
            
            
            //            [[NSUserDefaults standardUserDefaults] setObject:arrFuelValue forKey:@"prefdictFuelType"];
            
            //            /*mshau*/
            NSDictionary *flurryParams =
            [NSDictionary dictionaryWithObjectsAndKeys:
             self.strSelectedItem, @"Fuel Type", 
             nil];
            if(appDel.isFlurryOn)
            {
                [Flurry logEvent:@"Vehicle Search Tree - Fuel Type" withParameters:flurryParams];
            }
            //            /*mshau*/
            
            // lblFuelType.text = self.strSelectedItem;
            [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
            
        }
        else
        {
            
            [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
            
            
            /*severerr*/
            /*Error_Event*/
            NSDictionary *flurryParams =
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"WS-P-Fuel", @"ErrorLocation", 
             @"No Result Found", @"Error",
             nil];
            if(appDel.isFlurryOn)
            {
                //[Flurry logEvent:@"Vehicle Search Tree - Error" withParameters:flurryParams];
                NSError *error;
                error = [NSError errorWithDomain:@"Vehicle Search Tree - FuelType - No Result Found" code:200 userInfo:flurryParams];
                [Flurry logError:@"Vehicle Search Tree - FuelType - No Result Found"    message:@"Vehicle Search Tree - FuelType - No Result Found"   error:error];//m2806
            }
            /*Error_Event*/
            /*severerr*/
            
        }
        viewPicker.hidden = FALSE;
        //        [btnTransmission setEnabled:TRUE];
        //        imgTransmission.alpha=1;
        
    }
    @catch (NSException *exception) {
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
        
        NSLog(@"exception : %@",exception);
        
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"WS-P-Fuel", @"ErrorLocation", 
         exception.description, @"Error",
         nil];
        
        
        if(appDel.isFlurryOn)
        {
            NSError *error;
            error = [NSError errorWithDomain:@"Vehicle Search Tree - Fuel Type - Exception" code:200 userInfo:flurryParams];
            
            [Flurry logError:@"Vehicle Search Tree - FuelType - Exception"    message:@"Vehicle Search Tree - Fuel Type - Exception"  error:error];
        }
        
    }
    @finally {
        
    }
    
    
}
-(void)CalculateTransmission
{
    
    @try {
        
        // This will Filter All Transmission values from array, Filtered by Selected Derivative and Fuel
        // All Null Derivative AND Fuel AND Transmission will also get consider
        
        NSMutableArray *arrTransmissionValue = [[NSMutableArray alloc] init];
        
        
        for (NSDictionary *dicResult in self.arrFinalResult) {
            
            if (![[[dicResult objectForKey:@"typeField"] objectForKey:@"trimLineNameField"] isKindOfClass:[NSNull class]] && ![[[[dicResult objectForKey:@"engineField"] objectForKey:@"fuelField"]objectForKey:@"nameExField"] isKindOfClass:[NSNull class]]) {
                
                if ([[[dicResult objectForKey:@"typeField"] objectForKey:@"trimLineNameField"] isEqualToString:lblderivative.text] && [[[[dicResult objectForKey:@"engineField"] objectForKey:@"fuelField"]objectForKey:@"nameExField"] isEqualToString:lblFuelType.text]) {
                    
                    if (![[[[[dicResult objectForKey:@"transmissionField"] objectForKey:@"gearBoxField"]objectForKey:@"typeField"]objectForKey:@"nameExField"] isKindOfClass:[NSNull class]]) {
                        
                        NSString *strTransmission = [NSString stringWithFormat:@"%@",[[[[dicResult objectForKey:@"transmissionField"] objectForKey:@"gearBoxField"]objectForKey:@"typeField"]objectForKey:@"nameExField"]];
                        
                        if (![arrTransmissionValue containsObject:strTransmission]) {
                            
                            [arrTransmissionValue addObject:strTransmission];
                            
                        }
                        
                    }
                    
                }
                
            }
            else if([[[dicResult objectForKey:@"typeField"] objectForKey:@"trimLineNameField"] isKindOfClass:[NSNull class]] && [[[[dicResult objectForKey:@"engineField"] objectForKey:@"fuelField"]objectForKey:@"nameExField"] isKindOfClass:[NSNull class]])
            {
                
                if (![[[[[dicResult objectForKey:@"transmissionField"] objectForKey:@"gearBoxField"]objectForKey:@"typeField"]objectForKey:@"nameExField"] isKindOfClass:[NSNull class]]) {
                    
                    NSString *strTransmission = [NSString stringWithFormat:@"%@",[[[[dicResult objectForKey:@"transmissionField"] objectForKey:@"gearBoxField"]objectForKey:@"typeField"]objectForKey:@"nameExField"]];
                    
                    if (![arrTransmissionValue containsObject:strTransmission]) {
                        
                        [arrTransmissionValue addObject:strTransmission];
                        
                    }
                    
                }
                
                
            }
            
        }
        
        
        if ([arrTransmissionValue count] > 0) {
            
            NSSortDescriptor * dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
            NSArray * descriptors = [NSArray arrayWithObjects:dateDescriptor, nil];
            NSArray *arrSortedTransmission = [arrTransmissionValue sortedArrayUsingDescriptors:descriptors];
            
            
            aryPickerData = [[NSMutableArray alloc] init];
            
            //            NSSortDescriptor * dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
            //            [arrTransmissionValue sortUsingDescriptors:[NSArray arrayWithObjects:dateDescriptor,nil]];
            
            
            aryPickerData = [arrSortedTransmission mutableCopy];
            [pickerView reloadAllComponents];
            
            NSString *str = [NSString stringWithFormat:@"%@",lblTransmission.text];
            
            if ([arrSortedTransmission containsObject:str]) {
                
                int selectedRowIndex = [arrSortedTransmission indexOfObject:str];
                [pickerView selectRow:selectedRowIndex inComponent:0 animated:NO];
                self.strSelectedItem = str;
                
                
                
                
            }
            else{
                
                self.strSelectedItem = [aryPickerData objectAtIndex:0];
                [pickerView selectRow:0 inComponent:0 animated:NO];
            }
            
            
           [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
            
        }
        else
        {
            
            [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
            
            
            /*severerr*/
            /*Error_Event*/
            NSDictionary *flurryParams =
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"WS-P-Transmission", @"ErrorLocation", 
             @"No Result Found", @"Error",
             nil];
            if(appDel.isFlurryOn)
            {
                NSError *error;
                error = [NSError errorWithDomain:@"Vehicle Search Tree - Transmission - No Result Found" code:200 userInfo:flurryParams];
                [Flurry logError:@"Vehicle Search Tree - Transmission - No Result Found"  message:@"Vehicle Search Tree - Transmission - No Result Found"  error:error];//m2806
            }
            
            /*Error_Event*/
            /*severerr*/
        }
        viewPicker.hidden = FALSE;
        //        [btnEngineSize setEnabled:TRUE];
        //        imgEngineSize.alpha=1;
        
    }
    @catch (NSException *exception) {
        
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
        
        
        NSLog(@"exception : %@",exception);
        
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"WS-P-Transmission", @"ErrorLocation",
         exception.description, @"Error",
         nil];
        if(appDel.isFlurryOn)
        {
            NSError *error;
            error = [NSError errorWithDomain:@"Vehicle Search Tree - Transmission - Exception" code:200 userInfo:flurryParams];
            [Flurry logError:@"Vehicle Search Tree - Transmission - Exception"   message:@"Vehicle Search Tree - Transmission - Exception"  error:error];
        }
    }
    @finally {
        
    }
    
    
    
}

-(void)CalculateEngineSize
{
    
    @try {
        
        // This will Filter All Engine Size values from array, Filtered by Selected Derivative and Fuel and Transmission 
        // All Null Derivative AND Fuel AND Transmission AND Engine Size will also get consider
        
        NSMutableArray *arrEngineSizeValue = [[NSMutableArray alloc] init];
        
        
        for (NSDictionary *dicResult in self.arrFinalResult) {
            
            if (![[[dicResult objectForKey:@"typeField"] objectForKey:@"trimLineNameField"] isKindOfClass:[NSNull class]] && ![[[[dicResult objectForKey:@"engineField"] objectForKey:@"fuelField"]objectForKey:@"nameExField"] isKindOfClass:[NSNull class]] && ![[[[[dicResult objectForKey:@"transmissionField"] objectForKey:@"gearBoxField"]objectForKey:@"typeField"]objectForKey:@"nameExField"] isKindOfClass:[NSNull class]]) {
                
                if ([[[dicResult objectForKey:@"typeField"] objectForKey:@"trimLineNameField"] isEqualToString:lblderivative.text] && [[[[dicResult objectForKey:@"engineField"] objectForKey:@"fuelField"]objectForKey:@"nameExField"] isEqualToString:lblFuelType.text] && [[[[[dicResult objectForKey:@"transmissionField"] objectForKey:@"gearBoxField"]objectForKey:@"typeField"]objectForKey:@"nameExField"] isEqualToString:lblTransmission.text]) {
                    
                    if (![[[[dicResult objectForKey:@"engineField"] objectForKey:@"displacementField"]objectForKey:@"valueField"] isKindOfClass:[NSNull class]]) {
                        
                        NSString *strEngineSize = [NSString stringWithFormat:@"%@ cc",[[[dicResult objectForKey:@"engineField"] objectForKey:@"displacementField"]objectForKey:@"valueField"]];
                        
                        if (![arrEngineSizeValue containsObject:strEngineSize]) {
                            
                            [arrEngineSizeValue addObject:strEngineSize];
                            
                        }
                        
                    }
                    
                }
                
            }
            else if ([[[dicResult objectForKey:@"typeField"] objectForKey:@"trimLineNameField"] isKindOfClass:[NSNull class]] && [[[[dicResult objectForKey:@"engineField"] objectForKey:@"fuelField"]objectForKey:@"nameExField"] isKindOfClass:[NSNull class]] && [[[[[dicResult objectForKey:@"transmissionField"] objectForKey:@"gearBoxField"]objectForKey:@"typeField"]objectForKey:@"nameExField"] isKindOfClass:[NSNull class]])
            {
                
                if (![[[[dicResult objectForKey:@"engineField"] objectForKey:@"displacementField"]objectForKey:@"valueField"] isKindOfClass:[NSNull class]]) {
                    
                    NSString *strEngineSize = [NSString stringWithFormat:@"%@ cc",[[[dicResult objectForKey:@"engineField"] objectForKey:@"displacementField"]objectForKey:@"valueField"]];
                    
                    if (![arrEngineSizeValue containsObject:strEngineSize]) {
                        
                        [arrEngineSizeValue addObject:strEngineSize];
                        
                        
                    }
                    
                }
            }
            
            
        }
        
        
        
        if ([arrEngineSizeValue count] > 0) {
            
            NSSortDescriptor * dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
            NSArray * descriptors = [NSArray arrayWithObjects:dateDescriptor, nil];
            NSArray *arrSortedEngineSize = [arrEngineSizeValue sortedArrayUsingDescriptors:descriptors];
            
            aryPickerData = [[NSMutableArray alloc] init];
            
            
            aryPickerData = [arrSortedEngineSize mutableCopy];
            [pickerView reloadAllComponents];
            
            NSString *str = [NSString stringWithFormat:@"%@",lblEngineSize.text];
            if ([arrSortedEngineSize containsObject:str]) {
                
                int selectedRowIndex = [arrSortedEngineSize indexOfObject:str];
                [pickerView selectRow:selectedRowIndex inComponent:0 animated:NO];
                
                
                
                self.strSelectedItem = str;
                
            }
            else{
                
                self.strSelectedItem = [aryPickerData objectAtIndex:0];
                [pickerView selectRow:0 inComponent:0 animated:NO];
            }
            
            
            NSDictionary *flurryParams =
            [NSDictionary dictionaryWithObjectsAndKeys:
             self.strSelectedItem, @"Engine Size", nil];
            if(appDel.isFlurryOn)
            {
                [Flurry logEvent:@"Vehicle Search Tree - Engine Size" withParameters:flurryParams];
            }
            [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
            
        }
        
        else
        {
            
            [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
            
            
            /*Error_Event*/
            NSDictionary *flurryParams =
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"WS-P-EngineSize", @"ErrorLocation", 
             @"No Result Found", @"Error",
             nil];
            
            if(appDel.isFlurryOn)
            {
                NSError *error;
                error = [NSError errorWithDomain:@"Vehicle Search Tree - Enginesize - No Result Found" code:200 userInfo:flurryParams];
                [Flurry logError:@"Vehicle Search Tree - Enginesize - No Result Found"   message:@"Vehicle Search Tree - Enginesize - No Result Found"  error:error];
            }
        }
        
        viewPicker.hidden = FALSE;
        
    }
    @catch (NSException *exception) {
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
        
        
        NSLog(@"exception : %@",exception);
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"WS-P-EngineSize", @"ErrorLocation", 
         exception.description, @"Error",
         nil];
        
        
        if(appDel.isFlurryOn)
        {
            NSError *error;
            error = [NSError errorWithDomain:@"Vehicle Search Tree - Enginesize - Exception" code:200 userInfo:flurryParams];
            [Flurry logError:@"Vehicle Search Tree - Enginesize - Exception"   message:@"Vehicle Search Tree - Enginesize - Exception"  error:error];
        }
    }
    @finally {
        
    }
    
    
}
-(void)CalculateMakeValue {
    
    // This will Call Make WS with selected Year and Plate Value
    @try {
        
        NSArray *arrLastMakes = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefdictMakeValue"];
        NSString *strLastYear = [[NSUserDefaults standardUserDefaults] objectForKey:@"yr"];
        NSString *strLastPlate = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefPlate"];
        
        if (arrLastMakes && [arrLastMakes count] > 0  && [lblYear.text isEqualToString:strLastYear] && [lblPlate.text isEqualToString:strLastPlate]) {
            
            arrMakeValue = [arrLastMakes mutableCopy];
            dicMakeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefdictMakeCodeValue"];
            
            
            if ([arrMakeValue count] > 0) {
                
                NSSortDescriptor * dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
                [arrMakeValue sortUsingDescriptors:[NSArray arrayWithObjects:dateDescriptor,nil]];
                
                
                aryPickerData = nil;
                aryPickerData = [[NSMutableArray alloc] init];
                aryPickerData = [arrMakeValue mutableCopy];
                [pickerView reloadAllComponents];
                
                NSString *str = [NSString stringWithFormat:@"%@",lblmake.text];
                if ([arrMakeValue containsObject:str]) {
                    
                    int selectedRowIndex = [arrMakeValue indexOfObject:str];
                    [pickerView selectRow:selectedRowIndex inComponent:0 animated:NO];
                    self.strSelectedItem = str;
                    
                    
                    
                }
                else{
                    
                    self.strSelectedItem = [aryPickerData objectAtIndex:0];
                    
                    
                    
                    [pickerView selectRow:0 inComponent:0 animated:NO];
                }
                
                viewPicker.hidden = FALSE;
                [btnmodel setEnabled:TRUE];
                
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
            }
            return;
            
        }
        else if([arrLastMakes count] == 0 || ([arrLastMakes count] > 0  && (![lblYear.text isEqualToString:strLastYear] || ![lblPlate.text isEqualToString:strLastPlate])) ){
            
            if ([arrMakeValue count] > 0) {
                
                arrMakeValue = nil;
                arrMakeValue = [[NSMutableArray alloc] init];
            }
            
            if (appDel.isOnline) {
                
                
                NSString *strMonth = nil;
                int currentPlateIndex;
                for(int i=0;i<[self.arrPlates count];i++)
                {
                    if([lblPlate.text isEqualToString:[self.arrPlates objectAtIndex:i]])
                    {
                        currentPlateIndex = i;
                        break;
                    }
                }
                if([lblYear.text intValue]<=2000)
                {
                    if(currentPlateIndex == 0)
                        strMonth = @"1";
                    else if(currentPlateIndex == 1)
                        strMonth = @"5";
                    else
                        strMonth = @"11";
                }
                else
                {
                    if(currentPlateIndex == 0)
                        strMonth = @"1";
                    else if(currentPlateIndex == 1)
                        strMonth = @"6";
                    else
                        strMonth = @"12";
                    
                }
                
                
                if(appDel.isFlurryOn)
                {
                    
                    [Flurry logEvent:@"WS-P-GetListMake" timed:YES];
                }
                
                NSString *strProductionPeriodDate = [NSString stringWithFormat:@"%@-%@",lblYear.text,strMonth];
                
                
                NSMutableDictionary *DictRequest = [[NSMutableDictionary alloc] init];
                if (appDel.isTestMode) {
                    
                    [DictRequest setObject:Proxy_WS_ClientCode forKey:@"ClientCode"];
                    [DictRequest setObject:Proxy_WS_AccountName forKey:@"AccountName"];
                    [DictRequest setObject:Proxy_WS_Password forKey:@"Password"];
                    
                }
                
                else{
                    
                    [DictRequest setObject:Proxy_WS_ClientCode_LIVE forKey:@"ClientCode"];
                    [DictRequest setObject:Proxy_WS_AccountName_LIVE forKey:@"AccountName"];
                    [DictRequest setObject:Proxy_WS_Password_LIVE forKey:@"Password"];
                    
                }
                [DictRequest setObject:@"GB" forKey:@"ISOCountryCode"];
                [DictRequest setObject:@"GBP" forKey:@"ISOCurrencyCode"];
                [DictRequest setObject:@"EN" forKey:@"ISOLanguageCode"];
                [DictRequest setObject:@"10" forKey:@"VehicleTypeCode"];
                [DictRequest setObject:strProductionPeriodDate forKey:@"ProductionPeriodDate"];
                
                NSMutableDictionary *dicResponse;
                if (appDel.isTestMode) {
                    
                    dicResponse = [objWebServicesjson callJsonAPI:GetMakes_URL withDictionary:DictRequest];
                    
                }
                else{
                    
                    dicResponse = [objWebServicesjson callJsonAPI:GetMakes_URL_LIVE withDictionary:DictRequest];
                    
                }
                
                
                
                //        NSMutableDictionary *dicResponse = [objWebServicesjson callJsonAPIWithGetRequest:strURL];
                
                
                if (dicResponse) {
                    
                    if ([dicResponse count]> 0) {
                        
                        [Flurry endTimedEvent:@"WS-P-GetListMake" withParameters:nil];
                        
                        if (dicMakeValue) {
                            dicMakeValue = nil;
                        }
                        
                        dicMakeValue = [dicResponse mutableCopy];
                        
                        for (NSDictionary * dicValues in dicResponse) {
                            
                            if ([dicValues count] > 0 && [dicValues objectForKey:@"Name"]) {
                                
                                [arrMakeValue addObject:[NSString stringWithFormat:@"%@",[dicValues objectForKey:@"Name"]]];
                            }
                        }
                        
                        // }
                        
                        if ([arrMakeValue count] > 0) {
                            
                            NSSortDescriptor * dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
                            [arrMakeValue sortUsingDescriptors:[NSArray arrayWithObjects:dateDescriptor,nil]];
                            
                            
                            aryPickerData = nil;
                            aryPickerData = [[NSMutableArray alloc] init];
                            aryPickerData = [arrMakeValue mutableCopy];
                            [pickerView reloadAllComponents];
                            
                            NSString *str = [NSString stringWithFormat:@"%@",lblmake.text];
                            if ([arrMakeValue containsObject:str]) {
                                
                                int selectedRowIndex = [arrMakeValue indexOfObject:str];
                                [pickerView selectRow:selectedRowIndex inComponent:0 animated:NO];
                                self.strSelectedItem = str;
                                
                            }
                            else{
                                
                                self.strSelectedItem = [aryPickerData objectAtIndex:0];
                                
                                
                                
                                [pickerView selectRow:0 inComponent:0 animated:NO];
                            }
                            
                            viewPicker.hidden = FALSE;
                            
                            [SVProgressHUD dismiss];
                            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                            
                        }
                        
                        /*Store make Val*/
                        [[NSUserDefaults standardUserDefaults] setObject:arrMakeValue forKey:@"prefdictMakeValue"];
                        [[NSUserDefaults standardUserDefaults] setObject:dicMakeValue forKey:@"prefdictMakeCodeValue"];
                        /*Store make Val*/
                        
                        [self setStatus:DoneMake];
                        
                    }
                    
                    else{
                        
                        NSDictionary *flurryParams =
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"WS-P-GetListMake", @"ErrorLocation", 
                         @"No result Found", @"Error",
                         nil];
                        if(appDel.isFlurryOn)
                        {
                            
                            NSError *error;
                            error = [NSError errorWithDomain:@"Vehicle Search Tree - Make - No result Found"  code:200 userInfo:flurryParams];
                            [Flurry logError:@"Vehicle Search Tree - Make - No result Found"    message:@"Vehicle Search Tree - Make - No result Found"   error:error];//m2806
                        }
                        /*Error_Event*/
                        [Flurry endTimedEvent:@"WS-P-GetListMake" withParameters:nil];
                        
                        viewPicker.hidden = TRUE;
                        viewInner.frame = CurrentFrame;
                        [SVProgressHUD dismiss];
                        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                        
                        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message: [NSString stringWithFormat:@"%@ %@.",ErrorConnection,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertError show];
                        alertError = nil;
                        
                        
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefModel"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictModelValue"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictModelCodeValue"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefBodytype"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictBodytype"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictBodytypeCode"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictGetListType"];
                        
                        
                        
                        lblmodel.text = @"Model";
                        lblBodytype.text = @"Body Type";
                        lblderivative.text = @"Derivative";
                        lblFuelType.text = @"Fuel Type";
                        lblTransmission.text = @"Transmission";
                        lblEngineSize.text = @"Engine Size";
                        
                        [btnmodel setEnabled:FALSE];
                        [btnbodytype setEnabled:FALSE];
                        [btntransmission setEnabled:FALSE];
                        [btnenginesize setEnabled:FALSE];
                        [btnfueltype setEnabled:FALSE];
                        [btnderivative setEnabled:FALSE];
                        
                    }
                    
                }
                else{
                    /*severerr*/
                    /*Error_Event*/
                    NSDictionary *flurryParams =
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"WS-P-GetListMake", @"ErrorLocation", 
                     @"Server Error", @"Error",
                     nil];
                    if(appDel.isFlurryOn)
                    {
                        //  [Flurry logEvent:@"Vehicle Search Tree - Error" withParameters:flurryParams];
                        NSError *error;
                        error = [NSError errorWithDomain:@"Vehicle Search Tree - Make - Server Error"  code:200 userInfo:flurryParams];
                        [Flurry logError:@"Vehicle Search Tree - Make - Server Error"   message:@"Vehicle Search Tree - Make - Server Error"   error:error];
                        //m2806
                    }
                    /*Error_Event*/
                    [Flurry endTimedEvent:@"WS-P-GetListMake" withParameters:nil];
                    
                    
                    viewPicker.hidden = TRUE;
                    viewInner.frame = CurrentFrame;
                    [SVProgressHUD dismiss];
                    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                    
                    UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message: [NSString stringWithFormat:@"%@ %@.",ErrorInResponse,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertError show];
                    alertError = nil;
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefModel"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictModelValue"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictModelCodeValue"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefBodytype"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictBodytype"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictBodytypeCode"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictGetListType"];
                    
                    
                    lblmodel.text = @"Model";
                    lblBodytype.text = @"Body Type";
                    lblderivative.text = @"Derivative";
                    lblFuelType.text = @"Fuel Type";
                    lblTransmission.text = @"Transmission";
                    lblEngineSize.text = @"Engine Size";
                    
                    [btnmodel setEnabled:FALSE];
                    [btnbodytype setEnabled:FALSE];
                    [btntransmission setEnabled:FALSE];
                    [btnenginesize setEnabled:FALSE];
                    [btnfueltype setEnabled:FALSE];
                    [btnderivative setEnabled:FALSE];
                    
                    
                    
                }
                
                
                
            }
            else{
                
                viewPicker.hidden = TRUE;
                viewInner.frame = CurrentFrame;
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
                UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertError show];
                alertError = nil;
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefModel"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictModelValue"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictModelCodeValue"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefBodytype"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictBodytype"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictBodytypeCode"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictGetListType"];
                
                lblmodel.text = @"Model";
                lblBodytype.text = @"Body Type";
                lblderivative.text = @"Derivative";
                lblFuelType.text = @"Fuel Type";
                lblTransmission.text = @"Transmission";
                lblEngineSize.text = @"Engine Size";
                
                [btnmodel setEnabled:FALSE];
                [btnbodytype setEnabled:FALSE];
                [btntransmission setEnabled:FALSE];
                [btnenginesize setEnabled:FALSE];
                [btnfueltype setEnabled:FALSE];
                [btnderivative setEnabled:FALSE];
                
            }
            
            
        }
        
        
    }
    @catch (NSException *exception) {
        
        [Flurry endTimedEvent:@"WS-P-GetListMake" withParameters:nil];
        NSLog(@"exception : %@",exception);
        
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"WS-P-GetListMake", @"ErrorLocation", 
         exception.description, @"Error",
         nil];
        
        
        if(appDel.isFlurryOn)
        {
            NSError *error;
            error = [NSError errorWithDomain:@"Vehicle Search Tree - Make - Exception" code:200 userInfo:flurryParams];
            [Flurry logError:@"Vehicle Search Tree - Make - Exception"   message:@"Vehicle Search Tree - Make - Exception"  error:error];
        }
    }
    @finally {
        
    }
    
    
}

-(void)GetModelListFromMake{
    
    // This will Call Model WS with selected Year and Plate Value and Make code 
    @try {
        
        
        
        NSArray *arrLastModels = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefdictModelValue"];
        NSString *strLastMake = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefMake"];
        
        if (arrLastModels && [arrLastModels count] > 0  && [lblmake.text isEqualToString:strLastMake]) {
            
            
            arrModels = [arrLastModels mutableCopy];
            dicModelValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefdictModelCodeValue"];
            
            
            if ([arrModels count] > 0) {
                
                
                NSSortDescriptor * dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
                [arrModels sortUsingDescriptors:[NSArray arrayWithObjects:dateDescriptor,nil]];
                
                
                aryPickerData = nil;
                aryPickerData = [[NSMutableArray alloc] init];
                aryPickerData = [arrModels mutableCopy];
                
                [pickerView reloadAllComponents];
                
                NSString *str = [NSString stringWithFormat:@"%@",lblmodel.text];
                
                if ([arrModels containsObject:str]) {
                    
                    int selectedRowIndex = [arrModels indexOfObject:str];
                    [pickerView selectRow:selectedRowIndex inComponent:0 animated:NO];
                    self.strSelectedItem = str;
                    
                    
                }
                else{
                    
                    self.strSelectedItem = [aryPickerData objectAtIndex:0];
                    
                    
                    
                    [pickerView selectRow:0 inComponent:0 animated:NO];
                }
                
                viewPicker.hidden = FALSE;
                [btnbodytype setEnabled:TRUE];
                
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
                
                
            }
            
            NSString *makeCode;
            if ([dicMakeValue count] > 0) {
                
                NSString *strSelectedMake = lblmake.text;
                for (NSDictionary *dic in dicMakeValue) {
                    
                    if ([[dic objectForKey:@"Name"] isEqualToString:strSelectedMake]) {
                        
                        makeCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Code"]];
                        
                        [dicWithSelectedCode setObject:makeCode forKey:@"Make"];
                        
                        break;
                    }
                    
                }
                
                
            }
            
        }
        else if([arrLastModels count] == 0 || ([arrLastModels count] > 0  && (![lblmake.text isEqualToString:strLastMake])) ){
            
            if ([arrModels count] > 0) {
                
                arrModels = nil;
                arrModels = [[NSMutableArray alloc] init];
            }
            
            
            if (appDel.isOnline) {
                
                NSString *makeCode;
                if ([dicMakeValue count] > 0) {
                    
                    NSString *strSelectedMake = lblmake.text;
                    for (NSDictionary *dic in dicMakeValue) {
                        
                        if ([[dic objectForKey:@"Name"] isEqualToString:strSelectedMake]) {
                            
                            makeCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Code"]];
                            
                            [dicWithSelectedCode setObject:makeCode forKey:@"Make"];
                            
                            break;
                        }
                        
                    }
                    
                    
                }
                
                NSString *strMonth = nil;
                int currentPlateIndex;
                for(int i=0;i<[self.arrPlates count];i++)
                {
                    if([lblPlate.text isEqualToString:[self.arrPlates objectAtIndex:i]])
                    {
                        currentPlateIndex = i;
                        break;
                    }
                }
                if([lblYear.text intValue]<=2000)
                {
                    if(currentPlateIndex == 0)
                        strMonth = @"1";
                    else if(currentPlateIndex == 1)
                        strMonth = @"5";
                    else
                        strMonth = @"11";
                }
                else
                {
                    if(currentPlateIndex == 0)
                        strMonth = @"1";
                    else if(currentPlateIndex == 1)
                        strMonth = @"6";
                    else
                        strMonth = @"12";
                    
                }
                
                if(appDel.isFlurryOn)
                {
                    
                    [Flurry logEvent:@"WS-P-GetListModel" timed:YES];
                }
                
                
                
                
                NSString *strProductionPeriodDate = [NSString stringWithFormat:@"%@-%@",lblYear.text,strMonth];
                
                NSMutableDictionary *DictRequest = [[NSMutableDictionary alloc] init];
                if (appDel.isTestMode) {
                    
                    [DictRequest setObject:Proxy_WS_ClientCode forKey:@"ClientCode"];
                    [DictRequest setObject:Proxy_WS_AccountName forKey:@"AccountName"];
                    [DictRequest setObject:Proxy_WS_Password forKey:@"Password"];
                    
                }
                
                else{
                    
                    [DictRequest setObject:Proxy_WS_ClientCode_LIVE forKey:@"ClientCode"];
                    [DictRequest setObject:Proxy_WS_AccountName_LIVE forKey:@"AccountName"];
                    [DictRequest setObject:Proxy_WS_Password_LIVE forKey:@"Password"];
                    
                }
                [DictRequest setObject:@"GB" forKey:@"ISOCountryCode"];
                [DictRequest setObject:@"GBP" forKey:@"ISOCurrencyCode"];
                [DictRequest setObject:@"EN" forKey:@"ISOLanguageCode"];
                [DictRequest setObject:@"10" forKey:@"VehicleTypeCode"];
                [DictRequest setObject:makeCode forKey:@"MakeCode"];
                [DictRequest setObject:strProductionPeriodDate forKey:@"ProductionPeriodDate"];
                
                
                
                NSMutableDictionary *dicResponse;
                if (appDel.isTestMode) {
                    
                    dicResponse = [objWebServicesjson callJsonAPI:GetListModel_URL withDictionary:DictRequest];
                    
                }
                else{
                    
                    dicResponse = [objWebServicesjson callJsonAPI:GetListModel_URL_LIVE withDictionary:DictRequest];
                    
                }
                
                if (dicResponse) {
                    
                    if ([dicResponse count]> 0) {
                        
                        
                        [Flurry endTimedEvent:@"WS-P-GetListModel" withParameters:nil];
                        
                        
                        for (NSDictionary * dicValues in dicResponse) {
                            
                            if ([dicValues count] > 0 && [dicValues objectForKey:@"Name"]) {
                                
                                [arrModels addObject:[NSString stringWithFormat:@"%@",[dicValues objectForKey:@"Name"]]];
                            }
                        }
                        
                        // }
                        
                        
                        
                        
                        if ([arrModels count] > 0) {
                            
                            
                            NSSortDescriptor * dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
                            [arrModels sortUsingDescriptors:[NSArray arrayWithObjects:dateDescriptor,nil]];
                            
                            
                            if (dicModelValue) {
                                
                                dicModelValue = nil;
                            }
                            
                            dicModelValue = [dicResponse mutableCopy];
                            
                            aryPickerData = nil;
                            aryPickerData = [[NSMutableArray alloc] init];
                            aryPickerData = [arrModels mutableCopy];
                            
                            [pickerView reloadAllComponents];
                            
                            /*Store Model Val*/
                            [[NSUserDefaults standardUserDefaults] setObject:arrModels forKey:@"prefdictModelValue"];
                            [[NSUserDefaults standardUserDefaults] setObject:dicModelValue forKey:@"prefdictModelCodeValue"];
                            
                            /*Store Model Val*/
                            
                            //                NSString *str = [NSString stringWithFormat:@"%@",btnModel.titleLabel.text];
                            NSString *str = [dicSelectedData objectForKey:@"Model"];
                            
                            if ([arrModels containsObject:str]) {
                                
                                int selectedRowIndex = [arrModels indexOfObject:str];
                                [pickerView selectRow:selectedRowIndex inComponent:0 animated:NO];
                                self.strSelectedItem = str;
                                
                                
                            }
                            else{
                                
                                self.strSelectedItem = [aryPickerData objectAtIndex:0];
                                
                                
                                
                                [pickerView selectRow:0 inComponent:0 animated:NO];
                            }
                            
                            
                            viewPicker.hidden = FALSE;
                            
                            [SVProgressHUD dismiss];
                            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                            
                            
                            
                        }
                        
                        
                        [SVProgressHUD dismiss];
                        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                        
                        [self setStatus:DoneModel];
                        
                    }
                    
                    else{
                        /*severerr*/
                        /*Error_Event*/
                        NSDictionary *flurryParams =
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"WS-P-GetListModel", @"ErrorLocation", 
                         @"No Result Fountd", @"Error",
                         nil];
                        
                        if(appDel.isFlurryOn)
                        {
                            
                            NSError *error;
                            error = [NSError errorWithDomain:@"Vehicle Search Tree - Model - No Result Found" code:200 userInfo:flurryParams];
                            
                            [Flurry logError:@"Vehicle Search Tree - Model - No Result Found"   message:@"Vehicle Search Tree - Model - No Result Found"  error:error];
                        }
                        /*Error_Event*/
                        
                        [Flurry endTimedEvent:@"WS-P-GetListModel" withParameters:nil];
                        
                        viewPicker.hidden = TRUE;
                        viewInner.frame = CurrentFrame;
                        [SVProgressHUD dismiss];
                        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                        
                        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message: [NSString stringWithFormat:@"%@ %@.",ErrorConnection,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertError show];
                        alertError = nil;
                        
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefBodytype"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictBodytype"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictBodytypeCode"];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictGetListType"];
                        
                        
                        lblBodytype.text = @"Body Type";
                        lblderivative.text = @"Derivative";
                        lblFuelType.text = @"Fuel Type";
                        lblTransmission.text = @"Transmission";
                        lblEngineSize.text = @"Engine Size";
                        
                        
                        [btnbodytype setEnabled:FALSE];
                        [btnderivative setEnabled:FALSE];
                        [btnfueltype setEnabled:FALSE];
                        [btntransmission setEnabled:FALSE];
                        [btnenginesize setEnabled:FALSE];
                        
                        
                    }
                }
                else{
                    /*severerr*/
                    /*Error_Event*/
                    NSDictionary *flurryParams =
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"WS-P-GetListModel", @"ErrorLocation", 
                     @"Server Error", @"Error",
                     nil];
                    
                    if(appDel.isFlurryOn)
                    {
                        
                        NSError *error;
                        error = [NSError errorWithDomain:@"Vehicle Search Tree - Model - Server Error"  code:200 userInfo:flurryParams];
                        
                        [Flurry logError:@"Vehicle Search Tree - Model - Server Error"   message:@"Vehicle Search Tree - Model - Server Error"   error:error];
                    }
                    /*Error_Event*/
                    
                    [Flurry endTimedEvent:@"WS-P-GetListModel" withParameters:nil];
                    
                    viewPicker.hidden = TRUE;
                    viewInner.frame = CurrentFrame;
                    [SVProgressHUD dismiss];
                    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                    
                    UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message: [NSString stringWithFormat:@"%@ %@.",ErrorInResponse,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertError show];
                    alertError = nil;
                    
                    
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefBodytype"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictBodytype"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictBodytypeCode"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictGetListType"];
                    
                    lblBodytype.text = @"Body Type";
                    lblderivative.text = @"Derivative";
                    lblFuelType.text = @"Fuel Type";
                    lblTransmission.text = @"Transmission";
                    lblEngineSize.text = @"Engine Size";
                    
                    
                    [btnbodytype setEnabled:FALSE];
                    [btnderivative setEnabled:FALSE];
                    [btnfueltype setEnabled:FALSE];
                    [btntransmission setEnabled:FALSE];
                    [btnenginesize setEnabled:FALSE];
                    
                    
                }
                
                
                
                
            }
            else{
                
                
                viewPicker.hidden = TRUE;
                viewInner.frame = CurrentFrame;
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
                UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertError show];
                alertError = nil;
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefBodytype"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictBodytype"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictBodytypeCode"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictGetListType"];
                
                
                lblBodytype.text = @"Body Type";
                lblderivative.text = @"Derivative";
                lblFuelType.text = @"Fuel Type";
                lblTransmission.text = @"Transmission";
                lblEngineSize.text = @"Engine Size";
                
                
                [btnbodytype setEnabled:FALSE];
                [btnderivative setEnabled:FALSE];
                [btnfueltype setEnabled:FALSE];
                [btntransmission setEnabled:FALSE];
                [btnenginesize setEnabled:FALSE];
                
            }
            
        }
        
    }
    @catch (NSException *exception) {
        
        [Flurry endTimedEvent:@"WS-P-GetListModel" withParameters:nil];
        NSLog(@"exception : %@",exception);
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"WS-P-GetListModel", @"ErrorLocation",
         exception.description, @"Error",
         nil];
        if(appDel.isFlurryOn)
        {
            NSError *error;
            error = [NSError errorWithDomain:@"Vehicle Search Tree - Model - Exception" code:200 userInfo:flurryParams];
            
            [Flurry logError:@"Vehicle Search Tree - Model - Exception"   message:@"Vehicle Search Tree - Model - Exception" error:error];//m2806
        }
    }
    @finally {
        
    }
    
    
}

-(void)getValutionData : (NSString *) strVehicleID {
    
    @try {
        
        // WS Call For Valuation Service
        
        if (appDel.isOnline) {
            
            NSString *StrMilege;
            if (btnAverageMilage.isSelected) {
                StrMilege = @"0";
                
            }
            else{
                
                StrMilege = txtMileage.text;
                StrMilege = [StrMilege stringByReplacingOccurrencesOfString:@"," withString:@""];
            }
            
            appDel.strMileageLocal = StrMilege;
            appDel.strSortingString = @"Spot Price";
            
            
            if (appDel.isFirstValuation) {
                
                
            }
            
            if (appDel.dicSelectedTag) {
                
                [appDel.dicSelectedTag setObject:@"true" forKey:@"1"];
                [appDel.dicSelectedTag setObject:@"true" forKey:@"2"];
                [appDel.dicSelectedTag setObject:@"true" forKey:@"3"];
                [appDel.dicSelectedTag setObject:@"true" forKey:@"0"];
                [appDel.dicSelectedTag setObject:@"true" forKey:@"4"];
                
                
            }
            
            [NSThread detachNewThreadSelector:@selector(showProgressWith:) toTarget:self withObject:@"Finding your vehicle"];
            
            NSString *strMonth = nil;
            int currentPlateIndex;
            
            for(int i=0;i<[self.arrPlates count];i++)
            {
                if([lblPlate.text isEqualToString:[self.arrPlates objectAtIndex:i]])
                {
                    currentPlateIndex = i;
                    break;
                }
            }
            if([lblYear.text intValue]<=2000)
            {
                if(currentPlateIndex == 0)
                    strMonth = @"1";
                else if(currentPlateIndex == 1)
                    strMonth = @"5";
                else
                    strMonth = @"11";
            }
            else
            {
                if(currentPlateIndex == 0)
                    strMonth = @"1";
                else if(currentPlateIndex == 1)
                    strMonth = @"6";
                else
                    strMonth = @"12";
                
            }
            
            if(appDel.isFlurryOn)
            {
                
                [Flurry logEvent:@"WS-P-GetValuation" timed:YES];
            }
            
            appDel.isSummary = FALSE;
            
            NSString *strProductionPeriodDate = [NSString stringWithFormat:@"%@-%@",lblYear.text,strMonth];
            
            NSMutableDictionary *DictRequest = [[NSMutableDictionary alloc] init];
            if (appDel.isTestMode) {
                
                [DictRequest setObject:Proxy_WS_ClientCode forKey:@"ClientCode"];
                [DictRequest setObject:Proxy_WS_AccountName forKey:@"AccountName"];
                [DictRequest setObject:Proxy_WS_Password forKey:@"Password"];
                
            }
            
            else{
                
                [DictRequest setObject:Proxy_WS_ClientCode_LIVE forKey:@"ClientCode"];
                [DictRequest setObject:Proxy_WS_AccountName_LIVE forKey:@"AccountName"];
                [DictRequest setObject:Proxy_WS_Password_LIVE forKey:@"Password"];
                
            }
            [DictRequest setObject:@"GB" forKey:@"ISOCountryCode"];
            [DictRequest setObject:@"GBP" forKey:@"ISOCurrencyCode"];
            [DictRequest setObject:@"EN" forKey:@"ISOLanguageCode"];
            [DictRequest setObject:strVehicleID forKey:@"NatCode"];
            [DictRequest setObject:StrMilege forKey:@"Mileage"];
            [DictRequest setObject:strProductionPeriodDate forKey:@"RegistrationDate"];
            [DictRequest setObject:@"STANDARD" forKey:@"CalculationMode"];
            
            NSArray *arr;
            if (appDel.isTestMode) {
                
                arr = [objWebServicesjson callJsonAPIForAryReponse:GetValuation_URL withDictionary:DictRequest];
                
            }
            else{
                
                arr = [objWebServicesjson callJsonAPIForAryReponse:GetValuation_URL_LIVE withDictionary:DictRequest];
                
            }
            
            if (arr) {
                
                if ([arr count] > 0) {
                    
                    
                    if ([arr count] == 1) {
                        
                        NSDictionary *dic = [arr objectAtIndex:0];
                        if ([[dic objectForKey:@"ErrorCode"] isEqualToString:@"400"]) {
                            
                            /*Error_Event*/
                            NSDictionary *flurryParams =
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"WS-P-GetValuation", @"Error",
                             [NSString stringWithFormat:@"%@ for %@",[dic objectForKey:@"ErrorMsg"],strVehicleID],@"ErrorLocation",
                             
                             nil];
                            if(appDel.isFlurryOn)
                            {
                                
                                NSError *error;
                                error = [NSError errorWithDomain:@"Vehicle Search Tree - GetValuation - Server Error (400)" code:200 userInfo:flurryParams];
                                [Flurry logError:@"Vehicle Search Tree - GetValuation - Server Error (400)"   message:@"Vehicle Search Tree  - GetValuation - Server Error (400)"  error:error];
                            }
                            /*Error_Event*/
                            
                            [Flurry endTimedEvent:@"WS-P-GetValuation" withParameters:nil];
                            
                            [SVProgressHUD dismiss];
                            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                            
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"This vehicle cannot be valued. This may be because the vehicle is too new to have a used valuation available or is a rare or exotic model. We apologise for any inconvenience this has caused." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                            alert = nil;
                            
                            return;
                            
                        }
                        
                    }
                    
                    [objSKDatabase deleteWhere:[NSString stringWithFormat:@"GlassCarCode = '%@'",strVehicleID] forTable:@"tblVehicle"];
                    
                    [Flurry endTimedEvent:@"WS-P-GetValuation" withParameters:nil];
                    for (NSDictionary *dicResponse in arr) {
                        
                        NSMutableDictionary *dicToInsert = [[NSMutableDictionary alloc] init];
                        
                        NSDateFormatter *formatter;
                        NSString        *dateString;
                        
                        formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
                        
                        dateString = [formatter stringFromDate:[NSDate date]];
                        
                        [dicToInsert setObject:dateString forKey:@"Date"];
                        [dicToInsert setObject:@"" forKey:@"Name"];
                        
                        if (strVehicleID.length > 0) {
                            
                            [dicToInsert setObject:strVehicleID forKey:@"GlassCarCode"];
                        }
                        else{
                            [dicToInsert setObject:@"" forKey:@"GlassCarCode"];
                        }
                        
                        
                        int rowsel = [[NSUserDefaults standardUserDefaults] integerForKey:@"UseGPS"];
                        
                        if (rowsel == 0) {
                            
                            
                            if (appDel.strCurrentLocation.length > 0) {
                                
                                [dicToInsert setObject:appDel.strCurrentLocation forKey:@"Location"];
                                
                            }
                            else{
                                
                                [dicToInsert setObject:@"" forKey:@"Location"];
                            }
                            
                        }
                        else{
                            
                            [dicToInsert setObject:@"" forKey:@"Location"];
                        }
                        
                        
                        [dicToInsert setObject:lblmake.text forKey:@"Make"];
                        
                        [dicToInsert setObject:lblmodel.text forKey:@"Model"];
                        
                        [dicToInsert setObject:lblYear.text forKey:@"yearOfManufacture"];
                        
                        
                        
                        NSMutableString *strVehicleDesc = [[NSMutableString alloc] init];
                        
                        [strVehicleDesc appendString:[NSString stringWithFormat:@"%@",lblderivative.text]];
                        
                        [dicToInsert setObject:strVehicleDesc forKey:@"Description"];
                        
                        [dicToInsert setObject:@"" forKey:@"Variant"];
                        
                        [dicToInsert setObject:lblBodytype.text forKey:@"BodyType"];
                        
                        [dicToInsert setObject:@"" forKey:@"Doors"];
                        
                        [dicToInsert setObject:lblEngineSize.text forKey:@"EngineCapacity"];
                        
                        [dicToInsert setObject:lblTransmission.text forKey:@"TransmissionDescription"];
                        
                        NSString *strRegistrationDate = [NSString stringWithFormat:@"%@-01",strProductionPeriodDate];
                        [dicToInsert setObject:strRegistrationDate  forKey:@"RegistrationDate"];
                        
                        NSString *AverageMileage = [NSString stringWithFormat:@"%d",[[dicResponse objectForKey:@"averageMileageField"] intValue]];
                        
                        [dicToInsert setObject:AverageMileage forKey:@"AverageMileage"];
                        
                        if ([StrMilege isEqualToString:@"0"]) {
                            
                            
                            [dicToInsert setObject:AverageMileage forKey:@"Mileage"];
                            
                        }
                        else{
                            
                            [dicToInsert setObject:StrMilege forKey:@"Mileage"];
                        }
                        
                        if ([StrMilege isEqualToString:@"0"]) {
                            
                            
                            int totalValue;
                            if (![[dicResponse objectForKey:@"totalValuationField"] isKindOfClass:[NSNull class]]) {
                                
                                totalValue = [[[dicResponse objectForKey:@"totalValuationField"] objectForKey:@"tradeAmountField"] intValue];
                                
                                if (![[dicResponse objectForKey:@"mileageAdjustmentValueField"] isKindOfClass:[NSNull class]]) {
                                    
                                    totalValue = totalValue - [[[dicResponse objectForKey:@"mileageAdjustmentValueField"] objectForKey:@"tradeAmountField"] intValue];
                                }
                                
                            }
                            
                            NSString *TradePrice =[NSString stringWithFormat:@"%d",totalValue];
                            
                            [dicToInsert setObject:TradePrice forKey:@"TradePrice"];
                            
                        }
                        else{
                            
                            if (![[dicResponse objectForKey:@"totalValuationField"] isKindOfClass:[NSNull class]]) {
                                
                                int  totalValue = [[[dicResponse objectForKey:@"totalValuationField"] objectForKey:@"tradeAmountField"] intValue];
                                
                                NSString *TradePrice =[NSString stringWithFormat:@"%d",totalValue];
                                
                                [dicToInsert setObject:TradePrice forKey:@"TradePrice"];
                                
                            }
                            
                        }
                        
                        [dicToInsert setObject:@"" forKey:@"RegistrationNo"];
                        
                        appDel.intValSlider = [[NSUserDefaults standardUserDefaults] floatForKey:@"Distance"];
                        [dicToInsert setObject:[NSString stringWithFormat:@"%f",appDel.intValSlider] forKey:@"SearchRadius"];
                        
                        NSString *strTradePriceDate = [[dicResponse objectForKey:@"eTGdataIssuedOnField"] objectForKey:@"monthField"];
                        
                        if (strTradePriceDate.length > 0) {
                            
                            strTradePriceDate = [NSString stringWithFormat:@"%@ %@",strTradePriceDate,[[dicResponse objectForKey:@"eTGdataIssuedOnField"] objectForKey:@"yearField"]];
                            
                            NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
                            [dateFormate setDateFormat:@"MM yyyy"];
                            NSDate *date = [dateFormate dateFromString:strTradePriceDate];
                            
                            NSDateFormatter *dateFormate1 = [[NSDateFormatter alloc] init];
                            [dateFormate1 setDateFormat:@"MMM yyyy"];
                            NSString *strTradedate = [dateFormate1 stringFromDate:date];
                            
                            
                            [dicToInsert setObject:strTradedate forKey:@"TradePriceDate"];
                            
                            
                        }
                        
                        NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
                        [_formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
                        NSString *StrDate = [_formatter stringFromDate:[NSDate date]];
                        
                        [dicToInsert setObject:StrDate forKey:@"ActiveRun"];
                        
                        if (appDel.strCurrency.length > 0) {
                            
                            
                            [dicToInsert setObject:appDel.strCurrency forKey:@"Currency"];
                        }
                        else{
                            
                            [dicToInsert setObject:@"" forKey:@"Currency"];
                        }
                        
                        [dicToInsert setObject:@"" forKey:@"CustomPostCode"];
                        
                        [dicToInsert setObject:StrMilege forKey:@"OriginalMileage"];
                        
                        rowsel = [[NSUserDefaults standardUserDefaults] integerForKey:@"UseGPS"];
                        [dicToInsert setObject:[NSString stringWithFormat:@"%d",rowsel] forKey:@"UseGps"];
                        
                        [objSKDatabase insertDictionary:dicToInsert forTable:@"tblVehicle"];
                        
                    }
                    appDel.strVehicleID = strVehicleID;
                    [self setStatus:DoneValuation];
                }
                else{
                    /*severerr*/
                    /*Error_Event*/
                    NSDictionary *flurryParams =
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"WS-P-GetValuation", @"ErrorLocation",
                     @"No Result Found", @"Error",
                     nil];
                    if(appDel.isFlurryOn)
                    {

                        
                        NSError *error;
                        error = [NSError errorWithDomain:@"Vehicle Search Tree - GetValuation - No Result Found" code:200 userInfo:flurryParams];
                        [Flurry logError:@"Vehicle Search Tree - GetValuation - No Result Found"   message:@"Vehicle Search Tree - GetValuation - No Result Found"  error:error];//m2806
                        
                    }                    /*Error_Event*/
                    [Flurry endTimedEvent:@"WS-P-GetValuation" withParameters:nil];
                    
                    [SVProgressHUD dismiss];
                    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"This vehicle cannot be valued. This may be because the vehicle is too new to have a used valuation available or is a rare or exotic model. We apologise for any inconvenience this has caused." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    alert = nil;
                    
                    
                }
                
                
            }
            else{
                /*Error_Event*/
                NSDictionary *flurryParams =
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"WS-P-GetValuation", @"ErrorLocation", 
                 @"Server Error", @"Error",
                 nil];
                if(appDel.isFlurryOn)
                {
                    NSError *error;
                    error = [NSError errorWithDomain:@"Vehicle Search Tree - GetValuation - Server Error" code:200 userInfo:flurryParams];
                    
                    [Flurry logError:@"Vehicle Search Tree - GetValuation - Server Error"   message:@"Vehicle Search Tree - GetValuation - Server Error"  error:error];//m2806
                }
                [Flurry endTimedEvent:@"WS-P-GetValuation" withParameters:nil];
                
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@ %@",ErrorInResponse,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                alert = nil;
                
                
            }
            
            
            
        }
        else{
            
            [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
            
            UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertError show];
            alertError = nil;
            return;
            
            
        }
        
    }
    @catch (NSException *exception) {
        
        [Flurry endTimedEvent:@"WS-P-GetValuation" withParameters:nil];
        NSLog(@"exception : - %@" ,exception);
        
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"WS-P-GetValuation", @"ErrorLocation", 
         exception.description, @"Error",
         nil];
        
        
        if(appDel.isFlurryOn)
        {
            
            NSError *error;
            error = [NSError errorWithDomain:@"Vehicle Search Tree - GetValuation - Exception" code:200 userInfo:flurryParams];
            
            [Flurry logError:@"Vehicle Search Tree - GetValuation - Exception"  message:@"Vehicle Search Tree - GetValuation - Exception"  error:error];//m2806
        }
    }
    @finally {
        
    }
    
}

-(void)showProgressWith:(NSString *)strMessage
{
    
    [SVProgressHUD setStatus:strMessage];
}

-(void)resetAllData {
    
    
    // This will call once user visit the Search tree
    // All Saved data will be populated here from User Prefernces
    
    
    btnFind.enabled = FALSE;
    viewPicker.hidden = TRUE;
    viewInner.frame = CurrentFrame;
    
    lblPlate.text = @"Plate";
    
    lblmake.text = @"Make";
    lblmodel.text = @"Model";
    lblBodytype.text = @"Body Type";
    lblderivative.text = @"Derivative";
    lblFuelType.text = @"Fuel Type";
    lblTransmission.text = @"Transmission";
    lblEngineSize.text = @"Engine Size";
    
    
    txtMileage.text = @"";
    [btnAverageMilage setSelected:FALSE];
    
    self.arrPlates = nil;
    arrMakeValue = nil;
    arrModels = nil;
    arrBodyType = nil;
    arrDerivativeValue = nil;
    dicAllVehicleData = nil;
    
    // Disable All
    
    
    [btnPlate setEnabled:FALSE];
    [btnmake setEnabled:FALSE];
    [btnmodel setEnabled:FALSE];
    [btnbodytype setEnabled:FALSE];
    [btnderivative setEnabled:FALSE];
    [btnfueltype setEnabled:FALSE];
    [btntransmission setEnabled:FALSE];
    [btnenginesize setEnabled:FALSE];
    
    // Initialize All Array
    
    arrYears = [[NSMutableArray alloc] init];
    self.arrPlates = [[NSMutableArray alloc] init];
    arrMakeValue = [[NSMutableArray alloc] init];
    arrModels = [[NSMutableArray alloc] init];
    arrBodyType = [[NSMutableArray alloc] init];
    self.arrFinalResult = [[NSMutableArray alloc] init];
    dicWithSelectedCode = [[NSMutableDictionary alloc] init];
    
    
    NSMutableDictionary *dicPrefValues = [[NSUserDefaults standardUserDefaults] objectForKey:@"TreeValue"];
    
    if (dicPrefValues) {
        
        if ([dicPrefValues count] > 0) {
            NSDate *lastDate = [dicPrefValues objectForKey:@"lastTimestamp"];
            NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastDate];
            int hours = (int)interval / 3600;
            
            if (hours < 24) {
                arrYears = [dicPrefValues objectForKey:@"ArrYear"];
                if ([arrYears count] > 0) {
                    
                    NSString *fav;
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    fav = [defaults valueForKey:@"yr"];
                    
                    for(int i=0;i<arrYears.count;i++)
                    {
                        if([[arrYears objectAtIndex:i] isEqualToString:fav])
                        {
                            lblYear.text = [arrYears objectAtIndex:i];
                            break;
                        }
                    }
                    

                    
                }
                
                
                NSMutableArray *arrStoredPlates = [[NSMutableArray alloc] init];
                NSString *strprefPlate;
                
                strprefPlate = [[NSUserDefaults standardUserDefaults] valueForKey:@"prefPlate"];
                arrStoredPlates = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefdictPlateValue"];
                
            
                if ([arrStoredPlates count] > 0) {
                    
                    if ([arrStoredPlates containsObject:strprefPlate]) {
                        
                        if ([arrStoredPlates indexOfObject:strprefPlate] != NSNotFound) {
                            
                            [btnPlate setEnabled:TRUE];
                            lblPlate.text = strprefPlate;
                            [pickerView selectRow:[arrStoredPlates indexOfObject:strprefPlate] inComponent:0 animated:NO];
                        }
                    }
                }
                arrStoredPlates = nil;
                
                /*Fetch Make*/
                NSMutableArray *arrStoredMakes = [[NSMutableArray alloc] init];
                NSString *strprefMake;
                strprefMake = [[NSUserDefaults standardUserDefaults] valueForKey:@"prefMake"];
                
                arrStoredMakes = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefdictMakeValue"];
                
                if ([arrStoredMakes count] > 0) {
                    

                    if ([arrStoredMakes containsObject:strprefMake]) {
                        
                        if ([arrStoredMakes indexOfObject:strprefMake] != NSNotFound) {
                            
                            [btnmake setEnabled:TRUE];
                            lblmake.text = strprefMake;
                            [pickerView selectRow:[arrStoredMakes indexOfObject:strprefMake] inComponent:0 animated:NO];
                        }
                    }
                }
                
                arrStoredMakes = nil;
                
                /*Fetch Model*/
                
                /*Fetch Model*/
                NSMutableArray *arrStoredModel = [[NSMutableArray alloc] init];
                NSString *strprefModel;
                strprefModel = [[NSUserDefaults standardUserDefaults] valueForKey:@"prefModel"];
                
                arrStoredModel = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefdictModelValue"];
                
                if ([arrStoredModel count] > 0) {
                    
                    if ([arrStoredModel containsObject:strprefModel]) {
                        
                        if ([arrStoredModel indexOfObject:strprefModel] != NSNotFound) {
                            
                            [btnmodel setEnabled:TRUE];
                            lblmodel.text = strprefModel;
                            [pickerView selectRow:[arrStoredModel indexOfObject:strprefModel] inComponent:0 animated:NO];
                        }
                    }
                }
                /*Fetch Model*/
                
                /*Fetch Bodytype*/
                NSMutableArray *arrStoredBodytype = [[NSMutableArray alloc] init];
                NSString *strprefBodytype;
                strprefBodytype = [[NSUserDefaults standardUserDefaults] valueForKey:@"prefBodytype"];
                
                arrStoredBodytype = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefdictBodytype"];
                
                if ([arrStoredBodytype count] > 0) {
                    if ([arrStoredBodytype containsObject:strprefBodytype]) {
                        
                        if ([arrStoredBodytype indexOfObject:strprefBodytype] != NSNotFound) {
                            
                            [btnbodytype setEnabled:TRUE];
                            lblBodytype.text = strprefBodytype;
                            [pickerView selectRow:[arrStoredBodytype indexOfObject:strprefBodytype] inComponent:0 animated:NO];
                        }
                    }
                }
                
                arrStoredBodytype = nil;
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSData *data = [defaults objectForKey:@"prefdictGetListType"];
                
                if (data) {
                    
                    self.arrFinalResult = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
                }
                
                
                NSString *strprefDerivative;
                strprefDerivative = [[NSUserDefaults standardUserDefaults] valueForKey:@"prefDerivative"];
                lblderivative.text = strprefDerivative;
                
                
                NSString *strprefFuelType;
                strprefFuelType = [[NSUserDefaults standardUserDefaults] valueForKey:@"prefFuelType"];
                lblFuelType.text = strprefFuelType;
                
                
                NSString *strprefTrasmission;
                strprefTrasmission = [[NSUserDefaults standardUserDefaults] valueForKey:@"prefTrasmission"];
                lblTransmission.text = strprefTrasmission;
                
                
                NSString *strprefEngineSize;
                strprefEngineSize = [[NSUserDefaults standardUserDefaults] valueForKey:@"prefEngineSize"];
                lblEngineSize.text = strprefEngineSize;
                
                [btnderivative setEnabled:TRUE];
                [btnfueltype setEnabled:TRUE];
                [btntransmission setEnabled:TRUE];
                [btnenginesize setEnabled:TRUE];
                
                
                NSMutableDictionary *dicStoredMakeCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefdictMakeCodeValue"];
                NSMutableDictionary *dicStoredModelCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefdictModelCodeValue"];
                
                NSMutableDictionary *dicStoredBodyTypeCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"prefdictBodytypeCode"];
                
                
                NSString *makeCode;
                if ([dicStoredMakeCode count] > 0) {
                    
                    NSString *strSelectedMake = lblmake.text;
                    for (NSDictionary *dic in dicStoredMakeCode) {
                        
                        if ([[dic objectForKey:@"Name"] isEqualToString:strSelectedMake]) {
                            
                            makeCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Code"]];
                            
                            [dicWithSelectedCode setObject:makeCode forKey:@"Make"];
                            
                            break;
                        }
                        
                    }
                    
                    
                }
                
                NSString *modelCode;
                if ([dicStoredModelCode count] > 0) {
                    
                    
                    NSString *strSelectedModel = lblmodel.text;
                    
                    for (NSDictionary *dic in dicStoredModelCode) {
                        
                        if ([[dic objectForKey:@"Name"] isEqualToString:strSelectedModel]) {
                            
                            modelCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Code"]];
                            [dicWithSelectedCode setObject:modelCode forKey:@"Model"];
                            break;
                        }
                        
                    }
                    
                }
                
                
                NSString *BodyCode;
                for (NSDictionary *dic in dicStoredBodyTypeCode) {
                    
                    if ([[dic objectForKey:@"Name"] isEqualToString:lblBodytype.text]) {
                        
                        BodyCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Code"]];
                        [dicWithSelectedCode setObject:BodyCode forKey:@"BodyType"];
                        break;
                    }
                    
                }
                
                
                
                if ([[NSUserDefaults standardUserDefaults] valueForKey:@"TreeMileage"]) {
                    
                    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"TreeMileage"] isEqualToString:@"0"]) {
                        txtMileage.text=@"";
                        [btnAverageMilage setSelected:TRUE];
                        [txtMileage setEnabled:FALSE];
                    }
                    else{
                        [txtMileage setEnabled:TRUE];
                        [btnAverageMilage setSelected:FALSE];
                        
                        txtMileage.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"TreeMileage"];
                        [btnAverageMilage setSelected:FALSE];
                        
                    }
                }
                
                
                // Disable All accordingly
                
                if ([lblYear.text isEqualToString:@"Year"]) {
                    
                    [btnPlate setEnabled:FALSE];
                    [btnmodel setEnabled:FALSE];
                    [btnbodytype setEnabled:FALSE];
                    [btntransmission setEnabled:FALSE];
                    [btnenginesize setEnabled:FALSE];
                    [btnfueltype setEnabled:FALSE];
                    [btnderivative setEnabled:FALSE];
                    
                }
                else if ([lblmake.text isEqualToString:@"Make"]){
                    
                    [btnmodel setEnabled:FALSE];
                    [btnbodytype setEnabled:FALSE];
                    [btntransmission setEnabled:FALSE];
                    [btnenginesize setEnabled:FALSE];
                    [btnfueltype setEnabled:FALSE];
                    [btnderivative setEnabled:FALSE];
                    
                }
                else if ([lblmodel.text isEqualToString:@"Model"]){
                    
                    
                    [btnbodytype setEnabled:FALSE];
                    [btntransmission setEnabled:FALSE];
                    [btnenginesize setEnabled:FALSE];
                    [btnfueltype setEnabled:FALSE];
                    [btnderivative setEnabled:FALSE];
                    
                }
                else if ([lblBodytype.text isEqualToString:@"Body Type"]){
                    
                    [btntransmission setEnabled:FALSE];
                    [btnenginesize setEnabled:FALSE];
                    [btnfueltype setEnabled:FALSE];
                    [btnderivative setEnabled:FALSE];
                    
                }
                else if (![lblderivative.text isEqualToString:@"Derivative"] && ![lblFuelType.text isEqualToString:@"Fuel Type"] && ![lblTransmission.text isEqualToString:@"Transmission"] && ![lblEngineSize.text isEqualToString:@"Engine Size"]){
                    
                    [btnFind setEnabled:TRUE];
                }
                
            }
            else{
                
                /*Remove all prefs*/
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefPlate"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictPlateValue"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefMake"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictMakeValue"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictMakeCodeValue"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefModel"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictModelValue"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictModelCodeValue"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefBodytype"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictBodytype"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictBodytypeCode"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prefdictGetListType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                /*Remove all prefs*/
                
                [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                
                
                if (!appDel.UserAuthenticated) {
                    
                    [SVProgressHUD showWithStatus:@"Please wait for authentication.."];
                    [self CallLoginAPI];
                }
                else{
                    
                    [SVProgressHUD showWithStatus:@"Please Wait..."];
                    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(CalucaltePrimaryFields) userInfo:nil repeats:NO];
                }
                
                
                
            }
            
        }
        
    }
    else{
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [SVProgressHUD showWithStatus:@"Please Wait..."];
        [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(CalucaltePrimaryFields) userInfo:nil repeats:NO];
        
        
    }
    
    
}
- (void)cancelNumberPad
{
    viewInner.frame = CurrentFrame;
    txtMileage.text=@"";
    [txtMileage resignFirstResponder];
}

- (void)doneButton:(id)sender {
    
    viewInner.frame = CurrentFrame;
    [txtMileage resignFirstResponder];
    
}

#pragma mark-
#pragma mark Keyboard method


-(void)keyboardWillHide:(NSNotification *)aNotification
{
    viewInner.frame = CurrentFrame;
    isKeyboardVisible = FALSE;
    
}

-(void)keyboardWillShow:(NSNotification *)aNotification
{
    viewPicker.hidden = TRUE;
    isKeyboardVisible = TRUE;
}


#pragma mark - Picker View Method


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [aryPickerData count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [NSString stringWithFormat:@"%@",[aryPickerData objectAtIndex:row]];
    
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    [self fetchPickerValue];
    
}


-(void) fetchPickerValue {
    
    //This will call once user Select value from Picker view
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *strKey;
    self.strSelectedItem = [NSString stringWithFormat:@"%@",[aryPickerData objectAtIndex:[pickerView selectedRowInComponent:0]]];
    if(selectedItemIndex == 1)
    {
        strKey = @"Year";
        lblYear.text = self.strSelectedItem;
        strGYear=self.strSelectedItem;
     
        [self CalculatePlateValue];
        if ([self.arrPlates count] > 0) {
            
            lblPlate.text = [self.arrPlates objectAtIndex:0];
            
        }
        
        
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         self.strSelectedItem, @"Year", 
         nil];
        if(appDel.isFlurryOn)
        {
            [Flurry logEvent:@"Vehicle Search Tree - Year" withParameters:flurryParams];
            
        }
        
        
        
    }
    else if(selectedItemIndex == 2)  
    {
        strKey = @"Plate";
        lblPlate.text =self.strSelectedItem;
        strGPlate = self.strSelectedItem;
        
        
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         self.strSelectedItem, @"Plate", 
         nil];
        if(appDel.isFlurryOn)
        {
            [Flurry logEvent:@"Vehicle Search Tree - Plate" withParameters:flurryParams];
        }
        
        
        
    }
    else if(selectedItemIndex == 3)
    {
        strKey = @"Make";
        lblmake.text = self.strSelectedItem;
        
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         self.strSelectedItem, @"Make", 
         nil];
        if(appDel.isFlurryOn)
        {
            [Flurry logEvent:@"Vehicle Search Tree - Make" withParameters:flurryParams];
        }
    }
    else if(selectedItemIndex == 4) 
    {
        strKey = @"Model";
        lblmodel.text=self.strSelectedItem;
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         self.strSelectedItem, @"Model", 
         nil];
        if(appDel.isFlurryOn)
        {
            [Flurry logEvent:@"Vehicle Search Tree - Model" withParameters:flurryParams];
        }
        
    }
    else if(selectedItemIndex == 5) 
    {
        strKey = @"Body Type";
        lblBodytype.text=self.strSelectedItem;
        
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         self.strSelectedItem, @"Body Type", 
         nil];
        
        if(appDel.isFlurryOn)
        {
            [Flurry logEvent:@"Vehicle Search Tree - Body Type" withParameters:flurryParams];
        }
        
        
        
    }
    else if(selectedItemIndex == 6)   
    {
        strKey = @"Derivative";
        lblderivative.text=self.strSelectedItem;
        
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         self.strSelectedItem, @"Derivative", 
         nil];
        if(appDel.isFlurryOn)
        {
            [Flurry logEvent:@"Vehicle Search Tree - Derivative" withParameters:flurryParams];
        }
        
    }
    else if(selectedItemIndex == 7)   
    {
        strKey = @"Fuel Type";
        lblFuelType.text = self.strSelectedItem;
        
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         self.strSelectedItem, @"Fuel Type", 
         nil];
        if(appDel.isFlurryOn)
        {
            [Flurry logEvent:@"Vehicle Search Tree - Fuel Type" withParameters:flurryParams];
        }
        
    }
    else if(selectedItemIndex == 8)   
    {
        strKey = @"Trasmission";
        lblTransmission.text = self.strSelectedItem;
        
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         self.strSelectedItem, @"Transmission", 
         nil];
        if(appDel.isFlurryOn)
        {
            [Flurry logEvent:@"Vehicle Search Tree - Transmission" withParameters:flurryParams];
        }
        

    }
    else if(selectedItemIndex == 9)   
    {
        strKey = @"Engine Size";
        lblEngineSize.text = self.strSelectedItem;
        
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         self.strSelectedItem, @"Engine Size", 
         nil];
        if(appDel.isFlurryOn)
        {
            [Flurry logEvent:@"Vehicle Search Tree - Engine Size" withParameters:flurryParams];
        }
        

    }
    
    [dicSelectedData setValue:self.strSelectedItem forKey:strKey];
    
    [defaults synchronize];
    
}

#pragma mark - Textfield delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    viewPicker.hidden = TRUE;
    UpdatedFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 200, self.view.frame.size.width, self.view.frame.size.height);
    viewInner.frame = UpdatedFrame;
    return TRUE;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == txtMileage) {
        
        NSString *strTemo = [[textField.text stringByReplacingCharactersInRange:range withString:string] stringByReplacingOccurrencesOfString:@" " withString:@""];
        strTemo = [strTemo stringByReplacingOccurrencesOfString:@"," withString:@""];
        if ([[strTemo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 6)
        {
            
            return NO;
        }
        
        NSString *newString =[[textField.text stringByReplacingCharactersInRange:range withString:string] stringByReplacingOccurrencesOfString:@" " withString:@""];
        newString = [newString stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSString *expression = @"^([0-9]+)?$";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
            return NO;
        
        
        btnAverageMilage.selected=FALSE;
        
        
        if (newString.length > 0) {
            
            NSNumber* number = [NSNumber numberWithDouble:[newString doubleValue]];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
            [numberFormatter setGroupingSeparator:@","];
            NSString* commaString = [numberFormatter stringForObjectValue:number];
            txtMileage.text=@"";
            txtMileage.text = commaString;
            return NO;
            
            
        }
        else
            return YES;
        
        
    }
    
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    
    if(textField.text.length > 0)
        btnAverageMilage.selected = FALSE;
    
    if (isKeyboardVisible) {
        viewInner.frame = CurrentFrame;
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
    
}

#pragma mark - Other Memory Method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    
    viewPicker = nil;
    pickerView = nil;
    btnYear = nil;
    btnPlate = nil;
    btnbodytype = nil;
    btnfueltype = nil;
    btntransmission = nil;
    btnmodel = nil;
    btnmake = nil;
    btnderivative = nil;
    btnenginesize = nil;
    lblYear = nil;
    lblPlate = nil;
    btnBarPrev = nil;
    btnBarNext = nil;
    viewInner = nil;
    
    [super viewDidUnload];
}


#pragma mark
#pragma mark Button Methods


-(void)backClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnCancleClicked:(id)sender{
    
    [self fetchPickerValue];
    viewInner.frame = CurrentFrame;
    viewPicker.hidden=TRUE;
}


-(void)btnSettingClick:(id)sender
{
    [appDel loadSettingScreen];
    
}

- (IBAction)btnYearClicked:(id)sender {
    
    
    UpdatedFrame = CurrentFrame;
    viewInner.frame = UpdatedFrame;
    
    btnBarPrev.enabled = FALSE;
    btnBarNext.enabled = TRUE;
    
    [txtMileage resignFirstResponder];
    
    if ([arrYears count] > 0) {
        
        viewPicker.hidden = FALSE;
        if (sender) {
            
            selectedItemIndex = [sender tag];
        }
        aryPickerData = nil;
        aryPickerData = [[NSMutableArray alloc] init];
        aryPickerData = [arrYears mutableCopy];
        
        [pickerView reloadAllComponents];
        NSString *str = [NSString stringWithFormat:@"%@",lblYear.text];
        if ([arrYears containsObject:str]) {
            
            int selectedRowIndex = [arrYears indexOfObject:str];
            [pickerView selectRow:selectedRowIndex inComponent:0 animated:NO];
            self.strSelectedItem = str;
        }
        else{
            
            self.strSelectedItem = [aryPickerData objectAtIndex:0];
            [pickerView selectRow:0 inComponent:0 animated:NO];
            
            
        }
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         self.strSelectedItem, @"Year", 
         nil];
        if(appDel.isFlurryOn)
        {
            [Flurry logEvent:@"Vehicle Search Tree - Year" withParameters:flurryParams];
            
        }
        NSString *strLastYear = [[NSUserDefaults standardUserDefaults] objectForKey:@"yr"];
        
        if (strLastYear.length > 0 && [strLastYear isEqualToString:lblYear.text]) {
            
            [self CalculatePlateValue];
        }
        else{
            
            [self setStatus:DoneYear];
        }
    }
}


- (IBAction)btnPlateClecked:(id)sender {
    
    UpdatedFrame = CurrentFrame;
    viewInner.frame = UpdatedFrame;
    
    btnBarPrev.enabled = TRUE;
    btnBarNext.enabled = TRUE;
    
    [txtMileage resignFirstResponder];
    
    
    if ([lblYear.text isEqualToString:@"Year"]) {
        
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Select Year First." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertError show];
        alertError = nil;
        return;
    }
    
    [self CalculatePlateValue];
    if ([self.arrPlates count] > 0) {
        
        viewPicker.hidden = FALSE;
        
        if (sender) {
            
            
            selectedItemIndex = [sender tag];
            
        }
        
        aryPickerData = nil;
        aryPickerData = [[NSMutableArray alloc] init];
        aryPickerData = [self.arrPlates mutableCopy];
        [pickerView reloadAllComponents];
        
        NSString *str = [NSString stringWithFormat:@"%@",lblPlate.text];

        if ([self.arrPlates containsObject:str]) {
            
            int selectedRowIndex = [self.arrPlates indexOfObject:str];
            [pickerView selectRow:selectedRowIndex inComponent:0 animated:NO];
            self.strSelectedItem = str;
            
        }
        else{
            
            self.strSelectedItem = [aryPickerData objectAtIndex:0];
            
            
            [pickerView selectRow:0 inComponent:0 animated:NO];
        }
        
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         self.strSelectedItem, @"Plate", 
         nil];
        if(appDel.isFlurryOn)
        {
            [Flurry logEvent:@"Vehicle Search Tree - Plate" withParameters:flurryParams];
        }
    }
}
- (IBAction)btnBodyTypeClicked:(id)sender {
    
    
    viewInner.frame = CurrentFrame;
    viewPicker.hidden=TRUE;
    
    btnBarPrev.enabled = TRUE;
    btnBarNext.enabled = TRUE;
    
    [txtMileage resignFirstResponder];
    
    if (sender) {
        
        selectedItemIndex = [sender tag];
    }
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(CalculateBodyTypeValue) userInfo:nil repeats:NO];
}
- (IBAction)btnMakeClicked:(id)sender {
    
    btnBarPrev.enabled = TRUE;
    btnBarNext.enabled = TRUE;
    
    [txtMileage resignFirstResponder];
    
    if (sender) {
        
        selectedItemIndex = [sender tag];
    }
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(CalculateMakeValue) userInfo:nil repeats:NO];
    
}

- (IBAction)btnModelClicked:(id)sender {
    
    btnBarPrev.enabled = TRUE;
    btnBarNext.enabled = TRUE;
    
    [txtMileage resignFirstResponder];
    
    if (sender) {
        
        selectedItemIndex = [sender tag];
    }
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(GetModelListFromMake) userInfo:nil repeats:NO];
    
}

- (IBAction)btnDerivativeClicked:(id)sender {
    
    viewInner.frame = CurrentFrame;
    viewPicker.hidden=TRUE;
    
    btnBarPrev.enabled = TRUE;
    btnBarNext.enabled = TRUE;
    
    
    [txtMileage resignFirstResponder];
    
    if (sender) {
        
        selectedItemIndex = [sender tag];
    }
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(CalculateGetListTypeEx) userInfo:nil repeats:NO];
    
    
}
- (IBAction)btnFualTypeClicked:(id)sender {
    
    
    UpdatedFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 150, self.view.frame.size.width, self.view.frame.size.height);
    viewInner.frame = UpdatedFrame;
    
    btnBarPrev.enabled = TRUE;
    btnBarNext.enabled = TRUE;
    
    [txtMileage resignFirstResponder];
    
    viewPicker.hidden = FALSE;
    
    if (sender) {
        
        selectedItemIndex = [sender tag];
    }
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(CalculateFuel) userInfo:nil repeats:NO];
    
}
- (IBAction)btnTransmissionClicked:(id)sender {
    
    UpdatedFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 180, self.view.frame.size.width, self.view.frame.size.height);
    viewInner.frame = UpdatedFrame;

    btnBarPrev.enabled = TRUE;
    btnBarNext.enabled = TRUE;
    
    [txtMileage resignFirstResponder];
    
    viewPicker.hidden = FALSE;
    
    if (sender) {
        
        selectedItemIndex = [sender tag];
    }
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(CalculateTransmission) userInfo:nil repeats:NO];
}



- (IBAction)btnEngineSizeClicked:(id)sender {
    
    
    UpdatedFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 180, self.view.frame.size.width, self.view.frame.size.height);
    viewInner.frame = UpdatedFrame;
    
    btnBarPrev.enabled = TRUE;
    btnBarNext.enabled = TRUE;
    
    
    [txtMileage resignFirstResponder];
    
    viewPicker.hidden = FALSE;
    
    viewPicker.hidden = FALSE;
    
    if (sender) {
        
        selectedItemIndex = [sender tag];
    }
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(CalculateEngineSize) userInfo:nil repeats:NO];
    
}

-(IBAction)btnMilageClicked:(id)sender
{
    
    [txtMileage resignFirstResponder];
    if(btnAverageMilage.selected)
    {
        btnAverageMilage.selected = FALSE;
        txtMileage.enabled = TRUE;
        [txtMileage becomeFirstResponder];
    }
    else
    {
        viewInner.frame = CurrentFrame;
        btnAverageMilage.selected = TRUE;
        txtMileage.text=@"";
        txtMileage.enabled = FALSE;
    }
}

- (IBAction)btnPrevClick:(id)sender {
    
    viewPicker.hidden = TRUE;
    NSString *strKey;
    
    UIBarButtonItem *btn = (UIBarButtonItem *) sender;
    
    
    if (selectedItemIndex == 1) {
        [btn setEnabled:FALSE];
    }
    else{
        
        [btn setEnabled:TRUE];
    }
    
    if(selectedItemIndex == 1)   
    {
        strKey = @"Year";
        lblYear.text=self.strSelectedItem;
        selectedItemIndex--;
    }
    else if(selectedItemIndex == 2)   // Plate Selection
    {
        strKey = @"Plate";
        lblPlate.text =self.strSelectedItem;
        [self btnYearClicked:nil];
        selectedItemIndex--;
        
    }
    else if(selectedItemIndex == 3)   // Make Selection
    {
        strKey = @"Make";
        lblmake.text=self.strSelectedItem;
        
        [self btnPlateClecked:nil];
        selectedItemIndex--;
        
    }
    else if(selectedItemIndex == 4)   // Model Selection
    {
        strKey = @"Model";
        lblmodel.text=self.strSelectedItem;
        
        [self btnMakeClicked:nil];
        selectedItemIndex--;
        
    }
    else if(selectedItemIndex == 5)   // Body Type Selection
    {
        strKey = @"Body Type";
        lblBodytype.text=self.strSelectedItem;
        
        [self btnModelClicked:nil];
        selectedItemIndex--;
    }
    else if(selectedItemIndex == 6)   // Derivative Selection
    {
        
        strKey = @"Derivative";
        lblderivative.text=self.strSelectedItem;
        
        [self btnBodyTypeClicked:nil];
        selectedItemIndex--;
        
    }
    else if(selectedItemIndex == 7)   // @"Fuel Type" Selection
    {
        
        strKey = @"Fuel Type";
        lblFuelType.text=self.strSelectedItem;
        
        [self btnDerivativeClicked:nil];
        selectedItemIndex--;
    }
    else if(selectedItemIndex == 8)   // Trasmission Selection
    {
        
        strKey = @"Trasmission";
        lblTransmission.text=self.strSelectedItem;
        
        [self btnFualTypeClicked:nil];
        selectedItemIndex--;
        
        
    }
    else if(selectedItemIndex == 9)   // Engine Size Selection
    {
        strKey = @"Engine Size";
        lblEngineSize.text=self.strSelectedItem;
        
        [self btnTransmissionClicked:nil];
        selectedItemIndex--;
    }
    
    
    [dicSelectedData setValue:self.strSelectedItem forKey:strKey];
    
    
}


- (IBAction)btnDoneClicked:(id)sender {
    
    
    viewPicker.hidden = TRUE;
    NSString *strKey;
    
    UIBarButtonItem *btn = (UIBarButtonItem *) sender;
    
    
    if (selectedItemIndex == 8) {
        
        [btn setEnabled:FALSE];
    }
    else{
        
        [btn setEnabled:TRUE];
    }
    
    if(selectedItemIndex == 1)   
    {
        
        strKey = @"Year";
        
        lblYear.text=self.strSelectedItem;
        
        
        [btnPlate setEnabled:TRUE];
        [self btnPlateClecked:nil];
        selectedItemIndex++;
    }
    else if(selectedItemIndex == 2)   // Plate Selection
    {
        
        strKey = @"Plate";
        lblPlate.text =self.strSelectedItem;
        [btnmake setEnabled:TRUE];
        [self btnMakeClicked:nil];
        selectedItemIndex++;
        
    }
    else if(selectedItemIndex == 3)   // Make Selection
    {
        strKey = @"Make";
        lblmake.text =self.strSelectedItem;
        
        [btnmodel setEnabled:TRUE];
        [self btnModelClicked:nil];
        selectedItemIndex++;
        
    }
    else if(selectedItemIndex == 4)   // Model Selection
    {
        strKey = @"Model";
        lblmodel.text =self.strSelectedItem;
        
        [btnbodytype setEnabled:TRUE];
        [self btnBodyTypeClicked:nil];
        selectedItemIndex++;
        
    }
    else if(selectedItemIndex == 5)   // Model Selection
    {
        strKey = @"Body Type";
        lblBodytype.text =self.strSelectedItem;
        
        [btnderivative setEnabled:TRUE];
        [self btnDerivativeClicked:nil];
        selectedItemIndex++;
        
    }
    
    else if(selectedItemIndex == 6)   // Derivative Selection
    {
        strKey = @"Derivative";
        lblderivative.text =self.strSelectedItem;
        
        [self btnFualTypeClicked:nil];
        selectedItemIndex++;
    }
    else if(selectedItemIndex == 7)   // Fuel Type
    {
        strKey = @"Fuel Type";
        lblFuelType.text =self.strSelectedItem;
        
        [self btnTransmissionClicked:nil];
        selectedItemIndex++;
    }
    else if(selectedItemIndex == 8)   //Transmission
    {
        
        strKey = @"Trasmission";
        lblTransmission.text =self.strSelectedItem;
        
        [self btnEngineSizeClicked:nil];
        selectedItemIndex++;
        
    }
    else if(selectedItemIndex == 9)  
    {
        
        strKey = @"Engine Size";
        lblEngineSize.text =self.strSelectedItem;
        
        [txtMileage setEnabled:TRUE];
        if (btnAverageMilage.isSelected) {
            
            [btnAverageMilage setSelected:FALSE];
            [txtMileage becomeFirstResponder];
            
        }
        else{
            
            [txtMileage becomeFirstResponder];
        }
        
    }
    
    [dicSelectedData setValue:self.strSelectedItem forKey:strKey];
    
}
-(IBAction)actionFind:(id)sender
{
    
    
    if ([lblPlate.text isEqualToString:@"Plate"]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Plate Value." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    
    else if ([lblmake.text isEqualToString:@"Make"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Make Value." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        
    }
    
    else if ([lblmodel.text isEqualToString:@"Model"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Model Value." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        
    }
    
    else if ([lblBodytype.text isEqualToString:@"Body Type"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Body Type Value." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    
    else if ([lblderivative.text isEqualToString:@"Derivative"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Derivative Value." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        
    }
    
    else if ([lblFuelType.text isEqualToString:@"Fuel Type"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Fuel Type Value." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
    
    else if ([lblTransmission.text isEqualToString:@"Trasmission"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Trasmission Value." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
    else if ([lblEngineSize.text isEqualToString:@"Engine Size"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Engine Size Value." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        
    }
    else{
        
        
        if (btnAverageMilage.isSelected) {
            
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            [SVProgressHUD showWithStatus:@"Please Wait..."];
            
            [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(valuationSearchData) userInfo:nil repeats:NO];
            
        }
        else{
            
            NSString *strMileage1 = [txtMileage.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if([strMileage1 length] == 0)
            {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter Valid Mileage" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
            }
            else
            {
                // Once all attributes of vehicle selected, Valuation call will made

                [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                [SVProgressHUD showWithStatus:@"Please Wait..."];
                
                [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(valuationSearchData) userInfo:nil repeats:NO];
                
            }
            
        }
        
    }
    
}

-(void)valuationSearchData {
    
    
    NSMutableDictionary *dicTemp = [[NSMutableDictionary alloc] init];
    
    NSString *StrMilege;
    if (btnAverageMilage.isSelected) {
        StrMilege = @"0";
        
    }
    else{
        
        StrMilege = txtMileage.text;
        StrMilege = [StrMilege stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    
    NSString *strMonth = nil;
    int currentPlateIndex;
    
    for(int i=0;i<[self.arrPlates count];i++)
    {
        if([lblPlate.text isEqualToString:[self.arrPlates objectAtIndex:i]])
        {
            currentPlateIndex = i;
            break;
        }
    }
    if([lblYear.text intValue]<=2000)
    {
        if(currentPlateIndex == 0)
            strMonth = @"1";
        else if(currentPlateIndex == 1)
            strMonth = @"5";
        else
            strMonth = @"11";
    }
    else
    {
        if(currentPlateIndex == 0)
            strMonth = @"1";
        else if(currentPlateIndex == 1)
            strMonth = @"6";
        else
            strMonth = @"12";
        
    }
    
    NSString *strProductionPeriodDate = [NSString stringWithFormat:@"%@-%@",lblYear.text,strMonth];
    
    
    [dicTemp setObject:StrMilege forKey:@"Mileage"];
    [dicTemp setObject:strProductionPeriodDate forKey:@"RegistrationDate"];
    [dicTemp setObject:lblmake.text forKey:@"Make"];
    [dicTemp setObject:lblmodel.text forKey:@"Model"];
    [dicTemp setObject:lblPlate.text forKey:@"Plate"];
    [dicTemp setObject:lblFuelType.text forKey:@"FuelType"];
    [dicTemp setObject:lblYear.text forKey:@"yearOfManufacture"];
    [dicTemp setObject:lblBodytype.text forKey:@"BodyType"];
    [dicTemp setObject:lblEngineSize.text forKey:@"EngineCapacity"];
    [dicTemp setObject:lblTransmission.text forKey:@"TransmissionDescription"];
    [dicTemp setObject:lblderivative.text forKey:@"Dedivative"];
    
    NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dicResult in self.arrFinalResult) {
        
        if (![[[dicResult objectForKey:@"typeField"] objectForKey:@"trimLineNameField"] isKindOfClass:[NSNull class]] ) {
            
            if ([[[dicResult objectForKey:@"typeField"] objectForKey:@"trimLineNameField"] isEqualToString:lblderivative.text] ) {
                
                [arrTemp addObject:dicResult];
            }
            
        }
        else{
            
            [arrTemp addObject:dicResult];
        }
        
    }
    
    
    // Filter Vehicle ID From selected values (e.g Make, Model...)
     NSMutableDictionary *dicDisplayData = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *dicResult in arrTemp) {
        
        if (![[[[dicResult objectForKey:@"engineField"] objectForKey:@"fuelField"]objectForKey:@"nameExField"] isKindOfClass:[NSNull class]] && ![[[[[dicResult objectForKey:@"transmissionField"] objectForKey:@"gearBoxField"]objectForKey:@"typeField"]objectForKey:@"nameExField"] isKindOfClass:[NSNull class]]  && ![[[[dicResult objectForKey:@"engineField"] objectForKey:@"displacementField"]objectForKey:@"valueField"] isKindOfClass:[NSNull class]]) {
            
            NSString *strFuelSize = [NSString stringWithFormat:@"%@",[[[dicResult objectForKey:@"engineField"] objectForKey:@"fuelField"]objectForKey:@"nameExField"]];
            NSString *strTransmission = [NSString stringWithFormat:@"%@",[[[[dicResult objectForKey:@"transmissionField"] objectForKey:@"gearBoxField"]objectForKey:@"typeField"]objectForKey:@"nameExField"]];
            NSString *StrEngineSize = [NSString stringWithFormat:@"%@",[[[dicResult objectForKey:@"engineField"] objectForKey:@"displacementField"]objectForKey:@"valueField"]];
            
            
            if ([strFuelSize isEqualToString:lblFuelType.text] && [strTransmission isEqualToString:lblTransmission.text] && [StrEngineSize isEqualToString:[lblEngineSize.text stringByReplacingOccurrencesOfString:@" cc" withString:@""]]) {
                
                NSMutableString *strToDisplay = [[NSMutableString alloc] initWithString:@""];
                
                [strToDisplay appendString:[NSString stringWithFormat:@"%@", lblmake.text]];
                [strToDisplay appendString:[NSString stringWithFormat:@", %@", lblmodel.text]];
                
                
                if (![[NSString stringWithFormat:@"%@",[[dicResult objectForKey:@"typeField"] objectForKey:@"nameField"]] isKindOfClass:[NSNull class]]) {
                    
                    [strToDisplay appendString:[NSString stringWithFormat:@"\n%@",[[dicResult objectForKey:@"typeField"] objectForKey:@"nameField"]]];
                    
                }
                
                if (![[[dicResult objectForKey:@"typeField"] objectForKey:@"productionPeriodField"] isKindOfClass:[NSNull class]]) {
                    
                    
                    if (![[[[dicResult objectForKey:@"typeField"] objectForKey:@"productionPeriodField"] objectForKey:@"productionStartDateField"] isKindOfClass:[NSNull class]]) {
                        
                        [strToDisplay appendString:[NSString stringWithFormat:@"\n%@",[[[[dicResult objectForKey:@"typeField"] objectForKey:@"productionPeriodField"] objectForKey:@"productionStartDateField"] objectForKey:@"monthField"]]];
                        
                    }
                    
                    if (![[[[dicResult objectForKey:@"typeField"] objectForKey:@"productionPeriodField"] objectForKey:@"productionStartDateField"]isKindOfClass:[NSNull class]]) {
                        
                        [strToDisplay appendString:[NSString stringWithFormat:@"-%@",[[[[dicResult objectForKey:@"typeField"] objectForKey:@"productionPeriodField"] objectForKey:@"productionStartDateField"] objectForKey:@"yearField"]]];
                        
                    }
                    
                    if (![[[[dicResult objectForKey:@"typeField"] objectForKey:@"productionPeriodField"] objectForKey:@"productionEndDateField"] isKindOfClass:[NSNull class]]) {
                        
                        [strToDisplay appendString:[NSString stringWithFormat:@" %@",[[[[dicResult objectForKey:@"typeField"] objectForKey:@"productionPeriodField"] objectForKey:@"productionEndDateField"] objectForKey:@"monthField"]]];
                        
                    }
                    
                    if (![[[[dicResult objectForKey:@"typeField"] objectForKey:@"productionPeriodField"] objectForKey:@"productionEndDateField"]  isKindOfClass:[NSNull class]]) {
                        
                        [strToDisplay appendString:[NSString stringWithFormat:@"-%@",[[[[dicResult objectForKey:@"typeField"] objectForKey:@"productionPeriodField"] objectForKey:@"productionEndDateField"] objectForKey:@"yearField"]]];
                        
                    }
                    
                }
                
                if (![[[dicResult objectForKey:@"bodyField"] objectForKey:@"doorsNumberField"] isKindOfClass:[NSNull class]]) {
                    
                    [strToDisplay appendString:[NSString stringWithFormat:@"\n%@ doors",[[dicResult objectForKey:@"bodyField"] objectForKey:@"doorsNumberField"]]];
                    
                }
                
                
                if (![[[dicResult objectForKey:@"engineField"] objectForKey:@"powerField"] isKindOfClass:[NSNull class]]) {
                    
                    
                    NSArray *arrPower = [[dicResult objectForKey:@"engineField"] objectForKey:@"powerField"];
                    
                    
                    if ([arrPower count] > 0) {
                        
                        NSString *strUnit = [NSString stringWithFormat:@"%@",[[arrPower objectAtIndex:0] objectForKey:@"unitField"]];
                        
                        if ([strUnit isEqualToString:@"0"]) {
                            
                            strUnit = @"m";
                            
                        }
                        else if ([strUnit isEqualToString:@"1"]) {
                            
                            strUnit = @"mm";
                        }
                        else if ([strUnit isEqualToString:@"2"]) {
                            
                            strUnit = @"kg";
                        }
                        else if ([strUnit isEqualToString:@"3"]) {
                            
                            strUnit = @"ccm";
                        }
                        else if ([strUnit isEqualToString:@"4"]) {
                            
                            strUnit = @"hp";
                        }
                        else if ([strUnit isEqualToString:@"5"]) {
                            
                            strUnit = @"kw";
                        }
                        
                        [strToDisplay appendString:[NSString stringWithFormat:@", %@%@",[[arrPower objectAtIndex:0] objectForKey:@"valueField"],strUnit]];
                        
                        
                        if ([arrPower count] > 1) {
                            
                            
                            NSString *strUnit = [NSString stringWithFormat:@"%@",[[arrPower objectAtIndex:1] objectForKey:@"unitField"]];
                            
                            if ([strUnit isEqualToString:@"0"]) {
                                
                                strUnit = @"m";
                                
                            }
                            else if ([strUnit isEqualToString:@"1"]) {
                                
                                strUnit = @"mm";
                            }
                            else if ([strUnit isEqualToString:@"2"]) {
                                
                                strUnit = @"kg";
                            }
                            else if ([strUnit isEqualToString:@"3"]) {
                                
                                strUnit = @"ccm";
                            }
                            else if ([strUnit isEqualToString:@"4"]) {
                                
                                strUnit = @"hp";
                            }
                            else if ([strUnit isEqualToString:@"5"]) {
                                
                                strUnit = @"kw";
                            }
                            
                            [strToDisplay appendString:[NSString stringWithFormat:@"/%@%@ Power",[[arrPower objectAtIndex:1] objectForKey:@"valueField"],strUnit]];
                            
                            
                        }
                        
                    }
                    
                }
                
                NSString *strnationalVehicleCodeField = [NSString stringWithFormat:@"%@",[[dicResult objectForKey:@"typeField"] objectForKey:@"nationalVehicleCodeField"]];
                
                if (![dicDisplayData objectForKey:strnationalVehicleCodeField]) {
                    
                    [dicDisplayData setObject:strToDisplay forKey:strnationalVehicleCodeField];
                }
                
                
            }
            
        }
        
    }
    
    if ([dicDisplayData count] > 0) {
        
        
        if ([dicDisplayData count] == 1) {
            
            NSString *strVehicleCode = [[dicDisplayData allKeys] objectAtIndex:0];
            
            NSDictionary *dicVehicle = [objSKDatabase lookupRowForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",strVehicleCode]];
            
            int days;
            NSString *strDate = [dicVehicle objectForKey:@"ActiveRun"];
            NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
            [_formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
            
            NSString *str = [_formatter stringFromDate:[NSDate date]];
            
            NSArray *aryActiveRun = [strDate componentsSeparatedByString:@" "];
            NSArray *aryCurrentDate = [str componentsSeparatedByString:@" "];
            
            if([[aryActiveRun objectAtIndex:0] isEqualToString:[aryCurrentDate objectAtIndex:0]])
                days = 0;
            else
                days = -1;
            
            NSString *strQuery = [NSString stringWithFormat:@"select t1.* , t2.* from tblOnSale t1 , tblOnSold t2 where t1.GlassCarCode = '%@' AND t2.GlassCarCode = '%@'",strVehicleCode,strVehicleCode];
            
            NSArray *arrLastRecord = [objSKDatabase lookupAllForSQL:strQuery];
            
            
            if ([arrLastRecord count] > 0 && days == 0 && [[dicVehicle objectForKey:@"OriginalMileage"] isEqualToString:StrMilege])
            {
                
                // If Vehicle already exist, redirect to Summary
                
                appDel.isRadarSummery = TRUE;
                
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                appDel.strVehicleID = strVehicleCode;
                if(appDel.isIphone5)
                {
                    
                    SummaryViewController *objSummaryViewController=[[SummaryViewController alloc]initWithNibName:@"SummaryViewController_i5" bundle:Nil];
                    [appDel.navigationeController pushViewController:objSummaryViewController animated:YES];
                }
                else
                {
                    SummaryViewController *objSummaryViewController=[[SummaryViewController alloc]initWithNibName:@"SummaryViewController" bundle:Nil];
                    [appDel.navigationeController pushViewController:objSummaryViewController animated:YES];
                    
                }
                
            }
            else{
                
                
                
                // Insert Valuation
                
                [objSKDatabase deleteWhere:[NSString stringWithFormat:@"GlassCarCode = '%@'",strVehicleCode] forTable:@"tblVehicleSearchTree"];
                
                
                
                NSMutableDictionary *dicTemp = [[NSMutableDictionary alloc] init];
                
                NSString *StrMilege;
                if (btnAverageMilage.isSelected) {
                    StrMilege = @"0";
                    
                }
                else{
                    
                    StrMilege = txtMileage.text;
                    StrMilege = [StrMilege stringByReplacingOccurrencesOfString:@"," withString:@""];
                }
                
                NSString *strMonth = nil;
                int currentPlateIndex;
                
                for(int i=0;i<[self.arrPlates count];i++)
                {
                    if([lblPlate.text isEqualToString:[self.arrPlates objectAtIndex:i]])
                    {
                        currentPlateIndex = i;
                        break;
                    }
                }
                if([lblYear.text intValue]<=2000)
                {
                    if(currentPlateIndex == 0)
                        strMonth = @"1";
                    else if(currentPlateIndex == 1)
                        strMonth = @"5";
                    else
                        strMonth = @"11";
                }
                else
                {
                    if(currentPlateIndex == 0)
                        strMonth = @"1";
                    else if(currentPlateIndex == 1)
                        strMonth = @"6";
                    else
                        strMonth = @"12";
                    
                }
                
                NSString *strProductionPeriodDate = [NSString stringWithFormat:@"%@-%@",lblYear.text,strMonth];
                
                [dicTemp setObject:StrMilege forKey:@"Mileage"];
                [dicTemp setObject:strProductionPeriodDate forKey:@"RegistrationDate"];
                [dicTemp setObject:lblmake.text forKey:@"Make"];
                [dicTemp setObject:lblmodel.text forKey:@"Model"];
                [dicTemp setObject:lblYear.text forKey:@"Year"];
                [dicTemp setObject:lblPlate.text forKey:@"Plate"];
                [dicTemp setObject:lblFuelType.text forKey:@"FuelType"];
                [dicTemp setObject:lblBodytype.text forKey:@"BodyType"];
                [dicTemp setObject:lblEngineSize.text forKey:@"EngineSize"];
                [dicTemp setObject:lblTransmission.text forKey:@"Transmission"];
                [dicTemp setObject:lblderivative.text forKey:@"Derivative"];
                [dicTemp setObject:strVehicleCode forKey:@"GlassCarCode"];
                
                [objSKDatabase insertDictionary:dicTemp forTable:@"tblVehicleSearchTree"];
                
                // Call WS Valuation if one vehicle found
                
                [self getValutionData:strVehicleCode];
            }
        }
        else{
            
            // IF Multiple Vehicle Found , Redirect to SelectCarFromSearchTreeView 
            
            [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
            
            SelectCarFromSearchTreeView *objSelectCarFromSearchTreeView = [[SelectCarFromSearchTreeView alloc] initWithNibName:@"SelectCarFromSearchTreeView" bundle:nil];
            objSelectCarFromSearchTreeView.dicAllVehicleData = dicDisplayData;
            objSelectCarFromSearchTreeView.dicOfParameters = dicTemp;
            [self.navigationController pushViewController:objSelectCarFromSearchTreeView animated:YES];
        }
        
    }
    else{
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
        
        [Flurry endTimedEvent:@"WS-P-GetValuation" withParameters:nil];
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"This vehicle cannot be valued. This may be because the vehicle is too new to have a used valuation available or is a rare or exotic model. We apologise for any inconvenience this has caused." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
        
        
        
    }
    
}

@end
