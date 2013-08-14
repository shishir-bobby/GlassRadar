//
//  PasswordResetViewController.h
//  Glass_Radar
//
//  Created by Krutik Vora on 1/21/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordResetViewController : UIViewController<UIAlertViewDelegate>
{
    IBOutlet UIImageView *imgBG;
    WebServices *objWebServices;
    BOOL isSuccess;

}
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UIButton *btnRequest;
@property (strong, nonatomic) IBOutlet UIButton *btnPhone;
- (IBAction)btnRequestClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblInfo1;
@property (strong, nonatomic) IBOutlet UILabel *lblInfo2;
-(void)btnSettingClick:(id)sender;
- (IBAction)btnPhoneClick:(id)sender;
-(void)resetPassword;
@end
