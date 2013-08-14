//
//  HistoryViewController.h
//  Glass_Radar
//
//  Created by Mina Shau on 1/30/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

{
    BottomTabBarView *objBottomView;
    IBOutlet UITableViewCell *cellHistoryList;
    NSMutableArray *arrHistory;

    BOOL isEdited;
    IBOutlet UITableView *tblHistory;
    
    
    int selectedIndex;
    float tableHeight;
}
-(void)buttonmenuClick:(id)sender;
-(void)hideMenuBar;
-(void)stopAnimatingMethod;
-(void)swipeLeftHistory_Clicked;
@end
