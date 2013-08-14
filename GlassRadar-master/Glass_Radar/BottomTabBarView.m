//
//  BottomTabBarView.m
//  Glass_Radar
//
//  Created by Pankti on 25/01/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "BottomTabBarView.h"

@interface BottomTabBarView ()

@end

@implementation BottomTabBarView
@synthesize bottomTabBar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bottomTabBar.delegate=self;
    
    // Do any additional setup after loading the view from its nib.
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSUInteger indexOfTab = [[self.bottomTabBar items] indexOfObject:item];
    
    if(indexOfTab==0)
    {
        
        NSArray *ary = appDel.navigationeController.viewControllers;
        
        if([[ary objectAtIndex:ary.count -1] isKindOfClass:[VRMSearchViewController class]])
        {
            [[ary objectAtIndex:ary.count -1] compareValue];
        }
        else
        {
            appDel.appDelLastIndex = indexOfTab;
            
            BOOL isFind = FALSE;
            for(UIViewController *view in ary)
            {
                if([view isKindOfClass:[VRMSearchViewController class]])
                {
                    VRMSearchViewController *obj = [[VRMSearchViewController alloc] init];
                    [obj compareValue];
                    UIViewController *view1 =[ary objectAtIndex:ary.count -1];
                    isFind = TRUE;
                    [view1.navigationController popToViewController:view animated:YES];
                    break;
                }
                
            }
            
            if(!isFind)
            {
                CATransition *transition = [CATransition animation];
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                
                
                if(appDel.appDelLastIndex < indexOfTab)
                {
                    transition.type = kCATransitionPush;
                    transition.subtype = kCATransitionFromRight;
                }
                else
                {
                    transition.type = kCATransitionPush;
                    transition.subtype = kCATransitionFromLeft;
                    
                }
                [appDel.navigationeController.view.layer addAnimation:transition forKey:nil];
                
                
                
                VRMSearchViewController *obj = [[VRMSearchViewController alloc] init];
                [appDel.navigationeController pushViewController:obj animated:NO];
                
            }
            [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
            
            
        }
        
    }
    else if(indexOfTab==1)
    {
        
        
        
        NSArray *ary = appDel.navigationeController.viewControllers;
        
        if([[ary objectAtIndex:ary.count -1] isKindOfClass:[SummaryViewController class]])
        {
            return;
        }

        
        if(!appDel.isSummary)
        {
            [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
            return;
        }
        
        
        BOOL isFind = FALSE;
        
        
        if(!isFind)
        {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            
            if(appDel.appDelLastIndex <= indexOfTab)
            {
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
            }
            else
            {
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromLeft;
                
            }
            [appDel.navigationeController.view.layer addAnimation:transition forKey:nil];
            
            
            
            if(appDel.isIphone5)
            {
                SummaryViewController *objSummaryViewController=[[SummaryViewController alloc]initWithNibName:@"SummaryViewController_i5" bundle:Nil];
                [appDel.navigationeController pushViewController:objSummaryViewController animated:NO];
            }
            else
            {
                SummaryViewController *objSummaryViewController=[[SummaryViewController alloc]initWithNibName:@"SummaryViewController" bundle:Nil];
                [appDel.navigationeController pushViewController:objSummaryViewController animated:NO];
            }
            
        }
        
        [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
        
    }
    else if(indexOfTab == 2)
    {
        
        NSArray *ary = appDel.navigationeController.viewControllers;
        
        if([[ary objectAtIndex:ary.count -1] isKindOfClass:[OnSaleViewController class]])
        {
            return;
        }
        if(!appDel.isSummary)
        {
            [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
            
            return;
        }
        //  NSArray *ary = appDel.navigationeController.viewControllers;
        BOOL isFind = FALSE;
        
        if(!isFind)
        {
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            
            if(appDel.appDelLastIndex <= indexOfTab)
            {
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
            }
            else
            {
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromLeft;
                
            }
            [appDel.navigationeController.view.layer addAnimation:transition forKey:nil];
            
            
            OnSaleViewController *objOnSaleViewController =[[OnSaleViewController alloc]initWithNibName:@"OnSaleViewController" bundle:Nil];
            [appDel.navigationeController pushViewController:objOnSaleViewController animated:NO];
            
        }
        [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
        
    }
    else if(indexOfTab == 3)
    {
        
        NSArray *ary = appDel.navigationeController.viewControllers;
        
        if([[ary objectAtIndex:ary.count -1] isKindOfClass:[OnSoldViewController class]])
        {
            return;
        }
        if(!appDel.isSummary)
        {
            [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
            
            return;
        }
        //  NSArray *ary = appDel.navigationeController.viewControllers;
        
        BOOL isFind = FALSE;
        
        
        if(!isFind)
        {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            
            if(appDel.appDelLastIndex <= indexOfTab)
            {
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
            }
            else
            {
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromLeft;
                
            }
            [appDel.navigationeController.view.layer addAnimation:transition forKey:nil];
            
            
            OnSoldViewController *objOnSoldViewController =[[OnSoldViewController alloc]initWithNibName:@"OnSoldViewController" bundle:Nil];
            [appDel.navigationeController pushViewController:objOnSoldViewController animated:NO];
            
        }
        
        [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
        
    }
    else  if(indexOfTab==4)
    {
        
        BOOL isFind;
        isFind =FALSE;
        NSArray *ary = appDel.navigationeController.viewControllers;

        appDel.appDelLastIndex = indexOfTab;
        
        if([[ary objectAtIndex:ary.count -1] isKindOfClass:[HistoryViewController class]])
        {
            
        }
        else
        {
            
            
            if(!isFind)
            {
                
                CATransition *transition = [CATransition animation];
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
                [appDel.navigationeController.view.layer addAnimation:transition forKey:nil];
                
                
                HistoryViewController *objHistoryViewController =[[HistoryViewController alloc]initWithNibName:@"HistoryViewController" bundle:Nil];
                [appDel.navigationeController pushViewController:objHistoryViewController animated:NO];
                
            }
        }
        
    }
    else {}
    
}
-(void)push :(int)indexOfTab
{
    if(indexOfTab==0)
    {
        
        //appDel.isSummary = FALSE;
        NSArray *ary = appDel.navigationeController.viewControllers;
        
        if([[ary objectAtIndex:ary.count -1] isKindOfClass:[VRMSearchViewController class]])
        {
            [[ary objectAtIndex:ary.count -1] compareValue];
        }
        else
        {
            appDel.appDelLastIndex = indexOfTab;
            
            BOOL isFind = FALSE;
            for(UIViewController *view in ary)
            {
                if([view isKindOfClass:[VRMSearchViewController class]])
                {
                    VRMSearchViewController *obj = [[VRMSearchViewController alloc] init];
                    [obj compareValue];
                    UIViewController *view1 =[ary objectAtIndex:ary.count -1];
                    isFind = TRUE;
                    [view1.navigationController popToViewController:view animated:YES];
                    break;
                }
                
            }
            
            if(!isFind)
            {
                CATransition *transition = [CATransition animation];
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                
                
                if(appDel.appDelLastIndex < indexOfTab)
                {
                    transition.type = kCATransitionPush;
                    transition.subtype = kCATransitionFromRight;
                }
                else
                {
                    transition.type = kCATransitionPush;
                    transition.subtype = kCATransitionFromLeft;
                    
                }
                [appDel.navigationeController.view.layer addAnimation:transition forKey:nil];
                
                
                
                VRMSearchViewController *obj = [[VRMSearchViewController alloc] init];
                [appDel.navigationeController pushViewController:obj animated:NO];
                
            }
            [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];

            
        }
        
    }
    else if(indexOfTab==1)
    {
        if(!appDel.isSummary)
        {
            [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
            return;
        }
        

        BOOL isFind = FALSE;
        
        if(!isFind)
        {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            
            if(appDel.appDelLastIndex < indexOfTab)
            {
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
            }
            else
            {
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromLeft;
                
            }
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            
            if(appDel.isIphone5)
            {
                SummaryViewController *objSummaryViewController=[[SummaryViewController alloc]initWithNibName:@"SummaryViewController_i5" bundle:Nil];
                [self.navigationController pushViewController:objSummaryViewController animated:NO];
            }
            else
            {
                SummaryViewController *objSummaryViewController=[[SummaryViewController alloc]initWithNibName:@"SummaryViewController" bundle:Nil];
                [self.navigationController pushViewController:objSummaryViewController animated:NO];
            }
            
        }
        
        [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
        
        
        
    }
    else if(indexOfTab == 2)
    {
        if(!appDel.isSummary)
        {
            [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
            
            return;
        }

        BOOL isFind = FALSE;
        
        if(!isFind)
        {
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            
            if(appDel.appDelLastIndex < indexOfTab)
            {
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
            }
            else
            {
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromLeft;
                
            }
            [appDel.navigationeController.view.layer addAnimation:transition forKey:nil];

            
            OnSaleViewController *objOnSaleViewController =[[OnSaleViewController alloc]initWithNibName:@"OnSaleViewController" bundle:Nil];
            [appDel.navigationeController pushViewController:objOnSaleViewController animated:NO];
            
        }
        [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
        
    }
    else if(indexOfTab == 3)
    {
        if(!appDel.isSummary)
        {
            [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
            
            return;
        }
        
        BOOL isFind = FALSE;
        
        if(!isFind)
        {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            
            if(appDel.appDelLastIndex < indexOfTab)
            {
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
            }
            else
            {
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromLeft;
                
            }
            [appDel.navigationeController.view.layer addAnimation:transition forKey:nil];

            
            OnSoldViewController *objOnSoldViewController =[[OnSoldViewController alloc]initWithNibName:@"OnSoldViewController" bundle:Nil];
            [appDel.navigationeController pushViewController:objOnSoldViewController animated:NO];
            
        }
        
        [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
        
    }
    else  if(indexOfTab==4)
    {

        BOOL isFind;
        isFind =FALSE;
        NSArray *ary = appDel.navigationeController.viewControllers;
        appDel.appDelLastIndex = indexOfTab;
        
        HistoryViewController *objHistoryViewController =[[HistoryViewController alloc]initWithNibName:@"HistoryViewController" bundle:Nil];
        [appDel.navigationeController pushViewController:objHistoryViewController animated:YES];
        return;
        
        if([[ary objectAtIndex:ary.count -1] isKindOfClass:[HistoryViewController class]])
        {
            
        }
        else
        {
            
            
            if(!isFind)
            {
                
                CATransition *transition = [CATransition animation];
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                
                
                if(appDel.appDelLastIndex < indexOfTab)
                {
                    transition.type = kCATransitionPush;
                    transition.subtype = kCATransitionFromRight;
                }
                else
                {
                    transition.type = kCATransitionPush;
                    transition.subtype = kCATransitionFromLeft;
                    
                }
                [appDel.navigationeController.view.layer addAnimation:transition forKey:nil];
                
                
                HistoryViewController *objHistoryViewController =[[HistoryViewController alloc]initWithNibName:@"HistoryViewController" bundle:Nil];
                [appDel.navigationeController pushViewController:objHistoryViewController animated:NO];
                
            }
        }
        
    }
    else {
    
    }
    
}

-(void)pushSwipe :(int)indexOfTab
{
    if(indexOfTab==0)
    {
        
        NSArray *ary = appDel.navigationeController.viewControllers;
        
        if([[ary objectAtIndex:ary.count -1] isKindOfClass:[VRMSearchViewController class]])
        {
            [[ary objectAtIndex:ary.count -1] compareValue];
        }
        else
        {
            
            appDel.appDelLastIndex = indexOfTab;
            
            BOOL isFind = FALSE;
            for(UIViewController *view in ary)
            {
                if([view isKindOfClass:[VRMSearchViewController class]])
                {
                    VRMSearchViewController *obj = [[VRMSearchViewController alloc] init];
                    [obj compareValue];
                    UIViewController *view1 =[ary objectAtIndex:ary.count -1];
                    isFind = TRUE;
                    [view1.navigationController popToViewController:view animated:YES];
                    break;
                }
                
            }
            
            if(!isFind)
            {
                CATransition *transition = [CATransition animation];
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                
                
                if(appDel.appDelLastIndex < indexOfTab)
                {
                    transition.type = kCATransitionPush;
                    transition.subtype = kCATransitionFromRight;
                }
                else
                {
                    transition.type = kCATransitionPush;
                    transition.subtype = kCATransitionFromLeft;
                    
                }
                [appDel.navigationeController.view.layer addAnimation:transition forKey:nil];
                
                
                
                VRMSearchViewController *obj = [[VRMSearchViewController alloc] init];
                [appDel.navigationeController pushViewController:obj animated:NO];
                
            }
            [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
            
            
        }
        
    }
    else if(indexOfTab==1)
    {
        if(!appDel.isSummary)
        {
            [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
            return;
        }
        NSArray *ary = appDel.navigationeController.viewControllers;
        BOOL isFind = FALSE;
        for(UIViewController *view in ary)
        {
            if([view isKindOfClass:[SummaryViewController class]])
            {
                
                UIViewController *view1 =[ary objectAtIndex:ary.count -1];
                isFind = TRUE;
                [view1.navigationController popToViewController:view animated:YES];
                break;
            }
            
        }
        
        
        if(!isFind)
        {
            if(appDel.isIphone5)
            {
                SummaryViewController *objSummaryViewController=[[SummaryViewController alloc]initWithNibName:@"SummaryViewController_i5" bundle:Nil];
                [self.navigationController pushViewController:objSummaryViewController animated:YES];
            }
            else
            {
                SummaryViewController *objSummaryViewController=[[SummaryViewController alloc]initWithNibName:@"SummaryViewController" bundle:Nil];
                [self.navigationController pushViewController:objSummaryViewController animated:YES];
            }
            
        }
        [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
        
        
        
    }
    else if(indexOfTab == 2)
    {
        if(!appDel.isSummary)
        {
            [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
            
            return;
        }
        NSArray *ary = appDel.navigationeController.viewControllers;
        BOOL isFind = FALSE;
        for(UIViewController *view in ary)
        {
            if([view isKindOfClass:[OnSaleViewController class]])
            {
                
                UIViewController *view1 =[ary objectAtIndex:ary.count -1];
                isFind = TRUE;
                [view1.navigationController popToViewController:view animated:YES];
                break;
            }
            
        }
        
        if(!isFind)
        {
            OnSaleViewController *objOnSaleViewController =[[OnSaleViewController alloc]initWithNibName:@"OnSaleViewController" bundle:Nil];
            [appDel.navigationeController pushViewController:objOnSaleViewController animated:YES];
            
        }
        [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
        
    }
    else if(indexOfTab == 3)
    {
        if(!appDel.isSummary)
        {
            [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
            
            return;
        }
        NSArray *ary = appDel.navigationeController.viewControllers;
        
        BOOL isFind = FALSE;
        for(UIViewController *view in ary)
        {
            if([view isKindOfClass:[OnSoldViewController class]])
            {
                
                UIViewController *view1 =[ary objectAtIndex:ary.count -1];
                isFind = TRUE;
                [view1.navigationController popToViewController:view animated:YES];
                break;
            }
            
        }
        
        
        
        if(!isFind)
        {
            OnSoldViewController *objOnSoldViewController =[[OnSoldViewController alloc]initWithNibName:@"OnSoldViewController" bundle:Nil];
            [appDel.navigationeController pushViewController:objOnSoldViewController animated:YES];
            
        }
        [self.bottomTabBar setSelectedItem:[self.bottomTabBar.items objectAtIndex:appDel.appDelLastIndex]];
        
    }
    else  if(indexOfTab==4)
    {
        
        BOOL isFind;
        isFind =FALSE;
        NSArray *ary = appDel.navigationeController.viewControllers;
        
        appDel.appDelLastIndex = indexOfTab;
        
        HistoryViewController *objHistoryViewController =[[HistoryViewController alloc]initWithNibName:@"HistoryViewController" bundle:Nil];
        [appDel.navigationeController pushViewController:objHistoryViewController animated:YES];
        return;
        
        if([[ary objectAtIndex:ary.count -1] isKindOfClass:[HistoryViewController class]])
        {
            
        }
        else
        {
            
            for(UIViewController *view in ary)
            {
                if([view isKindOfClass:[HistoryViewController class]])
                {
                    isFind=TRUE;
                    UIViewController *view1 =[ary objectAtIndex:ary.count -1];
                    [view1.navigationController popToViewController:view animated:YES];
                    break;
                }
                
            }
            
            if(!isFind)
            {
                
                UIViewController *view1 =[ary objectAtIndex:ary.count -1];
                
                
                HistoryViewController *objHistoryViewController =[[HistoryViewController alloc]initWithNibName:@"HistoryViewController" bundle:Nil];
                [view1.navigationController pushViewController:objHistoryViewController animated:YES];
                
            }
        }
        
    }
    else {}
    
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    

    int indexOfView = [tabBarController.viewControllers indexOfObject:viewController];
    
    UITabBarItem *item = [self.bottomTabBar.items objectAtIndex:indexOfView];
    
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                  
                                  [UIColor redColor], UITextAttributeTextColor,
                                  
                                  nil] forState:UIControlStateNormal];
    
    // set prev item gray text
    
    UITabBarItem *prevItem = [self.bottomTabBar.items objectAtIndex:_prevSelectedTabIndex];
    
    [prevItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      
                                      [UIColor grayColor], UITextAttributeTextColor,
                                      
                                      nil] forState:UIControlStateNormal];
    
    // change prevIndex
    
    _prevSelectedTabIndex = indexOfView;
    
    return YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    bottomTabBar = nil;
    [super viewDidUnload];
}
@end
