//
//  FeedbackViewController.m
//  Glass_Radar
//
//  Created by Krutik Vora on 1/22/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

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
        
        [Flurry logEvent:@"Feedback"];
    }


}

- (void)viewDidLoad
{
    NSString *Sendstr = NSLocalizedString(@"BtnSendkey", nil);
    
    [_btnSend setTitle:Sendstr forState:UIControlStateNormal];

 
    txtEmail.inputAccessoryView = viewAccessory;
    txtCompany.inputAccessoryView = viewAccessory;
    txtName.inputAccessoryView = viewAccessory;
    txtCommentView.inputAccessoryView = viewAccessory;
    if(appDel.isIphone5)
    {
        imgBG.image = [UIImage imageNamed:@"background_i5.png"];
    }
    else
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
    NSString *Feedbacklblstr = NSLocalizedString(@"Feedbacklblkey", nil);
    _lblFeedback.text=Feedbacklblstr;
    NSString *Feedbackstr = NSLocalizedString(@"Feedbackey", nil);
    //NSString *strPassowrdReset = NSLocalizedString(@"Feedback", @"");
    
    txtCommentView.textColor = [UIColor lightGrayColor];
    
    self.navigationItem.titleView=[AppDelegate navigationTitleLable:Feedbackstr];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)backClicked:(id)sender
{
//	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationDuration:1.0];
//	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
//						   forView:self.navigationController.view
//							 cache:YES];
//
//	[UIView commitAnimations];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark Text Field Delegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    
    if(textField == txtName)
    {
        index = 0;
        barbtnPrevious.enabled = FALSE;
        btnNext.enabled = TRUE;
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    }
    else if(textField == txtCompany)
    {
        index = 1;
        barbtnPrevious.enabled = TRUE;
        btnNext.enabled = TRUE;

        self.view.frame = CGRectMake(0, -50, self.view.frame.size.width, self.view.frame.size.height);

    }
    else if(textField == txtEmail)
    {
        index = 2;
        barbtnPrevious.enabled = TRUE;
        btnNext.enabled = TRUE;

        self.view.frame = CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height);

    }

    return TRUE;
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == txtEmail)
        return YES;
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if(textField == txtName)
        [txtCompany becomeFirstResponder];
    else if(textField ==  txtCompany)
        [txtEmail becomeFirstResponder];
    else if(textField == txtEmail)
    {
       // if([appDel validateEmail:textField.text])
       // {
            [txtCommentView becomeFirstResponder];
         if (self.view.frame.origin.y==0) {
             
                 self.view.frame = CGRectMake(0, self.view.frame.origin.y - 200, self.view.frame.size.width, self.view.frame.size.height);
         }
       // }
        //else
        //{
        //}
    }
    else{
    
        [txtCommentView resignFirstResponder];
         self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    }
   return YES;
    
}



#pragma mark - Textview Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    index = 3;
    btnNext.enabled = FALSE;
    barbtnPrevious.enabled = TRUE;
    
    NSString *Commentstr = NSLocalizedString(@"Commentkey", nil);

    if ([textView.text isEqualToString:Commentstr]) {
        
        textView.text = @"";
        txtCommentView.textColor = [UIColor blackColor];

    }
    
    if (self.view.frame.origin.y==0) {
        
        self.view.frame = CGRectMake(0, self.view.frame.origin.y - 200, self.view.frame.size.width, self.view.frame.size.height);
        
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length == 0)
    {
        textView.text = @"Your Comment or Question";
        txtCommentView.textColor = [UIColor lightGrayColor];

    }
}
#pragma mark - Other Memory Method
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    imgBG = nil;
    txtName = nil;
    txtCompany = nil;
    txtEmail = nil;
    txtCommentView = nil;
    barbtnPrevious = nil;
    btnNext = nil;
    viewAccessory = nil;
    [self setLblFeedback:nil];
    [self setBtnSend:nil];
    [super viewDidUnload];
}
- (IBAction)btnSavedClicked:(id)sender {
    
    NSString *strName =  [txtName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *strCompany =  [txtCompany.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *strEmail =  [txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *strComment =  [txtCommentView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSString *Commentstr = NSLocalizedString(@"Commentkey", nil);

    
    if(strName.length == 0 || strCompany.length == 0 || strEmail.length == 0 || [strComment isEqualToString:Commentstr])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please complete all fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else if(![self validateEmail:txtEmail.text])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Valid Email Id." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }

    else
    {
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if (mailClass != nil)
        {
            // We must always check whether the current device is configured for sending emails
            if ([mailClass canSendMail])
            {
                [self displayComposerSheet];
            }
            else
            {
                [self launchMailAppOnDeviceForEmail];
            }
        }
        else
        {
            [self launchMailAppOnDeviceForEmail];
        }

       // [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)launchMailAppOnDeviceForEmail
{
    NSString *strEmail;
    
    if (appDel.isTestMode) {
        
        strEmail = Customer_Email;

    }
    else{
        
        strEmail = Customer_Email_LIVE;

    }
    
    
	
   // NSLog(@"Email %@",strEmail);
    NSString *recipients = [NSString stringWithFormat:@"mailto:%@",strEmail];
    NSString *body = [NSString stringWithFormat:@"&body="];
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields.

-(void)displayComposerSheet
{
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:[NSString stringWithFormat:@""]];
    
    // Set up recipients
    NSString *strEmail;
    
    if (appDel.isTestMode) {
        
        strEmail = Customer_Email;
        
    }
    else{
        
        strEmail = Customer_Email_LIVE;
        
    }
    
    NSArray *toRecipients = [NSArray arrayWithObject:strEmail];
    
    [picker setToRecipients:toRecipients];
    NSString *emailBody = [NSString stringWithFormat:@"Name: %@<br>Company: %@<br>Email: %@<br>Comment:%@",txtName.text,txtCompany.text,txtEmail.text,txtCommentView.text];
   [picker setMessageBody:emailBody isHTML:YES];
    
    NSString *VerNo = [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    [picker setSubject:[NSString stringWithFormat:@"RAPP IOS feedback v %@",VerNo]];
    
    [self presentModalViewController:picker animated:YES];
    
    
    
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //message.hidden = NO;
    // Notifies users about errors associated with the interface
    [self dismissModalViewControllerAnimated:YES];

    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:

            [self backClicked:nil];

            break;
        case MFMailComposeResultFailed:

            break;
        default:

            break;
    }
    
}


-(BOOL) validateEmail: (NSString *) email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
}
- (IBAction)btnDoneClicked:(id)sender
{
        [txtCompany resignFirstResponder];
        [txtEmail resignFirstResponder];
        [txtCommentView resignFirstResponder];
        [txtName resignFirstResponder];
    
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

}

- (IBAction)btnNextClicked:(id)sender
{
    
    NSString *Commentstr = NSLocalizedString(@"Commentkey", nil);

    if ([txtCommentView.text isEqualToString:@""]) {
        
        txtCommentView.text =Commentstr;
        
    }

    if(index == 0)
    {
        [txtCompany becomeFirstResponder];
    }
    else if(index == 1)
    {
        [txtEmail becomeFirstResponder];
    }
    else if(index == 2)
    {
        [txtCommentView becomeFirstResponder];
    }

}

- (IBAction)btnPreviousClicked:(id)sender
{
    NSString *Commentstr = NSLocalizedString(@"Commentkey", nil);

    if ([txtCommentView.text isEqualToString:@""]) {
        
        txtCommentView.text = Commentstr;
        
    }

    if(index == 3)
    {
        [txtEmail becomeFirstResponder];
    }
    else if(index == 2)
    {
        [txtCompany becomeFirstResponder];
    }
    else if(index == 1)
    {
        [txtName becomeFirstResponder];
    }

}
@end
