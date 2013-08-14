//
//  SettingVC.m
//  Glass_Radar
//
//  Created by Krutik Vora on 1/22/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "SettingVC.h"
#import "LocationViewController.h"
#import "InternationalViewController.h"
#import "AttributeLableCustomCell.h"
#import "FeedbackViewController.h"
#import "NSAttributedString+Attributes.h"
#import "KeychainItemWrapper.h"
@interface SettingVC ()

@end

@implementation SettingVC

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
    lblflurrytxt=[[UILabel alloc]init];
    lblflurrytxt.frame=CGRectMake(10, 20, 260, 130);
    lblflurrytxt2=[[UILabel alloc]init];
    lblflurrytxt2.frame=CGRectMake(10, 130, 260, 40);
    lblflurrytxt3=[[UILabel alloc]init];
    lblflurrytxt3.frame=CGRectMake(10, 180, 130, 20);
    lblVerNo=[[UILabel alloc] initWithFrame:CGRectMake(250, 0, 100, 40)];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    
    
    [Flurry logEvent:@"Settings"];
    
    if(appDel.isIphone5)
    {
        _tblSetting.frame=CGRectMake(_tblSetting.frame.origin.x, _tblSetting.frame.origin.y, _tblSetting.frame.size.width,440);
    }
    else
    {
        _tblSetting.frame=CGRectMake(_tblSetting.frame.origin.x, _tblSetting.frame.origin.y, _tblSetting.frame.size.width, _tblSetting.frame.size.height);
        
    }
    
    NSString *BackBtnstr = NSLocalizedString(@"BackBtnKey", nil);
    NSString *Settingsstr = NSLocalizedString(@"Settingskey", nil);
    
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, 50, 30)];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back-button-icon@2x.png"] forState:UIControlStateNormal];
    [btnBack setTitle:BackBtnstr forState:UIControlStateNormal];
    [btnBack setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    btnBack.titleLabel.textColor = [UIColor whiteColor];
    [btnBack.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [btnBack addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBack=[[UIBarButtonItem alloc]initWithCustomView:btnBack];
    
    //Temp Button
    
    UIButton *btnTemp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnTemp setFrame:CGRectMake(0, 0, 100, 30)];
    [btnTemp setTitle:@"Get Time Detail" forState:UIControlStateNormal];
    [btnTemp.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [btnTemp addTarget:self action:@selector(readFileForTime:) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *barTemp=[[UIBarButtonItem alloc]initWithCustomView:btnTemp];
    
    [self.navigationItem setLeftBarButtonItem:barBack];
    
    //  [self.navigationItem setRightBarButtonItem:barTemp];
    
    UILabel *lblNavTitle = [[UILabel alloc] init];
    lblNavTitle.text = Settingsstr;
    lblNavTitle.backgroundColor = [UIColor clearColor];
    lblNavTitle.textColor = [UIColor whiteColor];
    lblNavTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0];
    lblNavTitle.minimumFontSize=12.0;
    [lblNavTitle sizeToFit];
    self.navigationItem.titleView = lblNavTitle;
    
    [_tblSetting.layer setBorderWidth:2.0 ];
    [_tblSetting.layer setCornerRadius:10.0];
    [_tblSetting.layer setBorderColor:[UIColor colorWithRed:87.0f/255.0f green:213.0f/255.0f blue:235.0f/255.0f alpha:1.0f].CGColor];
    
    /**/
    NSString *Logoutstr = NSLocalizedString(@"Logoutkey", nil);
    NSString *LocationGPSstr = NSLocalizedString(@"LocationGPSkey", nil);
    NSString *LocationPostcodestr = NSLocalizedString(@"LocationPostcodekey", nil);
    NSString *Internationalstr = NSLocalizedString(@"Internationalkey", nil);
    NSString *Feedbackstr = NSLocalizedString(@"Feedbackkey", nil);
    NSString *Aboutstr = NSLocalizedString(@"AboutKey", nil);
    NSString *Termsstr = NSLocalizedString(@"TermsKey", nil);
    NSString *Privacystr = NSLocalizedString(@"PrivacyKey", nil);
    NSString *Legalstr = NSLocalizedString(@"LegalKey", nil);
    NSString *Loginstr = NSLocalizedString(@"Loginkey", nil);
    NSString *Distancestr = NSLocalizedString(@"SliderDistancekey", nil);
    
  //  NSString *Flurrystr = NSLocalizedString(@"Flurrykey", nil);
    
    version= [NSString stringWithFormat:@"Version"];
    /**/
    
    
    objArray=[[NSMutableArray alloc]init];
    
    [objArray addObject:version];
    
    [objArray addObject:Logoutstr];
    
    if (rowsel==0) {
        [objArray addObject:LocationGPSstr];
    }
    else
    {
        [objArray addObject:LocationPostcodestr];
    }
    
    
    [objArray addObject:Distancestr];
    [objArray addObject:Internationalstr];
    [objArray addObject:Feedbackstr];
    [objArray addObject:Termsstr];
    [objArray addObject:Privacystr];
    [objArray addObject:Legalstr];
    [objArray addObject:Aboutstr];
    // [objArray addObject:Flurrystr];
    
    if(appDel.isLogin)
        [objArray replaceObjectAtIndex:1 withObject:Logoutstr];
    else
        [objArray replaceObjectAtIndex:1 withObject:Loginstr];
    
    rowsel = [[NSUserDefaults standardUserDefaults]integerForKey:@"UseGPS"];
    
    if (rowsel==0) {
        
        [objArray replaceObjectAtIndex:2 withObject:LocationGPSstr];
        
    }
    else
    {
        [objArray replaceObjectAtIndex:2 withObject:LocationPostcodestr];
        
    }
    
    float defaultslider= [[NSUserDefaults standardUserDefaults] floatForKey:@"Distance"];
    
    
    if (defaultslider == 0.0) {
        
        strDistance = @"50";
    }
    else if (defaultslider == 0.25){
        
        strDistance = @"100";
    }
    else if (defaultslider == 0.50){
        
        strDistance = @"200";
    }
    else{
        
        strDistance = @"UK";
    }
    
    [_tblSetting reloadData];
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark QLPreviewController Delegates

- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"TimeStamp.text"];
    
	return [NSURL fileURLWithPath:filePath];
}


#pragma mark Button Events

-(void)readFileForTime :(id)sender{
    
    
	QLPreviewController *previewController = [[QLPreviewController alloc]init];
	previewController.delegate=self;
	previewController.dataSource=self;
    [previewController.navigationItem setRightBarButtonItem:nil];
	[self presentModalViewController:previewController animated:YES];
    
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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if(alertView.tag==1001)
    {
        if(buttonIndex==0)
        {
            
        }
        else
        {
            KeychainItemWrapper *wrapper= [[KeychainItemWrapper alloc] initWithIdentifier:@"Password" accessGroup:nil];
            [wrapper setObject:@"" forKey:kSecValueData];
            
            
            if(appDel.isFlurryOn)
            {
                [Flurry logEvent:@"Logout"];
                
            }
            
            appDel.isLogin = FALSE;
            [[NSUserDefaults standardUserDefaults] setBool:appDel.isLogin forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults]synchronize];

            appDel.isSummary = FALSE;
            [objSKDatabase deleteWhereAllRecord:@"tblVehicle"];
            [objSKDatabase deleteWhereAllRecord:@"tblUser"];
            [objSKDatabase deleteWhereAllRecord:@"tblOnSale"];
            [objSKDatabase deleteWhereAllRecord:@"tblOnSold"];
            [objSKDatabase deleteWhereAllRecord:@"tblPriceHistory"];
            [objSKDatabase deleteWhereAllRecord:@"tblVehicleSearchTree"];
            [objSKDatabase deleteWhereAllRecord:@"tblGetListType"];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                                   forView:self.navigationController.view
                                     cache:YES];
            [self.navigationController popToRootViewControllerAnimated:NO];
            [UIView commitAnimations];
        }
    }
}

#pragma mark Table Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return [objArray count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    NSString *identifier=@"Location";
    AttributeLableCustomCell* cell = (AttributeLableCustomCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    if (cell==nil) {
        
        cell=[[AttributeLableCustomCell alloc]initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        if(indexPath.row == 9 || indexPath.row == 0 )
        {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x,cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
            [view setBackgroundColor:[appDel colorForHex:@"#ffffff"]];
            cell.selectedBackgroundView = view;
            view= nil;
        }
        
        else{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x,cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
            [view setBackgroundColor:[appDel colorForHex:@"#005288"]];
            cell.selectedBackgroundView = view;
            view= nil;
        }
        cell.textLabel.highlightedTextColor = [UIColor redColor];
    }
    
    
    /* For Changing Accesory View Images*/
    UIImage *normalImage = [UIImage imageNamed:@"arrow@2x.png"];
    UIImage *selectedImage = [UIImage imageNamed:@"arrowSelected.png"];
    
    UIButton *accessoryView = [UIButton buttonWithType:UIButtonTypeCustom];
    accessoryView.frame = CGRectMake(0.0f, 0.0f, 9, 15);
    accessoryView.userInteractionEnabled = NO;
    [accessoryView setImage:normalImage forState:UIControlStateNormal];
    [accessoryView setImage:selectedImage forState:UIControlStateHighlighted];
    cell.accessoryView = accessoryView;
    
    cell.lblTitle.delegate=self;
    
    NSMutableAttributedString *strAttName=[NSMutableAttributedString attributedStringWithString:[objArray objectAtIndex:indexPath.row]];
    NSString *strname = NSLocalizedString([objArray objectAtIndex:indexPath.row], @"");
    
    [strAttName setFont:[UIFont boldSystemFontOfSize:15]];
    [strAttName setTextColor:[UIColor blackColor]];
    
    NSString *VerNo = [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    
    
    if(indexPath.row==0)
    {
        
        lblVerNo.backgroundColor=[UIColor clearColor];
        lblVerNo.text=VerNo;
        [cell.contentView addSubview:lblVerNo];
        
        cell.accessoryView = nil;
        
    }
    
    
    
    else if(indexPath.row==1)
    {
        [strAttName setTextColor:[UIColor blackColor] range:[strname rangeOfString:@"Logout"]];
        
    }
    else if(indexPath.row==2)
    {
        if(rowsel==0)
        {
            [strAttName setTextColor:[UIColor colorWithRed:0.0f/255.0f green:78.0f/255.0f blue:131.0f/255.0f alpha:1.0f] range:[strname rangeOfString:@"(GPS)"]];
        }
        else
        {
            [strAttName setTextColor:[UIColor colorWithRed:0.0f/255.0f green:78.0f/255.0f blue:131.0f/255.0f alpha:1.0f] range:[strname rangeOfString:@"(Postcode)"]];
            
        }
        //[strAttName setTextColor:[UIColor colorWithRed:0.0f/255.0f green:78.0f/255.0f blue:131.0f/255.0f alpha:1.0f]];
        
    }
    else if (indexPath.row == 3){
    
        [strAttName appendAttributedString:[NSAttributedString attributedStringWithString:[NSString stringWithFormat:@" (%@)",strDistance]]];
        
        [strAttName setFont:[UIFont boldSystemFontOfSize:15]];
        
        NSString *strTemp = [strAttName string];
        [strAttName setTextColor:[UIColor colorWithRed:0.0f/255.0f green:78.0f/255.0f blue:131.0f/255.0f alpha:1.0f] range:[strTemp rangeOfString:[NSString stringWithFormat:@" (%@)",strDistance]]];
    }
    else if(indexPath.row==4)
    {
        [strAttName setTextColor:[UIColor blackColor] range:[strname rangeOfString:@"International"]];
        
    }
    else if(indexPath.row==5)
    {
        [strAttName setTextColor:[UIColor blackColor] range:[strname rangeOfString:@"Send us feedback"]];
        
    }
    else if(indexPath.row==6)
    {
        [strAttName setTextColor:[UIColor blackColor] range:[strname rangeOfString:@"About"]];
        
    }
    else if(indexPath.row==7)
    {
        [strAttName setTextColor:[UIColor blackColor] range:[strname rangeOfString:@"o[Terms and Conditions"]];
        
    }
    else
    {
        [strAttName setTextColor:[UIColor blackColor] range:[strname rangeOfString:@"opopPrivacy Policy"]];
        // cell.textLabel.highlightedTextColor=[UIColor blackColor];
        
    }
    if (indexPath.row==8 || indexPath.row == 0) {
        cell.lblTitle.highlightedTextColor=[UIColor blackColor];
    }
    else
    {
        cell.lblTitle.highlightedTextColor=[UIColor whiteColor];
        
        
    }
    
    [cell.lblTitle setAttributedText:strAttName];
    return cell;
    
}
- (void)OnOffFlurry:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if(swFlurry.on)
    {
        
        [swFlurry setOn:YES animated:YES];
        [Flurry startSession:Flurry_API_Key];
        appDel.isFlurryOn=TRUE;
        [prefs setBool:appDel.isFlurryOn forKey:@"swFlurry"];
        
    }
    else
    {
        [swFlurry setOn:NO animated:NO];
        appDel.isFlurryOn=FALSE;
        [prefs setBool:appDel.isFlurryOn  forKey:@"swFlurry"];
        
    }
    
	
    appDel.isFlurryOn=TRUE;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //    cell.contentView.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    
    
    if(indexPath.row==1)
    {
        if(appDel.isLogin)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning" message:NSLocalizedString(@"Are you sure you want to logout?",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"No", @"") otherButtonTitles:NSLocalizedString(@"Yes", @""), nil];
            alert.tag=1001;
            [alert show];
        }
        else
        {
            
            
            appDel.isLogin = FALSE;
            [[NSUserDefaults standardUserDefaults] setBool:appDel.isLogin forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                                   forView:self.navigationController.view
                                     cache:YES];
            [self.navigationController popToRootViewControllerAnimated:NO];
            [UIView commitAnimations];
            
            
            
        }
    }
    else if(indexPath.row==2)
    {
        appDel.isWithoutPostCode = FALSE;
        LocationViewController *objLocationViewController=[[LocationViewController alloc]initWithNibName:@"LocationViewController" bundle:nil];
        [self.navigationController pushViewController:objLocationViewController animated:TRUE];
    }
    
    else if(indexPath.row==3)
    {

        DefaultDistanceView *objDefaultDistanceView = [[DefaultDistanceView alloc] initWithNibName:@"DefaultDistanceView" bundle:nil];
        [self.navigationController pushViewController:objDefaultDistanceView animated:YES];
        
    }

    else if(indexPath.row==4)
    {
        
        InternationalViewController *objInternationalViewController=[[InternationalViewController alloc]initWithNibName:@"InternationalViewController" bundle:nil];
        [self.navigationController pushViewController:objInternationalViewController animated:TRUE];
    }
    else if(indexPath.row == 5)
    {
        FeedbackViewController *objFeedbackController = [[FeedbackViewController alloc] initWithNibName:@"FeedbackViewController" bundle:nil];
        [self.navigationController pushViewController:objFeedbackController animated:YES];
    }
    
    else if(indexPath.row == 6)
    {
        
        TermsVC *objTermsVC =[[TermsVC alloc]initWithNibName:@"TermsVC" bundle:Nil];
        [appDel.navigationeController pushViewController:objTermsVC animated:YES];
        
    }
    else if(indexPath.row == 7)
    {
        
        PrivacyVC *objPrivacyVC =[[PrivacyVC alloc]initWithNibName:@"PrivacyVC" bundle:Nil];
        [appDel.navigationeController pushViewController:objPrivacyVC animated:YES];
        
    }
    
    else if(indexPath.row == 8)
    {
        
        LegalVc *objLegalVc =[[LegalVc alloc]initWithNibName:@"LegalVc" bundle:Nil];
        [appDel.navigationeController pushViewController:objLegalVc animated:YES];
        
    }
    else if(indexPath.row == 9)
    {
        
        AboutVC *objAboutVC =[[AboutVC alloc]initWithNibName:@"AboutVC" bundle:Nil];
        [appDel.navigationeController pushViewController:objAboutVC animated:YES];
        
    }
    
}



- (void)viewDidUnload {
    lbleVerNo = nil;
    [super viewDidUnload];
}

@end
