//
//  AdvertViewController.m
//  Glass_Radar
//
//  Created by Nirmalsinh Rathod on 2/4/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "AdvertViewController.h"

@interface AdvertViewController ()

@end

@implementation AdvertViewController
@synthesize advertURL;

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

    [Flurry logEvent:@"Advert"];

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
    
    
    NSString *CarAdvertNavstr = NSLocalizedString(@"CarAdvertNavkey", nil);
    
    self.navigationItem.titleView=[AppDelegate navigationTitleLable:CarAdvertNavstr];
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
    
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    
    webView.opaque = NO;
    webView.delegate = self;
    [webView setBackgroundColor:[UIColor clearColor]];
    
    // Append &MobileBypass=true if "motors.co.uk" found in URL
    if ([self.advertURL rangeOfString:@"motors.co.uk"].location != NSNotFound) {

        self.advertURL = [NSString stringWithFormat:@"%@&MobileBypass=true",self.advertURL];
    }

    NSURL *url = [NSURL URLWithString:self.advertURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark-
#pragma mark Webview Delegates

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    @try {
        
        [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception %@",exception);
    }
    @finally {
        
    }
	
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    @try {
        
        [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception %@",exception);
    }
    @finally {
        
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    imgBG = nil;
    webView = nil;
    [super viewDidUnload];
}
@end
