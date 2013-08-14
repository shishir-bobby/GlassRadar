//
//  AboutVC.h
//  Glass_Radar
//
//  Created by Mina Shau on 3/5/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutVC : UIViewController<UIWebViewDelegate>

{
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;

-(void)backClicked:(id)sender;
@end

