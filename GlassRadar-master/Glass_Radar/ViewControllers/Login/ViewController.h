//
//  ViewController.h
//  Glass_Radar
//
//  Created by Krutik Vora on 1/21/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainItemWrapper.h"
#import "NSData+Base64.h"
@class KeychainItemWrapper;
@interface ViewController : UIViewController<UITextFieldDelegate>
{
    
    KeychainItemWrapper *wrapper;
    
    IBOutlet UIImageView *imgBG;
    int occurrenceCapital ;
    int occurenceNumbers ;
    WebServices *objWebServices;
    IBOutlet UILabel *lblCheckLang;
}
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (strong, nonatomic) IBOutlet UIView *navView;

- (IBAction)ActionBtnInfo:(id)sender;
- (IBAction)actionBtnSetting:(id)sender;
- (IBAction)actionBtnLoginClick:(id)sender;
- (IBAction)actionBtnForgotPass:(id)sender;
-(void)successfullyAuthenticate;
-(void)keyboardWillHide:(NSNotification *)aNotification;
-(void)keyboardWillShow:(NSNotification *)aNotification;

@end
