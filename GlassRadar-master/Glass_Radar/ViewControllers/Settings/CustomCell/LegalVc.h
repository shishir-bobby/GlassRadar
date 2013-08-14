//
//  LegalVc.h
//  Glass_Radar
//
//  Created by Mina on 3/20/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLayoutView.h"
@interface LegalVc : UIViewController<UIScrollViewDelegate>

{
    
    IBOutlet VLayoutView *vLayout;
    
    IBOutlet UITextView *txtJson;

}
@end
