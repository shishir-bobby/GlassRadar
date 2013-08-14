//
//  OnSaleViewController.m
//  Glass_Radar
//
//  Created by Nirmalsinh Rathod on 1/23/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "OnSaleViewController.h"
#import "SummaryViewController.h"
#define kCellNibName @"OnSaleCell"
#define CellIdentifier @"cell"
@interface OnSaleViewController ()

@end

@implementation OnSaleViewController

@synthesize vWsale;


- (void)viewDidLoad
{
    
    
    NSString *Milesstr = NSLocalizedString(@"Mileskey", nil);
    NSString *SortedBystr = NSLocalizedString(@"SortedBykey", nil);
    NSString *Distanefromstr = NSLocalizedString(@"Distanefromkey", nil);
    NSString *OnSaleNavstr = NSLocalizedString(@"OnSaleNavKey", nil);
    NSString *btnMenustr = NSLocalizedString(@"btnMenukey", nil);
    NSString *btnSortstr = NSLocalizedString(@"btnSortkey", nil);
    
    
    _lblMiles.text=Milesstr;
    _lblSortedBy.text=SortedBystr;
    _lblDistanefrom.text=Distanefromstr;
    swipeGestureRightObjectViewsold = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight_Clicked)] ;
    swipeGestureRightObjectViewsold.numberOfTouchesRequired = 1;
    swipeGestureRightObjectViewsold.direction = (UISwipeGestureRecognizerDirectionLeft);
    [vWsale addGestureRecognizer:swipeGestureRightObjectViewsold];
    /**/
    swipeGestureLeftObjectViewonsale = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftonsale_Clicked)] ;
    swipeGestureLeftObjectViewonsale.numberOfTouchesRequired = 1;
    swipeGestureLeftObjectViewonsale.direction = (UISwipeGestureRecognizerDirectionRight);
    [vWsale addGestureRecognizer:swipeGestureLeftObjectViewonsale];
    
    
    if(appDel.isIphone5)
    {
        imgBG.image = [UIImage imageNamed:@"background_i5.png"];
    }
    {
        imgBG.image = [UIImage imageNamed:@"background@2x.png"];
    }
    
    tblView.backgroundColor=[UIColor clearColor];
    
    
    UILabel *lblNavTitle = [[UILabel alloc] init];
    lblNavTitle.text = OnSaleNavstr;
    lblNavTitle.backgroundColor = [UIColor clearColor];
    lblNavTitle.textColor = [UIColor whiteColor];
    lblNavTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0];
    lblNavTitle.minimumFontSize=12.0;
    [lblNavTitle sizeToFit];
    self.navigationItem.titleView = lblNavTitle;
    
    
    UIButton *buttonmenu=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonmenu setFrame:CGRectMake(0, 0, 44, 30)];
    [buttonmenu setBackgroundImage:[UIImage imageNamed:@"selection-button-icon@2x.png"] forState:UIControlStateNormal];
    [buttonmenu setTitle:btnMenustr forState:UIControlStateNormal];
    [buttonmenu addTarget:self action:@selector(buttonmenuClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonmenu setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    buttonmenu.titleLabel.textColor = [UIColor whiteColor];
    [buttonmenu.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    
    btnmenu=[[UIBarButtonItem alloc]initWithCustomView:buttonmenu];
    [self.navigationItem setLeftBarButtonItem:btnmenu];
    
    UIButton *buttonSort=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonSort setFrame:CGRectMake(50, 0, 44, 30)];
    [buttonSort setBackgroundImage:[UIImage imageNamed:@"selection-button-icon@2x.png"] forState:UIControlStateNormal];
    [buttonSort setTitle:btnSortstr forState:UIControlStateNormal];
    [buttonSort addTarget:self action:@selector(buttonsortClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonSort setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    buttonSort.titleLabel.textColor = [UIColor whiteColor];
    [buttonSort.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    UIBarButtonItem *btnSort=[[UIBarButtonItem alloc]initWithCustomView:buttonSort];
    
    
    @try {
        
        if([self.navigationItem respondsToSelector:@selector(setLeftBarButtonItems:)])
            [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:btnmenu,btnSort,nil]];
        else
        {
            UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0,0,200,40)];
            
            UIButton *buttonmenu=[UIButton buttonWithType:UIButtonTypeCustom];
            [buttonmenu setFrame:CGRectMake(0, 0, 44, 30)];
            [buttonmenu setBackgroundImage:[UIImage imageNamed:@"selection-button-icon@2x.png"] forState:UIControlStateNormal];
            [buttonmenu setTitle:btnMenustr forState:UIControlStateNormal];
            [buttonmenu addTarget:self action:@selector(buttonmenuClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [buttonmenu setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            buttonmenu.titleLabel.textColor = [UIColor whiteColor];
            [buttonmenu.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
            
            UIBarButtonItem *btnMenu=[[UIBarButtonItem alloc]initWithCustomView:buttonmenu];
            [self.navigationItem setLeftBarButtonItem:btnMenu];
            
            UIButton *buttonSort=[UIButton buttonWithType:UIButtonTypeCustom];
            [buttonSort setFrame:CGRectMake(50, 0, 44, 30)];
            [buttonSort setBackgroundImage:[UIImage imageNamed:@"selection-button-icon@2x.png"] forState:UIControlStateNormal];
            [buttonSort setTitle:btnSortstr forState:UIControlStateNormal];
            [buttonSort addTarget:self action:@selector(buttonsortClick:) forControlEvents:UIControlEventTouchUpInside];
            [buttonSort setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            buttonSort.titleLabel.textColor = [UIColor whiteColor];
            [buttonSort.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
            
            [view addSubview:buttonmenu];
            [view addSubview:buttonSort];
            UIBarButtonItem *btnEdit=[[UIBarButtonItem alloc]initWithCustomView:view];
            [self.navigationItem setLeftBarButtonItem:btnEdit];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@",exception);
    }
    @finally {
        
    }
    
    
    
    UIButton *buttonSetting=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonSetting setFrame:CGRectMake(0, 0, 30, 30)];
    [buttonSetting setBackgroundImage:[UIImage imageNamed:@"settings-icon@2x.png"] forState:UIControlStateNormal];
    [buttonSetting addTarget:self action:@selector(btnSettingClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnSetting=[[UIBarButtonItem alloc]initWithCustomView:buttonSetting];
    [self.navigationItem setRightBarButtonItem:btnSetting];
    
    
    objBottomView = [[BottomTabBarView alloc] initWithNibName:@"BottomTabBarView" bundle:nil];
    objBottomView.view.frame = CGRectMake(0,appDel.heightBottom, 320, 49);
    [self.view addSubview:objBottomView.view];
    
    if(appDel.isIphone5)
        tableHeight = 425-40;
    else
        tableHeight = tblView.frame.size.height-40;
    
    initValueOfSlider = 0.0;
    

    
    [super viewDidLoad];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    btnAll = nil;
    btnMed = nil;
    btnHigh = nil;
    btnVHigh = nil;
    imgBG = nil;
    btnPostcode = nil;
    [self setLblDistanefrom:nil];
    [self setLblSortedBy:nil];
    [self setLblMiles:nil];
    lblAverageDaysToSell = nil;
    viewSlider = nil;
    [super viewDidUnload];
}
-(void)viewWillAppear:(BOOL)animated
{
    if(appDel.isFlurryOn)
    {
        [Flurry logEvent:@"On Sale"];
    }
    
    
    if (!appDel.isFromPriceHistory) {
        
        [self reloadAllViewWhileServiceComplete];
    }
    else
        appDel.isFromPriceHistory = FALSE;
    
    [super viewWillAppear:animated];
}


#pragma mark-
#pragma mark Call Price History



-(void)callPriceHistoryForSaleRecords {
    
    
    // Make WS Call to get Price History for each Sale record
    NSString *OnSalePriceHistory = [objSKDatabase lookupColForSQL:[NSString stringWithFormat:@"select OnSalePriceHistory from tblOnSale where GlassCarCode = '%@'",appDel.strVehicleID]];
    
    if (OnSalePriceHistory != nil) {
        
        if ([OnSalePriceHistory isEqualToString:@"false"]) {
            
            NSArray *arr = [objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblOnSale where GlassCarCode = '%@'",appDel.strVehicleID]];
            
            if ([arr count] > 0) {
                
                
                if ([arr count] == 1 && [[[arr objectAtIndex:0] objectForKey:@"similarityCategory"] isEqualToString:@"0"]) {
                    
                    [SVProgressHUD dismiss];
                    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];

                }
                else{
                    
                    [objSKDatabase deleteWhere:[NSString stringWithFormat:@"GlassCarCode = '%@' AND ForTable = 'tblOnSale'",appDel.strVehicleID] forTable:@"tblPriceHistory"];
                    
                    ServiceCallTemp *objServiceCall = [[ServiceCallTemp alloc] init];

                    
                    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                    [NSThread detachNewThreadSelector:@selector(showProgressWith:) toTarget:self withObject:@"Finding vehicle price history"];

                    for (NSDictionary *dicToInsert in arr) {
                        
                            [objServiceCall performSelector:@selector(GetPriceHistory:ForTable:) withObject:dicToInsert withObject:@"tblOnSale"];
                            
                        
                    }

                
                }
                
                
                arr = nil;
                
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
                
                NSArray *arr =  [objSKDatabase lookupAllForSQL:@"select * from tblPriceHistory where vehicleId in (select vehicleId from tblOnSale)"];
                
                if ([arr count] > 0) {
                    
                    [objSKDatabase updateSQL:[NSString stringWithFormat:@"Update tblOnSale set OnSalePriceHistory = 'true' where GlassCarCode = '%@'",appDel.strVehicleID] forTable:@""];
                }
                
                [self listSimilarAdvertisements];
            }
            else{
                
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
            }
        }
        
    }
}


-(void)showProgressWith:(NSString *)strMessage
{
    
    [SVProgressHUD showWithStatus:strMessage];
    
}

#pragma mark - ReloadView while getting response from service


-(void)reloadAllViewWhileServiceComplete
{
    
    
    [self UpdateLayout];
    
    if (appDel.isOnline) {
        
        //Call Price History
        [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(callPriceHistoryForSaleRecords) userInfo:nil repeats:NO];
        
    }
    
    else{
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
        
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertError show];
        alertError = nil;
        
    }
    
    
}

-(void)UpdateLayout {
    
    NSString *strCustomPostCode = [objSKDatabase lookupColForSQL:[NSString stringWithFormat:@"select CustomPostCode from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
    
    
    if (strCustomPostCode.length > 0) {
        
        [btnPostcode setTitle:strCustomPostCode forState:UIControlStateNormal];
    }
    
    
    objWebServicesjson = nil;
    objWebServicesjson = [[WebServicesjson alloc]init];
    
    arrAdvertisements = nil;
    arrAdvertisements = [[NSMutableArray alloc] init];
    
    tblView.delegate = nil;
    tblView.dataSource = nil;
    tblView.hidden = TRUE;
    
    lblSortedValue.text=[NSString stringWithFormat:@"%@ -",appDel.strSortingString];
    int rowsel = [[NSUserDefaults standardUserDefaults] integerForKey:@"UseGPS"];
    
    if (rowsel== 0) {
        
        _btnLoc.selected = TRUE;
    }
    else
    {
        
        _btnLoc.selected = FALSE;
    }
    
    
    
    if(appDel.isSortOrder)
    {
        lblSortorder.text=@"Descending";
    }
    else
    {
        lblSortorder.text=@"Ascending";
    }
    
    [self hideMenuBar];
    appDel.appDelLastIndex=2;
    [objBottomView.bottomTabBar setSelectedItem:[objBottomView.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
    
    [self setToogleButton:nil];
    
    
    [self listSimilarAdvertisements];

}
#pragma mark-
#pragma mark Other Method

-(void)swipeLeftonsale_Clicked
{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    
    if(appDel.isIphone5)
    {
        SummaryViewController *objSummaryViewController1=[[SummaryViewController alloc]initWithNibName:@"SummaryViewController_i5" bundle:Nil];
        [self.navigationController pushViewController:objSummaryViewController1 animated:NO];
    }
    else
    {
        SummaryViewController *objSummaryViewController1=[[SummaryViewController alloc]initWithNibName:@"SummaryViewController" bundle:Nil];
        [[self navigationController] pushViewController:objSummaryViewController1 animated:NO];
    }
    
    
}




-(void)swipeRight_Clicked
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    
    OnSoldViewController *objOnSoldViewController =[[OnSoldViewController alloc]initWithNibName:@"OnSoldViewController" bundle:Nil];
    [self.navigationController pushViewController:objOnSoldViewController animated:NO];
    
    
}

-(void)listSimilarAdvertisements {
    
    // Fetch All Vehicle detail 
    
    NSString *strSotingString;
    
    if ([appDel.strSortingString isEqualToString:@"Spot Price"])
        
        strSotingString = @"spotPrice";
    else if ([appDel.strSortingString isEqualToString:@"Difference"])
        strSotingString = @"Difference";
    else if ([appDel.strSortingString isEqualToString:@"Distance"])
        strSotingString = @"Distance";
    else if ([appDel.strSortingString isEqualToString:@"Reg Date"])
        strSotingString = @"regDate";
    else if ([appDel.strSortingString isEqualToString:@"Mileage"])
        strSotingString = @"Mileage";
    else if ([appDel.strSortingString isEqualToString:@"Asking Price"])
        strSotingString = @"askingPrice";
    
    
    if ([arrAdvertisements count] > 0) {
        
        [arrAdvertisements removeAllObjects];
    }
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:strSotingString ascending:!appDel.isSortOrder];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-YYYY"];
    
    NSComparator compareDates = ^(id string1, id string2) {
        NSDate *date1 = [formatter dateFromString:string1];
        NSDate *date2 = [formatter dateFromString:string2];
        
        return [date1 compare:date2];
    };
    
    
    NSSortDescriptor * dateDescriptor = [[NSSortDescriptor alloc] initWithKey:strSotingString ascending:!appDel.isSortOrder comparator:compareDates];
    
    
    if (appDel.selectedTag == 4 && btnAll.isSelected == FALSE) {
        
        NSString *StrQuery;
        
        appDel.StrSortKeyword = [appDel.StrSortKeyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (appDel.StrSortKeyword.length > 0) {
            
            
            StrQuery = [NSString stringWithFormat:@"select * from tblOnSale where originalTypeDesc LIKE '%%%@%%' AND GlassCarCode = '%@'  ",appDel.StrSortKeyword,appDel.strVehicleID];
        }
        else{
            
            StrQuery = [NSString stringWithFormat:@"select * from tblOnSale where GlassCarCode = '%@' ",appDel.strVehicleID];
        }
        
        
        arrAdvertisements = (NSMutableArray *)[objSKDatabase lookupAllForSQL:StrQuery];
        
        if ([strSotingString isEqualToString:@"regDate"]) {
            
            [arrAdvertisements sortUsingDescriptors:[NSArray arrayWithObjects:dateDescriptor,nil]];
            
        }
        else{
            
            [arrAdvertisements sortUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor,nil]];
        }
        
        
    }
    else{
        
        
        if ([appDel.dicSelectedTag count] > 0) {
            
            NSArray *Arr = [appDel.dicSelectedTag allKeysForObject:@"true"];
            
            NSString *strSelectedTag = [Arr componentsJoinedByString:@","];
            NSString *StrQuery;
            if (appDel.StrSortKeyword.length > 0) {
                
                StrQuery = [NSString stringWithFormat:@"select * from tblOnSale where similarityCategory in (%@) AND originalTypeDesc LIKE '%%%@%%' AND GlassCarCode = '%@' ",strSelectedTag,appDel.StrSortKeyword,appDel.strVehicleID];
            }
            else{
                
                StrQuery = [NSString stringWithFormat:@"select * from tblOnSale where similarityCategory in (%@) AND GlassCarCode = '%@'  ",strSelectedTag,appDel.strVehicleID];
                
            }
            arrAdvertisements = (NSMutableArray *)[objSKDatabase lookupAllForSQL:StrQuery];
            
            
            if ([strSotingString isEqualToString:@"regDate"]) {
                
                [arrAdvertisements sortUsingDescriptors:[NSArray arrayWithObjects:dateDescriptor,nil]];
                
            }
            else{
                
                [arrAdvertisements sortUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor,nil]];
            }
            
        }
        
        else{
            
            arrAdvertisements = (NSMutableArray *)[objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblOnSale where GlassCarCode = '%@' ",appDel.strVehicleID]];
            
            
            if ([strSotingString isEqualToString:@"regDate"]) {
                
                [arrAdvertisements sortUsingDescriptors:[NSArray arrayWithObjects:dateDescriptor,nil]];
                
            }
            else{
                
                [arrAdvertisements sortUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor,nil]];
            }
            
        }
        
    }
    
    dicAllVehicleDetail = [objSKDatabase lookupRowForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
    
    NSString *sliderVal = [NSString stringWithFormat:@"%.2f",[[dicAllVehicleDetail objectForKey:@"SearchRadius"] floatValue]];
    
    sliderDBValue = [sliderVal floatValue];
    milesSlider.value = sliderDBValue;

    
    if ([dicAllVehicleDetail objectForKey:@"avgSellingTime"]) {
        
        lblAverageDaysToSell.text = [dicAllVehicleDetail objectForKey:@"avgSellingTime"];
        
    }
    int sellingCategory = [[dicAllVehicleDetail objectForKey:@"sellingTimeCategory"] intValue];
    
    if (sellingCategory == 1) {
        //Green calendar
        
        imgCalendar.image = [UIImage imageNamed:@"calendar-bg-GREEN@2x.png"];
        
    }
    else if (sellingCategory == 2)
    {
        
        //Amber calendar
        imgCalendar.image = [UIImage imageNamed:@"calendar-bg-AMBER@2x.png"];
    }
    else if (sellingCategory == 3){
        
        //Red Calendar
        imgCalendar.image = [UIImage imageNamed:@"calendar-bg-RED@2x.png"];
    }
    else{
        
        //black Calendar
        imgCalendar.image = [UIImage imageNamed:@"calendar-bg-BLACK@2x.png"];
    }
    
    
    NSMutableArray *arrAllData = (NSMutableArray *)[objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblOnSale where GlassCarCode = '%@'",appDel.strVehicleID]];
    
    int counterVeryHigh = 0;
    int counterHigh = 0;
    int counterMed = 0;
    
    
    for (NSDictionary *dic in arrAllData) {
        
        //similarityCategory
        if ([dic objectForKey:@"similarityCategory"]) {
            int code = [[dic objectForKey:@"similarityCategory"] intValue];
            
            if (code == 1) {
                
                // very High
                counterVeryHigh++;
                
            }
            else if (code == 2){
                
                counterHigh++;
                
            }
            else if (code == 3){
                
                counterMed++;
            }
            
        }
        
    }
    
    
    int all = [[NSString stringWithFormat:@"%d",counterVeryHigh] intValue] + [[NSString stringWithFormat:@"%d",counterHigh] intValue] + [[NSString stringWithFormat:@"%d",counterMed] intValue];
    
    [btnCounterVHigh setTitle:[NSString stringWithFormat:@"%d",counterVeryHigh] forState:UIControlStateNormal];
    [btnCounterHigh setTitle:[NSString stringWithFormat:@"%d",counterHigh] forState:UIControlStateNormal];
    [btnCounterMedium setTitle:[NSString stringWithFormat:@"%d",counterMed] forState:UIControlStateNormal];
    [btnCounterAll setTitle:[NSString stringWithFormat:@"%d",all] forState:UIControlStateNormal];
    
    [SVProgressHUD dismiss];
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
    
    if (dicPriceData) {
        dicPriceData = nil;
    }
    
    dicPriceData =[[NSMutableDictionary alloc] init];
    
    for (NSMutableDictionary *dict in arrAdvertisements) {
        
        NSArray *Arr = [objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblPriceHistory where vehicleId ='%@' AND ForTable = 'tblOnSale' AND GlassCarCode = '%@'",[dict objectForKey:@"vehicleId"],appDel.strVehicleID]];
        
        if ([Arr count] > 0) {
            
            [dicPriceData setObject:Arr forKey:[dict objectForKey:@"vehicleId"]];
            
        }
        
    }
    
    
    tblView.hidden = FALSE;
    tblView.delegate = self;
    tblView.dataSource = self;
    [tblView reloadData];
    [tblView scrollRectToVisible:CGRectMake(0, 0, tblView.frame.size.width, tblView.frame.size.height) animated:YES];
    
    
    
}
#pragma mark - TableView Method


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([arrAdvertisements count] > 0) {
        return [arrAdvertisements count];
    }
    else
        return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ([arrAdvertisements count] > 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:kCellNibName owner:self options:nil];
            cell=cellList;
            
        }
        
        tableView.separatorColor = [UIColor cyanColor];
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        
        
        UIImageView *imgBG1 = (UIImageView*)[cell viewWithTag:100];
        UIImageView *imgStripBg = (UIImageView *)[cell viewWithTag:101];
        UIImageView *imgStar = (UIImageView*)[cell viewWithTag:103];
        
        UIImageView *imgDays = (UIImageView*)[cell viewWithTag:104];
        
        
        UILabel *lblVehicleDesc = (UILabel*)[cell viewWithTag:201];
        UILabel *lblManuName = (UILabel*)[cell viewWithTag:202];
        UILabel *lblDate = (UILabel*)[cell viewWithTag:203];
        UILabel *lblAsk = (UILabel*)[cell viewWithTag:204];
        UILabel *lblSpot = (UILabel*)[cell viewWithTag:205];
        UILabel *lblDiff = (UILabel*)[cell viewWithTag:206];
        UILabel *lblAskSpotDiff = (UILabel*)[cell viewWithTag:207];
        UIView *viewDays = (UIView*)[cell viewWithTag:208];
        UILabel *lblCalendarDate = (UILabel*)[cell viewWithTag:209];
        UIButton *btnNumber = (UIButton*)[cell viewWithTag:210];
        UILabel *lblMileage = (UILabel*)[cell viewWithTag:211];
        UIImageView *imgNotification = (UIImageView*)[cell viewWithTag:212];
        
        lblSpot.backgroundColor = [appDel colorForHex:@"#005288"];
        
        lblVehicleDesc.text = [[arrAdvertisements objectAtIndex:indexPath.row] objectForKey:@"originalTypeDesc"];
        
        lblManuName.text = [[arrAdvertisements objectAtIndex:indexPath.row] objectForKey:@"dealerName"];
        
        lblDate.text = [[arrAdvertisements objectAtIndex:indexPath.row] objectForKey:@"regDate"];
        
        lblCalendarDate.text = [[arrAdvertisements objectAtIndex:indexPath.row] objectForKey:@"stockDays"];
        
        lblAsk.text = [NSString stringWithFormat:@"£%@",[[arrAdvertisements objectAtIndex:indexPath.row] objectForKey:@"askingPrice"]];
        
        
        
        CGSize textLabelSize1 = [lblAsk.text sizeWithFont:lblAsk.font /*constrainedToSize:constrainedSize*/];
        
        if (textLabelSize1.width > 50) {
            
            textLabelSize1.width = 50;
            
        }
        lblAsk.frame = CGRectMake(302-textLabelSize1.width - 5, lblAsk.frame.origin.y, textLabelSize1.width + 5, lblAsk.frame.size.height);
        
        lblAsk.textAlignment = UITextAlignmentCenter;

        
        
        if([[[arrAdvertisements objectAtIndex:indexPath.row] objectForKey:@"spotPrice"] intValue]==0)
            lblSpot.text=@"-";
        else
            lblSpot.text = [NSString stringWithFormat:@"£%@",[[arrAdvertisements objectAtIndex:indexPath.row] objectForKey:@"spotPrice"]];
        
        
        CGSize textLabelSize3 = [lblSpot.text sizeWithFont:lblSpot.font];
        
        if (textLabelSize3.width > 50) {
            
            textLabelSize3.width = 50;
            
        }

        lblSpot.frame = CGRectMake(302-textLabelSize3.width - 5, lblSpot.frame.origin.y, textLabelSize3.width + 5, lblSpot.frame.size.height);
        
        lblSpot.textAlignment = UITextAlignmentCenter;
        
        lblDiff.text =  [NSString stringWithFormat:@"£%@",[[arrAdvertisements objectAtIndex:indexPath.row] objectForKey:@"Difference"]];
        
        int diff = [[[arrAdvertisements objectAtIndex:indexPath.row] objectForKey:@"Difference"] intValue];
        
        if (diff < 0) {
            lblDiff.textColor = [UIColor blueColor];
        }
        else{
            
            lblDiff.textColor = [UIColor redColor];
        }
        
        
        CGSize textLabelSize2 = [lblDiff.text sizeWithFont:lblDiff.font /*constrainedToSize:constrainedSize*/];
        
        if (textLabelSize2.width > 50) {
            
            textLabelSize2.width = 50;
            
        }

        lblDiff.frame = CGRectMake(302-textLabelSize2.width - 5, lblDiff.frame.origin.y, textLabelSize2.width + 5, lblDiff.frame.size.height);
        
        lblDiff.textAlignment = UITextAlignmentCenter;

        NSString *strMileage = [NSString stringWithFormat:@"%d",[[[arrAdvertisements objectAtIndex:indexPath.row] objectForKey:@"Mileage"] intValue]];
        
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
        
        
        lblMileage.text = [NSString stringWithFormat:@"%@ m",[appDel formateCommaSeperate:[[arrAdvertisements objectAtIndex:indexPath.row] objectForKey:@"Mileage"]]];
        CGSize textLabelSize = [lblMileage.text sizeWithFont:lblMileage.font /*constrainedToSize:constrainedSize*/];
        
        lblMileage.frame = CGRectMake(lblMileage.frame.origin.x, lblMileage.frame.origin.y, textLabelSize.width, lblMileage.frame.size.height);
        lblMileage.textAlignment = UITextAlignmentRight;
        
        NSArray *arr = [dicPriceData objectForKey:[[arrAdvertisements objectAtIndex:indexPath.row] objectForKey:@"vehicleId"]];
        
        if ([arr count] > 0) {
            
            [btnNumber setTitle:[NSString stringWithFormat:@"%d",arr.count] forState:UIControlStateNormal];
        }
        
        
        int sortkey = [[[arrAdvertisements objectAtIndex:indexPath.row] objectForKey:@"similarityCategory"] intValue];
        
        /*
         
         1 = Similar
         2 = Pretty Similar
         3 = Otherwise
         */
        
        if (sortkey == 0) {
            
            imgStripBg.hidden = TRUE;
            imgBG1.image = [UIImage imageNamed:@"VRM-summary-block-selected-bg.png"];
            imgBG1.hidden = FALSE;
            imgNotification.hidden = TRUE;
            btnNumber.hidden = TRUE;
            lblAskSpotDiff.text = @"Spot";
            viewDays.hidden = TRUE;
            lblManuName.text = @"YOUR CAR";
            lblAsk.hidden = TRUE;
            lblDiff.hidden = TRUE;
          //  imgStar.hidden = TRUE;
            
        }
        else if (sortkey == 1){
            
          //  imgStar.hidden = TRUE;
            imgStripBg.image=[UIImage imageNamed:@"green-match-block@2x.png"];
            imgStripBg.hidden = FALSE;
            
            imgBG1.image = [UIImage imageNamed:@"VRM-summary-block-bg-l.png"];
            imgBG1.hidden = FALSE;
            imgNotification.hidden = FALSE;
            btnNumber.hidden = FALSE;
            lblAskSpotDiff.text = @"Ask Spot Diff";
            viewDays.hidden = FALSE;
            //        lblManuName.text = @"Johnsons Motors (8 mi)";
            lblAsk.hidden = FALSE;
            lblDiff.hidden = FALSE;
            
            
        }
        else if(sortkey == 2){
            
           // imgStar.hidden = TRUE;
            imgStripBg.image=[UIImage imageNamed:@"amber-match-block@2x.png"];
            imgStripBg.hidden = FALSE;
            
            imgBG1.image = [UIImage imageNamed:@"VRM-summary-block-bg-l.png"];
            imgBG1.hidden = FALSE;
            imgNotification.hidden = FALSE;
            btnNumber.hidden = FALSE;
            lblAskSpotDiff.text = @"Ask Spot Diff";
            viewDays.hidden = FALSE;
            //        lblManuName.text = @"Johnsons Motors (8 mi)";
            lblAsk.hidden = FALSE;
            lblDiff.hidden = FALSE;
            
            
        }
        else{
            
          //  imgStar.hidden = TRUE;
            imgStripBg.image=[UIImage imageNamed:@"red-match-block@2x.png"];
            imgStripBg.hidden = FALSE;
            
            imgBG1.image = [UIImage imageNamed:@"VRM-summary-block-bg-l.png"];
            imgBG1.hidden = FALSE;
            imgNotification.hidden = FALSE;
            btnNumber.hidden = FALSE;
            lblAskSpotDiff.text = @"Ask Spot Diff";
            viewDays.hidden = FALSE;
            //        lblManuName.text = @"Johnsons Motors (8 mi)";
            lblAsk.hidden = FALSE;
            lblDiff.hidden = FALSE;
            
        }
        
        
        if ([appDel.strVehicleID isEqualToString:[[arrAdvertisements objectAtIndex:indexPath.row] objectForKey:@"typeDesc"]] && sortkey == 1) {
            
            imgStar.hidden = FALSE;
            
        }
        else{
            
            imgStar.hidden = TRUE;
        }
    
    
        int days = [[[arrAdvertisements objectAtIndex:indexPath.row] objectForKey:@"stockDays"] intValue];
        if (days < 30) {
            
            //Green
            
            imgDays.image =[UIImage imageNamed:@"calendar-small-bgGREEN@2x.png"];
        }
        else if (days >=30 && days <= 59){
            
            //amber
            
            imgDays.image =[UIImage imageNamed:@"calendar-small-bgAMBER@2x.png"];
        }
        else if (days >= 60 && days <=89){
            
            
            //red
            imgDays.image =[UIImage imageNamed:@"calendar-small-bgRED@2x.png"];
        }
        else{
            
            //black
            imgDays.image =[UIImage imageNamed:@"calendar-small-bgBLACK@2x.png"];
        }
        
        return cell;
        
    }
    
    else{
        
        UITableViewCell *cellSimple = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        tableView.separatorColor = [UIColor clearColor];
        cellSimple.textLabel.text = @"No Vehicle Found";
        cellSimple.textLabel.textAlignment = UITextAlignmentCenter;
        cellSimple.userInteractionEnabled = FALSE;
        return cellSimple;
        
    }
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    // Navigate to the Price History screen with selected object
    if (![[[arrAdvertisements objectAtIndex:indexPath.row] objectForKey:@"similarityCategory"] isEqualToString:@"0"]) {
        
        PriceHistoryViewController *objPriceHistory = [[PriceHistoryViewController alloc] initWithNibName:@"PriceHistoryViewController" bundle:nil];
        
        if ([[dicPriceData objectForKey:[[arrAdvertisements objectAtIndex:indexPath.row] objectForKey:@"vehicleId"]] count] > 0) {
            
            if (objPriceHistory.dictForPriceCell) {
                objPriceHistory.dictForPriceCell=Nil;
            }
            if (objPriceHistory.arrPriceHistory) {
                objPriceHistory.arrPriceHistory=Nil;
                
            }
            
            objPriceHistory.arrPriceHistory=[dicPriceData objectForKey:[[arrAdvertisements objectAtIndex:indexPath.row] objectForKey:@"vehicleId"]];
            
            objPriceHistory.dictForPriceCell= [arrAdvertisements objectAtIndex:indexPath.row];
            
            objPriceHistory.isSold = FALSE;
            

         [self.navigationController pushViewController:objPriceHistory animated:YES];
                 [self.navigationController setNavigationBarHidden:NO animated:YES];
            
            
        }
        
    }
    
}


#pragma mark -
#pragma mark Button Method



-(void)buttonPriceClicked:(id)sender
{
    PriceHistoryViewController *objPriceHistory = [[PriceHistoryViewController alloc] initWithNibName:@"PriceHistoryViewController" bundle:nil];
    objPriceHistory.isSold = FALSE;

    [self.navigationController pushViewController:objPriceHistory animated:YES];
}

-(void)setToogleButton :(id) sender
{
    
    // This will set Filter button as per pervious track.
    if (sender != nil) {
        
        UIButton *btnMain = (UIButton *)sender;
        
        if (btnMain.tag == 4) {
            
            if(btnMain.selected)
            {
                
                [btnMain setSelected:FALSE];
                [btnVHigh setSelected:FALSE];
                [btnMed setSelected:FALSE];
                [btnHigh setSelected:FALSE];
                
                [appDel.dicSelectedTag setObject:@"true" forKey:@"1"];
                [appDel.dicSelectedTag setObject:@"true" forKey:@"2"];
                [appDel.dicSelectedTag setObject:@"true" forKey:@"3"];
                [appDel.dicSelectedTag setObject:@"true" forKey:@"4"];
                [appDel.dicSelectedTag setObject:@"true" forKey:@"0"];
                
                
            }
            else{
                [btnMain setSelected:TRUE];
                [btnVHigh setSelected:TRUE];
                [btnMed setSelected:TRUE];
                [btnHigh setSelected:TRUE];
                
                [appDel.dicSelectedTag setObject:@"false" forKey:@"1"];
                [appDel.dicSelectedTag setObject:@"false" forKey:@"2"];
                [appDel.dicSelectedTag setObject:@"false" forKey:@"3"];
                [appDel.dicSelectedTag setObject:@"false" forKey:@"4"];
                [appDel.dicSelectedTag setObject:@"true" forKey:@"0"];
            }
            
        }
        else{
            
            
            
            if(btnMain.selected)
            {
                btnMain.selected = FALSE;
                [appDel.dicSelectedTag setObject:@"true" forKey:[NSString stringWithFormat:@"%d",btnMain.tag]];
            }
            else
            {
                [btnMain setSelected:TRUE];
                [appDel.dicSelectedTag setObject:@"false" forKey:[NSString stringWithFormat:@"%d",btnMain.tag]];
            }
            
            if([[appDel.dicSelectedTag objectForKey:@"1"] isEqualToString:@"true"] && [[appDel.dicSelectedTag objectForKey:@"2"] isEqualToString:@"true"] && [[appDel.dicSelectedTag objectForKey:@"3"] isEqualToString:@"true"])
            {
                btnAll.selected = TRUE;
                [appDel.dicSelectedTag setObject:@"true" forKey:@"4"];
            }
            else
            {
                btnAll.selected = FALSE;
                [appDel.dicSelectedTag setObject:@"false" forKey:@"4"];
            }
        }
        
        
    }
    
    for (NSString *strKey in [appDel.dicSelectedTag allKeys]) {
        
        NSString *strValue = [appDel.dicSelectedTag objectForKey:strKey];
        int tag = [strKey intValue];
        if (tag == 0) {
            
        }
        else{
            
            UIButton *btn = (UIButton *)[self.view viewWithTag:tag];
            
            if ([strValue isEqualToString:@"true"]) {
                
                [btn setSelected:FALSE];
            }
            else{
                
                [btn setSelected:TRUE];
            }
            
        }
        
    }
    
    
}
- (IBAction)btntooggleClicked:(id)sender
{
    int tagValue = [sender tag];
    appDel.selectedTag = tagValue;
    [self setToogleButton:sender];
    [self listSimilarAdvertisements];
    
    
}
-(void)btnSettingClick:(id)sender
{
    [appDel loadSettingScreen];
}

-(void)buttonmenuClick:(id)sender
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    appDel.isMenuHidden = !appDel.isMenuHidden;
    [self hideMenuBar];
}
-(IBAction)buttonsortClick:(id)sender
{
    appDel.isDelSale=TRUE;
    
    SortViewController *objSortViewController = [[SortViewController alloc] initWithNibName:@"SortViewController" bundle:Nil];
    [appDel.navigationeController pushViewController:objSortViewController animated:YES];
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
        CGRect f = tblView.frame;
        tblView.frame = CGRectMake(f.origin.x, f.origin.y, f.size.width, tableHeight-49);
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
    else
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        objBottomView.view.frame=CGRectMake(0, self.view.frame.size.height, 320, 49);
        [UIView commitAnimations];
        [self performSelector:@selector(stopAnimatingMethod) withObject:nil afterDelay:0.3];
        CGRect f = tblView.frame;
        tblView.frame = CGRectMake(f.origin.x, f.origin.y, f.size.width, tableHeight);
        
    }
    

    
}
-(void)stopAnimatingMethod
{
    objBottomView.view.hidden=TRUE;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}
- (IBAction)btnLocClicked:(id)sender {
    
    appDel.isWithoutPostCode = FALSE;
    
    LocationViewController *objLocationViewController=[[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
    [self.navigationController pushViewController:objLocationViewController animated:YES];
}


- (IBAction)touchUpSlider:(id)sender {
    
    float silderValue = milesSlider.value;
    int flurryValue = 0;
    
    if(silderValue >= 0.0 && silderValue < 0.25)
    {
        milesSlider.value = 0.0;
        flurryValue = 50;
    }
    else if(silderValue >= 0.25 && silderValue < 0.50)
    {
        milesSlider.value = 0.25;
        flurryValue = 100;
    }
    else if(silderValue >= 0.50 && silderValue < 0.75)
    {
        milesSlider.value = 0.50;
        flurryValue = 200;
    }
    else if(silderValue >= 0.75)
    {
        flurryValue = -1;
        milesSlider.value = 1.0;
        
    }
    
    
    if (flurryValue == -1) {
        
        NSDictionary *sortParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"on Sale", @"From_Screen", 
         @"Country", @"Radius", 
         nil];
        if(appDel.isFlurryOn)
        {
            [Flurry logEvent:@"Change Radius" withParameters:sortParams];
            
        }
    }
    else{
        
        NSDictionary *sortParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"on Sale", @"From_Screen", 
         [NSString stringWithFormat:@"%d",flurryValue], @"Radius", // Capture the sorting
         nil];
        if(appDel.isFlurryOn)
        {
            [Flurry logEvent:@"Change Radius" withParameters:sortParams];
            
        }
        
    }
    
    
    
    if (sliderDBValue != silderValue) {
        
        // Call Webservice if Slider Value change
        // Call will made for Similar and Removed adverts
        
        if (appDel.isOnline) {
            
            sliderDBValue = milesSlider.value;
            appDel.intValSlider = milesSlider.value;
            
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            
            if (!appDel.UserAuthenticated) {
                
                [SVProgressHUD showWithStatus:@"Please wait for authentication.."];
                [self CallLoginAPI];
            }
            else{
                
                [SVProgressHUD showWithStatus:@"Please Wait..."];
                [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(callWebService) userInfo:nil repeats:NO];
            }
            
            
        }
        else{
            
            UIAlertView *AlertError = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [AlertError show];
            AlertError = nil;
            
        }
        
    }
    else {
        
        sliderDBValue=milesSlider.value;
        appDel.intValSlider = milesSlider.value;
    }

    
    
    
    
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
                
                NSString *sliderVal = [NSString stringWithFormat:@"%.2f",[[dicAllVehicleDetail objectForKey:@"SearchRadius"] floatValue]];
                
                sliderDBValue = [sliderVal floatValue];
                
                milesSlider.value = sliderDBValue;

                art = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@ %@",systemError,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [art show];
                
            }
            else if(![[dicreceivedData valueForKey:@"glassTokenField"] isEqualToString:@"00000000-0000-0000-0000-000000000000"] && [strValidField isEqualToString:@"0"])
            {
                
                appDel.UserAuthenticated = FALSE;
                
                NSString *sliderVal = [NSString stringWithFormat:@"%.2f",[[dicAllVehicleDetail objectForKey:@"SearchRadius"] floatValue]];
                
                sliderDBValue = [sliderVal floatValue];
                
                milesSlider.value = sliderDBValue;

                
                AccessDeniedViewController *objAccessDeniedViewController = [[AccessDeniedViewController alloc] initWithNibName:@"AccessDeniedViewController" bundle:nil];
                [self.navigationController pushViewController:objAccessDeniedViewController animated:YES];

            }
            
            else if(![[dicreceivedData valueForKey:@"glassTokenField"] isEqualToString:@"00000000-0000-0000-0000-000000000000"] && [strValidField isEqualToString:@"1"])
            {
                
                
                appDel.UserAuthenticated = TRUE;
                 [SVProgressHUD show];
                [self callWebService];
            }
            
        }
        else{
            
            [Flurry endTimedEvent:@"WS-GS-AuthenticateUserWithProduct" withParameters:nil];
            
            NSString *sliderVal = [NSString stringWithFormat:@"%.2f",[[dicAllVehicleDetail objectForKey:@"SearchRadius"] floatValue]];
            
            sliderDBValue = [sliderVal floatValue];
            
            milesSlider.value = sliderDBValue;

            
            appDel.UserAuthenticated = FALSE;
            [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            UIAlertView *art = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@ %@",ErrorInResponse,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [art show];
            
            
        }
        
    }
    
    else{
        
        NSString *sliderVal = [NSString stringWithFormat:@"%.2f",[[dicAllVehicleDetail objectForKey:@"SearchRadius"] floatValue]];
        
        sliderDBValue = [sliderVal floatValue];
        
        milesSlider.value = sliderDBValue;

        
        appDel.UserAuthenticated = FALSE;
        UIAlertView *alertNoInternet = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertNoInternet show];
        alertNoInternet = nil;
        
    }

}



-(void)callWebService {
    
    
    ServiceCallTemp *objServiceCall = [[ServiceCallTemp alloc] init];
    appDel.isFirstValuation = FALSE;
    
    
    
    NSDictionary *dicResponse = [objSKDatabase lookupRowForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
    
    if ([dicResponse count] > 0) {
        
        [objServiceCall performSelector:@selector(listSimilarAdvertisements:) withObject:dicResponse];
        
    }
    
    [SVProgressHUD dismiss];
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
    
    
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(callPriceHistoryForSaleRecords) userInfo:nil repeats:NO];
    
    
}


@end
