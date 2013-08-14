//
//  AboutVC.m
//  Glass_Radar
//
//  Created by Mina Shau on 3/5/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()

@end

@implementation AboutVC

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

    [Flurry logEvent:@"About"];
    }

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
    [btnBack.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];    [btnBack addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBack=[[UIBarButtonItem alloc]initWithCustomView:btnBack];
    [self.navigationItem setLeftBarButtonItem:barBack];
    NSString *Aboutstr = NSLocalizedString(@"AboutUSKey", nil);
    self.navigationItem.titleView=[AppDelegate navigationTitleLable:Aboutstr];

    
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"About" withExtension:@"html"];
    NSString *html = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    [_webView loadHTMLString:html baseURL:[url URLByDeletingLastPathComponent]];

    [self.view addSubview:_webView];
    // Do any additional setup after loading the view from its nib.
}

-(void)backClicked:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];

}
#pragma mark-
#pragma mark Webview Delegates

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	//NSLog(@"An error happened during load");
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
