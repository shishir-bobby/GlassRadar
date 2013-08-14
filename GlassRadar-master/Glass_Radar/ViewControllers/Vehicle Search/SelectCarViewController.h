//
//  SelectCarViewController.h
//  Glass_Radar
//
//  Created by Krutik Vora on 1/21/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCarViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableViewCell *cellList;
    
    
    NSArray *arrVehicle;
    
    IBOutlet UITableView *tblCarList;
    UIAlertView *alertNoPostcode;
    
}
@property (strong, nonatomic) IBOutlet UILabel *lblSelectCar;
@end
