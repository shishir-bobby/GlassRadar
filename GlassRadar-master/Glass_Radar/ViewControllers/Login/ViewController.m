//
//  ViewController.m
//  Glass_Radar
//
//  Created by Krutik Vora on 1/21/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "ViewController.h"
#import "PasswordResetViewController.h"
#import "VRMSearchViewController.h"
#import "AccessDeniedViewController.h"
#import "HelpViewController.h"
#import "SVProgressHUD.h"

NSString* const kCJBKey = @"NjRCtCU04O7I3YglEFrMjSUNtEVALxN2wDZt1LaEpsY=";


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    
    if(appDel.isFlurryOn)
    {
        [Flurry logEvent:@"Login"];
    }
    
    
    occurrenceCapital = 0;
    occurenceNumbers = 0;
    wrapper= [[KeychainItemWrapper alloc] initWithIdentifier:@"Password" accessGroup:nil];
    
    if(appDel.isIphone5)
    {
        imgBG.image = [UIImage imageNamed:@"background_i5.png"];
    }
    {
        imgBG.image = [UIImage imageNamed:@"background@2x.png"];
    }
    
    
    NSString *Loginstr = NSLocalizedString(@"Loginkey", nil);
    self.navigationItem.titleView=[AppDelegate navigationTitleLable:Loginstr];
    NSString *strUsername= NSLocalizedString(@"Username", @"");
    _txtUsername.placeholder=strUsername;
    NSString *strPassword= NSLocalizedString(@"Password", @"");
    _txtPassword.placeholder=strPassword;
    [_btnLogin setTitle:Loginstr forState:UIControlStateNormal];
    NSString *strForgotPass = NSLocalizedString(@"Forgotpwkey", nil);
    [_btnForgotPassword setTitle:strForgotPass forState:UIControlStateNormal] ;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UIButton *buttonLogout=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonLogout setFrame:CGRectMake(0, 0, 30, 30)];
    [buttonLogout setBackgroundImage:[UIImage imageNamed:@"settings-icon@2x.png"] forState:UIControlStateNormal];
    [buttonLogout addTarget:self action:@selector(actionBtnSetting:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSetting=[[UIBarButtonItem alloc]initWithCustomView:buttonLogout];
    [self.navigationItem setRightBarButtonItem:btnSetting];
    
    
    UIButton *buttonmenu=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonmenu setFrame:CGRectMake(0, 0, 30, 30)];
    [buttonmenu setBackgroundImage:[UIImage imageNamed:@"information-icon@2xV2.png"] forState:UIControlStateNormal];
    [buttonmenu setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [buttonmenu addTarget:self action:@selector(ActionBtnInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnmenu=[[UIBarButtonItem alloc]initWithCustomView:buttonmenu];
    [self.navigationItem setLeftBarButtonItem:btnmenu];
    
    
    //change here
    
//    _txtUsername.text = [wrapper objectForKey:kSecAttrAccount];
//    _txtPassword.text = [wrapper objectForKey:kSecValueData];
    
    _txtUsername.text = @"rapptestvalid";
    _txtPassword.text = @"VAU3WJS9N";

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWasResumed) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    if (appDel.isFromBackground) {
        
    }
    else{
        
        // IF Username and Password Exist Call WS Login
        
        if([_txtUsername.text length]>0 && [_txtPassword.text length]>0)
        {
            
            [self performSelector:@selector(actionBtnLoginClick:) withObject:nil afterDelay:.3];
            
        }
    }
    
    [super viewWillAppear:animated];
    
}

-(void) appWasResumed
{
    [_txtUsername resignFirstResponder];
    [_txtPassword resignFirstResponder];    //If you are changing positions of items, you might want to do that here too.
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    appDel.DelUserName=_txtUsername.text;
    
    [_txtUsername resignFirstResponder];
    [_txtPassword resignFirstResponder];
    
    
    [super viewWillDisappear:animated];
}

-(void)keyboardWillHide:(NSNotification *)aNotification
{
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    
    CGRect rect=self.view.frame;
    rect.origin.y=0;
    self.view.frame=rect;
    
    [UIView commitAnimations];
}

-(void)keyboardWillShow:(NSNotification *)aNotification
{
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    
    CGRect rect=self.view.frame;
    rect.origin.y=-175;
    self.view.frame=rect;
    
    [UIView commitAnimations];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark Textfield Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
{
    return TRUE;
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    
    appDel.DelUserName=_txtUsername.text;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    
    if(textField==_txtUsername){
        
        if(textField.text.length >= 4 )
        {
            [_txtPassword becomeFirstResponder];
        }
        else
        {
            
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Username must be minimum 4 length." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
        }
    }
    else if(textField==_txtPassword){
        
        [self ValidatePassword];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    //limit the size :
    int limit = 50;
    return !([textField.text length]>limit && [string length] > range.length);
}


#pragma mark Buttons Methods
- (IBAction)ActionBtnInfo:(id)sender {
    
    HelpViewController *objHelpView = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    [UIView beginAnimations:nil context:nil];
    
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
						   forView:self.navigationController.view
							 cache:YES];
    [self.navigationController pushViewController:objHelpView animated:FALSE];
	[UIView commitAnimations];
    
}

- (IBAction)actionBtnSetting:(id)sender {
    
    [appDel loadSettingScreen];
}

- (IBAction)actionBtnLoginClick:(id)sender{
    
    appDel.isFromBackground = FALSE;
    
    if([[_txtUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]== 0)
    {
        
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter valid username" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    else
    {
        if ([[_txtUsername.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]>0)
        {
            if(_txtUsername.text.length >= 4 )
            {
            }
            else
            {
                
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Username must be minimum 4 length."delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
                
                return;
            }
        }
    }
    if  ([[_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]== 0)
    {
        
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter valid Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        
        return;
    }
    
    else{
        
        
        [_txtUsername resignFirstResponder];
        [_txtPassword resignFirstResponder];
        
        if(appDel.isOnline)
        {
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            [SVProgressHUD showWithStatus:@"Please Wait..."];
            [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(successfullyAuthenticate) userInfo:nil repeats:NO];
        }
        else
        {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            alertView = nil;
            
        }
        
    }
    
}
-(void)ValidatePassword
{
    
    if(_txtPassword.text.length >= 8)
    {
        NSString *newString = _txtPassword.text;
        
        NSString *expression = @"([0-9])";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        
        NSString *password = newString;
        
        for (int i = 0; i < [password length]; i++) {
            if([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[password characterAtIndex:i]])
            {
                occurrenceCapital=occurrenceCapital+1;
            }
            
            
        }
        
        NSString *expression2 = @"([a-z])";
        NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:expression2
                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                  error:nil];
        NSUInteger numberOfMatches2 = [regex2 numberOfMatchesInString:newString
                                                              options:0
                                                                range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0 || occurrenceCapital == 0 || numberOfMatches2 == 0)
        {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Password must contain alpha and numeric characters with upper case & lower case combination." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
            return;
        }
        else
        {
            [_txtUsername resignFirstResponder];
            [_txtPassword resignFirstResponder];
            
            if(appDel.isOnline)
            {
                [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                [SVProgressHUD showWithStatus:@"Please Wait..."];
                [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(successfullyAuthenticate) userInfo:nil repeats:NO];
            }
            else
            {
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                alertView = nil;
                
            }
        }
        
        
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Password must be minimum 8 length." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
}
-(void)successfullyAuthenticate
{
    
    if (appDel.isOnline) {
        
        
        appDel.isFromBackground = FALSE;
        objWebServices = [[WebServices alloc]init];
        
        
        appDel.strUsrname = [self encryptDataAES:_txtUsername.text];
        appDel.strPassword = [self encryptDataAES:_txtPassword.text];
        
        
        if(appDel.isFlurryOn)
        {
            
           [Flurry logEvent:@"WS-GS-AuthenticateUserWithProduct" timed:YES];
        }
        
        
        // Call Login Web Service and handle the response
        
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
                _txtPassword.text=@"";
                appDel.UserAuthenticated = FALSE;
                appDel.isLogin = FALSE;
                
                [[NSUserDefaults standardUserDefaults] setBool:appDel.isLogin forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [wrapper setObject:[_txtUsername text] forKey:kSecAttrAccount];
                [wrapper setObject:[_txtPassword text] forKey:kSecValueData];
                
                art = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@ %@",systemError,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [art show];
                
            }
            else if(![[dicreceivedData valueForKey:@"glassTokenField"] isEqualToString:@"00000000-0000-0000-0000-000000000000"] && [strValidField isEqualToString:@"0"])
            {
                
                appDel.UserAuthenticated = FALSE;
                appDel.isLogin = FALSE;
                
                [[NSUserDefaults standardUserDefaults] setBool:appDel.isLogin forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                [wrapper setObject:[_txtUsername text] forKey:kSecAttrAccount];
                
                // If Found invalid login parameter, this will redirect to the Access denied screen
                
                AccessDeniedViewController *objAccessDeniedViewController = [[AccessDeniedViewController alloc] initWithNibName:@"AccessDeniedViewController" bundle:nil];
                [self.navigationController pushViewController:objAccessDeniedViewController animated:YES];
            }
            
            else if(![[dicreceivedData valueForKey:@"glassTokenField"] isEqualToString:@"00000000-0000-0000-0000-000000000000"] && [strValidField isEqualToString:@"1"])
            {
                
                appDel.UserAuthenticated = TRUE;
                appDel.isLogin = TRUE;
                
                [[NSUserDefaults standardUserDefaults] setBool:appDel.isLogin forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                [self storeAndRedirect:dicreceivedData];
            }
            
        }
        else{
            
            /*****No Result Found*****/
            NSDictionary *flurryParams =
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"WS-GS-AuthenticateUserWithProduct", @"ErrorLocation",
             @"No Result Found", @"Error",
             nil];
            if(appDel.isFlurryOn)
            {
                NSError *error;
                error = [NSError errorWithDomain:@"Login - AuthenticateUserWithProduct - No Result Found"  code:200 userInfo:flurryParams];
                
                [Flurry logError:@"Login - AuthenticateUserWithProduct - No Result Found"   message:@"Login - AuthenticateUserWithProduct - No Result Found"   error:error];
            }
            
            
            [Flurry endTimedEvent:@"WS-GS-AuthenticateUserWithProduct" withParameters:nil];
            
            /*****No Result Found*****/
            
            
            appDel.UserAuthenticated = FALSE;
            appDel.isLogin = TRUE;
            
            [SVProgressHUD dismiss];
            [[NSUserDefaults standardUserDefaults] setBool:appDel.isLogin forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            UIAlertView *art = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@ %@",ErrorInResponse,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [art show];
            
            
        }
        
    }
    
    else{
        
        /*****Server Error*****/
        appDel.UserAuthenticated = FALSE;
        appDel.isLogin = TRUE;
        
        [[NSUserDefaults standardUserDefaults] setBool:appDel.isLogin forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIAlertView *alertNoInternet = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertNoInternet show];
        alertNoInternet = nil;
        
    }
}



-(NSString *) encryptDataAES:(NSString *)string
{
    
    NSData *initVector = [@"eurotaxglass.com" dataUsingEncoding:NSASCIIStringEncoding];
    NSData* key = [[GTMStringEncoding rfc4648Base64StringEncoding] decode:kCJBKey];
    NSData *data = [string dataUsingEncoding: NSASCIIStringEncoding];
    
    CCCryptorStatus status = kCCSuccess;
    
    NSData *encrypted = [data dataEncryptedUsingAlgorithm:kCCAlgorithmAES128 key:key initializationVector:initVector options:kCCOptionPKCS7Padding error:&status];
    
    
    return [[GTMStringEncoding rfc4648Base64StringEncoding] encode:encrypted];
    
}



-(NSString *) getHexValueFromString : (NSString *) strResponse {
    
    NSData *strData = [strResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *mutableHEXString = [NSMutableString string];
    int i;
    for (i = 0; i < [strData length]; i++)
    {
        [mutableHEXString appendFormat:@"%2X ", ((char *)[strData bytes])[i]];
        
    }
    return mutableHEXString;
    
}

-(void)storeAndRedirect :(NSMutableDictionary *)dicreceivedData{
    
    // After Successfull Authentication it will check for Active Run and will redirect accordingly.
    
    appDel.isLogin = TRUE;
    [wrapper setObject:[_txtUsername text] forKey:kSecAttrAccount];
    [wrapper setObject:[_txtPassword text] forKey:kSecValueData];
    
    
    NSDictionary *dicUser = [objSKDatabase lookupRowForSQL:[NSString stringWithFormat:@"select * from tblUser where username = '%@'",_txtUsername.text]];
    
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
        
        appDel.isSummary = TRUE;
        NSString *strPostcode = [objSKDatabase lookupColForSQL:[NSString stringWithFormat:@"select CustomPostCode from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
        
        NSString *strRegistrationNo = [objSKDatabase lookupColForSQL:[NSString stringWithFormat:@"select RegistrationNo from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
        
        if (strRegistrationNo.length > 0) {
            
            appDel.isRadarSummery = FALSE;
            
        }
        else{
            
            appDel.isRadarSummery = TRUE;
        }
        
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
            SummaryViewController *objSummaryViewController=[[SummaryViewController alloc]initWithNibName:@"SummaryViewController" bundle:Nil];
            [appDel.navigationeController pushViewController:objSummaryViewController animated:YES];
            
        }
        
    }
    else{
        
        appDel.appDelLastIndex = 0;
        appDel.isSummary = FALSE;
        VRMSearchViewController *objVRMSearchViewController=[[VRMSearchViewController alloc]initWithNibName:@"VRMSearchViewController" bundle:nil];
        [self.navigationController pushViewController:objVRMSearchViewController animated:TRUE];
        
    }
    
}
-(BOOL)checkForActiveRun {
    
    NSString *strVehicleID = [[NSUserDefaults standardUserDefaults] objectForKey:@"GlassCarCode"];
    if (strVehicleID.length > 0) {
        
        
        NSArray *arrVehicleData = [objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",strVehicleID]];
        
        if ([arrVehicleData count] > 0) {
            
            strVehicleID = [NSString stringWithFormat:@"%@",[[arrVehicleData objectAtIndex:0] objectForKey:@"GlassCarCode"]];
            
            int days;
            NSString *strDate = [[arrVehicleData objectAtIndex:0] objectForKey:@"ActiveRun"];
            NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
            [_formatter setDateFormat:@"dd-MM-yyyy"];
            
            NSString *str = [_formatter stringFromDate:[NSDate date]];
            
            NSArray *aryActiveRun = [strDate componentsSeparatedByString:@" "];
            NSArray *aryCurrentDate = [str componentsSeparatedByString:@" "];
            
            
            if([[aryActiveRun objectAtIndex:0] isEqualToString:[aryCurrentDate objectAtIndex:0]])
                days = 0;
            else
                days = -1;
            
            
            NSString *strQuery = [NSString stringWithFormat:@"select t1.* , t2.* from tblOnSale t1 , tblOnSold t2 where t1.GlassCarCode = '%@' AND t2.GlassCarCode = '%@'",strVehicleID,strVehicleID];
            
            NSArray *arrLastRecord = [objSKDatabase lookupAllForSQL:strQuery];
            
            if ([arrLastRecord count] > 0 && days == 0){
                
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
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

- (IBAction)actionBtnForgotPass:(id)sender{
    
    
    // Redirect to the Password Reset screen
 
    PasswordResetViewController *objPasswordResetViewController=[[PasswordResetViewController alloc]initWithNibName:@"PasswordResetViewController" bundle:nil];
    [self.navigationController pushViewController:objPasswordResetViewController animated:TRUE];
}
- (void)viewDidUnload {
    lblCheckLang = nil;
    [super viewDidUnload];
}
@end
