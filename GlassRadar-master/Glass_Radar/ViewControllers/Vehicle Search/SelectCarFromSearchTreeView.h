//
//  SelectCarFromSearchTreeView.h
//  Glass_Radar
//
//  Created by Pankti on 26/04/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    
    DoneTreeValuation
    
} CarFromSearchTreeStatus;

@interface SelectCarFromSearchTreeView : UIViewController <UITableViewDelegate,UITableViewDataSource>
{

    IBOutlet UITableViewCell *cellList;
    
    IBOutlet UILabel *lblSelectedCar;
    IBOutlet UITableView *tblCarList;
    UIAlertView *alertNoPostcode;
    
    NSMutableDictionary *dicAllVehicleData;
    WebServicesjson *objWebServicesjson;
    
    NSMutableDictionary *dicOfParameters;
    NSString *strSelectedVehicleID;

}
@property (nonatomic,readwrite) CarFromSearchTreeStatus status;

@property (nonatomic, retain) NSMutableDictionary *dicOfParameters;
@property (nonatomic, retain) NSMutableDictionary *dicAllVehicleData;
@end
