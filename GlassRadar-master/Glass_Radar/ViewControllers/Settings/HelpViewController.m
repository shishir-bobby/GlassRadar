//
//  HelpViewController.m
//  Glass_Radar
//
//  Created by Nirmalsinh Rathod on 2/4/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

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

    [Flurry logEvent:@"Help"];
    }

}
- (void)viewDidLoad
{
    NSString *Lable01str = NSLocalizedString(@"lable01key", nil);
    NSString *Lable02str = NSLocalizedString(@"lable02key", nil);
    NSString *Lable03str = NSLocalizedString(@"lable03key", nil);
    NSString *Lable04str = NSLocalizedString(@"lable04key", nil);

    _lblhelp01.text=Lable01str;
    _lblhelp02.text=Lable02str;
    _lblhelp03.text=Lable03str;
    _lblhelp04.text=Lable04str;

    
    
    if(appDel.isIphone5)
    {
        imgBG.image = [UIImage imageNamed:@"background_i5.png"];
    }
    {
        imgBG.image = [UIImage imageNamed:@"background@2x.png"];
    }
    
    
    NSString *Loginstr = NSLocalizedString(@"Loginkey", nil);

    NSString *HelpNavstr = NSLocalizedString(@"HelpNavkey", nil);

    
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
    
   // NSString *strPassowrdReset = NSLocalizedString(@"Help", @"");
    self.navigationItem.titleView=[AppDelegate navigationTitleLable:HelpNavstr];
    
    UIButton *buttonLogout=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonLogout setFrame:CGRectMake(0, 0, 30, 30)];
    [buttonLogout setBackgroundImage:[UIImage imageNamed:@"settings-icon@2x.png"] forState:UIControlStateNormal];
    
    [buttonLogout addTarget:self action:@selector(btnSettingClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSetting=[[UIBarButtonItem alloc]initWithCustomView:buttonLogout];
    [self.navigationItem setRightBarButtonItem:btnSetting];
    [super viewDidLoad];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    imgBG = nil;
    [self setLblhelp01:nil];
    [self setLblhelp02:nil];
    [self setLblhelp03:nil];
    [self setLblhelp04:nil];
    [super viewDidUnload];
    
}

#pragma mark Button Events
- (IBAction)btnPhoneClick:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        
        NSString *strPhone = [NSString stringWithFormat:@"tel:%@",[btn.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strPhone]];
    }
    else {
        
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
    
    
}


-(void)backClicked:(id)sender
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
						   forView:self.navigationController.view
							 cache:YES];
	[self.navigationController popViewControllerAnimated:NO];
	[UIView commitAnimations];
}
-(void)btnSettingClick:(id)sender
{
    [appDel loadSettingScreen];
}



@end
