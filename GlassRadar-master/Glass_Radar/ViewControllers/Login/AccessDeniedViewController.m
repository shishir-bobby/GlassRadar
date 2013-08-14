//
//  AccessDeniedViewController.m
//  Glass_Radar
//
//  Created by Nirmalsinh Rathod on 1/24/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "AccessDeniedViewController.h"

@interface AccessDeniedViewController ()

@end

@implementation AccessDeniedViewController

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
        
        [Flurry logEvent:@"Access Denied"];
    }
    
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
    
    NSString *strPassowrdReset = NSLocalizedString(@"Access Denied", @"");
    self.navigationItem.titleView=[AppDelegate navigationTitleLable:strPassowrdReset];
    
    UIButton *buttonLogout=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonLogout setFrame:CGRectMake(0, 0, 30, 30)];
    [buttonLogout setBackgroundImage:[UIImage imageNamed:@"settings-icon@2x.png"] forState:UIControlStateNormal];
    
    [buttonLogout addTarget:self action:@selector(btnSettingClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSetting=[[UIBarButtonItem alloc]initWithCustomView:buttonLogout];
    [self.navigationItem setRightBarButtonItem:btnSetting];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)btnPhoneClick:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        
        NSString *strPhone = [NSString stringWithFormat:@"tel:%@",[btn.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strPhone]];    }
    else {
        
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
    
}


-(void)backClicked:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}
-(void)btnSettingClick:(id)sender
{
    [appDel loadSettingScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    imgBG = nil;
    [super viewDidUnload];
}
@end
