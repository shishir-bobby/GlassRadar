//
//  FeedbackViewController.h
//  Glass_Radar
//
//  Created by Krutik Vora on 1/22/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface FeedbackViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate>
{
    
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtCompany;
    IBOutlet UITextField *txtName;
    IBOutlet UIImageView *imgBG;
    IBOutlet UITextView *txtCommentView;
    IBOutlet UIView *viewAccessory;
    IBOutlet UIBarButtonItem *btnNext;
    IBOutlet UIBarButtonItem *barbtnPrevious;
    int index;
}
@property (strong, nonatomic) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UILabel *lblFeedback;
- (IBAction)btnSavedClicked:(id)sender;
- (IBAction)btnDoneClicked:(id)sender;
- (IBAction)btnNextClicked:(id)sender;
- (IBAction)btnPreviousClicked:(id)sender;
@end
