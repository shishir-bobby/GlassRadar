//
//  SelectCarFromSearchTreeView.m
//  Glass_Radar
//
//  Created by Pankti on 26/04/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "SelectCarFromSearchTreeView.h"
#import "SummaryViewController.h"
#define kCellNibName @"SelectCarFromTreeCell"
#define CellIdentifier @"cell"

@interface SelectCarFromSearchTreeView ()

@end

@implementation SelectCarFromSearchTreeView
@synthesize dicAllVehicleData;
@synthesize dicOfParameters;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    
    NSString *VRMBackstr = NSLocalizedString(@"VRMBackkey", nil);
    NSString *SelectCarNavstr = NSLocalizedString(@"SelectCarNavkey", nil);
    NSString *Selectcarlblstr = NSLocalizedString(@"Selectcarlblkey", nil);
    
    lblSelectedCar.text=Selectcarlblstr;
    
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
    self.navigationItem.titleView=[AppDelegate navigationTitleLable:SelectCarNavstr];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    objWebServicesjson = [[WebServicesjson alloc]init];
    
    if(appDel.isFlurryOn)
    {
        [Flurry logEvent:@"Select Vehicle"];
        
    }
    
}

-(void)backClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark Service Call


-(void) setStatus:(CarFromSearchTreeStatus)status {
    
    if (status == DoneTreeValuation){
        
        appDel.isRadarSummery = TRUE;
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
        
        
        int rowsel = [[NSUserDefaults standardUserDefaults] integerForKey:@"UseGPS"];
        
        if (rowsel== 0) {
            
            // Call Location API
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
        
        NSArray *arr = [objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
        
        if ([arr count] > 0) {
            
            // All WS Call Start from here with Spot Price
            
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


-(void)valuationSearchData {
    
    
    if ([dicAllVehicleData count] > 0) {
        
        NSString *strVehicleCode = strSelectedVehicleID;
        
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
        
        if ([arrLastRecord count] > 0 && days == 0 && [[dicVehicle objectForKey:@"OriginalMileage"] isEqualToString:[dicOfParameters objectForKey:@"Mileage"]]){
            
            appDel.isRadarSummery = TRUE;
            
            [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
            
            
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
            
            [dicTemp setObject:[self.dicOfParameters objectForKey:@"Mileage"] forKey:@"Mileage"];
            [dicTemp setObject:[self.dicOfParameters objectForKey:@"RegistrationDate"] forKey:@"RegistrationDate"];
            [dicTemp setObject:[self.dicOfParameters objectForKey:@"Make"] forKey:@"Make"];
            [dicTemp setObject:[self.dicOfParameters objectForKey:@"Model"] forKey:@"Model"];
            [dicTemp setObject:[self.dicOfParameters objectForKey:@"yearOfManufacture"] forKey:@"Year"];
            [dicTemp setObject:[self.dicOfParameters objectForKey:@"Plate"] forKey:@"Plate"];
            [dicTemp setObject:[self.dicOfParameters objectForKey:@"FuelType"] forKey:@"FuelType"];
            [dicTemp setObject:[self.dicOfParameters objectForKey:@"BodyType"] forKey:@"BodyType"];
            [dicTemp setObject:[self.dicOfParameters objectForKey:@"EngineCapacity"] forKey:@"EngineSize"];
            [dicTemp setObject:[self.dicOfParameters objectForKey:@"TransmissionDescription"] forKey:@"Transmission"];
            [dicTemp setObject:[self.dicOfParameters objectForKey:@"Dedivative"] forKey:@"Derivative"];
            [dicTemp setObject:strVehicleCode forKey:@"GlassCarCode"];
            
            [objSKDatabase insertDictionary:dicTemp forTable:@"tblVehicleSearchTree"];
            
            [self getValutionData:strVehicleCode];
        }
        
    }
    
}
-(void)getValutionData : (NSString *) strVehicleID {
    
    @try {
        
        if (appDel.isOnline) {
            
            NSString *StrMilege = [self.dicOfParameters objectForKey:@"Mileage"];
            
            
            appDel.strMileageLocal = StrMilege;
            appDel.strSortingString = @"Spot Price";
            
            
            if (appDel.isFirstValuation) {
                
               // appDel.intValSlider = 0.0;
                
            }
            
            if (appDel.dicSelectedTag) {
                
                [appDel.dicSelectedTag setObject:@"true" forKey:@"1"];
                [appDel.dicSelectedTag setObject:@"true" forKey:@"2"];
                [appDel.dicSelectedTag setObject:@"true" forKey:@"3"];
                [appDel.dicSelectedTag setObject:@"true" forKey:@"0"];
                [appDel.dicSelectedTag setObject:@"true" forKey:@"4"];
                
                
            }
            
            [NSThread detachNewThreadSelector:@selector(showProgressWith:) toTarget:self withObject:@"Finding your vehicle"];
            
            
            if(appDel.isFlurryOn)
            {
                
                [Flurry logEvent:@"WS-P-GetValuation" timed:YES];
            }
            
            appDel.isSummary = FALSE;
            
            NSString *strProductionPeriodDate = [self.dicOfParameters objectForKey:@"RegistrationDate"];
            
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
                        
                        //@"No record found in SAE table",@"ErrorMsg",@"400",@"ErrorCode"
                        
                        if ([[dic objectForKey:@"ErrorCode"] isEqualToString:@"400"]) {
                            
                            /*Error_Event*/
                            NSDictionary *flurryParams =
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"WS-P-GetValuation", @"Error",
                             [NSString stringWithFormat:@"%@ for %@",[dic objectForKey:@"ErrorMsg"],strVehicleID],@"ErrorLocation",
                             
                             nil];
                            if(appDel.isFlurryOn)
                            {
                                //[Flurry logEvent:@"Vehicle Search Tree - Error" withParameters:flurryParams];
                                NSError *error;
                                
                                error = [NSError errorWithDomain:@"Vehicle Search Tree - WS-P-GetValuation - Server Error (400)" code:200 userInfo:flurryParams];
                                
                                [Flurry logError:@"Vehicle Search Tree - WS-P-GetValuation - Server Error (400)"   message:@"Vehicle Search Tree - WS-P-GetValuation - Server Error (400)"   error:error];//m2806
                                
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
                        
                        [dicToInsert setObject:[self.dicOfParameters objectForKey:@"Make"] forKey:@"Make"];
                        
                        [dicToInsert setObject:[self.dicOfParameters objectForKey:@"Model"] forKey:@"Model"];
                        
                        [dicToInsert setObject:[self.dicOfParameters objectForKey:@"yearOfManufacture"] forKey:@"yearOfManufacture"];
                        
                        NSMutableString *strVehicleDesc = [[NSMutableString alloc] init];
                        
                        [strVehicleDesc appendString:[NSString stringWithFormat:@"%@",[self.dicOfParameters objectForKey:@"Dedivative"]]];
                        
                        [dicToInsert setObject:strVehicleDesc forKey:@"Description"];
                        
                        [dicToInsert setObject:@"" forKey:@"Variant"];
                        
                        [dicToInsert setObject:[self.dicOfParameters objectForKey:@"BodyType"] forKey:@"BodyType"];
                        
                        [dicToInsert setObject:@"" forKey:@"Doors"];
                        
                        [dicToInsert setObject:[self.dicOfParameters objectForKey:@"EngineCapacity"] forKey:@"EngineCapacity"];
                        
                        [dicToInsert setObject:[self.dicOfParameters objectForKey:@"TransmissionDescription"] forKey:@"TransmissionDescription"];
                        
                        
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
                            
                            //change here
                            [dicToInsert setObject:@"" forKey:@"Currency"];
                        }
                        
                        [dicToInsert setObject:@"" forKey:@"CustomPostCode"];
                        
                        [dicToInsert setObject:StrMilege forKey:@"OriginalMileage"];
                        
                        [objSKDatabase insertDictionary:dicToInsert forTable:@"tblVehicle"];
                        
                        
                        
                    }
                    appDel.strVehicleID = strVehicleID;
                    [self setStatus:DoneTreeValuation];
                }
                else{
                    
                    /*****No Result Found*****/
                    NSDictionary *flurryParams =
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"WS-P-GetValuation", @"ErrorLocation", 
                     @"No Result Found", @"Error",
                     nil];
                    if(appDel.isFlurryOn)
                    {
                        
                        NSError *error;
                        error = [NSError errorWithDomain:@"Vehicle Search Tree - WS-P-GetValuation - No Result Found" code:200 userInfo:flurryParams];
                        [Flurry logError:@"Vehicle Search Tree - WS-P-GetValuation - No Result Found"   message:@"Vehicle Search Tree - WS-P-GetValuation - No Result Found"  error:error];
                        
                    }
                    /*****No Result Found*****/
                    
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
                /*****Server Error*****/
                NSDictionary *flurryParams =
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"WS-P-GetValuation", @"ErrorLocation", 
                 @"Server Error", @"Error",
                 nil];
                if(appDel.isFlurryOn)
                {
                    //[Flurry logEvent:@"Select Car From Search Tree - Error" withParameters:flurryParams];
                    NSError *error;
                    error = [NSError errorWithDomain:@"Vehicle Search Tree - WS-P-GetValuation - Server Error" code:200 userInfo:flurryParams];
                    
                    [Flurry logError:@"Vehicle Search Tree - WS-P-GetValuation - Server Error"   message:@"Vehicle Search Tree - WS-P-GetValuation - Server Error"  error:error];//m2806
                }
              /*****Server Error*****/
                
                
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
        
        /*****@catch*****/
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"WS-P-GetValuation", @"ErrorLocation", 
         exception.description, @"Error",
         nil];
        
        if(appDel.isFlurryOn)
        {
            //[Flurry logEvent:@"Select Car From Search Tree - Error" withParameters:flurryParams];
            NSError *error;
            error = [NSError errorWithDomain:@"Vehicle Search Tree - WS-P-GetValuation - Exception" code:200 userInfo:flurryParams];
            
            [Flurry logError:@"Vehicle Search Tree - WS-P-GetValuation - Exception"   message:@"Vehicle Search Tree - WS-P-GetValuation - Exception"  error:error];//m2806
        }

        /*****@catch*****/

        [Flurry endTimedEvent:@"WS-P-GetValuation" withParameters:nil];
        NSLog(@"exception : - %@" ,exception);
    }
    @finally {
        
        
    }
    
}

-(void)showProgressWith:(NSString *)strMessage
{
    
    [SVProgressHUD setStatus:strMessage];

    
}

#pragma mark
#pragma mark TableView Delegate Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    if ([self.dicAllVehicleData count] > 0) {
        
        return [self.dicAllVehicleData count];
    }
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if ([self.dicAllVehicleData count] > 0) {
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:kCellNibName owner:self options:nil];
            cell=cellList;
        }
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        
        
        UILabel *lblCarDetail = (UILabel *)[cell.contentView viewWithTag:1];
        
        
        //DisplayData
        
        NSString *strVehicleDesc = [[self.dicAllVehicleData allValues] objectAtIndex:indexPath.section];
        lblCarDetail.text = strVehicleDesc;
        
        return cell;
        
    }
    else{
        
        UITableViewCell *cellSimple = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        tableView.separatorColor = [UIColor clearColor];
        cellSimple.textLabel.text = @"No Vehicle Found";
        cellSimple.textLabel.textAlignment = UITextAlignmentCenter;
        cellSimple.userInteractionEnabled = FALSE;
        return cellSimple;
        
        
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    strSelectedVehicleID = [[self.dicAllVehicleData allKeys] objectAtIndex:indexPath.section];
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(valuationSearchData) userInfo:nil repeats:NO];
    
   
}



-(void) callWebService {
    
    
    // All WS Call Start from here with Spot Price
    
    ServiceCallTemp *objVRMServiceCall = [[ServiceCallTemp alloc] init];
    NSMutableDictionary *dic = (NSMutableDictionary *)[objSKDatabase lookupRowForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
    
    appDel.isFirstTimeGPS = FALSE;
    [objVRMServiceCall getSpotPrice:dic];
    
    
    [SVProgressHUD dismiss];
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView == alertNoPostcode) {
        
        appDel.isWithoutPostCode = TRUE;
        LocationViewController *objLocationViewController=[[LocationViewController alloc]initWithNibName:@"LocationViewController" bundle:nil];
        [appDel.navigationeController pushViewController:objLocationViewController animated:YES];
        
        
    }
    
}
- (void)viewDidUnload {
    
    tblCarList = nil;
    lblSelectedCar = nil;
    [super viewDidUnload];
}
@end
