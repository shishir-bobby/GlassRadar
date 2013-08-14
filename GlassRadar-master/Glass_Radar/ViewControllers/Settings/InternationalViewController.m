//
//  InternationalViewController.m
//  Glass_Radar
//
//  Created by Krutik Vora on 1/22/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "InternationalViewController.h"
#import "AttributeLableCustomCell.h"
#import "NSAttributedString+Attributes.h"
@interface InternationalViewController ()

@end

@implementation InternationalViewController

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

    NSString *Internationalstr = NSLocalizedString(@"Internationalkey", nil);
    NSString *Savestr = NSLocalizedString(@"btndsavekey", nil);
    [_btnSave setTitle:Savestr forState:UIControlStateNormal];

//NSString *strPassowrdReset = NSLocalizedString(@"International", @"");
self.navigationItem.titleView=[AppDelegate navigationTitleLable:Internationalstr];
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
                                   [btnBack.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
                                   [btnBack addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
                                   UIBarButtonItem *barBack=[[UIBarButtonItem alloc]initWithCustomView:btnBack];
                                   [self.navigationItem setLeftBarButtonItem:barBack];
    /*retrive values from Settings*/
    NSLocale *locale = [NSLocale currentLocale];
    
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];

//    NSString *language = [locale displayNameForKey:NSLocaleIdentifier
//                                             value:[locale localeIdentifier]];
    
    NSString *language = [[locale objectForKey: NSLocaleLanguageCode] uppercaseString];
    
//    NSString *symbol = [locale objectForKey:NSLocaleCurrencySymbol];
    NSString *code = [locale objectForKey:NSLocaleCurrencyCode];
    if([code length]>0)
    {
        appDel.strCurrency=code;

    }
    else
    {
        appDel.strCurrency=@"";
    }
    Countrystr = NSLocalizedString(@"Countrykey", nil);
    Currstr = NSLocalizedString(@"Currkey", nil);
    Lang = NSLocalizedString(@"Languagekey", nil);
    Dist = NSLocalizedString(@"Distancekey", nil);
    
    NSString *strObjCountry=[NSString stringWithFormat:@"%@ (%@)",Countrystr,countryCode];
    NSString *strObjCurr=[NSString stringWithFormat:@"%@ (%@)",Currstr,code];
    NSString *strObjLan=[NSString stringWithFormat:@"%@ (%@)",Lang,language];

    
    objArray=[[NSMutableArray alloc]init];
    [objArray addObject:strObjCountry];
    [objArray addObject:strObjLan];
   // [objArray addObject:Dist];
    [objArray addObject:strObjCurr];
    
    
    [_tblInternational.layer setBorderWidth:2.0 ];
    [_tblInternational.layer setCornerRadius:10.0];
    [_tblInternational.layer setBorderColor:[UIColor colorWithRed:87.0f/255.0f green:213.0f/255.0f blue:235.0f/255.0f alpha:1.0f].CGColor];

    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)backClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    if(appDel.isFlurryOn)
    {
        [Flurry logEvent:@"International"];

    }

//    if(appDel.isIphone5)
//    {
//        _tblInternational.frame=CGRectMake(10, 9, 300, 150);
//    }
//    else
//    {
//        _tblInternational.frame=CGRectMake(10, 9, 300, 150);
//
//        
//    }
    _tblInternational.frame=CGRectMake(10, 9, 300, 134);

    //[objArray replaceObjectAtIndex:0 withObject:@"Country (Postcode)"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [objArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *identifier=@"AttributeCell";
    AttributeLableCustomCell* cell = (AttributeLableCustomCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[AttributeLableCustomCell alloc]initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:identifier];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell.lblTitle setBackgroundColor:[UIColor clearColor]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    NSMutableAttributedString *strAttName=[NSMutableAttributedString attributedStringWithString:[objArray objectAtIndex:indexPath.row]];
    NSString *strname=[objArray objectAtIndex:indexPath.row];
    [strAttName setFont:[UIFont boldSystemFontOfSize:15]];
    // [strAttName setTextColor:[UIColor blackColor]];
    [strAttName setTextColor:[UIColor colorWithRed:0.0f/255.0f green:78.0f/255.0f blue:131.0f/255.0f alpha:1.0f]];

    if(indexPath.row==0)
    {
        [strAttName setTextColor:[UIColor blackColor] range:[strname rangeOfString:Countrystr]];
        
    }
    else if(indexPath.row==1)
    {
        
        [strAttName setTextColor:[UIColor blackColor] range:[strname rangeOfString:Lang]];
        
    }
    else if(indexPath.row==2)
    {
        
        [strAttName setTextColor:[UIColor blackColor] range:[strname rangeOfString:Currstr]];
        
//        [strAttName setTextColor:[UIColor blackColor] range:[strname rangeOfString:@"Distance in"]];
        
    }

    [cell.lblTitle setAttributedText:strAttName];


    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 44;
}


- (void)viewDidUnload {
    [self setTblInternational:nil];
    [self setBtnSave:nil];
    imgBG = nil;
    [self setBtnSave:nil];
    [super viewDidUnload];
}
- (IBAction)btnSaveClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
