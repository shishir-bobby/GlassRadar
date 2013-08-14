//
//  LocationViewController.m
//  Glass_Radar
//
//  Created by Krutik Vora on 1/22/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "LocationViewController.h"
#import "SVProgressHUD.h"
@interface LocationViewController ()
@end
@implementation LocationViewController
@synthesize lblLocationText;
@synthesize btnLocationType;
@synthesize txtPostCode;
@synthesize btnSave;
@synthesize objPicker;
@synthesize viewPicker;
@synthesize locationManager;
@synthesize geoCoder;

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
    
    
    if(appDel.isIphone5)
    {
        imgBG.image = [UIImage imageNamed:@"background_i5.png"];
    }
    {
        imgBG.image = [UIImage imageNamed:@"background@2x.png"];
    }
    
    arr=[[NSMutableArray alloc]init];
    
    NSString *UseGpsstr = NSLocalizedString(@"picGpskey", nil);
    NSString *UsePoststr = NSLocalizedString(@"picPostkey", nil);
    NSString *Locationstr = NSLocalizedString(@"Locationkey", nil);
    
    [arr addObject:UseGpsstr];
    [arr addObject:UsePoststr];
    [objPicker reloadAllComponents];
    
    
    self.navigationItem.titleView=[AppDelegate navigationTitleLable:Locationstr];
    
    
    
    NSString *Lable03str = NSLocalizedString(@"lblLocationkey", nil);
    
    lblLocationText.text=Lable03str;
    
    NSString *Savetr = NSLocalizedString(@"btndsavekey", nil);
    
    txtPostCode.placeholder=NSLocalizedString(@"Postcode", @"");
    [btnSave setTitle:Savetr forState:UIControlStateNormal];
    
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    NSString *BackBtnstr = NSLocalizedString(@"BackBtnKey", nil);
    [btnBack setTitle:BackBtnstr forState:UIControlStateNormal];
    [btnBack setFrame:CGRectMake(0, 0, 50, 30)];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back-button-icon@2x.png"] forState:UIControlStateNormal];
    [btnBack setTitle:BackBtnstr forState:UIControlStateNormal];
    [btnBack setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    btnBack.titleLabel.textColor = [UIColor whiteColor];
    [btnBack.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [btnBack addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBack=[[UIBarButtonItem alloc]initWithCustomView:btnBack];
    [self.navigationItem setLeftBarButtonItem:barBack];
    
    viewPicker.hidden=TRUE;
    
    [super viewDidLoad];
    
}


-(void) viewWillAppear:(BOOL)animated

{
    
    if(appDel.isFlurryOn)
    {
        [Flurry logEvent:@"Location"];
        
    }
    
    // Check for the last Postcode store and populate accordingly.
    
    if (appDel.isWithoutPostCode) {
        
        appDel.isWithoutPostCode = FALSE;
        txtPostCode.enabled=TRUE;
        [objPicker selectRow:1 inComponent:0 animated:TRUE];
        [btnLocationType setTitle:[arr objectAtIndex:1] forState:UIControlStateNormal];
        
        rowsel = 1;
    }
    
    else{
        
        rowsel = [[NSUserDefaults standardUserDefaults]integerForKey:@"UseGPS"];
        
        if(rowsel == 0)
        {
            
            txtPostCode.enabled=FALSE;
            txtPostCode.text = appDel.strDelPostCode;
            
        }
        else
        {
            
            txtPostCode.enabled=TRUE;
            txtPostCode.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"Postcode"];
            
        }
        
        [objPicker selectRow:rowsel inComponent:0 animated:TRUE];
        [btnLocationType setTitle:[arr objectAtIndex:rowsel] forState:UIControlStateNormal];
        
        NSString *strCustomPostCode = [objSKDatabase lookupColForSQL:[NSString stringWithFormat:@"select CustomPostCode from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
        
        if (strCustomPostCode.length > 0) {
            
            NSString *strUseGps = [objSKDatabase lookupColForSQL:[NSString stringWithFormat:@"select UseGps from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
            
            [objPicker selectRow:[strUseGps intValue] inComponent:0 animated:TRUE];
            [btnLocationType setTitle:[arr objectAtIndex:[strUseGps intValue]] forState:UIControlStateNormal];
            
            txtPostCode.text = strCustomPostCode;
        }
    }
}

- (void)viewDidUnload
{
    
    [self setLblLocationText:nil];
    [self setBtnLocationType:nil];
    [self setTxtPostCode:nil];
    [self setBtnSave:nil];
    [self setObjPicker:nil];
    [self setViewPicker:nil];
    imgBG = nil;
    
    
    
    btnDefaultDis = nil;
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark
#pragma mark touch Method
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{


    if ([txtPostCode isFirstResponder]) {
        
        [txtPostCode resignFirstResponder];
    }

}




#pragma mark
#pragma mark Web-service call

-(void)CallLoginAPI
{

    // WS Call for Authentication
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
            
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
            [SVProgressHUD dismiss];
            
            NSString *strValidField = [NSString stringWithFormat:@"%@",[dicreceivedData valueForKey:@"validField"]];
            if([[dicreceivedData valueForKey:@"glassTokenField"] isEqualToString:@"00000000-0000-0000-0000-000000000000"] && [strValidField isEqualToString:@"0"])
            {
                // Invalid username and password
                [SVProgressHUD dismiss];
                appDel.UserAuthenticated = FALSE;
                art = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@ %@",systemError,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [art show];
                
            }
            else if(![[dicreceivedData valueForKey:@"glassTokenField"] isEqualToString:@"00000000-0000-0000-0000-000000000000"] && [strValidField isEqualToString:@"0"])
            {
                
                appDel.UserAuthenticated = FALSE;
                [SVProgressHUD dismiss];
                AccessDeniedViewController *objAccessDeniedViewController = [[AccessDeniedViewController alloc] initWithNibName:@"AccessDeniedViewController" bundle:nil];
                [self.navigationController pushViewController:objAccessDeniedViewController animated:YES];

            }
            
            else if(![[dicreceivedData valueForKey:@"glassTokenField"] isEqualToString:@"00000000-0000-0000-0000-000000000000"] && [strValidField isEqualToString:@"1"])
            {
                
                appDel.UserAuthenticated = TRUE;
                [SVProgressHUD dismiss];
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
        [SVProgressHUD dismiss];
        UIAlertView *alertNoInternet = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertNoInternet show];
        alertNoInternet = nil;
        
    }

}



#pragma mark Buttons Events

- (IBAction)btnSaveClick:(id)sender {
    
    if ([txtPostCode isFirstResponder]) {
        
        [txtPostCode resignFirstResponder];
    }
    
    if(rowsel == 1)
    {
        if([[txtPostCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
        {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Postcode" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            return;
            
        }
        else
        {
            if([[txtPostCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] <6)
                
            {
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Postcode should be a minimum of 6 characters" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                return;
            }
            
            NSString *newString = txtPostCode.text;
            NSString *expression = @"(GIR 0AA)|((([A-Z-[QVX]][0-9][0-9]?)|(([A-Z-[QVX]][A-Z-[IJZ]][0-9][0-9]?)|(([A-Z-[QVX]][0-9][A-HJKSTUW])|([A-Z-[QVX]][A-Z-[IJZ]][0-9][ABEHMNPRVWXY])))) [0-9][A-Z-[CIKMOV]]{2})";
            
            
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:nil];
            NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                                options:0
                                                                  range:NSMakeRange(0, [newString length])];
            if (numberOfMatches == 0)
            {
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a valid postcode" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
                return;
                
            }
            else
            {
                
                // Make WS call if user change the postcode
                
                [[NSUserDefaults standardUserDefaults] setInteger:rowsel forKey:@"UseGPS"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                // Call webservice
                
                NSDictionary *dicActiveRun = [objSKDatabase lookupRowForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
                
                NSString *strPostCode = [dicActiveRun objectForKey:@"CustomPostCode"];
                
                if ([dicActiveRun objectForKey:@"CustomPostCode"] && ![strPostCode isEqualToString:txtPostCode.text]) {
                    
                    [[NSUserDefaults standardUserDefaults] setValue:txtPostCode.text forKey:@"Postcode"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    
                    
                    
                    if (!appDel.UserAuthenticated) {
                        
                        // Call Login service if no Authentication found
                        
                        [SVProgressHUD showWithStatus:@"Please wait for authentication.."];
                        [self CallLoginAPI];
                    }
                    else{
                        
                        [SVProgressHUD showWithStatus:@"Please Wait..."];
                        [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(callWebService) userInfo:nil repeats:NO];
                    }
                    
                }
                
                else{
                    
                    [[NSUserDefaults standardUserDefaults] setValue:txtPostCode.text forKey:@"Postcode"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    [self.navigationController popViewControllerAnimated:TRUE];
                    
                    
                }
                
            }
            
            
        }
        
    }
    else if(rowsel == 0)
    {
        
        NSDictionary *dicActiveRun = [objSKDatabase lookupRowForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
        
        NSString *strPostCode = [dicActiveRun objectForKey:@"CustomPostCode"];
        
        
        if (txtPostCode.text.length == 0 || txtPostCode.text.length <= 4) {
            
            UIAlertView *alertNoPostcode = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry postcode could not be calculated, please enter your postcode manually." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertNoPostcode show];

            
        }
        else{
            
            [[NSUserDefaults standardUserDefaults] setInteger:rowsel forKey:@"UseGPS"];
            [[NSUserDefaults standardUserDefaults]synchronize];

            
            if ([dicActiveRun objectForKey:@"CustomPostCode"] && ![strPostCode isEqualToString:txtPostCode.text]) {
                
                appDel.strDelPostCode = txtPostCode.text;
                
                
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
                
                appDel.strDelPostCode = txtPostCode.text;
                [self.navigationController popViewControllerAnimated:TRUE];
                
                
            }
        
        }
        
    }
    
}

-(void) callWebService {
    
    
    ServiceCallTemp *objVRMServiceCall = [[ServiceCallTemp alloc] init];
    
    NSMutableDictionary *dic = (NSMutableDictionary *)[objSKDatabase lookupRowForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
    
    
    [objVRMServiceCall getSpotPrice:dic];
    
    [SVProgressHUD dismiss];
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
    
    
}

-(void)backClicked:(id)sender
{
    
    if (txtPostCode.text.length > 0) {
        
        NSDictionary *dicActiveRun = [objSKDatabase lookupRowForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
        
        NSString *strPostCode = [dicActiveRun objectForKey:@"CustomPostCode"];
        
        if ([dicActiveRun objectForKey:@"CustomPostCode"]) {
            
            if (![strPostCode isEqualToString:txtPostCode.text]) {
                
                UIAlertView *alertView1=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Do you want to save changes?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
                alertView1.tag=222;
                [alertView1 show];
                
            }
            else{
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
        else{
            if (rowsel == 0) {
                
                if ([txtPostCode.text isEqualToString:appDel.strDelPostCode]) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    
                    UIAlertView *alertView1=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Do you want to save changes?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
                    alertView1.tag=222;
                    [alertView1 show];
                    
                    
                }
            }
            else if (rowsel == 1){
                
                NSString *strLastPostcode = [[NSUserDefaults standardUserDefaults] objectForKey:@"Postcode"];
                if ([txtPostCode.text isEqualToString:strLastPostcode]) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    
                    UIAlertView *alertView1=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Do you want to save changes?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
                    alertView1.tag=222;
                    [alertView1 show];
                    
                    
                }
                
                
            }
            
            
        }
        
    }
    
    else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
	
}

- (IBAction)btnDefaultDisClick:(id)sender {
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==222) {
        
        if(buttonIndex==0)
        {
            [self.navigationController popViewControllerAnimated:TRUE];
        }
        if(buttonIndex==1)
        {
            [self btnSaveClick:nil];
        }
    }
}

- (IBAction)btnDoneClick:(id)sender
{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    viewPicker.hidden=TRUE;
    [UIView commitAnimations];
    rowsel = [objPicker selectedRowInComponent:0];
    [btnLocationType setTitle:[arr objectAtIndex:rowsel] forState:UIControlStateNormal];
    
    if(rowsel==1)
    {
        appDel.iSGpson=FALSE;
        txtPostCode.enabled=TRUE;
        txtPostCode.text=@"";
    }
    else
    {
        appDel.iSGpson=TRUE;
        txtPostCode.enabled=FALSE;
        
        // Call Location API
        txtPostCode.text=@"";
        
        [SVProgressHUD showWithStatus:@"Updating Location..."];
        appDel.isFirstTimeGPS = FALSE;
        
        [appDel getNewLocaiton:self];
        
        
    }
}
-(void)LocationCalledAndReturned {

    txtPostCode.text = appDel.strDelPostCode;
    
    if (! ([CLLocationManager locationServicesEnabled])
        || ( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)){
        
        rowsel = 1;
        [objPicker selectRow:1 inComponent:0 animated:NO];
        appDel.iSGpson=FALSE;
        txtPostCode.enabled=TRUE;
        [btnLocationType setTitle:[arr objectAtIndex:1] forState:UIControlStateNormal];
        txtPostCode.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"Postcode"];
    }


}

- (IBAction)btnUseGPSClick:(id)sender
{
    
    int selectedIndex = [arr indexOfObject:btnLocationType.titleLabel.text];
    [objPicker selectRow:selectedIndex inComponent:0 animated:NO];
    
    [txtPostCode resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    viewPicker.hidden=FALSE;
    [UIView commitAnimations];
    
    
    
}

- (IBAction)btnCancelClick:(id)sender {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    viewPicker.hidden=TRUE;
    [UIView commitAnimations];
}

#pragma mark Picker view

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [arr count];
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [arr objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    
    rowsel = row;
    
}


#pragma mark Textfiel Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    
    
    [textField resignFirstResponder];
    return TRUE;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    
    if(textField == txtPostCode)
    {
        NSString *strTemo = [[textField.text stringByReplacingCharactersInRange:range withString:string] stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([[strTemo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 8)
        {
            return NO;
        }
        
        NSRange lowercaseCharRange;
        lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
        
        if (lowercaseCharRange.location != NSNotFound) {
            
            textField.text = [txtPostCode.text stringByReplacingCharactersInRange:range
                                                                       withString:[string uppercaseString]];
            return NO;
        }
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *expression = @"^[a-zA-Z0-9 _]*$";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
            return NO;
        
        
    }
    return YES;
    
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    NSString *newString=[appDel formatIdentificationNumber:[appDel checkSpace:textField.text]];
    txtPostCode.text = newString;
    
    return TRUE;
    
}


@end
