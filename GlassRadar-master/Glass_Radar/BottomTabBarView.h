//
//  BottomTabBarView.h
//  Glass_Radar
//
//  Created by Pankti on 25/01/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomTabBarView : UIViewController<UITabBarControllerDelegate,UITabBarDelegate>
{


    IBOutlet UITabBar *bottomTabBar;
    int _prevSelectedTabIndex;
    IBOutlet UITabBarItem *item1;


}
-(void)push :(int)indexOfTab;
@property(nonatomic,retain)UITabBar *bottomTabBar;
@end
