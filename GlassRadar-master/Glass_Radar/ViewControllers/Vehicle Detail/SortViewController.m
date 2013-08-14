//
//  SortViewController.m
//  Glass_Radar
//
//  Created by Mina Shau on 1/29/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "SortViewController.h"

@interface SortViewController ()

@end

@implementation SortViewController

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
        [Flurry logEvent:@"Sort"];
        
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *SortNavstr = NSLocalizedString(@"SortNavKey", nil);
    NSString *Sortlblstr = NSLocalizedString(@"SortlblKey", nil);
    NSString *Applybtnstr = NSLocalizedString(@"ApplybtnKey", nil);
    
    
    [btnApply setTitle:Applybtnstr forState:UIControlStateNormal];
    
    _lblKeyword.text=Sortlblstr;
    
    isSorting = appDel.isSortOrder;
    
    strSotingString = [NSString stringWithFormat:@"%@",appDel.strSortingString];
    
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, 50, 30)];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back-button-icon@2x.png"] forState:UIControlStateNormal];
    NSString *BackBtnstr = NSLocalizedString(@"BackBtnKey", nil);
    [btnBack setTitle:BackBtnstr forState:UIControlStateNormal];
    [btnBack setTitle:BackBtnstr forState:UIControlStateNormal];
    [btnBack setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    btnBack.titleLabel.textColor = [UIColor whiteColor];
    [btnBack.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];    [btnBack addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBack=[[UIBarButtonItem alloc]initWithCustomView:btnBack];
    [self.navigationItem setLeftBarButtonItem:barBack];
    self.title= SortNavstr;
    // Do any additional setup after loading the view from its nib.
    arrSortvalue = [[NSMutableArray alloc] init];
    
    [arrSortvalue addObject:@"Asking Price"];
    [arrSortvalue addObject:@"Spot Price"];
    [arrSortvalue addObject:@"Difference"];
    [arrSortvalue addObject:@"Distance"];
    [arrSortvalue addObject:@"Reg Date"];
    [arrSortvalue addObject:@"Mileage"];
    
    
    arrSortorder = [[NSMutableArray alloc] init];
    [arrSortorder addObject:@"Ascending"];
    [arrSortorder addObject:@"Descending"];
    
    if(isSorting)
    {
        [pickerViewsort selectRow:1 inComponent:1 animated:YES];
    }
    else
    {
        [pickerViewsort selectRow:0 inComponent:1 animated:YES];
        
    }
    for(int i=0;i<[arrSortvalue count];i++)
    {
        if([strSotingString isEqualToString:[NSString stringWithFormat:@"%@",[arrSortvalue objectAtIndex:i]]])
        {
            [pickerViewsort selectRow:i inComponent:0 animated:YES];
            break;
        }
    }
    
    
    if (appDel.StrSortKeyword.length > 0) {
        
        txtKeyword.text = appDel.StrSortKeyword;
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}


-(void)keyboardWillHide:(NSNotification *)aNotification
{
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    
    CGRect rect=self.view.frame;
    rect.origin.y=0;
    self.view.frame=rect;
    
    [UIView commitAnimations];
}

-(void)keyboardWillShow:(NSNotification *)aNotification
{
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    
    CGRect rect=self.view.frame;
    rect.origin.y=-175;
    self.view.frame=rect;
    
    [UIView commitAnimations];
    
}

- (IBAction)btnApplyClicked:(id)sender {
    
    appDel.isSortOrder = isSorting;
    appDel.strSortingString = nil;
    appDel.strSortingString = [NSString stringWithFormat:@"%@",strSotingString];
    appDel.StrSortKeyword = txtKeyword.text;

    if(appDel.isDelSale)
    {
        if(!isSorting){
            
            NSDictionary *soParams = [[NSDictionary alloc] initWithObjectsAndKeys: @"On Sale", @"From_Screen",                                     strSotingString, @"Sorting",@"Ascending", @"Direction",nil];
            
            if(appDel.isFlurryOn)
            {
                [Flurry logEvent:@"Change Sort" withParameters:soParams];
                
            }
            
        }
        else{
            
            
            NSDictionary *soParams = [[NSDictionary alloc] initWithObjectsAndKeys: @"On Sale", @"From_Screen",                                      strSotingString, @"Sorting",@"Descending", @"Direction",nil];
            
            if(appDel.isFlurryOn)
            {
                [Flurry logEvent:@"Change Sort" withParameters:soParams];
                
            }
            
        }
        
    }
    else
    {
        
        if(!isSorting)
        {
            
            NSDictionary *soParams = [[NSDictionary alloc] initWithObjectsAndKeys: @"Sold", @"From_Screen",                                strSotingString, @"Sorting",@"Ascending", @"Direction",nil];
            
            if(appDel.isFlurryOn)
            {
                [Flurry logEvent:@"Change Sort" withParameters:soParams];
                
            }
            
            
        }
        else
        {
            NSDictionary *soParams = [[NSDictionary alloc] initWithObjectsAndKeys:@"Sold", @"From_Screen",                                      strSotingString, @"Sorting",@"Descending", @"Direction",nil];
            
            if(appDel.isFlurryOn)
            {
                [Flurry logEvent:@"Change Sort" withParameters:soParams];
                
            }
            
            
            
        }
        
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Picker View Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component==0) { return [arrSortvalue count]; }
    
    else { return[arrSortorder count]; }}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (component)
    {
        case 0:
            return [arrSortvalue objectAtIndex:row];
            break;
        case 1:
            return [arrSortorder objectAtIndex:row];
            break;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //	NSLog(@"Selected Color: %@. Index of selected color: %i", [arrayColors objectAtIndex:row], row);
    
    
    if (component == 0)
    {
        strSotingString = [arrSortvalue objectAtIndex:row];
    }
    else
    {
        if(row==0)
        {
            isSorting=FALSE;
            
        }
        else if(row==1)
        {
            isSorting=TRUE;
        }
        else
        {}
        
        
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *expression = @"^[a-zA-Z0-9 _]*$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                        options:0
                                                          range:NSMakeRange(0, [newString length])];
    if (numberOfMatches == 0)
        return NO;
    
    
    return YES;
    
}

- (void)viewDidUnload {
    btnApply = nil;
    txtKeyword = nil;
    [self setLblKeyword:nil];
    [super viewDidUnload];
}
@end
