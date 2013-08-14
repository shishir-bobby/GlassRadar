//
//  PasswordResetViewController.m
//  Glass_Radar
//
//  Created by Krutik Vora on 1/21/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "PasswordResetViewController.h"
#import "SVProgressHUD.h"
#import "KeychainItemWrapper.h"
@interface PasswordResetViewController ()

@end

@implementation PasswordResetViewController

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
    if(appDel.isFlurryOn)
    {
        [Flurry logEvent:@"Password Reset"];
        
    }
    
    _txtUsername.text = appDel.DelUserName;
    
    [super viewWillAppear:NO];
}

- (void)viewDidLoad
{
    

    NSString *lblinfo1str = NSLocalizedString(@"lblinfo1key", nil);
    NSString *lblinfo2str = NSLocalizedString(@"lblinfo2key", nil);
    NSString *PasswordResetNavstr = NSLocalizedString(@"PasswordResetNavKey", nil);
    
    isSuccess=FALSE;
    _lblInfo1.text=lblinfo1str;
    _lblInfo2.text=lblinfo2str;
    
    if(appDel.isIphone5)
    {
        imgBG.image = [UIImage imageNamed:@"background_i5.png"];
    }
    {
        imgBG.image = [UIImage imageNamed:@"background@2x.png"];
    }
    NSString *Loginstr = NSLocalizedString(@"Loginkey", nil);
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, 50, 30)];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back-button-icon@2x.png"] forState:UIControlStateNormal];
    [btnBack setTitle:Loginstr forState:UIControlStateNormal];
    [btnBack setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    btnBack.titleLabel.textColor = [UIColor whiteColor];
    [btnBack.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [btnBack addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBack=[[UIBarButtonItem alloc]initWithCustomView:btnBack];
    [self.navigationItem setLeftBarButtonItem:barBack];
    
    self.navigationItem.titleView=[AppDelegate navigationTitleLable:PasswordResetNavstr];
    
    NSString *strusername = NSLocalizedString(@"Username", @"");
    [_txtUsername setPlaceholder:strusername];
    
    NSString *lblRequeststr = NSLocalizedString(@"Requestkey", nil);
    [_btnRequest setTitle:lblRequeststr forState:UIControlStateNormal];
    UIButton *buttonLogout=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonLogout setFrame:CGRectMake(0, 0, 30, 30)];
    [buttonLogout setBackgroundImage:[UIImage imageNamed:@"settings-icon@2x.png"] forState:UIControlStateNormal];
    [buttonLogout addTarget:self action:@selector(btnSettingClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSetting=[[UIBarButtonItem alloc]initWithCustomView:buttonLogout];
    [self.navigationItem setRightBarButtonItem:btnSetting];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



-(void)btnSettingClick:(id)sender
{
    [appDel loadSettingScreen];
}

- (void)viewDidUnload {
    imgBG = nil;
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Textfield delgates
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    
    if(textField.text.length >= 4)
    {
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Information" message:@"Username must be minimum 4 length." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        
    }
    [textField resignFirstResponder];
    
    return TRUE;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //limit the size :
    int limit = 50;
    return !([textField.text length]>limit && [string length] > range.length);
}
#pragma mark Buttons Events
-(void)resetPassword
{
    
    objWebServices = [[WebServices alloc]init];
    
    if(appDel.isFlurryOn)
    {
        
        
        [Flurry logEvent:@"WS-GS-ForgotPassword" timed:YES];
    }
    
    // WS call for Password reset
    NSMutableDictionary *dicreceivedData;
    if (appDel.isTestMode) {
        
        dicreceivedData = [objWebServices Call_PwdResetWebService:ForgotPassword_URL UserName:_txtUsername.text];
        
    }
    else{
        
        dicreceivedData = [objWebServices Call_PwdResetWebService:ForgotPassword_URL_LIVE UserName:_txtUsername.text];
    }
    
    
    // check response
    
    [Flurry endTimedEvent:@"WS-GS-ForgotPassword" withParameters:nil];
    [SVProgressHUD dismiss];
    
    UIAlertView *art;
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    // Process response
    if ([dicreceivedData count] > 0) {
        
        
        NSString *strResult = [NSString stringWithFormat:@"%@",[dicreceivedData valueForKey:@"changeResultField"]];
        if([strResult isEqualToString:@"0"] && [[dicreceivedData objectForKey:@"glassTokenField"] isEqualToString:@"00000000-0000-0000-0000-000000000000"])
        {
            
            
            NSString *resetNotFoundStr1 = NSLocalizedString(@"resetNotFound1", nil);
            NSString *resetNotFoundStr2 = NSLocalizedString(@"resetNotFound2", nil);
            
            
            
            art = [[UIAlertView alloc] initWithTitle:@"Information" message:[NSString stringWithFormat:@"%@ '%@' %@",resetNotFoundStr1,_txtUsername.text,resetNotFoundStr2] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [art show];
            
        }
        else if([strResult isEqualToString:@"0"])
        {
            
            
            art = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@ %@",ErrorInResponse,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [art show];
            
        }
        
        else if([strResult isEqualToString:@"1"] )
        {
            NSString *resetSentStr = NSLocalizedString(@"resetSent", nil);
            isSuccess=TRUE;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:[NSString stringWithFormat:@"%@ ",resetSentStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag=111;
            [alert show];
            
        }
        art = nil;
        
        
    }
    else{
        /*****Server Error*****/
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"WS-GS-ForgotPassword", @"ErrorLocation",
         @"Server Error", @"Error",
         nil];
        if(appDel.isFlurryOn)
        {
            
            NSError *error;
            error = [NSError errorWithDomain:@"ForgotPassword - WS-GS-ForgotPassword - Server Error" code:200 userInfo:flurryParams];
            
            [Flurry logError:@"ForgotPassword - WS-GS-ForgotPassword - Server Error"   message:@"ForgotPassword - WS-GS-ForgotPassword - Server Error"  error:error];//m2806
        }
        /*****Server Error*****/
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@ %@",ErrorInUser,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        
    }
    
}

-(void)backClicked:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnPhoneClick:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        
        NSString *strPhone = [NSString stringWithFormat:@"tel:%@",[btn.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strPhone]];    }
    else {
        
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Information" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
    
    
    
    
}
- (IBAction)btnRequestClicked:(id)sender {
    
    if(_txtUsername.text.length >= 4 && _txtUsername.text.length <50 )
    {
        
        if(appDel.isOnline)
        {
            [SVProgressHUD showWithStatus:@"Please Wait..."];
            [_txtUsername resignFirstResponder];
            [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(resetPassword) userInfo:nil repeats:NO];
        }
        else
        {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Information" message:@"There is currently no internet connection detected – please try again when you are connected to the internet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            alertView = nil;
            
        }
        
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Information" message:@"Username must be minimum 4 length." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==111)
    {
        if(isSuccess)
        {
            
            if (buttonIndex==0) {
                
                appDel.DelUserName = _txtUsername.text;
                KeychainItemWrapper *wrapper= [[KeychainItemWrapper alloc] initWithIdentifier:@"Password" accessGroup:nil];
                
                [wrapper setObject:[_txtUsername text] forKey:kSecAttrAccount];
                [wrapper setObject:@"" forKey:kSecValueData];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            
        }
    }
}
@end
