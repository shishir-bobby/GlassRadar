//
//  SummaryViewController.m
//  Glass_Radar
//
//  Created by Nirmalsinh Rathod on 1/23/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "SummaryViewController.h"
#import "VehicalSearchTreeViewController.h"
@interface SummaryViewController ()

@end

@implementation SummaryViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [SVProgressHUD dismiss];
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    if(appDel.isFlurryOn)
    {
        [Flurry logEvent:@"Summary"];
        
    }
    
    // Get the Postcode from databse and Display
    
    NSString *strCustomPostCode = [objSKDatabase lookupColForSQL:[NSString stringWithFormat:@"select CustomPostCode from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
    
    
    if (strCustomPostCode.length > 0) {
        
        [btnPostcode setTitle:strCustomPostCode forState:UIControlStateNormal];
    }
    
    /* Check Gps is on or not*/
    
    int rowsel = [[NSUserDefaults standardUserDefaults] integerForKey:@"UseGPS"];
    
    if (rowsel== 0) {
        
        btnLoc.selected = TRUE;
    }
    else
    {
        
        btnLoc.selected = FALSE;
    }
    
    
    /* Check Gps is on or not*/
    
    appDel.isSummary = TRUE;
    
    if (appDel.isRadarSummery)
    {
        imgViewPlate.hidden=TRUE;
        lblPlateNo.hidden =TRUE;
        NSString *RadarSummeryNavKeystr = NSLocalizedString(@"RadarSummeryNavKey", nil);
        self.navigationItem.titleView=[AppDelegate navigationTitleLable:RadarSummeryNavKeystr];
    }
    else
    {
        imgViewPlate.hidden=FALSE;
        lblPlateNo.hidden =FALSE;
        NSString *VRMSummeryNavKeystr = NSLocalizedString(@"VRMSummeryNavKey", nil);
        self.navigationItem.titleView=[AppDelegate navigationTitleLable:VRMSummeryNavKeystr];
        
    }
    
    [objBottomView.bottomTabBar setSelectedItem:[objBottomView.bottomTabBar.items objectAtIndex:1]];
    
    appDel.appDelLastIndex=1;
    
    
    if (appDel.isFromHistory) {
        
        _btnWrongvehicle.hidden = TRUE;
        
    }
    else{
        
        _btnWrongvehicle.hidden = FALSE;
    }
    
    
    if (appDel.strVehicleID.length == 0) {
        
        appDel.strVehicleID = [[NSUserDefaults standardUserDefaults] objectForKey:@"GlassCarCode"];
        
    }
    else{
        
        [[NSUserDefaults standardUserDefaults] setObject:appDel.strVehicleID forKey:@"GlassCarCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    //Fetch All Vehicle detail that needs to show
    //appDel.strVehicleID is the Vehicle ID used in whole App
    [self fetchDetailFromDB];
    
    //Set the Filter button as per the last search made
    [self setToogleButton:nil];
    
    [self hideMenuBar];
    
}
- (void)viewDidLoad
{
    
    
    NSString *Mileskeystr = NSLocalizedString(@"Mileskey", nil);
    NSString *Distanefromkeystr = NSLocalizedString(@"Distanefromkey", nil);
    NSString *wrongVehiclestr = NSLocalizedString(@"wrongVehiclekey", nil);
    NSString *ViewOnSaleMatchesstr = NSLocalizedString(@"ViewOnSaleMatcheskey", nil);
    NSString *ViewSoldMatchesstr = NSLocalizedString(@"ViewSoldMatcheskey", nil);
    NSString *btnMenustr = NSLocalizedString(@"btnMenukey", nil);
    
    
    /**/
    
    _btnViewSale.text=ViewOnSaleMatchesstr;
    _btnViewSold.text=ViewSoldMatchesstr;
    [_btnWrongvehicle setTitle:wrongVehiclestr forState:UIControlStateNormal];
    _lblDistancefrom.text=Distanefromkeystr;
    _lblMiles.text=Mileskeystr;
    /*Left Click*/
    
    
    swipeGestureLeftObjectViewSummery = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftSummery_Clicked)] ;
    swipeGestureLeftObjectViewSummery.numberOfTouchesRequired = 1;
    swipeGestureLeftObjectViewSummery.direction = (UISwipeGestureRecognizerDirectionRight);
    [viewMain addGestureRecognizer:swipeGestureLeftObjectViewSummery];
    
    /*Right click*/
    swipeGestureRightObjectViewVRM = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightSummery_Clicked)] ;
    
    swipeGestureRightObjectViewVRM.numberOfTouchesRequired = 1;
    swipeGestureRightObjectViewVRM.direction = (UISwipeGestureRecognizerDirectionLeft);
    [viewMain addGestureRecognizer:swipeGestureRightObjectViewVRM];
    
    /**/
    UIButton *buttonmenu=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonmenu setFrame:CGRectMake(0, 0, 44, 30)];
    [buttonmenu setBackgroundImage:[UIImage imageNamed:@"selection-button-icon@2x.png"] forState:UIControlStateNormal];
    [buttonmenu setTitle:btnMenustr forState:UIControlStateNormal];
    [buttonmenu setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    buttonmenu.titleLabel.textColor = [UIColor whiteColor];
    [buttonmenu.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [buttonmenu addTarget:self action:@selector(buttonmenuClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnmenu=[[UIBarButtonItem alloc]initWithCustomView:buttonmenu];
    [self.navigationItem setLeftBarButtonItem:btnmenu];
    
    UIButton *buttonSetting=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonSetting setFrame:CGRectMake(0, 0, 30, 30)];
    [buttonSetting setBackgroundImage:[UIImage imageNamed:@"settings-icon@2x.png"] forState:UIControlStateNormal];
    [buttonSetting addTarget:self action:@selector(btnSettingClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSetting=[[UIBarButtonItem alloc]initWithCustomView:buttonSetting];
    
    [self.navigationItem setRightBarButtonItem:btnSetting];
    
    objBottomView = [[BottomTabBarView alloc] initWithNibName:@"BottomTabBarView" bundle:nil];
    objBottomView.view.frame = CGRectMake(0,appDel.heightBottom, 320, 49);
    [self.view addSubview:objBottomView.view];
    
    lblSpotPrice.backgroundColor = [appDel colorForHex:@"#005288"];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark -
#pragma mark Other Method

-(void)fetchDetailFromDB {
    
    dicVehicleDetail = [[NSDictionary alloc] init];
    dicVehicleDetail = [objSKDatabase lookupRowForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
    
    
    if ([dicVehicleDetail count] > 0) {
        
        if ([dicVehicleDetail objectForKey:@"TradePriceDate"]) {
            //Glass Trade
            
            lblTradePriceDate.text = [NSString stringWithFormat:@"%@ Glass Trade",[dicVehicleDetail objectForKey:@"TradePriceDate"]];
        }
        
        
        lblPlateNo.text = [dicVehicleDetail objectForKey:@"RegistrationNo"];
        
        NSString *sliderVal = [NSString stringWithFormat:@"%.2f",[[dicVehicleDetail objectForKey:@"SearchRadius"] floatValue]];
        
        sliderDBValue = [sliderVal floatValue];
        milesSlider.value = sliderDBValue;
        
        int sellingCategory = [[dicVehicleDetail objectForKey:@"sellingTimeCategory"] intValue];
        
        if (sellingCategory == 1) {
            //Green calendar
            
            imgCalendar.image = [UIImage imageNamed:@"calendar-bg-GREEN@2x.png"];
            
        }
        else if (sellingCategory == 2)
        {
            
            //Amber calendar
            imgCalendar.image = [UIImage imageNamed:@"calendar-bg-AMBER@2x.png"];
        }
        else if (sellingCategory == 3){
            
            //Red Calendar
            imgCalendar.image = [UIImage imageNamed:@"calendar-bg-RED@2x.png"];
        }
        else{
            
            //black Calendar
            imgCalendar.image = [UIImage imageNamed:@"calendar-bg-BLACK@2x.png"];
        }
        
        NSMutableString *strVehicleDesc = [[NSMutableString alloc] init];
        
        
        
        if ([[dicVehicleDetail objectForKey:@"yearOfManufacture"] length] > 0) {
            
            [strVehicleDesc appendString:[dicVehicleDetail objectForKey:@"yearOfManufacture"]];
        }
        
        if ([[dicVehicleDetail objectForKey:@"Make"] length] > 0) {
            
            [strVehicleDesc appendString:[NSString stringWithFormat:@", %@",[dicVehicleDetail objectForKey:@"Make"]]];
        }
        if ([[dicVehicleDetail objectForKey:@"Model"] length] > 0) {
            
            [strVehicleDesc appendString:[NSString stringWithFormat:@", %@",[dicVehicleDetail objectForKey:@"Model"]]];
        }
        
        if ([[dicVehicleDetail objectForKey:@"Description"] length] > 0) {
            
            [strVehicleDesc appendString:[NSString stringWithFormat:@", %@",[dicVehicleDetail objectForKey:@"Description"]]];
        }
        if ([[dicVehicleDetail objectForKey:@"BodyType"] length] > 0) {
            
            [strVehicleDesc appendString:[NSString stringWithFormat:@", %@",[dicVehicleDetail objectForKey:@"BodyType"]]];
        }
        
        lblModelDesc.text = strVehicleDesc;
        
        
        //£
        
        if ([dicVehicleDetail objectForKey:@"SpotPrice"]) {
            
            if([[dicVehicleDetail objectForKey:@"SpotPrice"] intValue] == 0)
                lblSpotPrice.text=@"-";
            else
                lblSpotPrice.text = [NSString stringWithFormat:@"£%@",[dicVehicleDetail objectForKey:@"SpotPrice"]];
            
            CGSize textLabelSize = [lblSpotPrice.text sizeWithFont:lblSpotPrice.font /*constrainedToSize:constrainedSize*/];
            
            
            if (textLabelSize.width > 60) {
                textLabelSize.width = 60;
            }
            lblSpotPrice.frame = CGRectMake(284-textLabelSize.width - 5, lblSpotPrice.frame.origin.y, textLabelSize.width + 5, lblSpotPrice.frame.size.height);
            
            lblSpotPrice.textAlignment = UITextAlignmentCenter;
            
            
        }
        if ([dicVehicleDetail objectForKey:@"TradePrice"]) {
            
            lblTradePrice.text = [NSString stringWithFormat:@"£%@",[dicVehicleDetail objectForKey:@"TradePrice"]];
            
            CGSize textLabelSize = [lblTradePrice.text sizeWithFont:lblTradePrice.font /*constrainedToSize:constrainedSize*/];
            
            if (textLabelSize.width > 60) {
                textLabelSize.width = 60;
            }
            
            lblTradePrice.frame = CGRectMake(284-textLabelSize.width - 5, lblTradePrice.frame.origin.y, textLabelSize.width + 5, lblTradePrice.frame.size.height);
            lblTradePrice.textAlignment = UITextAlignmentCenter;
            
        }
        if ([dicVehicleDetail objectForKey:@"avgSellingTime"]) {
            
            lblAverageSellingDay.text = [NSString stringWithFormat:@"%@",[dicVehicleDetail objectForKey:@"avgSellingTime"]];
        }
        
        
        // Set Counter For sale
        
        NSMutableArray *arrAllData = (NSMutableArray *)[objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblOnSale where GlassCarCode = '%@'",appDel.strVehicleID]];
        
        int counterVeryHigh = 0;
        int counterHigh = 0;
        int counterMed = 0;
        
        
        for (NSDictionary *dic in arrAllData) {
            
            //similarityCategory
            if ([dic objectForKey:@"similarityCategory"]) {
                int code = [[dic objectForKey:@"similarityCategory"] intValue];
                
                if (code == 1) {
                    
                    // very High
                    counterVeryHigh++;
                    
                }
                else if (code == 2){
                    
                    counterHigh++;
                    
                }
                else if (code == 3){
                    
                    counterMed++;
                }
                
            }
            
        }
        
        
        int all = [[NSString stringWithFormat:@"%d",counterVeryHigh] intValue] + [[NSString stringWithFormat:@"%d",counterHigh] intValue] + [[NSString stringWithFormat:@"%d",counterMed] intValue];
        
        [lblCounterVHigh setText:[NSString stringWithFormat:@"%d",counterVeryHigh]];
        [lblCounterHigh setText:[NSString stringWithFormat:@"%d",counterHigh]];
        [lblCounterMed setText:[NSString stringWithFormat:@"%d",counterMed]];
        [lblCounterAll setText:[NSString stringWithFormat:@"%d",all]];
        
        
        arrAllData = nil;
        
        arrAllData = (NSMutableArray *)[objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblOnSold where GlassCarCode = '%@'",appDel.strVehicleID]];
        
        counterVeryHigh = 0;
        counterHigh = 0;
        counterMed = 0;
        
        
        for (NSDictionary *dic in arrAllData) {
            
            //similarityCategory
            if ([dic objectForKey:@"similarityCategory"]) {
                int code = [[dic objectForKey:@"similarityCategory"] intValue];
                
                if (code == 1) {
                    
                    // very High
                    counterVeryHigh++;
                    
                }
                else if (code == 2){
                    
                    counterHigh++;
                    
                }
                else if (code == 3){
                    
                    counterMed++;
                }
                
            }
            
        }
        
        all = [[NSString stringWithFormat:@"%d",counterVeryHigh] intValue] + [[NSString stringWithFormat:@"%d",counterHigh] intValue] + [[NSString stringWithFormat:@"%d",counterMed] intValue];
        
        
        [lblSoldCounterVHigh setText:[NSString stringWithFormat:@"%d",counterVeryHigh]];
        [lblSoldCounterHigh setText:[NSString stringWithFormat:@"%d",counterHigh]];
        [lblSoldCounterMed setText:[NSString stringWithFormat:@"%d",counterMed]];
        [lblSoldCounterAll setText:[NSString stringWithFormat:@"%d",all]];
        
    }
    
}


-(void)swipeRightSummery_Clicked
{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    
    OnSaleViewController *objOnSaleViewController =[[OnSaleViewController alloc]initWithNibName:@"OnSaleViewController" bundle:nil];
    [self.navigationController pushViewController:objOnSaleViewController animated:NO];
}
-(void)swipeLeftSummery_Clicked
{
    
    [objBottomView push:0];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Button Method
-(void)btnSettingClick:(id)sender
{
    [appDel loadSettingScreen];
}

-(void)buttonmenuClick:(id)sender
{
    
    appDel.isMenuHidden = !appDel.isMenuHidden;
    [self hideMenuBar];
}
-(void)hideMenuBar
{
    if(appDel.isMenuHidden==FALSE)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        objBottomView.view.frame=CGRectMake(0, self.view.frame.size.height-49, 320, 49);
        [UIView commitAnimations];
        objBottomView.view.hidden=FALSE;
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        //        appDel.isMenuHidden = FALSE;
    }
    else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        objBottomView.view.frame=CGRectMake(0, self.view.frame.size.height, 320, 49);
        [UIView commitAnimations];
        [self performSelector:@selector(stopAnimatingMethod) withObject:nil afterDelay:0.3];
        // appDel.isMenuHidden = TRUE;
    }
    
}

-(void)stopAnimatingMethod
{
    objBottomView.view.hidden=TRUE;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (IBAction)btnLocClicked:(id)sender {
    
    appDel.isWithoutPostCode = FALSE;
    LocationViewController *objLocationViewController=[[LocationViewController alloc]initWithNibName:@"LocationViewController" bundle:nil];
    [self.navigationController pushViewController:objLocationViewController animated:YES];
}


- (IBAction)btnWrongVehicleClicked:(id)sender  {
    
    
    @try {
        
        appDel.isWrongVehiclePressed = TRUE;
        NSArray *ary = appDel.navigationeController.viewControllers;
        UIViewController *view1;
        
        
        //RegistrationNo
        
        if (!lblPlateNo.hidden) {
            
            for(UIViewController *view in ary)
            {
                if([view isKindOfClass:[VRMSearchViewController class]] )
                {
                    view1 =view;
                    break;
                }
                
                
            }
            
            
            if (view1 != nil) {
                
                CATransition *transition = [CATransition animation];
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                
                
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromLeft;
                [appDel.navigationeController.view.layer addAnimation:transition forKey:nil];
                
                
                [appDel.navigationeController popToViewController:view1 animated:NO];
                
            }
            else{
                
                CATransition *transition = [CATransition animation];
                transition.duration = 0.0;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromLeft;
                
                [self.navigationController.view.layer addAnimation:transition forKey:nil];
                
                VRMSearchViewController *objVRMSearchViewController = [[VRMSearchViewController alloc] initWithNibName:@"VRMSearchViewController" bundle:nil];
                [self.navigationController pushViewController:objVRMSearchViewController animated:NO];
                
            }
            
        }
        else{
            
            for(UIViewController *view in ary)
            {
                if([view isKindOfClass:[VehicalSearchTreeViewController class]] )
                {
                    view1 =view;
                    break;
                }
                
                
            }
            
            if (view1 != nil) {
                
                CATransition *transition = [CATransition animation];
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                
                
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromLeft;
                [appDel.navigationeController.view.layer addAnimation:transition forKey:nil];
                
                
                [appDel.navigationeController popToViewController:view1 animated:NO];
                
            }
            else{
                
                CATransition *transition = [CATransition animation];
                transition.duration = 0.0;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromLeft;
                
                [self.navigationController.view.layer addAnimation:transition forKey:nil];
                
                VehicalSearchTreeViewController *objVehicalSearchTreeViewController = [[VehicalSearchTreeViewController alloc] initWithNibName:@"VehicalSearchTreeViewController" bundle:nil];
                [self.navigationController pushViewController:objVehicalSearchTreeViewController animated:NO];
                
            }
            
            
        }
        
        
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}


- (IBAction)btnOnSaleClickedButton:(id)sender
{
    
    OnSaleViewController *objOnSale = [[OnSaleViewController alloc] initWithNibName:@"OnSaleViewController" bundle:nil];
    
    [self.navigationController pushViewController:objOnSale animated:YES];
}
- (IBAction)btnOnSoldClickedButton:(id)sender
{
    
    OnSoldViewController *objOnSold = [[OnSoldViewController alloc] initWithNibName:@"OnSoldViewController" bundle:nil];
    [self.navigationController pushViewController:objOnSold animated:YES];
}

- (IBAction)touchUpSlider:(id)sender {
    
    float silderValue = milesSlider.value;
    int flurryValue = 0;
    
    if(silderValue >= 0.0 && silderValue < 0.25)
    {
        milesSlider.value = 0.0;
        flurryValue = 50;
    }
    else if(silderValue >= 0.25 && silderValue < 0.50)
    {
        milesSlider.value = 0.25;
        flurryValue = 100;
    }
    else if(silderValue >= 0.50 && silderValue < 0.75)
    {
        milesSlider.value = 0.50;
        flurryValue = 200;
    }
    else if(silderValue >= 0.75)
    {
        milesSlider.value = 1.0;
        flurryValue = -1;
        
    }
    
    
    if (flurryValue == -1) {
        
        NSDictionary *sortParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"Summary", @"From_Screen", 
         @"Country", @"Radius", // Capture the sorting
         nil];
        
        if(appDel.isFlurryOn)
        {
            [Flurry logEvent:@"Change Radius" withParameters:sortParams];
            
        }
        // [Flurry logEvent:[NSString stringWithFormat:@"Change Radius' with Country"]];
    }
    else{
        
        NSDictionary *sortParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"Summary", @"From_Screen", 
         [NSString stringWithFormat:@"%d",flurryValue], @"Radius", // Capture the sorting
         nil];
        
        
        if(appDel.isFlurryOn)
        {
            [Flurry logEvent:@"Change Radius" withParameters:sortParams];
            
        }
        
    }
    
    if (sliderDBValue != milesSlider.value) {
        
        // Call Webservice if Slider Value change
        // Call will made for Similar and Removed adverts
        
        if (appDel.isOnline) {
            
            
            sliderDBValue = milesSlider.value;
            appDel.intValSlider = milesSlider.value;
            
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            
            if (!appDel.UserAuthenticated) {
                
                [SVProgressHUD showWithStatus:@"Please wait for authentication.."];
                [self CallLoginAPI];
            }
            else{
                
                [SVProgressHUD showWithStatus:@"Please Wait..."];
                [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(callWebService) userInfo:nil repeats:NO];
            }
            
            
        }
        else{
            
            UIAlertView *AlertError = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [AlertError show];
            AlertError = nil;
            
        }
        
    }
    else{
        sliderDBValue = milesSlider.value;
        appDel.intValSlider = milesSlider.value;
    }
    
}

#pragma mark
#pragma mark Webservice Call

-(void)CallLoginAPI
{
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
                    
                    // Bapu's Changes 09-0
                    AccessDeniedViewController *objAccessDeniedViewController = [[AccessDeniedViewController alloc] initWithNibName:@"AccessDeniedViewController" bundle:nil];
                    [self.navigationController pushViewController:objAccessDeniedViewController animated:YES];
                    
                }
                
                else if(![[dicreceivedData valueForKey:@"glassTokenField"] isEqualToString:@"00000000-0000-0000-0000-000000000000"] && [strValidField isEqualToString:@"1"])
                {
                    
                    appDel.UserAuthenticated = TRUE;
                    [SVProgressHUD show];
                    [self callWebService];
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
}

-(void)callWebService {
    
    ServiceCallTemp *objServiceCall = [[ServiceCallTemp alloc] init];
    
    appDel.isFirstValuation = FALSE;
    
    NSDictionary *dicResponse = [objSKDatabase lookupRowForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
    
    if ([dicResponse count] > 0) {
        
        [objServiceCall performSelector:@selector(listSimilarAdvertisements:) withObject:dicResponse];
        
    }
    
    [SVProgressHUD dismiss];
    
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    
    [self fetchDetailFromDB];
    
}

- (IBAction)btnOnSaleClicked:(id)sender
{
    int tagValue = [sender tag];
    appDel.selectedTag = tagValue;
    
    [self setToogleButton:sender];
    
    OnSaleViewController *objOnSale = [[OnSaleViewController alloc] initWithNibName:@"OnSaleViewController" bundle:nil];
    [self.navigationController pushViewController:objOnSale animated:YES];
}
- (IBAction)btnOnSoldClicked:(id)sender
{
    
    int tagValue = [sender tag];
    appDel.selectedTag = tagValue;
    
    [self setToogleButton:sender];
    
    OnSoldViewController *objOnSold = [[OnSoldViewController alloc] initWithNibName:@"OnSoldViewController" bundle:nil];
    [self.navigationController pushViewController:objOnSold animated:YES];
}

-(void)setToogleButton :(id) sender
{
    
    
    if (sender != nil) {
        
        UIButton *btnMain = (UIButton *)sender;
        UIButton *btnSold;
        
        if (btnMain.tag > 200) {
            
            btnSold = (UIButton *)[viewMain viewWithTag:btnMain.tag];
            
        }
        
        
        if (btnMain.tag == 4 || btnSold.tag == 204){
            
            if ([btnMain isSelected] || [btnSold isSelected])
            {
                
                [btnMain setSelected:FALSE];
                [btnVHigh setSelected:FALSE];
                [btnMed setSelected:FALSE];
                [btnHigh setSelected:FALSE];
                
                [btnSold setSelected:FALSE];
                [btnVHighSold setSelected:FALSE];
                [btnMedSold setSelected:FALSE];
                [btnHighsSold setSelected:FALSE];
                
                [appDel.dicSelectedTag setObject:@"true" forKey:@"1"];
                [appDel.dicSelectedTag setObject:@"true" forKey:@"2"];
                [appDel.dicSelectedTag setObject:@"true" forKey:@"3"];
                [appDel.dicSelectedTag setObject:@"true" forKey:@"4"];
                [appDel.dicSelectedTag setObject:@"true" forKey:@"0"];
                
            }
            else
            {
                [btnMain setSelected:TRUE];
                [btnVHigh setSelected:TRUE];
                [btnMed setSelected:TRUE];
                [btnHigh setSelected:TRUE];
                
                [btnSold setSelected:TRUE];
                [btnVHighSold setSelected:TRUE];
                [btnMedSold setSelected:TRUE];
                [btnHighsSold setSelected:TRUE];
                
                [appDel.dicSelectedTag setObject:@"false" forKey:@"1"];
                [appDel.dicSelectedTag setObject:@"false" forKey:@"2"];
                [appDel.dicSelectedTag setObject:@"false" forKey:@"3"];
                [appDel.dicSelectedTag setObject:@"false" forKey:@"4"];
                [appDel.dicSelectedTag setObject:@"true" forKey:@"0"];
            }
            
        }
        else{
        
            int selectedTag ;
            if(btnMain.tag < 200)
                selectedTag = btnMain.tag;
            else
                selectedTag = btnMain.tag - 200;
            
            for(int i =1;i<5;i++)
            {
                if(i == selectedTag)
                    [appDel.dicSelectedTag setObject:@"true" forKey:[NSString stringWithFormat:@"%d",i]];
                else
                    [appDel.dicSelectedTag setObject:@"false" forKey:[NSString stringWithFormat:@"%d",i]];
            }
            
            if([[appDel.dicSelectedTag objectForKey:@"1"] isEqualToString:@"true"] && [[appDel.dicSelectedTag objectForKey:@"2"] isEqualToString:@"true"] && [[appDel.dicSelectedTag objectForKey:@"3"] isEqualToString:@"true"])
            {
                btnAll.selected = TRUE;
                btnAllSold.selected = TRUE;
                [appDel.dicSelectedTag setObject:@"true" forKey:@"4"];
            }
            else
            {
                btnAll.selected = FALSE;
                btnAllSold.selected = FALSE;
                [appDel.dicSelectedTag setObject:@"false" forKey:@"4"];
            }
            
            
        }
    }
    for (NSString *strKey in [appDel.dicSelectedTag allKeys]) {
        
        NSString *strValue = [appDel.dicSelectedTag objectForKey:strKey];
        int tag = [strKey intValue];
        if (tag == 0) {
            
        }
        else{
            
            UIButton *btn = (UIButton *)[viewMain viewWithTag:tag];
            UIButton *btnSld = (UIButton *)[viewMain viewWithTag:200+tag];
            
            if ([strValue isEqualToString:@"true"]) {
                
                [btn setSelected:FALSE];
                [btnSld setSelected:FALSE];
            }
            else{
                
                [btn setSelected:TRUE];
                [btnSld setSelected:TRUE];
            }
            
        }
    }
}


- (void)viewDidUnload {
    
    milesSlider = nil;
    lblPlateNo = nil;
    imgViewPlate = nil;
    btnLoc = nil;
    [self setBtnViewSold:nil];
    [self setBtnViewSold:nil];
    [self setBtnViewSale:nil];
    [self setLblDistancefrom:nil];
    [self setLblMiles:nil];
    [self setBtnWrongvehicle:nil];
    imgCalendar = nil;
    viewSlider = nil;
    viewMain = nil;
    lblTradePriceDate = nil;
    lblSpotPriceColor = nil;
    lblCounterVHigh = nil;
    lblCounterHigh = nil;
    lblCounterMed = nil;
    lblCounterAll = nil;
    lblSoldCounterVHigh = nil;
    lblSoldCounterHigh = nil;
    lblSoldCounterMed = nil;
    lblSoldCounterAll = nil;
    [super viewDidUnload];
}
@end
