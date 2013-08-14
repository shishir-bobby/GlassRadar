//
//  PriceHistoryViewController.h
//  Glass_Radar
//
//  Created by Nirmalsinh Rathod on 2/4/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIImageView *imgBG;
    IBOutlet UITableViewCell *cellList;
    IBOutlet UITableView *tblView;
    NSMutableArray *aryData;
    IBOutlet UIButton *btnAdvert;
    BOOL isSold;
    IBOutlet UILabel *lblHeading1;
    IBOutlet UILabel *lblheading2;
    IBOutlet UILabel *lbldate;
    IBOutlet UILabel *lblePrice01;
    IBOutlet UILabel *lblPrice02;
    IBOutlet UILabel *lblPrice03;
    IBOutlet UILabel *lblMileage;
    
    
    NSArray *arrPriceHistory;
    NSMutableDictionary *dictForPriceCell;
    
    IBOutlet UILabel *lblCalendarDate;

    IBOutlet UIImageView *imageDays;
}
@property(nonatomic)BOOL isSold;
@property (nonatomic,retain)  NSArray *arrPriceHistory;;
@property (nonatomic, retain) NSMutableDictionary *dictForPriceCell;

- (IBAction)btnSetAdvertClicked:(id)sender;


@end
