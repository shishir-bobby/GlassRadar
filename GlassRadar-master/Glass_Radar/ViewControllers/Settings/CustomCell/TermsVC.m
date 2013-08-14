//
//  TermsVC.m
//  Glass_Radar
//
//  Created by Mina on 3/19/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "TermsVC.h"

@interface TermsVC ()

@end

@implementation TermsVC

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
    
    
    [super viewDidLoad];
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    
    NSString *BackBtnstr = NSLocalizedString(@"BackBtnKey", nil);
    [btnBack setTitle:BackBtnstr forState:UIControlStateNormal];
    //NSString *BackBtnstr = NSLocalizedString(@"BackBtnKey", nil);
    
    
    [btnBack setFrame:CGRectMake(0, 0, 50, 30)];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back-button-icon@2x.png"] forState:UIControlStateNormal];
    [btnBack setTitle:BackBtnstr forState:UIControlStateNormal];
    [btnBack setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    btnBack.titleLabel.textColor = [UIColor whiteColor];
    [btnBack.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [btnBack addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBack=[[UIBarButtonItem alloc]initWithCustomView:btnBack];
    [self.navigationItem setLeftBarButtonItem:barBack];
    
    NSString *Aboutstr = NSLocalizedString(@"TermsKey", nil);
    
    self.navigationItem.titleView=[AppDelegate navigationTitleLable:Aboutstr];
    
    
    if (appDel.isOnline) {
        
        [SVProgressHUD showWithStatus:@"Please Wait..."];
        webView.delegate = self;
        NSURL *url = [NSURL URLWithString:@"http://www.glassbusiness.co.uk/radarapp/terms.htm"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //        [webView setScalesPageToFit:YES];
        [webView loadRequest:request];
    }
    else{
        
        UIAlertView *AlertError = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [AlertError show];
    }
    
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [SVProgressHUD dismiss];
    
}


#pragma mark-
#pragma mark Webview Delegates

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	//NSLog(@"An error happened during load");
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
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception %@",exception);
    }
    @finally {
        
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

@end
