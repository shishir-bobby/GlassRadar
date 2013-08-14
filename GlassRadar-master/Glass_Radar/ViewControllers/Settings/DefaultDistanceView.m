//
//  DefaultDistanceView.m
//  Glass_Radar
//
//  Created by Pankti on 10/05/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "DefaultDistanceView.h"

@interface DefaultDistanceView ()

@end

@implementation DefaultDistanceView

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
    
    NSString *DistanceNavstr = NSLocalizedString(@"DistanceNavKey", nil);
    NSString *DistanceBtn = NSLocalizedString(@"DistanceBtnKey", nil);
    [btnSave setTitle:DistanceBtn forState:UIControlStateNormal];
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, 50, 30)];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back-button-icon@2x.png"] forState:UIControlStateNormal];
    NSString *BackBtnstr = NSLocalizedString(@"BackBtnKey", nil);
    [btnBack setTitle:BackBtnstr forState:UIControlStateNormal];
    [btnBack setTitle:BackBtnstr forState:UIControlStateNormal];
    [btnBack setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    btnBack.titleLabel.textColor = [UIColor whiteColor];
    [btnBack.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [btnBack addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBack=[[UIBarButtonItem alloc]initWithCustomView:btnBack];
    [self.navigationItem setLeftBarButtonItem:barBack];
    self.title= DistanceNavstr;
    

    arrDistance = [[NSArray alloc] initWithObjects:@"50",@"100",@"200",@"UK", nil];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {

    float defaultslider= [[NSUserDefaults standardUserDefaults] floatForKey:@"Distance"];
    
    
    if (defaultslider == 0.0) {
        
        [pickerDistance selectRow:0 inComponent:0 animated:NO];
    }
    else if (defaultslider == 0.25){
        
        [pickerDistance selectRow:1 inComponent:0 animated:NO];
    }
    else if (defaultslider == 0.50){
        
        [pickerDistance selectRow:2 inComponent:0 animated:NO];
    }
    else{
        
        [pickerDistance selectRow:3 inComponent:0 animated:NO];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    btnSave = nil;
    pickerDistance = nil;
    [super viewDidUnload];
}

-(void)backClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSaveClicked:(id)sender {
    
    NSString *strDistanceValue = [arrDistance objectAtIndex:[pickerDistance selectedRowInComponent:0]];
    
    if ([strDistanceValue isEqualToString:@"50"]) {
        appDel.intValSlider = 0.0;
    }
    else if ([strDistanceValue isEqualToString:@"100"]) {
        appDel.intValSlider = 0.25;
    }
    else if ([strDistanceValue isEqualToString:@"200"]) {
        appDel.intValSlider = 0.50;
    }
    else{
        
        appDel.intValSlider = 1.00;
    }
    
    [[NSUserDefaults standardUserDefaults] setFloat:appDel.intValSlider forKey:@"Distance"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    //[DictRequest setObject:[NSString stringWithFormat:@"%f",value] forKey:@"SearchRadius"]
   // [objSKDatabase updateSQL:[NSString stringWithFormat:@"Update tblVehicle set SearchRadius = '%f' where GlassCarCode = '%@'",appDel.intValSlider,appDel.strVehicleID] forTable:@""];

    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark
#pragma mark Picker View Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [arrDistance count];
}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [arrDistance objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
}




@end
