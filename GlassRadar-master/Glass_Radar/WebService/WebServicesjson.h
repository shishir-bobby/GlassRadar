//
//  WebServices.h
//  winkflash
//
//  Created by Nandpal on 01/10/12.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//



@protocol JsonDataDelegate <NSObject>
@required

- (void)JsonprocessSuccessful: (NSString *)receivedData;
- (void)JsonprocessSuccessfuldownloadFolderImage: (NSString *)receivedData;
- (void)Calldownload: (NSString *)receivedData;
- (void)JsonprocessArrImageResponse;    // Arr image count == 0
- (void)JsonprocessFail;
- (void)GetEmptyList;

- (void)Call_DisplayMagnifierImages;
- (void)Call_GotoDisplayMagnifierImages;
- (void)Call_DismissSharePopUp;

- (void)Call_RefreshView;
- (void)Call_SessionCreate;

- (void)Call_GOTOLoginScreen;

@end


@interface WebServicesjson : NSObject
{
    
    id <JsonDataDelegate> delegate;
}

-(NSMutableDictionary *)callJsonAPI:(NSString *)url withDictionary : (NSMutableDictionary *)dicAPIData;
-(NSArray *)callJsonAPIForAryReponse:(NSString *)url withDictionary : (NSMutableDictionary *)dicAPIData;




@end
