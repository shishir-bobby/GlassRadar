//
//  VRMSearchViewController.h
//  Glass_Radar
//
//  Created by Krutik Vora on 1/21/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomTabBarView.h"
#import <CoreLocation/CoreLocation.h>
#import "WebServicesjson.h"
#import "ServiceCallTemp.h"

@interface VRMSearchViewController : UIViewController
{
    IBOutlet UITextField *txtMileage;
    IBOutlet UITextField *txtRegNumber;
    IBOutlet UIButton *btnCheckMark;
  //  BottomView *objBottomView;
    
    BottomTabBarView *objBottomView;
    IBOutlet UIButton *btnFind;
    IBOutlet UIButton *btnUseTree;
    IBOutlet UIImageView *imgMileage;
    IBOutlet UIImageView *imgBG;
    
    ServiceCallTemp *objVRMServiceCall;
    NSTimer *timer;
    
    
}
@property (strong, nonatomic) IBOutlet UILabel *lbluseavgMileage;

- (IBAction)actionBtnFindClick:(id)sender;
- (IBAction)actionBtnSearchTreeClick:(id)sender;
- (IBAction)ActionBtnCheckMark:(id)sender;
-(void)hideMenuBar;
-(void)buttonmenuClick:(id)sender;
-(void)compareValue;
-(void)swipeVRMRight_Clicked;
-(void)vrmSearchData;
@end
