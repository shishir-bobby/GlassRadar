//
//  ServiceCallTemp.h
//  Glass_Radar
//
//  Created by Pankti on 26/03/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    
	DoneVRMValuation,
    DoneSpotPrice,
    DoneAverageSellingTime,
    DoneOnSale,
    DoneOnSold,
    DonePriceHistoryOnSale,
    DonePriceHistoryOnSold

} VRMStatus;


@interface ServiceCallTemp : NSObject
{


    BOOL isGotResponse;
    NSString *strGlassCarCode;
    WebServicesjson *objWebServicesjson;
    UIAlertView *alertNoPostcode;


}

@property (nonatomic,readwrite) VRMStatus status;

-(void)getVRMValuation :(NSString * )strVRM withMileage : (NSString *)strMileage;
-(void)getSpotPrice :(NSMutableDictionary *)dicResponse;
-(void)getAverageSellingTime :(NSMutableDictionary *)dicResponse;
-(void)listSimilarAdvertisements :(NSMutableDictionary *)dicData;
-(void)listSimilarRemoveAdvertisements :(NSMutableDictionary *)dicData;
-(void)grabAndStoreVehicleDetail : (NSMutableArray *) arrAllData forTable : (NSString *)strTableName;
-(void) GetPriceHistory :(NSMutableDictionary *) dicVehicleDetail ForTable : (NSString *) strTableName;


@end
