//
//  SelectCarViewController.m
//  Glass_Radar
//
//  Created by Krutik Vora on 1/21/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "SelectCarViewController.h"

#import "SummaryViewController.h"
#define kCellNibName @"SelectCarCell"
#define CellIdentifier @"cell"
@interface SelectCarViewController ()

@end

@implementation SelectCarViewController

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
    /*for back button*/
    
    NSString *VRMBackstr = NSLocalizedString(@"VRMBackkey", nil);
    NSString *SelectCarNavstr = NSLocalizedString(@"SelectCarNavkey", nil);
    NSString *Selectcarlblstr = NSLocalizedString(@"Selectcarlblkey", nil);

    _lblSelectCar.text=Selectcarlblstr;
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, 44, 30)];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back-button-icon@2x.png"] forState:UIControlStateNormal];
    [btnBack setTitle:VRMBackstr forState:UIControlStateNormal];
    [btnBack setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    btnBack.titleLabel.textColor = [UIColor whiteColor];
    [btnBack.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];    [btnBack addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBack=[[UIBarButtonItem alloc]initWithCustomView:btnBack];
    [self.navigationItem setLeftBarButtonItem:barBack];
    
    self.navigationItem.titleView=[AppDelegate navigationTitleLable:SelectCarNavstr];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    
    tblCarList.delegate = nil;
    tblCarList.dataSource = nil;
    tblCarList.hidden = TRUE;
    
    if(appDel.isFlurryOn)
    {
        [Flurry logEvent:@"Select Vehicle"];

    }
    
    [self fetchAllVehicle];
    
}

- (void) fetchAllVehicle {

    if (arrVehicle) {
        
        arrVehicle = nil;
    }
    
    arrVehicle = [[NSArray alloc] init];
    arrVehicle = [objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblVehicle where  RegistrationNo = '%@'",appDel.strRegistrationNo]];


    tblCarList.delegate = self;
    tblCarList.dataSource = self;
    tblCarList.hidden = FALSE;
    [tblCarList reloadData];


}
-(void)backClicked:(id)sender
{

    appDel.isFromSelectVehicle = TRUE;
    NSArray *ary = appDel.navigationeController.viewControllers;
    for (int i=0;i<[ary count]; i++)
    {
        if([[ary objectAtIndex:i] isKindOfClass:[VRMSearchViewController class]])
        {
            [self.navigationController popToViewController:[ary objectAtIndex:i] animated:YES];
            break;
        }

    }
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    if ([arrVehicle count] > 0) {
        
        return [arrVehicle count];
    }
    
    return 1;
       
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
     return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if ([arrVehicle count] > 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            [[NSBundle mainBundle] loadNibNamed:kCellNibName owner:self options:nil];
            cell=cellList;
            
        }
        
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        UILabel *lblCarDetail = (UILabel *)[cell.contentView viewWithTag:1];
        
        NSDictionary *dicVehicleDetail = [arrVehicle objectAtIndex:indexPath.section];
        NSMutableString *strVehicleDesc = [[NSMutableString alloc] init];
        
        
        if ([[dicVehicleDetail objectForKey:@"StartDate"] length] > 0) {
            
            NSString *strStartDate = [dicVehicleDetail objectForKey:@"StartDate"];
            NSArray *arr = [strStartDate componentsSeparatedByString:@"-"];
            if (arr.count == 3) {
                
               [strVehicleDesc appendString:[NSString stringWithFormat:@"%@-%@",[arr objectAtIndex:1],[arr objectAtIndex:0]]];
            }
            
        }
        
        if ([[dicVehicleDetail objectForKey:@"Make"] length] > 0) {
            
            [strVehicleDesc appendString:[NSString stringWithFormat:@", %@",[dicVehicleDetail objectForKey:@"Make"]]];
        }
        if ([[dicVehicleDetail objectForKey:@"Description"] length] > 0) {
            
            [strVehicleDesc appendString:[NSString stringWithFormat:@", %@",[dicVehicleDetail objectForKey:@"Description"]]];
        }
        if ([[dicVehicleDetail objectForKey:@"EngineCapacity"] length] > 0) {
            
            [strVehicleDesc appendString:[NSString stringWithFormat:@", %@ cc",[dicVehicleDetail objectForKey:@"EngineCapacity"]]];
        }

        if ([[dicVehicleDetail objectForKey:@"BodyType"] length] > 0) {
            
            [strVehicleDesc appendString:[NSString stringWithFormat:@", %@",[dicVehicleDetail objectForKey:@"BodyType"]]];
        }
        lblCarDetail.text = strVehicleDesc;

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
    appDel.selectedTag = 4;
    if (appDel.dicSelectedTag) {
        
        [appDel.dicSelectedTag setObject:@"true" forKey:@"1"];
        [appDel.dicSelectedTag setObject:@"true" forKey:@"2"];
        [appDel.dicSelectedTag setObject:@"true" forKey:@"3"];
        [appDel.dicSelectedTag setObject:@"true" forKey:@"0"];
        [appDel.dicSelectedTag setObject:@"true" forKey:@"4"];
        
    }
    
    appDel.strVehicleID = [[arrVehicle objectAtIndex:indexPath.section] objectForKey:@"GlassCarCode"];
    
    if ([appDel.strVehicleID length] > 0) {
        
        
        NSString *strQuery = [NSString stringWithFormat:@"select t1.* , t2.* from tblOnSale t1 , tblOnSold t2 where t1.GlassCarCode = '%@' AND t2.GlassCarCode = '%@'",appDel.strVehicleID,appDel.strVehicleID];
        
        NSArray *arrLastRecord = [objSKDatabase lookupAllForSQL:strQuery];
        
        if ([arrLastRecord count] > 0) {
            
            // If Vehicle already exist, redirect to Summary

            
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
        
        else{

            int rowsel = [[NSUserDefaults standardUserDefaults] integerForKey:@"UseGPS"];
            
            if (rowsel== 0) {
                
                // Call Location API
                [appDel getNewLocaiton:self];
                
            }
            else
            {
                
                appDel.strLastPostCode = [[NSUserDefaults standardUserDefaults] valueForKey:@"Postcode"];
                
                [self LocationCalledAndReturned];
            }
            
            
        }

    }


}

-(void)LocationCalledAndReturned  {
    
    
    int rowsel = [[NSUserDefaults standardUserDefaults] integerForKey:@"UseGPS"];
    
    if (rowsel == 0) {
        
        appDel.strLastPostCode = appDel.strDelPostCode;
    }
    
    if (appDel.strLastPostCode.length == 0 ) {
        
        alertNoPostcode = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry postcode could not be calculated, please enter your postcode manually." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertNoPostcode show];
        
    }
    
    else{
        
        [SVProgressHUD showWithStatus:@"Please Wait..."];
        [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(callWebService) userInfo:nil repeats:NO];
        
    }
    
    
}

-(void) callWebService {
    

    // All WS Call Start from here with Spot Price
    ServiceCallTemp *objVRMServiceCall = [[ServiceCallTemp alloc] init];
    NSMutableDictionary *dic = (NSMutableDictionary *)[objSKDatabase lookupRowForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
    
    appDel.isFirstTimeGPS = FALSE;
    [objVRMServiceCall getSpotPrice:dic];
    
    
    [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
    

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView == alertNoPostcode) {
        
        appDel.isWithoutPostCode = TRUE;
        LocationViewController *objLocationViewController=[[LocationViewController alloc]initWithNibName:@"LocationViewController" bundle:nil];
        [appDel.navigationeController pushViewController:objLocationViewController animated:YES];
        
        
    }
    
}
- (void)viewDidUnload {
    [self setLblSelectCar:nil];
    tblCarList = nil;
    [super viewDidUnload];
}
@end
