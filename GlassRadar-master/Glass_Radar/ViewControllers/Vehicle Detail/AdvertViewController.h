//
//  AdvertViewController.h
//  Glass_Radar
//
//  Created by Nirmalsinh Rathod on 2/4/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvertViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIImageView *imgBG;
    
    IBOutlet UIWebView *webView;
    
    NSString *advertURL;
}
@property (nonatomic , retain)  NSString *advertURL;
@end
