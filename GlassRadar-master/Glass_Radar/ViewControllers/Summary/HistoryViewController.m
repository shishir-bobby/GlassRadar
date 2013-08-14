//
//  HistoryViewController.m
//  Glass_Radar
//
//  Created by Mina Shau on 1/30/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "HistoryViewController.h"
#define kCellNibName @"HistoryCell"
#define CellIdentifier @"cell"
@interface HistoryViewController ()

@end

@implementation HistoryViewController

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
    
    tblHistory.editing = NO;
    isEdited = TRUE;
    
    [self setNavBarButton];

    
    tblHistory.delegate = nil;
    tblHistory.dataSource = nil;
    tblHistory.hidden = YES;
    
    if(appDel.isIphone5)
        tableHeight = 520;
    else
        tableHeight = tblHistory.frame.size.height - 40;

    NSString *Historynavstr = NSLocalizedString(@"Historynavkey", nil);
    
    UILabel *lblNavTitle = [[UILabel alloc] init];
    lblNavTitle.text = Historynavstr;
    lblNavTitle.backgroundColor = [UIColor clearColor];
    lblNavTitle.textColor = [UIColor whiteColor];
    lblNavTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0];
    lblNavTitle.minimumFontSize=12.0;
    [lblNavTitle sizeToFit];
    self.navigationItem.titleView = lblNavTitle;
    
    
    UIButton *buttonLogout=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonLogout setFrame:CGRectMake(0, 0, 30, 30)];
    [buttonLogout setBackgroundImage:[UIImage imageNamed:@"settings-icon@2x.png"] forState:UIControlStateNormal];
    
    [buttonLogout addTarget:self action:@selector(btnSettingClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSetting=[[UIBarButtonItem alloc]initWithCustomView:buttonLogout];
    
    [self.navigationItem setRightBarButtonItem:btnSetting];

    objBottomView = [[BottomTabBarView alloc] initWithNibName:@"BottomTabBarView" bundle:nil];
    objBottomView.view.frame = CGRectMake(0,appDel.heightBottom, 320, 49);
    [self.view addSubview:objBottomView.view];
    
    
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    
    if(appDel.isFlurryOn)
    {
        
        [Flurry logEvent:@"History"];
    }
    
    UISwipeGestureRecognizer *swipeGestureLeftObjectViewHistory = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftHistory_Clicked)] ;
    swipeGestureLeftObjectViewHistory.numberOfTouchesRequired = 1;
    swipeGestureLeftObjectViewHistory.direction = (UISwipeGestureRecognizerDirectionRight);
    [self.view addGestureRecognizer:swipeGestureLeftObjectViewHistory];

    // Fetch Vehicle detail from History table
    [self fetchHistoryData];
    
    [objBottomView.bottomTabBar setSelectedItem:[objBottomView.bottomTabBar.items objectAtIndex:4]];
    [self hideMenuBar];
    [super viewWillAppear:animated];
}


#pragma mark
#pragma mark Other Method


-(void)fetchHistoryData {

    if (arrHistory) {
        
        arrHistory = nil;
    }
    arrHistory =[[NSMutableArray alloc] init];
    arrHistory = (NSMutableArray *)[objSKDatabase lookupAllForSQL:@"select * from tblHistory"];

    
    if ([arrHistory count] > 0) {
    
        NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithCapacity:[arrHistory count]];
        for (int i = [arrHistory count]-1 ; i >= 0 ; i--) {
            
            [arrTemp addObject:[arrHistory objectAtIndex:i]];
            
        }
        
        [arrHistory removeAllObjects];
         arrHistory = nil;
        
        arrHistory = [arrTemp mutableCopy];
        
    }
    
    tblHistory.delegate = self;
    tblHistory.dataSource = self;
    [tblHistory reloadData];
    tblHistory.hidden = FALSE;
    
    
}
-(void)swipeLeftHistory_Clicked
{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    
    if(!appDel.isSummary)
    {
        VRMSearchViewController *objVRMSearch = [[VRMSearchViewController alloc] initWithNibName:@"VRMSearchViewController" bundle:nil];
        [self.navigationController pushViewController:objVRMSearch animated:NO];
    }
    else
    {
        OnSoldViewController *objOnSoldViewController =[[OnSoldViewController alloc]initWithNibName:@"OnSoldViewController" bundle:nil];
        [self.navigationController pushViewController:objOnSoldViewController animated:NO];
    }
    
    
}

-(void)setNavBarButton
{
    NSString *btnMenustr = NSLocalizedString(@"btnMenukey", nil);
    NSString *btnEditstr = NSLocalizedString(@"btnEditkey", nil);
    NSString *btnDonestr = NSLocalizedString(@"btnDonekey", nil);


    UIButton *buttonmenu=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonmenu setFrame:CGRectMake(0, 0, 44, 30)];
    [buttonmenu setBackgroundImage:[UIImage imageNamed:@"selection-button-icon@2x.png"] forState:UIControlStateNormal];
    [buttonmenu setTitle:btnMenustr forState:UIControlStateNormal];
    [buttonmenu setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    buttonmenu.titleLabel.textColor = [UIColor whiteColor];
    [buttonmenu.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    
    [buttonmenu addTarget:self action:@selector(buttonmenuClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnmenu=[[UIBarButtonItem alloc]initWithCustomView:buttonmenu];
    
    // [self.navigationItem setLeftBarButtonItem:btnmenu];
    
    UIButton *buttonEdit=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonEdit setFrame:CGRectMake(50, 0, 44, 30)];
    [buttonEdit setBackgroundImage:[UIImage imageNamed:@"selection-button-icon@2x.png"] forState:UIControlStateNormal];
    
    if(isEdited)
    {
        tblHistory.editing=NO;
        isEdited = FALSE;
        [buttonEdit setTitle:btnEditstr forState:UIControlStateNormal];
    }
    else
    {
        tblHistory.editing=YES;
        isEdited = TRUE;

        [buttonEdit setTitle:btnDonestr forState:UIControlStateNormal];
    }
    
    
    [buttonEdit setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    buttonEdit.titleLabel.textColor = [UIColor whiteColor];
    [buttonEdit.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    
    [buttonEdit addTarget:self action:@selector(buttonEditClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnEdit=[[UIBarButtonItem alloc]initWithCustomView:buttonEdit];
    
    
    @try {
        if([self.navigationItem respondsToSelector:@selector(setLeftBarButtonItems:)])
            [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:btnmenu,btnEdit,nil]];
        else
        {
            UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0,0,200,40)];
            
            
            NSString *btnMenustr = NSLocalizedString(@"btnMenukey", nil);
            NSString *btnEditstr = NSLocalizedString(@"btnEditkey", nil);
            NSString *btnDonestr = NSLocalizedString(@"btnDonekey", nil);
            
            
            UIButton *buttonmenu=[UIButton buttonWithType:UIButtonTypeCustom];
            [buttonmenu setFrame:CGRectMake(0,5, 44, 30)];
            [buttonmenu setBackgroundImage:[UIImage imageNamed:@"selection-button-icon@2x.png"] forState:UIControlStateNormal];
            [buttonmenu setTitle:btnMenustr forState:UIControlStateNormal];
            [buttonmenu setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            buttonmenu.titleLabel.textColor = [UIColor whiteColor];
            [buttonmenu.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
            
            [buttonmenu addTarget:self action:@selector(buttonmenuClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            UIButton *buttonEdit=[UIButton buttonWithType:UIButtonTypeCustom];
            [buttonEdit setFrame:CGRectMake(50,5, 44, 30)];
            [buttonEdit setBackgroundImage:[UIImage imageNamed:@"selection-button-icon@2x.png"] forState:UIControlStateNormal];
            
            if(isEdited)
            {
                tblHistory.editing=NO;
                isEdited = FALSE;
                [buttonEdit setTitle:btnEditstr forState:UIControlStateNormal];
            }
            else
            {
                tblHistory.editing=YES;
                isEdited = TRUE;
                
                [buttonEdit setTitle:btnDonestr forState:UIControlStateNormal];
            }
            
            
            [buttonEdit setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            buttonEdit.titleLabel.textColor = [UIColor whiteColor];
            [buttonEdit.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
            
            [buttonEdit addTarget:self action:@selector(buttonEditClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:buttonmenu];
            [view addSubview:buttonEdit];
            UIBarButtonItem *btnEdit=[[UIBarButtonItem alloc]initWithCustomView:view];
            [self.navigationItem setLeftBarButtonItem:btnEdit];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Print:%@",exception);
    }
    @finally {
        
    }
    

    
    
}

-(void)btnSettingClick:(id)sender
{
    [appDel loadSettingScreen];
}


#pragma mark - TableView Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 116;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([arrHistory count] > 0) {
        
       return [arrHistory count];
        
    }
    else
        return 1;

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

{
    

    selectedIndex = indexPath.row;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you wish to re-run this valuation ?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alert.tag = 1;
    [alert show];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ([arrHistory count] > 0) {
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:kCellNibName owner:self options:nil];
            cell=cellHistoryList;
            
        }
        
        UILabel *lbldate = (UILabel*)[cell viewWithTag:1];
        NSString *strDate;
        
        if ([[arrHistory objectAtIndex:indexPath.row] objectForKey:@"DateTime"] && [[[arrHistory objectAtIndex:indexPath.row] objectForKey:@"DateTime"] length] > 0) {
            
            strDate = [NSString stringWithFormat:@"%@",[[arrHistory objectAtIndex:indexPath.row] objectForKey:@"DateTime"]];
            
        }
        if (strDate.length > 0) {
            
            if ([[arrHistory objectAtIndex:indexPath.row] objectForKey:@"RegistrationNo"] && [[[arrHistory objectAtIndex:indexPath.row] objectForKey:@"RegistrationNo"] length] > 0) {
                
                strDate = [NSString stringWithFormat:@"%@ - %@",strDate,[[arrHistory objectAtIndex:indexPath.row] objectForKey:@"RegistrationNo"]];
                
            }
            
        }
        
        lbldate.text = strDate;
        UILabel *lbladdress = (UILabel*)[cell viewWithTag:2];
        
        lbladdress.text = [[arrHistory objectAtIndex:indexPath.row] objectForKey:@"Description"];
        
        
        UILabel *lblspotpriceval = (UILabel*)[cell viewWithTag:4];
        lblspotpriceval.backgroundColor = [appDel colorForHex:@"#005288"];
        
        if([[[arrHistory objectAtIndex:indexPath.row] objectForKey:@"SpotPrice"] intValue]==0)
            lblspotpriceval.text=@"-";
        else
            lblspotpriceval.text = [NSString stringWithFormat:@"£%@",[[arrHistory objectAtIndex:indexPath.row] objectForKey:@"SpotPrice"]];
        
        
        CGSize textLabelSize3 = [lblspotpriceval.text sizeWithFont:lblspotpriceval.font /*constrainedToSize:constrainedSize*/];
        
        if (textLabelSize3.width > 65) {
            
            textLabelSize3.width = 65;
            
        }
        
        lblspotpriceval.frame = CGRectMake(lblspotpriceval.frame.origin.x, lblspotpriceval.frame.origin.y, textLabelSize3.width + 5, lblspotpriceval.frame.size.height);
        
        lblspotpriceval.textAlignment = UITextAlignmentCenter;

        
        
        UILabel *lblPostcode = (UILabel*)[cell viewWithTag:5];
        lblPostcode.text = [NSString stringWithFormat:@"%@",[[arrHistory objectAtIndex:indexPath.row] objectForKey:@"Postcode"]];
        
        lblPostcode.frame = CGRectMake(lblspotpriceval.frame.origin.x + lblspotpriceval.frame.size.width + 5, lblPostcode.frame.origin.y, lblPostcode.frame.size.width, lblPostcode.frame.size.height);

        
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        
        return cell;
    }
    else{
        
        UITableViewCell *cellSimple = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        tableView.separatorColor = [UIColor clearColor];
        tableView.editing = FALSE;
        cellSimple.textLabel.text = @"No History Found";
        cellSimple.textLabel.textAlignment = UITextAlignmentCenter;
        cellSimple.userInteractionEnabled = FALSE;
        
        return cellSimple;
        
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
      
        
        selectedIndex = indexPath.row;

        UIAlertView *alertDelete=[[UIAlertView alloc]initWithTitle:@"Warning" message:NSLocalizedString(@"Are you sure want to delete this car from history?",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"No", @"") otherButtonTitles:NSLocalizedString(@"Yes", @""), nil];

        alertDelete.tag=200;
        [alertDelete show];
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag == 1)
    {
        if(buttonIndex == 0)
        {
            appDel.isSummary = TRUE;
            
            appDel.strVehicleID = [[arrHistory objectAtIndex:selectedIndex] objectForKey:@"CarID"];
            
            // Make WS call for Vehicle.
            // If Vehicle was searched from Search tree it will start call from Valuation service.

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

        
    }
    else if(alertView.tag == 200)
    {

           if(buttonIndex==0)
           {
               
           }
           if(buttonIndex==1)
           {

               NSDictionary *dicLast = [arrHistory objectAtIndex:selectedIndex];
               
               [objSKDatabase deleteWhere:[NSString stringWithFormat:@"CarID = '%@' AND DateTime = '%@'",[dicLast objectForKey:@"CarID"],[dicLast objectForKey:@"DateTime"]] forTable:@"tblHistory"];

               [self fetchHistoryData];
               
           }
    }
    
}

#pragma mark
#pragma mark Web-service call

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



-(void) callWebService {
    
    
    appDel.isFirstValuation = TRUE;
    appDel.isFromHistory = TRUE;
    
    NSMutableDictionary *dic = (NSMutableDictionary *)[objSKDatabase lookupRowForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
    
    ServiceCallTemp *objVRMServiceCall = [[ServiceCallTemp alloc] init];
    appDel.strLastPostCode = [[arrHistory objectAtIndex:selectedIndex] objectForKey:@"Postcode"];
    
    NSDictionary *dicHistoryData = [arrHistory objectAtIndex:selectedIndex];
    
    if([[dic valueForKey:@"RegistrationNo"] length] > 0){
        
        //VRM valuation
        appDel.isRadarSummery = FALSE;
        
        
        NSString *strRegistrationNo = [dicHistoryData objectForKey:@"RegistrationNo"];
        NSString *strMileage = [dicHistoryData objectForKey:@"OriginalMileage"];
        [objVRMServiceCall getVRMValuation:strRegistrationNo withMileage:strMileage];
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];

    }
    else{
        
        // valuation
        appDel.isRadarSummery = TRUE;
        [self getValutionData:[dicHistoryData objectForKey:@"CarID"]];
        
    }
    
    
    
}

-(void)getValutionData : (NSString *) strVehicleID {
    
    @try {
        
        // WS call for Valuation Service
        // Will called if User Re-Run the Search tree valuation
        
        if (appDel.isOnline) {
            
            
            WebServicesjson *objWebServicesjson = [[WebServicesjson alloc] init];
            
            NSDictionary *dicVehicle = [objSKDatabase lookupRowForSQL:[NSString stringWithFormat:@"select * from tblVehicleSearchTree where GlassCarCode = '%@'",strVehicleID]];
            
            appDel.strMileageLocal = [dicVehicle objectForKey:@"Mileage"];
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
            
            
            if(appDel.isFlurryOn)
            {
                
                [Flurry logEvent:@"WS-P-GetValuation" timed:YES];
            }
            
            appDel.isSummary = FALSE;
            
            NSString *strProductionPeriodDate = [NSString stringWithFormat:@"%@",[dicVehicle objectForKey:@"RegistrationDate"]];
            
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
            [DictRequest setObject:[dicVehicle objectForKey:@"Mileage"] forKey:@"Mileage"];
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
                            
                            NSDictionary *flurryParams =
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"WS-P-GetValuation", @"Error",
                             [NSString stringWithFormat:@"%@ for %@",[dic objectForKey:@"ErrorMsg"],strVehicleID],@"ErrorLocation",
                             nil];
                            if(appDel.isFlurryOn)
                            {
                                NSError *error;
                                error = [NSError errorWithDomain:@"History - WS-P-GetValuation - Server Error(400)" code:200 userInfo:flurryParams];
                                
                                [Flurry logError:@"History - WS-P-GetValuation - Server Error(400)"  message:@"History - WS-P-GetValuation - Server Error(400)" error:error];//m2806

                            }
                            
                            [Flurry endTimedEvent:@"WS-P-GetValuation" withParameters:nil];
                            
                            [SVProgressHUD dismiss];
                            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                            
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
                        
                        
                        [dicToInsert setObject:[dicVehicle objectForKey:@"Make"] forKey:@"Make"];
                        
                        [dicToInsert setObject:[dicVehicle objectForKey:@"Model"] forKey:@"Model"];
                        
                        [dicToInsert setObject:[dicVehicle objectForKey:@"Year"] forKey:@"yearOfManufacture"];
                        
                        
                        
                        NSMutableString *strVehicleDesc = [[NSMutableString alloc] init];
                        
                        [strVehicleDesc appendString:[NSString stringWithFormat:@"%@",[dicVehicle objectForKey:@"Derivative"]]];
                        
                        [dicToInsert setObject:strVehicleDesc forKey:@"Description"];
                        
                        [dicToInsert setObject:@"" forKey:@"Variant"];
                        
                        [dicToInsert setObject:[dicVehicle objectForKey:@"BodyType"] forKey:@"BodyType"];
                        
                        [dicToInsert setObject:@"" forKey:@"Doors"];
                        
                        [dicToInsert setObject:[dicVehicle objectForKey:@"EngineSize"] forKey:@"EngineCapacity"];
                        
                        [dicToInsert setObject:[dicVehicle objectForKey:@"Transmission"] forKey:@"TransmissionDescription"];
                        
                        NSString *strRegistrationDate = [NSString stringWithFormat:@"%@-01",strProductionPeriodDate];
                        [dicToInsert setObject:strRegistrationDate  forKey:@"RegistrationDate"];
                        
                        NSString *AverageMileage = [NSString stringWithFormat:@"%d",[[dicResponse objectForKey:@"averageMileageField"] intValue]];
                        
                        [dicToInsert setObject:AverageMileage forKey:@"AverageMileage"];
                        
                        if ([[dicVehicle objectForKey:@"Mileage"] isEqualToString:@"0"]) {
                            
                            
                            [dicToInsert setObject:AverageMileage forKey:@"Mileage"];
                            
                        }
                        else{
                            
                            [dicToInsert setObject:[dicVehicle objectForKey:@"Mileage"] forKey:@"Mileage"];
                        }
                        
                        if ([[dicVehicle objectForKey:@"Mileage"] isEqualToString:@"0"]) {
                            
                            
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
                        [dicToInsert setObject:[dicVehicle objectForKey:@"Mileage"] forKey:@"OriginalMileage"];
                        
                        rowsel = [[NSUserDefaults standardUserDefaults] integerForKey:@"UseGPS"];
                        [dicToInsert setObject:[NSString stringWithFormat:@"%d",rowsel] forKey:@"UseGps"];
                        
                        [objSKDatabase insertDictionary:dicToInsert forTable:@"tblVehicle"];
                        
                        
                        
                    }
                    appDel.strVehicleID = strVehicleID;
                    
                    [SVProgressHUD show];
                    ServiceCallTemp *objVRMServiceCall = [[ServiceCallTemp alloc] init];
                    NSMutableDictionary *dic = (NSMutableDictionary *)[objSKDatabase lookupRowForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",strVehicleID]];
                    [objVRMServiceCall getSpotPrice:dic];
                    
                }
                else{
                    
                    NSDictionary *flurryParams =
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"WS-P-GetValuation", @"ErrorLocation", 
                     @"No Result Found", @"Error",
                     nil];
                    if(appDel.isFlurryOn)
                    {
                        NSError *error;
                        
                        error = [NSError errorWithDomain:@"History - WS-P-GetValuation - No Result Found" code:200 userInfo:flurryParams];
                    
                        [Flurry logError:@"History - WS-P-GetValuation - No Result Found"  message:@"History - WS-P-GetValuation - No Result Found" error:error];
                    }
                    
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
                    NSError *error;
                    error = [NSError errorWithDomain:@"History - WS-P-GetValuation - Server Error" code:200 userInfo:flurryParams];
                    
                    [Flurry logError:@"History - WS-P-GetValuation - Server Error"   message:@"History - WS-P-GetValuation - Server Error"  error:error];
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
        /*****@catch*****/
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"WS-P-GetValuation", @"ErrorLocation", 
         exception.description, @"Error",
         nil];
        
        if(appDel.isFlurryOn)
        {
          
            NSError *error;
        error = [NSError errorWithDomain:@"History - WS-P-GetValuation - Exception"  code:200 userInfo:flurryParams];
        [Flurry logError:@"History - WS-P-GetValuation - Exception"   message:@"History - WS-P-GetValuation - Exception"  error:error];
            
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


#pragma mark Button events

-(void)buttonEditClick:(id)sender
{
    [self setNavBarButton];
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
        [UIView setAnimationDuration:0];
        objBottomView.view.frame=CGRectMake(0, self.view.frame.size.height-49, 320, 49);
        objBottomView.view.hidden=FALSE;
        CGRect f = tblHistory.frame;
        
        if (appDel.isIphone5) {
            
            tblHistory.frame = CGRectMake(f.origin.x, f.origin.y, f.size.width, tableHeight-58);
        }
        else{
        
            tblHistory.frame = CGRectMake(f.origin.x, f.origin.y, f.size.width, tableHeight-49);
        }

        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0];
        objBottomView.view.frame=CGRectMake(0, self.view.frame.size.height, 320, 49);
        [UIView commitAnimations];
        [self performSelector:@selector(stopAnimatingMethod) withObject:nil afterDelay:0.3];
        CGRect f = tblHistory.frame;
        tblHistory.frame = CGRectMake(f.origin.x, f.origin.y, f.size.width, tableHeight-2);

    }
    
    
}

-(void)stopAnimatingMethod
{
    objBottomView.view.hidden=TRUE;
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
