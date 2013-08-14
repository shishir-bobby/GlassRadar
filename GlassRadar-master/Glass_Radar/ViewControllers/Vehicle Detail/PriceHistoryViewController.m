//
//  PriceHistoryViewController.m
//  Glass_Radar
//
//  Created by Nirmalsinh Rathod on 2/4/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "PriceHistoryViewController.h"
#import "AdvertViewController.h"
#define kCellNibName @"PriceCell"
#define CellIdentifier @"cell"

@interface PriceHistoryViewController ()

@end

@implementation PriceHistoryViewController
@synthesize isSold;
@synthesize arrPriceHistory;
@synthesize dictForPriceCell;

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

    
    appDel.isFromPriceHistory = TRUE;
    
    if(self.isSold)
        btnAdvert.hidden = TRUE;
    else
        btnAdvert.hidden = FALSE;
    
    tblView.backgroundColor = [UIColor clearColor];
    if(appDel.isIphone5)
    {
        imgBG.image = [UIImage imageNamed:@"background_i5.png"];
    }
    {
        imgBG.image = [UIImage imageNamed:@"background@2x.png"];
    }
    
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    NSString *BackBtnstr = NSLocalizedString(@"BackBtnKey", nil);
    [btnBack setTitle:BackBtnstr forState:UIControlStateNormal];
    [btnBack setFrame:CGRectMake(0, 0, 50, 30)];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back-button-icon@2x.png"] forState:UIControlStateNormal];
    [btnBack setTitle:BackBtnstr forState:UIControlStateNormal];
    [btnBack setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    btnBack.titleLabel.textColor = [UIColor whiteColor];
    [btnBack.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];    [btnBack addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBack=[[UIBarButtonItem alloc]initWithCustomView:btnBack];
    [self.navigationItem setLeftBarButtonItem:barBack];
    
    
        NSString *PriceChangeNavkeystr = NSLocalizedString(@"PriceChangeNavkey", nil);
    self.navigationItem.titleView=[AppDelegate navigationTitleLablePrice:PriceChangeNavkeystr];
    
    
    
    UIButton *buttonLogout=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonLogout setFrame:CGRectMake(0, 0, 30, 30)];
    [buttonLogout setBackgroundImage:[UIImage imageNamed:@"settings-icon@2x.png"] forState:UIControlStateNormal];
    
    [buttonLogout addTarget:self action:@selector(btnSettingClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSetting=[[UIBarButtonItem alloc]initWithCustomView:buttonLogout];
    
    [self.navigationItem setRightBarButtonItem:btnSetting];

    lblHeading1.text=[self.dictForPriceCell objectForKey:@"originalTypeDesc"];
    lblheading2.text=[self.dictForPriceCell objectForKey:@"dealerName"];
    lbldate.text=[self.dictForPriceCell objectForKey:@"regDate"];
    lblPrice03.backgroundColor = [appDel colorForHex:@"#005288"];
    
    lblCalendarDate.text = [self.dictForPriceCell  objectForKey:@"stockDays"];
    
    int days = [[self.dictForPriceCell objectForKey:@"stockDays"] intValue];
    if (days < 30) {
        
        //Green
        
        imageDays.image =[UIImage imageNamed:@"calendar-small-bgGREEN@2x.png"];
    }
    else if (days >=30 && days <= 59){
        
        //amber
        
        imageDays.image =[UIImage imageNamed:@"calendar-small-bgAMBER@2x.png"];
    }
    else if (days >= 60 && days <=89){
        
        
        //red
        imageDays.image =[UIImage imageNamed:@"calendar-small-bgRED@2x.png"];
    }
    else{
        
        //black
        imageDays.image =[UIImage imageNamed:@"calendar-small-bgBLACK@2x.png"];
    }


    
    lblePrice01.text = [NSString stringWithFormat:@"£%@",[self.dictForPriceCell objectForKey:@"askingPrice"]];
    
    CGSize textLabelSize1 = [lblePrice01.text sizeWithFont:lblePrice01.font /*constrainedToSize:constrainedSize*/];
    
    if (textLabelSize1.width > 50) {
        
        textLabelSize1.width = 50;
        
    }
    lblePrice01.frame = CGRectMake(302-textLabelSize1.width - 5, lblePrice01.frame.origin.y, textLabelSize1.width + 5, lblePrice01.frame.size.height);
    
    lblePrice01.textAlignment = UITextAlignmentCenter;

    
    if([[self.dictForPriceCell objectForKey:@"spotPrice"] intValue] == 0)
        lblPrice03.text = @"-";
    else
        lblPrice03.text = [NSString stringWithFormat:@"£%@",[self.dictForPriceCell objectForKey:@"spotPrice"]];
    
    
    CGSize textLabelSize3 = [lblPrice03.text sizeWithFont:lblPrice03.font /*constrainedToSize:constrainedSize*/];
    
    if (textLabelSize3.width > 50) {
        
        textLabelSize3.width = 50;
        
    }
    
    lblPrice03.frame = CGRectMake(302-textLabelSize3.width - 5, lblPrice03.frame.origin.y, textLabelSize3.width + 5, lblPrice03.frame.size.height);
    
    lblPrice03.textAlignment = UITextAlignmentCenter;

    
    
    
    lblPrice02.text =  [NSString stringWithFormat:@"£%@",[self.dictForPriceCell objectForKey:@"Difference"]];
    
    int diff = [[self.dictForPriceCell objectForKey:@"Difference"] intValue];
    
    if (diff < 0) {
        lblPrice02.textColor = [UIColor blueColor];
    }
    else{
        
        lblPrice02.textColor = [UIColor redColor];
    }
    
    
    CGSize textLabelSize2 = [lblPrice02.text sizeWithFont:lblPrice02.font /*constrainedToSize:constrainedSize*/];
    
    if (textLabelSize2.width > 50) {
        
        textLabelSize2.width = 50;
        
    }
    
    lblPrice02.frame = CGRectMake(302-textLabelSize2.width - 5, lblPrice02.frame.origin.y, textLabelSize2.width + 5, lblPrice02.frame.size.height);
    
    lblPrice02.textAlignment = UITextAlignmentCenter;
    


    NSString *strMileage = [NSString stringWithFormat:@"%d",[[self.dictForPriceCell objectForKey:@"Mileage"] intValue]];
    
    float mileage = [strMileage floatValue]/(float)1000;
    
    if (mileage > 1) {
        
        mileage = roundf([strMileage floatValue]/(float)1000);
    }
    
    if (mileage < 10 && mileage >= 1) {
        
        strMileage = [NSString stringWithFormat:@" %d | K",(int)mileage];
        
    }
    else if (mileage >= 10 && mileage < 100 && mileage >= 1){
        
        strMileage = [NSString stringWithFormat:@" %@ | %@ | K",[strMileage substringWithRange:NSMakeRange(0, 1)],[strMileage substringWithRange:NSMakeRange(1, 1)]];
        
    }
    else if (mileage >= 100 && mileage < 1000 && mileage >= 1){
        
        strMileage = [NSString stringWithFormat:@" %@ | %@ | %@ | K",[strMileage substringWithRange:NSMakeRange(0, 1)],[strMileage substringWithRange:NSMakeRange(1, 1)],[strMileage substringWithRange:NSMakeRange(2, 1)]];
        
    }
    
    else if (mileage < 1 && mileage > 0){
        
        strMileage = [NSString stringWithFormat:@" . | %@ | K",[strMileage substringWithRange:NSMakeRange(0, 1)]];
        
    }
    else if (mileage == 0){
        
        strMileage = [NSString stringWithFormat:@" %@ | K",[strMileage substringWithRange:NSMakeRange(0, 1)]];
    }
    
    
//    lblMileage.text = strMileage;
    lblMileage.text = [NSString stringWithFormat:@"%@ m",[appDel formateCommaSeperate:[self.dictForPriceCell objectForKey:@"Mileage"]]];
    CGSize textLabelSize = [lblMileage.text sizeWithFont:lblMileage.font /*constrainedToSize:constrainedSize*/];
    
    lblMileage.frame = CGRectMake(lblMileage.frame.origin.x, lblMileage.frame.origin.y, textLabelSize.width, 13);
    lblMileage.textAlignment = UITextAlignmentRight;
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    if(appDel.isFlurryOn)
    {
            [Flurry logEvent:@"Price Change History"];

    }

    [super viewWillAppear:animated];
}
#pragma mark - TableView Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.arrPriceHistory count] > 0) {
        
        return [self.arrPriceHistory count];
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:kCellNibName owner:self options:nil];
        cell=cellList;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UILabel *lblCellDate = (UILabel *)[cell viewWithTag:3];
    UILabel *lblCellName = (UILabel *)[cell viewWithTag:1];
    UILabel *lblCellPrice = (UILabel *)[cell viewWithTag:2];

    if ([self.arrPriceHistory count] > 0) {
        
        lblCellDate.text = [[arrPriceHistory objectAtIndex:indexPath.row] objectForKey:@"pricingDate"];
        lblCellName.text = [[arrPriceHistory objectAtIndex:indexPath.row] objectForKey:@"priceChangeDescription"];
        lblCellPrice.text = [NSString stringWithFormat:@"£%@",[[arrPriceHistory objectAtIndex:indexPath.row] objectForKey:@"price"]];
    }
    else{
        
        UITableViewCell *cellSimple = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        tableView.separatorColor = [UIColor clearColor];
        cellSimple.textLabel.text = @"No Price History Found";
        cellSimple.textLabel.textAlignment = UITextAlignmentCenter;
        cellSimple.userInteractionEnabled = FALSE;
        return cellSimple;
        
    }

    
    
    
        return cell;
    
}

#pragma mark - Navigation Button
-(void)backClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnSettingClick:(id)sender
{
    [appDel loadSettingScreen];
}

#pragma mark - Other Memory Method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    imgBG = nil;
    tblView = nil;
    btnAdvert = nil;
    lblMileage = nil;
    lblCalendarDate = nil;
    imageDays = nil;
    [super viewDidUnload];
}
- (IBAction)btnSetAdvertClicked:(id)sender {
    
    
    if (appDel.isOnline) {
        
        
        // Navigate to Advert screen with selected URL
        
        AdvertViewController *objAdvert = [[AdvertViewController alloc] initWithNibName:@"AdvertViewController" bundle:nil];
        objAdvert.advertURL = [self.dictForPriceCell objectForKey:@"advertismentUrl"];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                               forView:self.navigationController.view
                                 cache:YES];
        [self.navigationController pushViewController:objAdvert animated:FALSE];
        [UIView commitAnimations];
        
    }
    else{
        
        UIAlertView *AlertError = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [AlertError show];
        
    }

}
@end
