//
//  HelpViewController.h
//  Glass_Radar
//
//  Created by Nirmalsinh Rathod on 2/4/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController
{
    
    IBOutlet UIImageView *imgBG;
}
@property (strong, nonatomic) IBOutlet UITextView *lblhelp04;
@property (strong, nonatomic) IBOutlet UITextView *lblhelp02;
@property (strong, nonatomic) IBOutlet UITextView *lblhelp01;
@property (strong, nonatomic) IBOutlet UITextView *lblhelp03;
- (IBAction)btnPhoneClick:(id)sender;
@end
