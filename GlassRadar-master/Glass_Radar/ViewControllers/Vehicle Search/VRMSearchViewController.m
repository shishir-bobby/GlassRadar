//
//  VRMSearchViewController.m
//  Glass_Radar
//
//  Created by Krutik Vora on 1/21/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "VRMSearchViewController.h"
#import "VehicalSearchTreeViewController.h"
#import "SummaryViewController.h"
#import "SelectCarViewController.h"
#import "KeychainItemWrapper.h"



//#import "SVProgressHUD.h"
@interface VRMSearchViewController ()

@end

@implementation VRMSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    /**/
    if(appDel.isFlurryOn)
    {
        [Flurry logEvent:@"VRM Search"];
        
    }
    /**/
    
    
    // Populate Reg No and Mileage if already Seached
    
    NSDictionary *dicSearchedVehicle = [objSKDatabase lookupRowForSQL:[NSString stringWithFormat:@"select * from tblVehicle where  GlassCarCode = '%@'",appDel.strVehicleID]];
    
    
    if(appDel.isWrongVehiclePressed && [[dicSearchedVehicle objectForKey:@"RegistrationNo"] length] > 0){
        
        
        if ([dicSearchedVehicle count] > 0) {
            
            txtRegNumber.text = [NSString stringWithFormat:@"%@",[dicSearchedVehicle objectForKey:@"RegistrationNo"]];
            if ([[dicSearchedVehicle objectForKey:@"OriginalMileage"] isEqualToString:@"0"]) {
                
                [btnCheckMark setSelected:YES];
                txtMileage.enabled = FALSE;
            }
            else{
                
                NSString *newString= [NSString stringWithFormat:@"%@",[dicSearchedVehicle objectForKey:@"OriginalMileage"]];
                NSNumber* number = [NSNumber numberWithDouble:[newString doubleValue]];
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle:kCFNumberFormatterDecimalStyle];
                [numberFormatter setGroupingSeparator:@","];
                NSString* commaString = [numberFormatter stringForObjectValue:number];
                txtMileage.text=@"";
                txtMileage.text = commaString;
                
                
            }
        }
        
        
        appDel.isWrongVehiclePressed = FALSE;
    }
    else if (appDel.isFromSelectVehicle){
        
        txtRegNumber.text = appDel.strRegistrationNo;
        
        if ([appDel.strMileageLocal isEqualToString:@"0"]) {
            
            [btnCheckMark setSelected:TRUE];
            
        }
        else
            txtMileage.text = appDel.strMileageLocal;
        
        appDel.isFromSelectVehicle = FALSE;
        
        
    }
    
    else{
        
        txtMileage.text = @"";
        txtRegNumber.text = @"";
        
        [btnCheckMark setSelected:NO];
        txtMileage.enabled = TRUE;
        
        
    }
    
    [objBottomView.bottomTabBar setSelectedItem:[objBottomView.bottomTabBar.items objectAtIndex:0]];
    
    [self hideMenuBar];
    
    [super viewWillAppear:animated];
}


- (void)viewDidLoad
{
    
    //  NSString *UseGpsstr = NSLocalizedString(@"picGpskey", nil);
    NSString *UseSearchTreestr = NSLocalizedString(@"UseSearchTreeKey", nil);
    NSString *UseAverageMileagestr = NSLocalizedString(@"UseAverageMileageKey", nil);
    NSString *FindValueKeystr = NSLocalizedString(@"FindValueKey", nil);
    NSString *VRMSearchNavstr = NSLocalizedString(@"VRMSearchNavKey", nil);
    
    _lbluseavgMileage.text=UseAverageMileagestr;
    [btnFind setTitle:FindValueKeystr forState:UIControlStateNormal];
    [btnUseTree setTitle:UseSearchTreestr forState:UIControlStateNormal];
    
    
    UISwipeGestureRecognizer *swipeGestureRightObjectViewVRM = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeVRMRight_Clicked)] ;
    swipeGestureRightObjectViewVRM.numberOfTouchesRequired = 1;
    swipeGestureRightObjectViewVRM.direction = (UISwipeGestureRecognizerDirectionLeft);
    [self.view addGestureRecognizer:swipeGestureRightObjectViewVRM];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButton:)],
                           nil];
    [numberToolbar sizeToFit];
    
    txtMileage.inputAccessoryView = numberToolbar;
    
    if(appDel.isIphone5)
    {
        
        imgBG.image = [UIImage imageNamed:@"background_i5.png"];
    }
    else
    {
        imgBG.image = [UIImage imageNamed:@"background@2x.png"];
    }
    if(appDel.heightBottom+64<=480)
    {
    }
    else
    {
        
    }
    
    NSString *btnMenustr = NSLocalizedString(@"btnMenukey", nil);
    
    self.navigationItem.titleView=[AppDelegate navigationTitleLable:VRMSearchNavstr];
    UIButton *buttonLogout=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonLogout setFrame:CGRectMake(0, 0, 30, 30)];
    [buttonLogout setBackgroundImage:[UIImage imageNamed:@"settings-icon@2x.png"] forState:UIControlStateNormal];
    [buttonLogout addTarget:self action:@selector(btnSettingClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSetting=[[UIBarButtonItem alloc]initWithCustomView:buttonLogout];
    [self.navigationItem setRightBarButtonItem:btnSetting];
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
    
    
    objBottomView = [[BottomTabBarView alloc] initWithNibName:@"BottomTabBarView" bundle:nil];
    objBottomView.view.frame = CGRectMake(0,appDel.heightBottom, 320, 49);
    [self.view addSubview:objBottomView.view];
    
    [super viewDidLoad];
}

-(void)swipeVRMRight_Clicked
{
    
    if (!appDel.isSummary) {
        return;
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *prefStrRegNo= [NSString stringWithFormat:@"%@",[prefs objectForKey:@"strRegNo"]];
    
    NSArray *arr = [objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblVehicle where RegistrationNo = '%@'",prefStrRegNo]];
    
    if([arr count] == 0)
    {
        return;
    }
    else
    {
        NSArray *ary = appDel.navigationeController.viewControllers;
        BOOL isFind = FALSE;
        for(UIViewController *view in ary)
        {
            if([view isKindOfClass:[SummaryViewController class]])
            {
                
                UIViewController *view1 =[ary objectAtIndex:ary.count -1];
                isFind = TRUE;
                
                CATransition *transition = [CATransition animation];
                transition.duration = 0.2;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
                [self.navigationController.view.layer addAnimation:transition forKey:nil];
                
                [view1.navigationController popToViewController:view animated:NO];
                break;
            }
            
        }
        
        if(!isFind)
        {
            if(appDel.isIphone5)
            {
                SummaryViewController *objSummaryViewController=[[SummaryViewController alloc]initWithNibName:@"SummaryViewController_i5" bundle:Nil];
                [self.navigationController pushViewController:objSummaryViewController animated:YES];
            }
            else
            {
                SummaryViewController *objSummaryViewController=[[SummaryViewController alloc]initWithNibName:@"SummaryViewController" bundle:Nil];
                [self.navigationController pushViewController:objSummaryViewController animated:YES];
            }
            
        }
        
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [txtMileage resignFirstResponder];
    [txtRegNumber resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
    
    imgBG = nil;
    imgMileage = nil;
    [self setLbluseavgMileage:nil];
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
#pragma mark - Web-Service Called


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
                [self vrmSearchData];
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
    
    else{
        
        [SVProgressHUD dismiss];
        appDel.UserAuthenticated = FALSE;
        UIAlertView *alertNoInternet = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertNoInternet show];
        alertNoInternet = nil;
        
    }
    
}



-(void)vrmSearchData{
    
    
    // This will make call to the VRM Valuation with Reg. No and Mileage
    // (if Mileage is Avg.Mileage then it will send 0 as Mileage)
    
    NSString *StrMilege;
    
    if (btnCheckMark.isSelected) {
        StrMilege = @"0";
        
    }
    else{
        
        StrMilege = txtMileage.text;
        StrMilege = [StrMilege stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    
    NSString *prefStrRegNo= [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"strRegNo"]];
    NSString *prefStrMileage= [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"strMileage"]];
    
    if (prefStrMileage == nil) {
        
        prefStrMileage = @"0";
    }
    if (![prefStrRegNo isEqualToString:txtRegNumber.text] || ![prefStrMileage isEqualToString:StrMilege]) {
        
        appDel.isFirstValuation = TRUE;
        
    }
    
    appDel.isFromHistory = FALSE;
    objVRMServiceCall = [[ServiceCallTemp alloc] init];
    [objVRMServiceCall getVRMValuation:txtRegNumber.text withMileage:StrMilege];
    
}



//}

#pragma mark
#pragma mark touch Method
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    if ([txtRegNumber isFirstResponder]) {
        
        [txtRegNumber resignFirstResponder];
    }
    else if ([txtMileage isFirstResponder]){
        
        [txtMileage resignFirstResponder];
    }
    
}


#pragma mark buttons Events

- (void)cancelNumberPad
{
    txtMileage.text=@"";
    [txtMileage resignFirstResponder];
}

- (void)doneButton:(id)sender {
    
    [self.view endEditing:TRUE];
}


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
    }
    else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        objBottomView.view.frame=CGRectMake(0, self.view.frame.size.height, 320, 49);
        [UIView commitAnimations];
        [self performSelector:@selector(stopAnimatingMethod) withObject:nil afterDelay:0.3];
    }
    
    
}
-(void)stopAnimatingMethod
{
    
    objBottomView.view.hidden=TRUE;
    
}
- (IBAction)actionBtnFindClick:(id)sender
{
    
    [txtMileage resignFirstResponder];
    [txtRegNumber resignFirstResponder];
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(findClick) userInfo:nil repeats:NO];
    
}

-(void)findClick
{
    
    NSString *strTemp = [txtRegNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *strMileage = [txtMileage.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([strTemp length] < 10 && [strTemp length]<1)
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter Valid Registration Number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        
    }
    else if([strMileage length] ==0)
    {
        
        if (txtMileage.enabled)
        {
            
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter Valid Mileage" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
        }
        else
        {
            
            
            [[NSUserDefaults standardUserDefaults] setValue:txtRegNumber.text forKey:@"strRegNo"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            appDel.isRadarSummery=FALSE;
            
            if (appDel.isOnline) {
                
                
                
                [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                
                
                
                if (!appDel.UserAuthenticated) {
                    
                    [SVProgressHUD showWithStatus:@"Please wait for authentication.."];
                    [self CallLoginAPI];
                }
                else {
                    
                    [SVProgressHUD showWithStatus:@"Please Wait..."];
                    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(vrmSearchData) userInfo:nil repeats:NO];
                }
                
            }
            else{
                
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                alertView = nil;
                
            }
            
        }
        
    }
    else
    {
        
        [[NSUserDefaults standardUserDefaults] setValue:txtRegNumber.text forKey:@"strRegNo"];
        [[NSUserDefaults standardUserDefaults] setValue:txtMileage.text forKey:@"strMileage"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        appDel.isRadarSummery=FALSE;
        
        if (appDel.isOnline) {
            
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            
            
            if (!appDel.UserAuthenticated) {
                
                [SVProgressHUD showWithStatus:@"Please wait for authentication.."];
                [self CallLoginAPI];
            }
            else{
                
                [SVProgressHUD showWithStatus:@"Please Wait..."];
                [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(vrmSearchData) userInfo:nil repeats:NO];
            }
        }
        else{
            
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            alertView = nil;
            
        }
        
    }
    
}

-(void)compareValue
{
}

- (IBAction)actionBtnSearchTreeClick:(id)sender {
    
    // This will navigate to Vehicle Search screen
    if (appDel.isIphone5)
    {
        VehicalSearchTreeViewController *objVehicalSearchTreeViewController=[[VehicalSearchTreeViewController alloc]initWithNibName:@"VehicalSearchTreeVC_i5" bundle:nil];
        [self.navigationController pushViewController:objVehicalSearchTreeViewController animated:TRUE];
    }
    else
    {
        VehicalSearchTreeViewController *objVehicalSearchTreeViewController=[[VehicalSearchTreeViewController alloc]initWithNibName:@"VehicalSearchTreeViewController" bundle:nil];
        [self.navigationController pushViewController:objVehicalSearchTreeViewController animated:TRUE];
        
    }
    
    
    
}

- (IBAction)ActionBtnCheckMark:(id)sender {
    
    [txtMileage resignFirstResponder];
    [txtRegNumber resignFirstResponder];
    
    UIButton *btnCheck = (UIButton *)sender;
    btnCheck.tag=9000;
    
    if (btnCheck.selected) {
        
        [btnCheck setSelected:NO];
        
        imgMileage.alpha = 1;
        txtMileage.enabled = TRUE;
        [txtMileage becomeFirstResponder];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO  forKey:@"prefUseAvgM"];
        
    }
    else{
        
        [btnCheck setSelected:YES];
        txtMileage.text=@"";
        
        imgMileage.alpha = .6;
        txtMileage.enabled = FALSE;
        [[NSUserDefaults standardUserDefaults] setBool:YES  forKey:@"prefUseAvgM"];
        
        
    }
}
#pragma mark Textfield Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    
    
    [textField resignFirstResponder];
    return TRUE;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if(textField == txtRegNumber)
    {
        if ([[txtRegNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] <= 10)
        {
            
            
        }
        else{
            
            
        }
        
        
    }
    else if (textField == txtMileage) {
        
    }
    return YES;
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == txtMileage)  {
        
        
        
        
        NSString *strTemo = [[textField.text stringByReplacingCharactersInRange:range withString:string] stringByReplacingOccurrencesOfString:@" " withString:@""];
        strTemo = [strTemo stringByReplacingOccurrencesOfString:@"," withString:@""];
        if ([[strTemo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 6)
        {
            
            return NO;
        }
        
        NSString *newString =[[textField.text stringByReplacingCharactersInRange:range withString:string] stringByReplacingOccurrencesOfString:@" " withString:@""];// [strMileage stringByReplacingCharactersInRange:range withString:string];
        
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
        
        
        btnCheckMark.selected=FALSE;
        
        
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
    
    
    else if(textField == txtRegNumber)
    {
        NSString *strTemo = [[textField.text stringByReplacingCharactersInRange:range withString:string] stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([[strTemo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 10)
        {
            
            return NO;
        }
        
        NSRange lowercaseCharRange;
        lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
        
        if (lowercaseCharRange.location != NSNotFound) {
            
            textField.text = [txtRegNumber.text stringByReplacingCharactersInRange:range
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
@end
