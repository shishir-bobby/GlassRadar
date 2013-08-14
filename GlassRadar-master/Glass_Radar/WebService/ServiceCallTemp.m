//
//  ServiceCallTemp.m
//  Glass_Radar
//
//  Created by Pankti on 26/03/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "ServiceCallTemp.h"
#import "KeychainItemWrapper.h"

@implementation ServiceCallTemp

-(id)init{
    
    if (self) {
        
        objWebServicesjson = [[WebServicesjson alloc] init];
        
        int rowsel = [[NSUserDefaults standardUserDefaults] integerForKey:@"UseGPS"];
        
        if (rowsel== 0) {
            
            //change here
            appDel.strLastPostCode = appDel.strDelPostCode;
            // appDel.strLastPostCode = @"KT16 9TU";
            
        }
        else
        {
            appDel.strLastPostCode = [[NSUserDefaults standardUserDefaults] valueForKey:@"Postcode"];
            
        }
        
    }
    return self;
    
}


-(void)getVRMValuation :(NSString * )strVRM withMileage : (NSString *)strMileage {
    
    
    // This Method will call the VRM valuation Service and store the Vehicle detail unto database.
    
    
    appDel.strRegistrationNo = strVRM;
    appDel.strMileageLocal = strMileage;
    
    appDel.strSortingString = @"Spot Price";
    
    if (appDel.isOnline) {
        
        
        // Check for Vehicle if already Searched and ActiveRun
        
        NSString *strTemp = [strVRM stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSArray *arrVehicleData = [objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblVehicle where RegistrationNo = '%@' AND OriginalMileage = '%@' OR RegistrationNoTemp = '%@' AND OriginalMileage = '%@' OR RegistrationNoTemp = '%@' AND OriginalMileage = '%@'",strVRM,strMileage,strVRM,strMileage,strTemp,strMileage]];
        
        NSString *strVehicleID;
        
        if ([arrVehicleData count] > 1) {
            
            for (NSDictionary *dic in arrVehicleData) {
                
                int days;
                NSString *strDate = [dic objectForKey:@"ActiveRun"];
                NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
                [_formatter setDateFormat:@"dd-MM-yyyy"];
                
                NSString *str = [_formatter stringFromDate:[NSDate date]];
                
                NSArray *aryActiveRun = [strDate componentsSeparatedByString:@" "];
                NSArray *aryCurrentDate = [str componentsSeparatedByString:@" "];
                
                
                if([[aryActiveRun objectAtIndex:0] isEqualToString:[aryCurrentDate objectAtIndex:0]])
                    days = 0;
                else
                    days = -1;
                
                strVehicleID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"GlassCarCode"]];
                
                
                if (days == 0 && !appDel.isFromHistory)
                {
                    
                    [SVProgressHUD dismiss];
                    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                    
                    
                    SelectCarViewController *objSelectCarViewController=[[SelectCarViewController alloc]initWithNibName:@"SelectCarViewController" bundle:nil];
                    [appDel.navigationeController pushViewController:objSelectCarViewController animated:TRUE];
                    return;
                    
                }
                
            }
            
        }
        else if ([arrVehicleData count] > 0 && [arrVehicleData count] < 2){
            
            strVehicleID = [NSString stringWithFormat:@"%@",[[arrVehicleData objectAtIndex:0] objectForKey:@"GlassCarCode"]];
            
            int days;
            NSString *strDate = [[arrVehicleData objectAtIndex:0] objectForKey:@"ActiveRun"];
            NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
            [_formatter setDateFormat:@"dd-MM-yyyy"];
            
            NSString *str = [_formatter stringFromDate:[NSDate date]];
            
            NSArray *aryActiveRun = [strDate componentsSeparatedByString:@" "];
            NSArray *aryCurrentDate = [str componentsSeparatedByString:@" "];
            
            
            if([[aryActiveRun objectAtIndex:0] isEqualToString:[aryCurrentDate objectAtIndex:0]])
                days = 0;
            else
                days = -1;
            
            
            NSString *strQuery = [NSString stringWithFormat:@"select t1.* , t2.* from tblOnSale t1 , tblOnSold t2 where t1.GlassCarCode = '%@' AND t2.GlassCarCode = '%@'",strVehicleID,strVehicleID];
            
            NSArray *arrLastRecord = [objSKDatabase lookupAllForSQL:strQuery];
            
            if ([arrLastRecord count] > 0 && days == 0 && !appDel.isFromHistory){
                
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
                appDel.strVehicleID = [[arrVehicleData objectAtIndex:0] objectForKey:@"GlassCarCode"];
                [self setStatus:DoneOnSold];
                return;
                
            }
            
        }
        
        
        if (appDel.dicSelectedTag) {
            
            [appDel.dicSelectedTag setObject:@"true" forKey:@"1"];
            [appDel.dicSelectedTag setObject:@"true" forKey:@"2"];
            [appDel.dicSelectedTag setObject:@"true" forKey:@"3"];
            [appDel.dicSelectedTag setObject:@"true" forKey:@"0"];
            [appDel.dicSelectedTag setObject:@"true" forKey:@"4"];
            
            
        }
        
        appDel.isSummary = FALSE;
        
        if(appDel.isFlurryOn)
        {
            [Flurry logEvent:@"WS-P-GetVRMValuation" timed:YES];
        }
        
        [NSThread detachNewThreadSelector:@selector(showProgressWith:) toTarget:self withObject:@"Finding your vehicle"];
        
        
        NSMutableDictionary *DictRequest = [[NSMutableDictionary alloc] init];
        
        
        //{"ClientCode":"********","AccountName":"********","Password":"********","ISOCountryCode":"GB","ISOCurrencyCode":"GBP","ISOLanguageCode":"EN","VRM":"pj60rdz","Mileage":"10000”}
        
        if (appDel.isTestMode) {
            
            [DictRequest setObject:Proxy_WS_ClientCode forKey:@"ClientCode"];
            [DictRequest setObject:Proxy_WS_AccountName forKey:@"AccountName"];
            [DictRequest setObject:Proxy_WS_Password forKey:@"Password"];
            
        }
        
        else{
            
            [DictRequest setObject:Proxy_WS_ClientCode_LIVE forKey:@"ClientCode"];
            [DictRequest setObject:Proxy_WS_AccountName_LIVE forKey:@"AccountName"];
            [DictRequest setObject:Proxy_WS_Password_LIVE forKey:@"Password"];
            
        }
        [DictRequest setObject:@"GB" forKey:@"ISOCountryCode"];
        [DictRequest setObject:@"GBP" forKey:@"ISOCurrencyCode"];
        [DictRequest setObject:@"EN" forKey:@"ISOLanguageCode"];
        [DictRequest setObject:strVRM forKey:@"VRM"];
        [DictRequest setObject:strMileage forKey:@"Mileage"];
        
        NSMutableDictionary *dicResponse;
        if (appDel.isTestMode) {
            
            dicResponse = [objWebServicesjson callJsonAPI:VRM_URL withDictionary:DictRequest];
            
        }
        else{
            
            dicResponse = [objWebServicesjson callJsonAPI:VRM_URL_LIVE withDictionary:DictRequest];
            
        }
        
        
        
        @try {
            
            if (dicResponse) {
                
                
                if ([dicResponse count]> 0) {
                    
                    
                    if ([dicResponse count] == 1) {
                        
                        NSDictionary *dic = [dicResponse mutableCopy];
                        
                        //@"No record found in SAE table",@"ErrorMsg",@"400",@"ErrorCode"
                        
                        if ([[dic objectForKey:@"ErrorCode"] isEqualToString:@"400"]) {
                            
                            /*Error_Event*/
                            NSDictionary *flurryParams =
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"WS-P-GetVRMValuation", @"Error",
                             [NSString stringWithFormat:@"%@",[dic objectForKey:@"ErrorMsg"]],@"ErrorLocation",
                             
                             nil];
                            if(appDel.isFlurryOn)
                            {
                                NSError *error;
                                error = [NSError errorWithDomain:@"WS-P-GetVRMValuation - Server Code (400)" code:200 userInfo:flurryParams];
                                
                                [Flurry logError:@"WS-P-GetVRMValuation - Server Code (400)"   message:@"Vehicle Search - WS-P-GetVRMValuation - Server Code (400)"  error:error];
                                
                                
                            }
                            /*Error_Event*/
                            
                            [Flurry endTimedEvent:@"WS-P-GetVRMValuation" withParameters:nil];
                            
                            //                                [SVProgressHUD dismiss];
                            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                            
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"This vehicle cannot be valued. This may be because the vehicle is too new to have a used valuation available or is a rare or exotic model. We apologise for any inconvenience this has caused." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                            alert = nil;
                            
                            return;
                            
                        }
                        
                    }
                    
                    
                    [Flurry endTimedEvent:@"WS-P-GetVRMValuation" withParameters:nil];
                    
                    int errorCode = [[dicResponse objectForKey:@"errorCodeField"] intValue];
                    int vRMErrorCodeField = [[dicResponse objectForKey:@"vRMErrorCodeField"] intValue];
                    
                    
                    if (errorCode == 0 && vRMErrorCodeField == 0) {
                        
                        
                        NSString *strTradePriceDate = @"";
                        if (![[dicResponse objectForKey:@"editionDate"] isKindOfClass:[NSNull class]]) {
                            
                            
                            strTradePriceDate = [dicResponse objectForKey:@"editionDate"];
                        }
                        
                        if ([dicResponse objectForKey:@"itemsField"]) {
                            
                            
                            NSArray *arrAllLastVehicle = [objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblVehicle where RegistrationNo = '%@' OR RegistrationNoTemp = '%@'",strVRM,strTemp]];
                            if ([arrAllLastVehicle count]  > 0) {
                                
                                [objSKDatabase deleteWhere:[NSString stringWithFormat:@"GlassCarCode in (select GlassCarCode from tblVehicle where RegistrationNo = '%@' OR RegistrationNoTemp = '%@')",strVRM,strTemp] forTable:@"tblOnSale"];
                                [objSKDatabase deleteWhere:[NSString stringWithFormat:@"GlassCarCode in (select GlassCarCode from tblVehicle where RegistrationNo = '%@' OR RegistrationNoTemp = '%@')",strVRM,strTemp] forTable:@"tblOnSold"];
                                [objSKDatabase deleteWhere:[NSString stringWithFormat:@"GlassCarCode in (select GlassCarCode from tblVehicle where RegistrationNo = '%@' OR RegistrationNoTemp = '%@')",strVRM,strTemp] forTable:@"tblPriceHistory"];
                                
                            }
                            [objSKDatabase deleteWhere:[NSString stringWithFormat:@"RegistrationNo = '%@' OR RegistrationNoTemp = '%@'",strVRM,strTemp] forTable:@"tblVehicle"];
                            
                            NSArray *arr = [dicResponse objectForKey:@"itemsField"];
                            
                            // insert in vehicle table
                            
                            for (NSDictionary *dicResponse in arr) {
                                
                                NSMutableDictionary *dicToInsert = [[NSMutableDictionary alloc] init];
                                
                                NSDateFormatter *formatter;
                                NSString        *dateString;
                                
                                formatter = [[NSDateFormatter alloc] init];
                                [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
                                
                                dateString = [formatter stringFromDate:[NSDate date]];
                                
                                
                                [dicToInsert setObject:dateString forKey:@"Date"];
                                [dicToInsert setObject:@"" forKey:@"Name"];
                                
                                if ([dicResponse objectForKey:@"qualifiedModelCodeField"]) {
                                    
                                    [dicToInsert setObject:[dicResponse objectForKey:@"qualifiedModelCodeField"] forKey:@"GlassCarCode"];
                                }
                                else{
                                    
                                    [dicToInsert setObject:@"" forKey:@"GlassCarCode"];
                                }
                                
                                if ([dicResponse objectForKey:@"qualifiedModelCodeField"]) {
                                    
                                    [dicToInsert setObject:[dicResponse objectForKey:@"qualifiedModelCodeField"] forKey:@"GlassCarCode"];
                                }
                                else{
                                    
                                    [dicToInsert setObject:@"" forKey:@"GlassCarCode"];
                                }
                                
                                int rowsel = [[NSUserDefaults standardUserDefaults] integerForKey:@"UseGPS"];
                                
                                if (rowsel == 0) {
                                    
                                    if (appDel.strCurrentLocation.length > 0) {
                                        
                                        [dicToInsert setObject:appDel.strCurrentLocation forKey:@"Location"];
                                    }
                                    else{
                                        
                                        [dicToInsert setObject:@"" forKey:@"Location"];
                                    }
                                    
                                }
                                else {
                                    
                                    [dicToInsert setObject:@"" forKey:@"Location"];
                                }
                                
                                if ([dicResponse objectForKey:@"vehicleDetailsField"]) {
                                    
                                    NSString *strMake = [[dicResponse objectForKey:@"vehicleDetailsField"] objectForKey:@"manufacturerField"];
                                    
                                    [dicToInsert setObject:strMake forKey:@"Make"];
                                    
                                    NSString *strModel = [[dicResponse objectForKey:@"vehicleDetailsField"] objectForKey:@"modelDescriptionField"];
                                    
                                    [dicToInsert setObject:strModel forKey:@"Model"];
                                    
                                    NSString *stryearOfManufacture = [[dicResponse objectForKey:@"vehicleDetailsField"] objectForKey:@"yearOfManufactureField"];
                                    
                                    [dicToInsert setObject:stryearOfManufacture forKey:@"yearOfManufacture"];
                                    
                                    
                                    NSString *strModelDesc = [[dicResponse objectForKey:@"vehicleDetailsField"] objectForKey:@"descriptionField"];
                                    
                                    [dicToInsert setObject:strModelDesc forKey:@"Description"];
                                    
                                    NSString *strVariant = [[dicResponse objectForKey:@"vehicleDetailsField"] objectForKey:@"variantField"];
                                    
                                    [dicToInsert setObject:strVariant forKey:@"Variant"];
                                    
                                    NSString *strBodyType = [[dicResponse objectForKey:@"vehicleDetailsField"] objectForKey:@"bodyTypeField"];
                                    
                                    [dicToInsert setObject:strBodyType forKey:@"BodyType"];
                                    
                                    NSString *strdoorsField = [[dicResponse objectForKey:@"vehicleDetailsField"] objectForKey:@"doorsField"];
                                    
                                    [dicToInsert setObject:strdoorsField forKey:@"Doors"];
                                    
                                    NSString *strEngineCapacity = [[dicResponse objectForKey:@"vehicleDetailsField"] objectForKey:@"engineCapacityField"];
                                    
                                    [dicToInsert setObject:strEngineCapacity forKey:@"EngineCapacity"];
                                    
                                    NSString *strTransmissionDescription = [[dicResponse objectForKey:@"vehicleDetailsField"] objectForKey:@"transmissionDescriptionField"];
                                    
                                    [dicToInsert setObject:strTransmissionDescription forKey:@"TransmissionDescription"];
                                    
                                    if ([[[dicResponse objectForKey:@"vehicleDetailsField"] objectForKey:@"dateOfRegistrationField"] length] > 0) {
                                        
                                        NSString *strRegistrationDate = [[dicResponse objectForKey:@"vehicleDetailsField"] objectForKey:@"dateOfRegistrationField"];
                                        
                                        [dicToInsert setObject:[appDel fetchDateFromTimestamp:strRegistrationDate] forKey:@"RegistrationDate"];
                                        
                                    }
                                    
                                    NSString *StartDate = [[dicResponse objectForKey:@"vehicleDetailsField"] objectForKey:@"startDateField"];
                                    
                                    if (StartDate.length > 0) {
                                        
                                        StartDate = [appDel fetchDateFromTimestamp:StartDate];
                                    }
                                    
                                    [dicToInsert setObject:StartDate forKey:@"StartDate"];
                                    
                                    
                                    NSString *EndDate = [[dicResponse objectForKey:@"vehicleDetailsField"] objectForKey:@"endDateField"];
                                    
                                    if (EndDate.length > 0) {
                                        
                                        EndDate = [appDel fetchDateFromTimestamp:EndDate];
                                    }
                                    
                                    [dicToInsert setObject:EndDate forKey:@"EndDate"];
                                    
                                    
                                    NSString *AverageMileage = [NSString stringWithFormat:@"%d",[[dicResponse objectForKey:@"averageMileageField"] intValue]];
                                    
                                    [dicToInsert setObject:AverageMileage forKey:@"AverageMileage"];
                                    
                                    if ([strMileage isEqualToString:@"0"]) {
                                        
                                        
                                        [dicToInsert setObject:AverageMileage forKey:@"Mileage"];
                                        
                                    }
                                    else{
                                        
                                        [dicToInsert setObject:strMileage forKey:@"Mileage"];
                                    }
                                    
                                    
                                    if ([strMileage isEqualToString:@"0"]) {
                                        
                                        NSString *TradePrice =[NSString stringWithFormat:@"%d",[[[dicResponse objectForKey:@"basicResidualValuesField"] objectForKey:@"tradeValueField"] intValue]];
                                        
                                        [dicToInsert setObject:TradePrice forKey:@"TradePrice"];
                                        
                                    }
                                    else{
                                        
                                        NSString *TradePrice =[NSString stringWithFormat:@"%d",[[[dicResponse objectForKey:@"totalValuationsField"] objectForKey:@"tradeValueField"] intValue]];
                                        
                                        [dicToInsert setObject:TradePrice forKey:@"TradePrice"];
                                        
                                    }
                                    
                                    if (appDel.strCurrency.length > 0) {
                                        
                                        
                                        [dicToInsert setObject:appDel.strCurrency forKey:@"Currency"];
                                    }
                                    else{
                                        
                                        [dicToInsert setObject:@"" forKey:@"Currency"];
                                    }
                                    
                                    
                                    [dicToInsert setObject:strVRM forKey:@"RegistrationNo"];
                                    
                                    [dicToInsert setObject:[NSString stringWithFormat:@"%f",appDel.intValSlider] forKey:@"SearchRadius"];
                                    
                                    if (strTradePriceDate.length > 0) {
                                        
                                        
                                        NSString *strTradePrice = [appDel fetchDateFromTimestamp:strTradePriceDate withDateFormate:@"MMM yyyy"];
                                        [dicToInsert setObject:strTradePrice forKey:@"TradePriceDate"];
                                        
                                        
                                    }
                                    
                                    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
                                    [_formatter setDateFormat:@"dd-MM-yyyy"];
                                    NSString *StrDate = [_formatter stringFromDate:[NSDate date]];
                                    
                                    [dicToInsert setObject:StrDate forKey:@"ActiveRun"];
                                    
                                    
                                    if (appDel.strCurrency.length > 0) {
                                        
                                        
                                        [dicToInsert setObject:appDel.strCurrency forKey:@"Currency"];
                                    }
                                    else{
                                        
                                        [dicToInsert setObject:@"" forKey:@"Currency"];
                                    }
                                    
                                    //RegistrationNoTemp
                                    
                                    [dicToInsert setObject:[strVRM stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"RegistrationNoTemp"];
                                    
                                    [dicToInsert setObject:strMileage forKey:@"OriginalMileage"];
                                    
                                    [dicToInsert setObject:@"" forKey:@"CustomPostCode"];
                                    
                                    int rowsel = [[NSUserDefaults standardUserDefaults] integerForKey:@"UseGPS"];
                                    [dicToInsert setObject:[NSString stringWithFormat:@"%d",rowsel] forKey:@"UseGps"];
                                    
                                    [objSKDatabase insertDictionary:dicToInsert forTable:@"tblVehicle"];
                                    
                                }
                                
                                
                            }
                            
                            [self setStatus:DoneVRMValuation];
                            
                            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                            
                        }
                        
                        else{
                            
                            [SVProgressHUD dismiss];
                            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                            
                        }
                    }
                    else if ([[dicResponse objectForKey:@"errorStringField"] rangeOfString:@"No Vehicles Returned"].location != NSNotFound){
                        
                        [SVProgressHUD dismiss];
                        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Sorry the VRM you entered has not been found, please check and try again, or use the search tree." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                        alert = nil;
                        
                        
                    }
                    
                    else if ([[dicResponse objectForKey:@"errorStringField"] rangeOfString:@"No Vehicles"].location != NSNotFound){
                        
                        [SVProgressHUD dismiss];
                        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"This vehicle cannot be valued. This may be because the vehicle is too new to have a used valuation available or is a rare or exotic model. We apologise for any inconvenience this has caused." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                        alert = nil;
                        
                        
                    }
                    else if ([[dicResponse objectForKey:@"errorStringField"] rangeOfString:@"No Values"].location != NSNotFound){
                        
                        [SVProgressHUD dismiss];
                        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"This vehicle cannot be valued. This may be because the vehicle is too new to have a used valuation available or is a rare or exotic model. We apologise for any inconvenience this has caused." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                        alert = nil;
                        
                        
                    }
                    else if ([[dicResponse objectForKey:@"errorStringField"] rangeOfString:@"VRM wrong length"].location != NSNotFound){
                        
                        [SVProgressHUD dismiss];
                        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Sorry the VRM you entered has not been found, please check and try again, or use the search tree." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                        alert = nil;
                        
                        
                    }
                    
                    else{
                        
                        [SVProgressHUD dismiss];
                        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                        
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Sorry the VRM you entered has not been found, please check and try again, or use the search tree." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                        alert = nil;
                        
                        
                    }
                    
                }
                else{
                    
                    /*****No Result Found*****/
                    NSDictionary *flurryParams =
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"WS-P-GetVRMValuation", @"ErrorLocation", 
                     @"No Result Found", @"Error",
                     nil];
                    if(appDel.isFlurryOn)
                    {
                        //[Flurry logEvent:@"GetVRMValuation - Error" withParameters:flurryParams];
                        NSError *error;
                        error = [NSError errorWithDomain:@"WS-P-GetVRMValuation - No Result Found" code:200 userInfo:flurryParams];
                        [Flurry logError:@"WS-P-GetVRMValuation - No Result Found"   message:@"WS-P-GetVRMValuation - No Result Found"  error:error];//m2806
                        
                    }
                    /*****No Result Found*****/
                    
                    [Flurry endTimedEvent:@"WS-P-GetVRMValuation" withParameters:nil];
                    [SVProgressHUD dismiss];
                    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:[NSString stringWithFormat:@"%@ %@.",ErrorInResponse,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:
                                          nil];
                    [alert show];
                    alert = nil;
                    
                }
                
                
            }
            else{
                /*****Server Error*****/
                NSDictionary *flurryParams =
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"WS-P-GetVRMValuation", @"ErrorLocation", 
                 @"Server Error", @"Error",
                 nil];
                if(appDel.isFlurryOn)
                {
                    //[Flurry logEvent:@"GetVRMValuation - Error" withParameters:flurryParams];
                    NSError *error;
                    
                    error = [NSError errorWithDomain:@"WS-P-GetVRMValuation - Server Error" code:200 userInfo:flurryParams];
                    
                    [Flurry logError:@"WS-P-GetVRMValuation - Server Error"   message:@"WS-P-GetVRMValuation - Server Error"  error:error];//m2806
                    
                }
                /*****Server Error*****/
                
                [Flurry endTimedEvent:@"WS-P-GetVRMValuation" withParameters:nil];
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:[NSString stringWithFormat:@"%@ %@.",ErrorInResponse,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:
                                      nil];
                [alert show];
                alert = nil;
                
            }
            
        }
        
        @catch (NSException *exception) {
            
            /*****@catch*****/
            NSDictionary *flurryParams =
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"WS-P-GetVRMValuation", @"ErrorLocation", 
             exception.description, @"Error",
             nil];
            
            if(appDel.isFlurryOn)
            {
                
                NSError *error;
                error = [NSError errorWithDomain:@"WS-P-GetVRMValuation - Exception"  code:200 userInfo:flurryParams];
                [Flurry logError:@"WS-P-GetVRMValuation - Exception"   message:@"WS-P-GetVRMValuation - Exception"  error:error];
                
            }
            
            /*****@catch*****/
            [Flurry endTimedEvent:@"WS-P-GetVRMValuation" withParameters:nil];
            [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
            
            NSLog(@"%@",[exception description]);
            
            
        }
    }
    else{
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
        
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertError show];
        alertError = nil;
        return;
    }
    
    
}

-(void)getSpotPrice :(NSMutableDictionary *)dicResponse
{
    
    // This Method will call the Vehicle Spot Price Service and update in Vehicle table.
    
    
    if (appDel.isOnline) {
        
        @try {
            
            appDel.intValSlider = [[NSUserDefaults standardUserDefaults] floatForKey:@"Distance"];
            
            if(appDel.isFlurryOn)
            {
                
                [Flurry logEvent:@"WS-P-GetOwnVehicleSpotPrice" timed:YES];
            }
            
            
            
            [NSThread detachNewThreadSelector:@selector(showProgressWith:) toTarget:self withObject:@"Vehicle spot price"];
            
            //{"ClientCode":"********","AccountName":"********","Password":"********","ISOCountryCode":"GB","ISOCurrencyCode":"GBP","ISOLanguageCode":"EN", "DataOrigin":"OwnVehicle", "Mileage":"10000", "NatCode":"106946001", "RegionID":"1", "RegistrationDate":"2011-01-20", "PostCode":"RH11"}
            
            NSMutableDictionary *dicUpdated = [dicResponse mutableCopy];
            NSMutableDictionary *DictRequest = [[NSMutableDictionary alloc] init];
            
            if (appDel.isTestMode) {
                
                [DictRequest setObject:Proxy_WS_ClientCode forKey:@"ClientCode"];
                [DictRequest setObject:Proxy_WS_AccountName forKey:@"AccountName"];
                [DictRequest setObject:Proxy_WS_Password forKey:@"Password"];
                
            }
            
            else{
                
                [DictRequest setObject:Proxy_WS_ClientCode_LIVE forKey:@"ClientCode"];
                [DictRequest setObject:Proxy_WS_AccountName_LIVE forKey:@"AccountName"];
                [DictRequest setObject:Proxy_WS_Password_LIVE forKey:@"Password"];
                
            }
            [DictRequest setObject:@"GB" forKey:@"ISOCountryCode"];
            [DictRequest setObject:@"GBP" forKey:@"ISOCurrencyCode"];
            [DictRequest setObject:@"EN" forKey:@"ISOLanguageCode"];
            [DictRequest setObject:[dicResponse objectForKey:@"RegistrationDate"] forKey:@"RegistrationDate"];
            [DictRequest setObject:[dicResponse objectForKey:@"Mileage"] forKey:@"Mileage"];
            [DictRequest setObject:[dicResponse objectForKey:@"GlassCarCode"] forKey:@"NatCode"];
            
            [DictRequest setObject:@"OwnVehicle" forKey:@"DataOrigin"];
            [DictRequest setObject:@"-1" forKey:@"RegionID"];
            
            if ([appDel.strLastPostCode length] > 0) {
                
                [DictRequest setObject:appDel.strLastPostCode forKey:@"PostCode"];
                
            }
            else
                [DictRequest setObject:@"0" forKey:@"PostCode"];
            
            
            // [DictRequest setObject:@"RH11" forKey:@"PostCode"];
            //[DictRequest setObject:@"KT16 9TU" forKey:@"PostCode"];
            
            NSMutableDictionary *dicPriceResponse;
            if (appDel.isTestMode) {
                
                dicPriceResponse = [objWebServicesjson callJsonAPI:GetOwnVehicleSpotPrice_URL withDictionary:DictRequest];
                
            }
            else{
                
                dicPriceResponse = [objWebServicesjson callJsonAPI:GetOwnVehicleSpotPrice_URL_LIVE withDictionary:DictRequest];
                
            }
            
            
            
            if (dicPriceResponse) {
                
                if ([dicPriceResponse count]> 0) {
                    
                    [Flurry endTimedEvent:@"WS-P-GetOwnVehicleSpotPrice" withParameters:nil];
                    
                    if (![[dicPriceResponse objectForKey:@"spotPriceDetailField"] isKindOfClass:[NSNull class]]) {
                        
                        NSDictionary *dic = [dicPriceResponse objectForKey:@"spotPriceDetailField"];
                        
                        if (![[dic objectForKey:@"standardVehicleField"] isKindOfClass:[NSNull class]]) {
                            
                            int spotPrice = 0;
                            
                            if (![[[dic objectForKey:@"standardVehicleField"] objectForKey:@"nationalAskingPriceField"] isKindOfClass:[NSNull class]]) {
                                
                                spotPrice = [[[[dic objectForKey:@"standardVehicleField"] objectForKey:@"nationalAskingPriceField"] objectForKey:@"valueField"] intValue];
                                
                                if (![[dic objectForKey:@"correctionField"] isKindOfClass:[NSNull class]]) {
                                    
                                    int ageField = [[[dic objectForKey:@"correctionField"] objectForKey:@"ageEffectField"] intValue];
                                    int FimileageEffectFieldeld = [[[dic objectForKey:@"correctionField"] objectForKey:@"mileageEffectField"] intValue];
                                    int regionalEffectField = [[[dic objectForKey:@"correctionField"] objectForKey:@"regionalEffectField"] intValue];
                                    
                                    if ([[dicResponse objectForKey:@"OriginalMileage"] isEqualToString:@"0"]) {
                                        
                                        // Average Mileage
                                        
                                        spotPrice += ageField +  regionalEffectField;
                                    }
                                    else{
                                    
                                    
                                        // Mileage
                                        
                                        spotPrice += ageField + FimileageEffectFieldeld + regionalEffectField;
                                        
                                        
                                    }
                                    
                                }
                                
                                NSString *value = [NSString stringWithFormat:@"%d",spotPrice];
                                
                                [dicUpdated setObject:value forKey:@"SpotPrice"];
                                
                                NSString *strCustomPostCode = @"";
                                
                                if (appDel.strLastPostCode.length > 0) {
                                    
                                    strCustomPostCode = appDel.strLastPostCode;
                                }
                                else{
                                    
                                    strCustomPostCode = @"";
                                }
                                
                                if (value.length > 0) {
                                    
                                    NSString *strUpdate = [NSString stringWithFormat:@"Update tblVehicle set SpotPrice = '%@' where GlassCarCode = '%@'",value,[dicResponse objectForKey:@"GlassCarCode"]];
                                    
                                    [objSKDatabase updateSQL:strUpdate forTable:@""];
                                    
                                }
                            }
                            
                            
                        }
                        
                        [self setStatus:DoneSpotPrice];
                        
                    }
                    else{
                        
                        [SVProgressHUD dismiss];
                        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                        
                        
                        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message: [NSString stringWithFormat:@"%@ %@.",ErrorConnection,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertError show];
                        alertError = nil;
                        
                        
                    }
                    
                    //                    [SVProgressHUD dismiss];
                    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                    
                }
                
                else{
                    
                    /*****No Result Found*****/
                    NSDictionary *flurryParams =
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"WS-P-GetOwnVehicleSpotPrice", @"ErrorLocation", 
                     @"No Result Found", @"Error",
                     nil];
                    if(appDel.isFlurryOn)
                    {
                        //[Flurry logEvent:@"GetOwnVehicleSpotPrice- Error" withParameters:flurryParams];
                        NSError *error;
                        error = [NSError errorWithDomain:@"WS-P-GetOwnVehicleSpotPrice - No Result Found" code:200 userInfo:flurryParams];
                        
                        [Flurry logError:@"WS-P-GetOwnVehicleSpotPrice - No Result Found"   message:@"WS-P-GetOwnVehicleSpotPrice - No Result Found"  error:error];//m2806
                    }
                    /*****No Result Found*****/
                    
                    [Flurry endTimedEvent:@"WS-P-GetOwnVehicleSpotPrice" withParameters:nil];
                    [SVProgressHUD dismiss];
                    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                    
                    
                    UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message: [NSString stringWithFormat:@"%@ %@.",ErrorInResponse,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertError show];
                    alertError = nil;
                    
                }
                
            }
            else{
                
                /*****Server Error*****/
                NSDictionary *flurryParams =
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"WS-P-GetOwnVehicleSpotPrice", @"ErrorLocation", 
                 @"Server Error", @"Error",
                 nil];
                
                if(appDel.isFlurryOn)
                {
                    // [Flurry logEvent:@"GetOwnVehicleSpotPrice - Error" withParameters:flurryParams];
                    
                    NSError *error;
                    error = [NSError errorWithDomain:@"WS-P-GetOwnVehicleSpotPrice - Server Error"  code:200 userInfo:flurryParams];
                    
                    [Flurry logError:@"WS-P-GetOwnVehicleSpotPrice - Server Error"   message:@"WS-P-GetOwnVehicleSpotPrice - Server Error"  error:error];//m2806
                    
                }
                
                /*****Server Error*****/
                
                [Flurry endTimedEvent:@"WS-P-GetOwnVehicleSpotPrice" withParameters:nil];
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
                
                UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message: [NSString stringWithFormat:@"%@ %@.",ErrorInResponse,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertError show];
                alertError = nil;
                
            }
            
        }
        @catch (NSException *exception) {
            
            /*****@catch*****/
            NSDictionary *flurryParams =
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"WS-P-GetOwnVehicleSpotPrice", @"ErrorLocation", 
             exception.description, @"Error",
             nil];
            
            if(appDel.isFlurryOn)
            {
                //[Flurry logEvent:@"GetOwnVehicleSpotPrice" withParameters:flurryParams];
                NSError *error;
                error = [NSError errorWithDomain:@"WS-P-GetOwnVehicleSpotPrice - Exception" code:200 userInfo:flurryParams];
                
                [Flurry logError:@"WS-P-GetOwnVehicleSpotPrice - Exception"   message:@"WS-P-GetOwnVehicleSpotPrice - Exception"  error:error];//m2806
            }
            
            
            /*****@catch*****/
            [Flurry endTimedEvent:@"WS-P-GetOwnVehicleSpotPrice" withParameters:nil];
            [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
            
            NSLog(@"%@",[exception description]);
        }
    }
    else{
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
        
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertError show];
        alertError = nil;
        return;
    }
    
    
}

-(void)getAverageSellingTime :(NSMutableDictionary *)dicResponse
{
    
    
    // This Method will call the Average Selling Time and update in Vehicle table.
    
    if (appDel.isOnline) {
        
        @try {
            
            if(appDel.isFlurryOn)
            {
                
                [Flurry logEvent:@"WS-P-GetAverageSellingTime" timed:YES];
            }
            
            [NSThread detachNewThreadSelector:@selector(showProgressWith:) toTarget:self withObject:@"Average selling time"];
            
            
            NSMutableDictionary *dicUpdated = [dicResponse mutableCopy];
            NSMutableDictionary *DictRequest = [[NSMutableDictionary alloc] init];
            
            if (appDel.isTestMode) {
                
                [DictRequest setObject:Proxy_WS_ClientCode forKey:@"ClientCode"];
                [DictRequest setObject:Proxy_WS_AccountName forKey:@"AccountName"];
                [DictRequest setObject:Proxy_WS_Password forKey:@"Password"];
                
            }
            
            else{
                
                [DictRequest setObject:Proxy_WS_ClientCode_LIVE forKey:@"ClientCode"];
                [DictRequest setObject:Proxy_WS_AccountName_LIVE forKey:@"AccountName"];
                [DictRequest setObject:Proxy_WS_Password_LIVE forKey:@"Password"];
                
            }
            
            [DictRequest setObject:@"GB" forKey:@"ISOCountryCode"];
            [DictRequest setObject:@"GBP" forKey:@"ISOCurrencyCode"];
            [DictRequest setObject:@"EN" forKey:@"ISOLanguageCode"];
            [DictRequest setObject:[dicResponse objectForKey:@"Mileage"] forKey:@"Mileage"];
            [DictRequest setObject:[dicResponse objectForKey:@"GlassCarCode"] forKey:@"NatCode"];
            
            if ([appDel.strLastPostCode length] > 0) {
                
                [DictRequest setObject:appDel.strLastPostCode forKey:@"PostCode"];
                
            }
            else
                [DictRequest setObject:@"0" forKey:@"PostCode"];
            
            
            
            [DictRequest setObject:[dicResponse objectForKey:@"RegistrationDate"] forKey:@"RegistrationDate"];
            
            NSMutableDictionary *dicPriceResponse;
            if (appDel.isTestMode) {
                
                dicPriceResponse = [objWebServicesjson callJsonAPI:GetAverageSellingTime_URL withDictionary:DictRequest];
                
            }
            else{
                
                dicPriceResponse = [objWebServicesjson callJsonAPI:GetAverageSellingTime_URL_LIVE withDictionary:DictRequest];
                
            }
            
            
            
            if (dicPriceResponse) {
                
                if ([dicPriceResponse count]> 0) {
                    
                    [Flurry endTimedEvent:@"WS-P-GetAverageSellingTime" withParameters:nil];
                    
                    if (![[dicPriceResponse objectForKey:@"sellingTimeField"] isKindOfClass:[NSNull class]]) {
                        
                        NSMutableDictionary *dic1 = [dicPriceResponse objectForKey:@"sellingTimeField"];
                        NSString *strAverage = [NSString stringWithFormat:@"%d",[[dic1 objectForKey:@"averageSellingTimeField"] intValue]] ;
                        NSString *sellingTimeCategory = [NSString stringWithFormat:@"%d",[[dic1 objectForKey:@"categoryCodeField"] intValue]] ;
                        
                        [dicUpdated setObject:strAverage forKey:@"avgSellingTime"];
                        [dicUpdated setObject:sellingTimeCategory forKey:@"sellingTimeCategory"];
                        
                        NSString *strUpdate = [NSString stringWithFormat:@"Update tblVehicle set avgSellingTime = '%@' , sellingTimeCategory = '%@' where GlassCarCode = '%@'",strAverage,sellingTimeCategory,[dicResponse objectForKey:@"GlassCarCode"]];
                        
                        [objSKDatabase updateSQL:strUpdate forTable:@""];
                        
                        [self setStatus:DoneAverageSellingTime];
                        
                        
                    }
                    
                    
                    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                    
                }
                
                else{
                    
                    /*****No Result Found*****/
                    NSDictionary *flurryParams =
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"WS-P-GetAverageSellingTime", @"ErrorLocation", 
                     @"No Result Found", @"Error",
                     nil];
                    if(appDel.isFlurryOn)
                    {
                        NSError *error;
                        error = [NSError errorWithDomain:@"WS-P-GetAverageSellingTime - No Result Found" code:200 userInfo:flurryParams];
                        
                        [Flurry logError:@"WS-P-GetAverageSellingTime - No Result Found"   message:@"WS-P-GetAverageSellingTime - No Result Found"  error:error];//m2806
                    }
                    /*****No Result Found*****/
                    
                    
                    [Flurry endTimedEvent:@"WS-P-GetAverageSellingTime" withParameters:nil];
                    
                    [SVProgressHUD dismiss];
                    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                    
                    
                    UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message: [NSString stringWithFormat:@"%@ %@.",ErrorInResponse,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertError show];
                    alertError = nil;
                    
                    
                }
                
            }
            else{
                
                /*****Server Error*****/
                NSDictionary *flurryParams =
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"WS-P-GetAverageSellingTime", @"ErrorLocation", 
                 @"Server Error", @"Error",
                 nil];
                if(appDel.isFlurryOn)
                {
                    
                    NSError *error;
                    error = [NSError errorWithDomain:@"WS-P-GetAverageSellingTime - Server Error" code:200 userInfo:flurryParams];
                    [Flurry logError:@"WS-P-GetAverageSellingTime - Server Error"   message:@"WS-P-GetAverageSellingTime - Server Error" error:error];//m2806
                    
                }
                /*****Server Error*****/
                
                [Flurry endTimedEvent:@"WS-P-GetAverageSellingTime" withParameters:nil];
                
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
            }
            
        }
        @catch (NSException *exception) {
            
            /*****@catch*****/
            NSDictionary *flurryParams =
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"WS-P-GetAverageSellingTime", @"ErrorLocation", 
             exception.description, @"Error",
             nil];
            
            
            if(appDel.isFlurryOn)
            {
                //[Flurry logEvent:@"GetOwnVehicleSpotPrice" withParameters:flurryParams];
                NSError *error;
                error = [NSError errorWithDomain:@"WS-P-GetAverageSellingTime - Exception" code:200 userInfo:flurryParams];
                
                [Flurry logError:@"WS-P-GetAverageSellingTime - Exception"   message:@"WS-P-GetAverageSellingTime - Exception"  error:error];//m2806
            }
            
            
            /*****@catch*****/
            [Flurry endTimedEvent:@"WS-P-GetAverageSellingTime" withParameters:nil];
            
            [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
            
            NSLog(@"%@",[exception description]);
        }
    }    else{
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
        
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertError show];
        alertError = nil;
        return;
    }
    
}

-(void)listSimilarAdvertisements :(NSMutableDictionary *)dicData
{
    
    
    // This will be called after the AverageSellingTime Service call made, will get list similarAdverts and store in database.
    
    if (appDel.isOnline) {
        
        @try {
            
            if(appDel.isFlurryOn)
            {
                
                [Flurry logEvent:@"WS-P-ListSimilarAdvertisements" timed:YES];
            }
            
            
            [NSThread detachNewThreadSelector:@selector(showProgressWith:) toTarget:self withObject:@"Similar live advertisements"];
            NSMutableDictionary *DictRequest = [[NSMutableDictionary alloc] init];
            
            if (appDel.isTestMode) {
                
                [DictRequest setObject:Proxy_WS_ClientCode forKey:@"ClientCode"];
                [DictRequest setObject:Proxy_WS_AccountName forKey:@"AccountName"];
                [DictRequest setObject:Proxy_WS_Password forKey:@"Password"];
                
            }
            
            else{
                
                [DictRequest setObject:Proxy_WS_ClientCode_LIVE forKey:@"ClientCode"];
                [DictRequest setObject:Proxy_WS_AccountName_LIVE forKey:@"AccountName"];
                [DictRequest setObject:Proxy_WS_Password_LIVE forKey:@"Password"];
                
            }
            [DictRequest setObject:@"GB" forKey:@"ISOCountryCode"];
            [DictRequest setObject:@"GBP" forKey:@"ISOCurrencyCode"];
            [DictRequest setObject:@"EN" forKey:@"ISOLanguageCode"];
            
            [DictRequest setObject:[dicData objectForKey:@"Mileage"] forKey:@"Mileage"];
            [DictRequest setObject:[dicData objectForKey:@"GlassCarCode"] forKey:@"NatCode"];
            
            if ([appDel.strLastPostCode length] > 0) {
                
                [DictRequest setObject:appDel.strLastPostCode forKey:@"PostCode"];
            }
            else
                [DictRequest setObject:@"0" forKey:@"PostCode"];
            
            [DictRequest setObject:[dicData objectForKey:@"SpotPrice"] forKey:@"AskingPrice"];
            [DictRequest setObject:[dicData objectForKey:@"RegistrationDate"] forKey:@"RegistrationDate"];
            
            strGlassCarCode = [dicData objectForKey:@"GlassCarCode"];
            
            float value;
            if (appDel.intValSlider == 0.0) {
                
                value = 50;
            }
            else if (appDel.intValSlider == 0.25){
                
                value = 100;
            }
            else if (appDel.intValSlider == 0.50){
                
                value = 200;
            }
            else{
                
                value = 999;
                
            }
            
            [DictRequest setObject:[NSString stringWithFormat:@"%f",value] forKey:@"SearchRadius"];
            [DictRequest setObject:@"21" forKey:@"ShowHits"];
            
            [NSThread detachNewThreadSelector:@selector(showProgressWith:) toTarget:self withObject:@"Similar live advertisements"];
            
            NSMutableDictionary *dicResponse;
            if (appDel.isTestMode) {
                
                dicResponse = [objWebServicesjson callJsonAPI:listSimilarAdvertisements_URL withDictionary:DictRequest];
                
            }
            else{
                
                dicResponse = [objWebServicesjson callJsonAPI:listSimilarAdvertisements_URL_LIVE withDictionary:DictRequest];
                
            }
            
            if (dicResponse) {
                
                if ([dicResponse count]> 0) {
                    
                    [Flurry endTimedEvent:@"WS-P-ListSimilarAdvertisements" withParameters:nil];
                    
                    int errorCode = [[dicResponse objectForKey:@"errorCodeField"] intValue];
                    int vRMErrorCodeField = [[dicResponse objectForKey:@"vRMErrorCodeField"] intValue];
                    
                    
                    if (errorCode == 0 && vRMErrorCodeField == 0) {
                        
                        NSMutableArray *arrAllData = [[NSMutableArray alloc] init];
                        arrAllData = [dicResponse objectForKey:@"advertisementsField"];
                        
                        if ([arrAllData count] > 0) {
                            
                            [objSKDatabase deleteWhereAllRecord:@"tblOnSale"];
                            
                            [self grabAndStoreVehicleDetail:arrAllData forTable:@"tblOnSale"];
                            
                            [self setStatus:DoneOnSale];
                        }
                        
                    }
                    else{
                        
                        [Flurry endTimedEvent:@"WS-P-ListSimilarAdvertisements" withParameters:nil];
                        
                        [SVProgressHUD dismiss];
                        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                        
                        NSString *Str = [NSString stringWithFormat:@"GBvRMErrorCodeField%d",vRMErrorCodeField];
                        NSString *strErrorMsg = NSLocalizedString(Str,@"");
                        
                        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",strErrorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertError show];
                        alertError = nil;
                    }
                    
                }
                else{
                    
                    /*****No Result Found*****/
                    NSDictionary *flurryParams =
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"WS-P-ListSimilarAdvertisements", @"ErrorLocation", 
                     @"No Result Found", @"Error",
                     nil];
                    
                    if(appDel.isFlurryOn)
                    {
                        
                        NSError *error;
                        
                        error = [NSError errorWithDomain:@"WS-P-ListSimilarAdvertisements - No Result Found" code:200 userInfo:flurryParams];
                        
                        [Flurry logError:@"WS-P-ListSimilarAdvertisements - No Result Found"   message:@"WS-P-ListSimilarAdvertisements - No Result Found"  error:error];
                        
                    }
                    /*****No Result Found*****/
                    
                    [Flurry endTimedEvent:@"WS-P-ListSimilarAdvertisements" withParameters:nil];
                    [SVProgressHUD dismiss];
                    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                    
                    
                    UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message: [NSString stringWithFormat:@"%@ %@.",ErrorInResponse,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertError show];
                    alertError = nil;
                    
                }
                
            }
            
            else{
                /*****Server Error*****/
                NSDictionary *flurryParams =
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"WS-P-ListSimilarAdvertisements", @"ErrorLocation", 
                 @"Server Error", @"Error",
                 nil];
                if(appDel.isFlurryOn)
                {
                    NSError *error;
                    
                    error = [NSError errorWithDomain:@"WS-P-ListSimilarAdvertisements - Server Error" code:200 userInfo:flurryParams];
                    
                    [Flurry logError:@"WS-P-ListSimilarAdvertisements - Server Error"   message:@"WS-P-ListSimilarAdvertisements - Server Error"  error:error];//m2806
                    
                }
                /*****Server Error*****/
                
                [Flurry endTimedEvent:@"WS-P-ListSimilarAdvertisements" withParameters:nil];
                
                [SVProgressHUD dismiss];
                
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
                
                UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message: [NSString stringWithFormat:@"%@ %@.",ErrorInResponse,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertError show];
                alertError = nil;
                
            }
            
            
        }
        @catch (NSException *exception) {
            
            /*****@catch*****/
            NSDictionary *flurryParams =
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"WS-P-ListSimilarAdvertisements", @"ErrorLocation", 
             exception.description, @"Error",
             nil];
            
            if(appDel.isFlurryOn)
            {
                //[Flurry logEvent:@"GetOwnVehicleSpotPrice" withParameters:flurryParams];
                NSError *error;
                error = [NSError errorWithDomain:@"WS-P-ListSimilarAdvertisements - Exception" code:200 userInfo:flurryParams];
                
                [Flurry logError:@"WS-P-ListSimilarAdvertisements - Exception"   message:@"WS-P-ListSimilarAdvertisements - Exception"  error:error];//m2806
            }
            
            
            /*****@catch*****/
            
            [Flurry endTimedEvent:@"WS-P-ListSimilarAdvertisements" withParameters:nil];
            [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
            
            NSLog(@"exception :- %@", exception);
            
        }
        @finally {
            
        }
        
    }
    else{
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
        
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertError show];
        alertError = nil;
        return;
    }
    
    
}

-(void)grabAndStoreVehicleDetail : (NSMutableArray *) arrAllData forTable : (NSString *)strTableName{
    
    // This will used to store On sale and sold vehicle detail in database.
    
    
    
    
    NSMutableArray *arrAdvertisements;
    
    @try {
        
        if ([arrAllData count] > 0) {
            
            arrAdvertisements = [[NSMutableArray alloc] init];
            int counterVeryHigh = 0;
            int counterHigh = 0;
            int counterMed = 0;
            
            
            
            for (int i = 0; i < [arrAllData count]; i++) {
                
                NSMutableDictionary *dicVehicleDetail = [[NSMutableDictionary alloc] init];
                
                if (![[[arrAllData objectAtIndex:i] objectForKey:@"vehicleField"] isKindOfClass:[NSNull class]] ) {
                    
                    NSDictionary *dicTemp = [[arrAllData objectAtIndex:i] objectForKey:@"vehicleField"];
                    
                    if (![[dicTemp objectForKey:@"vehicleIDField"]  isKindOfClass:[NSNull class]]) {
                        
                        NSString *strkey = [NSString stringWithFormat:@"%d",[[dicTemp objectForKey:@"vehicleIDField"] intValue]];
                        
                        [dicVehicleDetail setObject:strkey forKey:@"vehicleId"];
                        
                    }
                    else{
                        
                        [dicVehicleDetail setObject:@"" forKey:@"vehicleId"];
                    }
                    
                    
                    if (![[dicTemp objectForKey:@"iDDField"]  isKindOfClass:[NSNull class]]) {
                        
                        NSString *strkey = [[dicTemp objectForKey:@"iDDField"] objectForKey:@"typeField"];
                        
                        [dicVehicleDetail setObject:strkey forKey:@"typeDesc"];
                        
                    }
                    else{
                        
                        [dicVehicleDetail setObject:@"" forKey:@"typeDesc"];
                    }
                    
                    if (![[dicTemp objectForKey:@"iDDField"]  isKindOfClass:[NSNull class]]) {
                        
                        NSString *strkey = [[dicTemp objectForKey:@"iDDField"] objectForKey:@"typeDescriptionField"];
                        
                        [dicVehicleDetail setObject:strkey forKey:@"originalTypeDesc"];
                        
                    }
                    else{
                        
                        [dicVehicleDetail setObject:@"" forKey:@"originalTypeDesc"];
                    }
                    
                    if (![[dicTemp objectForKey:@"iDDField"]  isKindOfClass:[NSNull class]]) {
                        
                        NSString *strkey = [[dicTemp objectForKey:@"iDDField"] objectForKey:@"makeField"];
                        
                        [dicVehicleDetail setObject:strkey forKey:@"Make"];
                        
                    }
                    else{
                        
                        [dicVehicleDetail setObject:@"" forKey:@"Make"];
                    }
                    
                    
                    if (![[dicTemp objectForKey:@"iDDField"]  isKindOfClass:[NSNull class]]) {
                        
                        NSString *strkey = [[dicTemp objectForKey:@"iDDField"] objectForKey:@"modelField"];
                        
                        [dicVehicleDetail setObject:strkey forKey:@"Model"];
                        
                    }
                    else{
                        
                        [dicVehicleDetail setObject:@"" forKey:@"Model"];
                    }
                    
                    
                    
                    
                    if (![[dicTemp objectForKey:@"similarityField"]  isKindOfClass:[NSNull class]]) {
                        
                        NSString *strkey = [NSString stringWithFormat:@"%d",[[[dicTemp objectForKey:@"similarityField"] objectForKey:@"codeField"] intValue]];
                        
                        int code = [[[dicTemp objectForKey:@"similarityField"] objectForKey:@"codeField"] intValue];
                        if (code == 1) {
                            
                            // very High
                            counterVeryHigh++;
                            
                        }
                        else if (code == 2){
                            
                            counterHigh++;
                            
                        }
                        else if (code == 3){
                            
                            counterMed++;
                        }
                        
                        [dicVehicleDetail setObject:strkey forKey:@"similarityCategory"];
                        
                    }
                    else{
                        
                        [dicVehicleDetail setObject:@"" forKey:@"similarityCategory"];
                    }
                    
                    if (![[dicTemp objectForKey:@"descriptionField"]  isKindOfClass:[NSNull class]]) {
                        
                        [dicVehicleDetail setObject:[[[arrAllData objectAtIndex:i] objectForKey:@"vehicleField"] objectForKey:@"descriptionField"] forKey:@"title"];
                        
                    }
                    else{
                        
                        [dicVehicleDetail setObject:@"" forKey:@"title"];
                    }
                    if (![[dicTemp objectForKey:@"registrationField"] isKindOfClass:[NSNull class]]) {
                        
                        if ([[[[arrAllData objectAtIndex:i] objectForKey:@"vehicleField"] objectForKey:@"registrationField"] objectForKey:@"dateField"]) {
                            
                            NSString *strDate = [[[[arrAllData objectAtIndex:i] objectForKey:@"vehicleField"] objectForKey:@"registrationField"] objectForKey:@"dateField"];
                            
                            
                            NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
                            [_formatter setDateFormat:@"YYYY-MM-dd"];
                            NSDate *date = [_formatter dateFromString:strDate];
                            
                            NSDateFormatter *_formatter1=[[NSDateFormatter alloc]init];
                            [_formatter1 setDateFormat:@"dd-MM-YYYY"];
                            NSString *_date=[_formatter1 stringFromDate:date];
                            
                            [dicVehicleDetail setObject:_date forKey:@"regDate"];
                            
                            
                        }
                        
                    }
                    else{
                        
                        [dicVehicleDetail setObject:@"" forKey:@"regDate"];
                    }
                    
                    if (![[dicTemp objectForKey:@"askingPriceField"] isKindOfClass:[NSNull class]]) {
                        
                        NSDictionary *dicAsk = [[[arrAllData objectAtIndex:i] objectForKey:@"vehicleField"] objectForKey:@"askingPriceField"];
                        if ([dicAsk count] > 0) {
                            
                            [dicVehicleDetail setObject:[NSString stringWithFormat:@"%d",[[dicAsk objectForKey:@"valueField"] intValue]] forKey:@"askingPrice"];
                        }
                    }
                    else{
                        
                        [dicVehicleDetail setObject:@"" forKey:@"askingPrice"];
                    }
                    
                    if (![[dicTemp objectForKey:@"autovistaAskingPriceField"] isKindOfClass:[NSNull class]]) {
                        
                        NSDictionary *dicSpot = [[[arrAllData objectAtIndex:i] objectForKey:@"vehicleField"] objectForKey:@"autovistaAskingPriceField"];
                        
                        if ([dicSpot count] > 0) {
                            
                            if (![[[arrAllData objectAtIndex:i] objectForKey:@"dataOriginField"]  isKindOfClass:[NSNull class]]) {
                                
                                NSString *strkey = [NSString stringWithFormat:@"%@",[[arrAllData objectAtIndex:i] objectForKey:@"dataOriginField"]];
                                
                                if ([strkey isEqualToString:@"OwnVehicle"]) {
                                    
                                    
                                    NSDictionary *dicAsk = [[[arrAllData objectAtIndex:i] objectForKey:@"vehicleField"] objectForKey:@"askingPriceField"];
                                    
                                    [dicVehicleDetail setObject:[NSString stringWithFormat:@"%d",[[dicAsk objectForKey:@"valueField"] intValue]] forKey:@"spotPrice"];
                                    
                                    
                                    
                                    
                                }
                                else{
                                    
                                    [dicVehicleDetail setObject:[NSString stringWithFormat:@"%d",[[dicSpot objectForKey:@"valueField"] intValue]] forKey:@"spotPrice"];
                                    
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    else{
                        
                        [dicVehicleDetail setObject:@"" forKey:@"spotPrice"];
                    }
                    
                    if ([dicVehicleDetail objectForKey:@"spotPrice"] && [dicVehicleDetail objectForKey:@"askingPrice"]) {
                        
                        int diff = [[dicVehicleDetail objectForKey:@"askingPrice"] intValue] - [[dicVehicleDetail objectForKey:@"spotPrice"] intValue];
                        
                        [dicVehicleDetail setObject:[NSString stringWithFormat:@"%d",diff] forKey:@"Difference"];
                        
                        
                    }
                    else{
                        
                        [dicVehicleDetail setObject:@"0" forKey:@"Difference"];
                    }
                    
                    
                    
                    //mileageField
                    
                    if (![[[arrAllData objectAtIndex:i] objectForKey:@"dataOriginField"]  isKindOfClass:[NSNull class]]) {
                        
                        NSString *strkey = [NSString stringWithFormat:@"%@",[[arrAllData objectAtIndex:i] objectForKey:@"dataOriginField"]];
                        
                        if (strkey.length > 0 && [strkey isEqualToString:@"OwnVehicle"] && [appDel.strMileageLocal isEqualToString:@"0"]) {
                            
                            NSString *strMileage = [objSKDatabase lookupColForSQL:[NSString stringWithFormat:@"select AverageMileage from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
                            
                            [dicVehicleDetail setObject:strMileage forKey:@"mileage"];
                            
                        }
                        else{
                            
                            if (![[dicTemp objectForKey:@"mileageField"] isKindOfClass:[NSNull class]]) {
                                
                                NSString *strMileage = [NSString stringWithFormat:@"%d",[[[dicTemp objectForKey:@"mileageField"] objectForKey:@"valueField"] intValue]];
                                
                                
                                [dicVehicleDetail setObject:strMileage forKey:@"mileage"];
                                
                            }
                            
                            else{
                                
                                [dicVehicleDetail setObject:@"" forKey:@"mileage"];
                            }
                        }
                        
                    }
                    
                }
                
                if (![[[arrAllData objectAtIndex:i] objectForKey:@"locationField"]  isKindOfClass:[NSNull class]]) {
                    
                    NSDictionary *dicTemp = [[arrAllData objectAtIndex:i] objectForKey:@"locationField"];
                    if ((![[dicTemp objectForKey:@"regionIDField"] isKindOfClass:[NSNull class]])) {
                        
                        NSString *strkey = [NSString stringWithFormat:@"%d",[[dicTemp objectForKey:@"regionIDField"] intValue]];
                        [dicVehicleDetail setObject:strkey forKey:@"regionId"];
                        
                    }
                    else{
                        
                        [dicVehicleDetail setObject:@"" forKey:@"regionId"];
                    }
                    if (![[dicTemp objectForKey:@"distanceField"] isKindOfClass:[NSNull class]]) {
                        
                        NSString *strDistance = [NSString stringWithFormat:@"%d",[[[dicTemp objectForKey:@"distanceField"] objectForKey:@"valueField"] intValue]];
                        
                        [dicVehicleDetail setObject:strDistance forKey:@"Distance"];
                        
                        
                    }
                    else{
                        
                        [dicVehicleDetail setObject:@"" forKey:@"Distance"];
                        
                    }
                    
                    
                }
                
                
                if (![[[arrAllData objectAtIndex:i] objectForKey:@"uRLField"]  isKindOfClass:[NSNull class]]) {
                    
                    NSString *strkey = [NSString stringWithFormat:@"%@",[[arrAllData objectAtIndex:i] objectForKey:@"uRLField"]];
                    [dicVehicleDetail setObject:strkey forKey:@"advertismentUrl"];
                    
                }
                else{
                    
                    [dicVehicleDetail setObject:@"" forKey:@"advertismentUrl"];
                }
                
                if (![[[arrAllData objectAtIndex:i] objectForKey:@"dataOriginField"]  isKindOfClass:[NSNull class]]) {
                    
                    NSString *strkey = [NSString stringWithFormat:@"%@",[[arrAllData objectAtIndex:i] objectForKey:@"dataOriginField"]];
                    [dicVehicleDetail setObject:strkey forKey:@"dataOrigin"];
                    
                }
                else{
                    
                    [dicVehicleDetail setObject:@"" forKey:@"dataOrigin"];
                }
                
                
                NSString *strDealer;
                NSDictionary *dicDealer = [[arrAllData objectAtIndex:i] objectForKey:@"dealerField"];
                
                if (![dicDealer isKindOfClass:[NSNull class]]) {
                    
                    if (![[dicDealer objectForKey:@"organizationField"] isKindOfClass:[NSNull class]]) {
                        
                        strDealer = [[[dicDealer objectForKey:@"organizationField" ] objectForKey:@"companyNameField"] objectForKey:@"valueField"];
                        
                        [dicVehicleDetail setObject:strDealer forKey:@"dealerName"];
                        
                    }
                }
                else{
                    
                    [dicVehicleDetail setObject:@"" forKey:@"dealerName"];
                    
                }
                
                if (![[[arrAllData objectAtIndex:i] objectForKey:@"advertisementDaysField"] isKindOfClass:[NSNull class]]) {
                    
                    [dicVehicleDetail setObject:[NSString stringWithFormat:@"%d",[[[arrAllData objectAtIndex:i] objectForKey:@"advertisementDaysField"] intValue]] forKey:@"stockDays"];
                    
                }
                else{
                    
                    [dicVehicleDetail setObject:@"" forKey:@"stockDays"];
                    
                }
                
                //depublishedField
                
                if (![[[arrAllData objectAtIndex:i] objectForKey:@"depublishedField"] isKindOfClass:[NSNull class]]) {
                    
                    [dicVehicleDetail setObject:[[arrAllData objectAtIndex:i] objectForKey:@"depublishedField"] forKey:@"dateAdRemoved"];
                    
                    
                }
                else{
                    
                    [dicVehicleDetail setObject:@"" forKey:@"dateAdRemoved"];
                    
                }
                
                [dicVehicleDetail setObject:[NSString stringWithFormat:@"%f",appDel.intValSlider] forKey:@"SearchRadius"];
                
                [dicVehicleDetail setObject:strGlassCarCode forKey:@"GlassCarCode"];
                
                if ([strTableName isEqualToString:@"tblOnSold"]) {
                    
                    [dicVehicleDetail setObject:@"false" forKey:@"OnSoldPriceHistory"];
                }
                else{
                    
                    [dicVehicleDetail setObject:@"false" forKey:@"OnSalePriceHistory"];
                    
                }
                
                
                
                [objSKDatabase insertDictionary:dicVehicleDetail forTable:strTableName];
                
                //                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
            }
            
            
        }
        else
        {
            
            
        }
        
    }
    @catch (NSException *exception) {
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        NSLog(@"exception :- %@",exception);
    }
    @finally {
        
    }
    
    
}

-(void) GetPriceHistory :(NSMutableDictionary *) dicVehicleDetail ForTable : (NSString *) strTableName {
    
    
    
    
    // This will be called once the user visit the On Sale or Sold page
    // IT will fetch the Price history for (strTableName) of each record if not available
    //Will store detail in databas.
    
    @try {
        
        if(appDel.isFlurryOn)
        {
            
            [Flurry logEvent:@"WS-P-GetListPrice" timed:YES];
        }
        
        
        
        if (![[dicVehicleDetail objectForKey:@"similarityCategory"] isEqualToString:@"0"]) {
            
            NSMutableDictionary *DictRequest = [[NSMutableDictionary alloc] init];
            
            NSString *strDataOrigin;
            if ([strTableName isEqualToString:@"tblOnSale"]) {
                
                strDataOrigin = @"Vehicle";
            }
            else{
                
                strDataOrigin = @"VehicleDeleted";
            }
            
            
            if (appDel.isTestMode) {
                
                [DictRequest setObject:Proxy_WS_ClientCode forKey:@"ClientCode"];
                [DictRequest setObject:Proxy_WS_AccountName forKey:@"AccountName"];
                [DictRequest setObject:Proxy_WS_Password forKey:@"Password"];
                
            }
            
            else{
                
                [DictRequest setObject:Proxy_WS_ClientCode_LIVE forKey:@"ClientCode"];
                [DictRequest setObject:Proxy_WS_AccountName_LIVE forKey:@"AccountName"];
                [DictRequest setObject:Proxy_WS_Password_LIVE forKey:@"Password"];
                
            }
            [DictRequest setObject:@"GB" forKey:@"ISOCountryCode"];
            [DictRequest setObject:@"GBP" forKey:@"ISOCurrencyCode"];
            [DictRequest setObject:@"EN" forKey:@"ISOLanguageCode"];
            [DictRequest setObject:strDataOrigin forKey:@"DataOrigin"];
            [DictRequest setObject:[dicVehicleDetail objectForKey:@"vehicleId"] forKey:@"VehicleID"];
            
            NSMutableDictionary *dicResponse;
            if (appDel.isTestMode) {
                
                dicResponse = [objWebServicesjson callJsonAPI:ListPriceHistory_URL withDictionary:DictRequest];
            }
            else{
                
                dicResponse = [objWebServicesjson callJsonAPI:ListPriceHistory_URL_LIVE withDictionary:DictRequest];
            }
            
            
            
            NSMutableArray *arrAllPriceData = [[NSMutableArray alloc] init];
            arrAllPriceData = [dicResponse objectForKey:@"priceHistoryField"];
            
            
            if (arrAllPriceData) {
                
                if ([arrAllPriceData count] > 0) {
                    
                    [Flurry endTimedEvent:@"WS-P-GetListPrice" withParameters:nil];
                    
                    
                    for (NSDictionary *dict in arrAllPriceData)
                    {
                        NSMutableDictionary *dicPriceHistory = [[NSMutableDictionary alloc] init];
                        
                        [dicPriceHistory setObject:[DictRequest objectForKey:@"VehicleID"] forKey:@"vehicleId"];
                        
                        if(![[dict objectForKey:@"amountField"] isKindOfClass:[NSNull class]])
                        {
                            NSString *strAmtValkey = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"amountField"] objectForKey:@"valueField"]];
                            
                            [dicPriceHistory setObject:strAmtValkey forKey:@"price"];
                            
                        }
                        if(![[dict objectForKey:@"priceHistoryField"] isKindOfClass:[NSNull class]])
                        {
                            NSString *strChangeDesckey = [NSString stringWithFormat:@"%@",[dict  objectForKey:@"changeDescriptionField"]];
                            [dicPriceHistory setObject:strChangeDesckey forKey:@"priceChangeDescription"];
                            
                        }
                        if(![[dict objectForKey:@"dateField"] isKindOfClass:[NSNull class]])
                        {
                            
                            NSString *strDatekey = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"dateField"] objectForKey:@"dateField"]];
                            
                            
                            if (strDatekey.length > 0) {
                                
                                
                                strDatekey = [appDel fetchDateFromTimestamp:strDatekey withDateFormate:@"dd-MM-YYYY"];
                            }
                            
                            
                            [dicPriceHistory setObject:strDatekey forKey:@"pricingDate"];
                            
                        }
                        
                        [dicPriceHistory setObject:appDel.strVehicleID forKey:@"GlassCarCode"];
                        [dicPriceHistory setObject:strTableName forKey:@"ForTable"];
                        [objSKDatabase insertDictionary:dicPriceHistory forTable:@"tblPriceHistory"];
                        
                        
                    }
                    
                    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                    
                    
                }
                else{
                    /*****No Result Found*****/
                    NSDictionary *flurryParams =
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"WS-P-GetListPrice", @"ErrorLocation", 
                     @"No Result Found", @"Error",
                     nil];
                    if(appDel.isFlurryOn)
                    {
                        NSError *error;
                        error = [NSError errorWithDomain:@"WS-P-GetListPrice - No Result Found" code:200 userInfo:flurryParams];
                        
                        [Flurry logError:@"WS-P-GetListPrice - No Result Found"   message:@"WS-P-GetListPrice - No Result Found"  error:error];//m2806
                        
                    }
                    
                    [Flurry endTimedEvent:@"WS-P-GetListPrice" withParameters:nil];
                    /*****No Result Found*****/
                    
                }
            }
            else{
                /*****Server Error*****/
                NSDictionary *flurryParams =
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"WS-P-GetListPrice", @"ErrorLocation", 
                 @"Server Error", @"Error",
                 nil];
                
                if(appDel.isFlurryOn)
                {
                    NSError *error;
                    error = [NSError errorWithDomain:@"WS-P-GetListPrice - Server Error" code:200 userInfo:flurryParams];
                    
                    [Flurry logError:@"WS-P-GetListPrice - Server Error"   message:@"WS-P-GetListPrice - Server Error"  error:error];//m2806
                    
                }

                
                [Flurry endTimedEvent:@"WS-P-GetListPrice" withParameters:nil];
                /*****Server Error*****/
                
            }
            
            
        }
        
        
    }
    @catch (NSException *exception) {
        
        /*****@catch*****/
        NSDictionary *flurryParams =
        [NSDictionary dictionaryWithObjectsAndKeys:
         @"WS-P-GetListPrice", @"ErrorLocation", 
         exception.description, @"Error",
         nil];
        
        
        if(appDel.isFlurryOn)
        {
            //[Flurry logEvent:@"GetOwnVehicleSpotPrice" withParameters:flurryParams];
            NSError *error;
            error = [NSError errorWithDomain:@"WS-P-GetListPrice - Exception" code:200 userInfo:flurryParams];
            
            [Flurry logError:@"WS-P-GetListPrice - Exception"   message:@"WS-P-GetListPrice - Exception"  error:error];//m2806
        }
        
        
        /*****@catch*****/
        
        [Flurry endTimedEvent:@"WS-P-GetListPrice" withParameters:nil];
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
        
        NSLog(@"Exeption :- %@" , exception);
    }
    @finally {
        
    }
    
}

-(void)listSimilarRemoveAdvertisements :(NSMutableDictionary *)dicData

{
    
    // This will be called after the On Sale Service call made, will get list similarRemoveAdverts and store in database.
    
    if (appDel.isOnline) {
        
        @try {
            
            
            if(appDel.isFlurryOn)
            {
                
                [Flurry logEvent:@"WS-P-ListSimilarRemovedAdvertisements" timed:YES];
            }
            
            [NSThread detachNewThreadSelector:@selector(showProgressWith:) toTarget:self withObject:@"Removed advertisements"];
            
            NSMutableDictionary *DictRequest = [[NSMutableDictionary alloc] init];
            
            if (appDel.isTestMode) {
                
                [DictRequest setObject:Proxy_WS_ClientCode forKey:@"ClientCode"];
                [DictRequest setObject:Proxy_WS_AccountName forKey:@"AccountName"];
                [DictRequest setObject:Proxy_WS_Password forKey:@"Password"];
                
            }
            
            else{
                
                [DictRequest setObject:Proxy_WS_ClientCode_LIVE forKey:@"ClientCode"];
                [DictRequest setObject:Proxy_WS_AccountName_LIVE forKey:@"AccountName"];
                [DictRequest setObject:Proxy_WS_Password_LIVE forKey:@"Password"];
                
            }
            [DictRequest setObject:@"GB" forKey:@"ISOCountryCode"];
            [DictRequest setObject:@"GBP" forKey:@"ISOCurrencyCode"];
            [DictRequest setObject:@"EN" forKey:@"ISOLanguageCode"];
            
            
            [DictRequest setObject:[dicData objectForKey:@"SpotPrice"] forKey:@"AskingPrice"];
            [DictRequest setObject:[dicData objectForKey:@"Mileage"] forKey:@"Mileage"];
            [DictRequest setObject:[dicData objectForKey:@"GlassCarCode"] forKey:@"NatCode"];
            [DictRequest setObject:[dicData objectForKey:@"RegistrationDate"] forKey:@"RegistrationDate"];
            
            if ([appDel.strLastPostCode length] > 0) {
                
                [DictRequest setObject:appDel.strLastPostCode forKey:@"PostCode"];
            }
            else{
                
                [DictRequest setObject:@"0" forKey:@"PostCode"];
            }
            
            
            
            strGlassCarCode = [dicData objectForKey:@"GlassCarCode"];
            
            
            int value;
            if (appDel.intValSlider == 0.0) {
                
                value = 50;
            }
            else if (appDel.intValSlider == 0.25){
                
                value = 100;
            }
            else if (appDel.intValSlider == 0.50){
                
                value = 200;
            }
            else{
                
                value = 999;
                
            }
            
            [DictRequest setObject:[NSString stringWithFormat:@"%d",value] forKey:@"SearchRadius"];
            
            
            [DictRequest setObject:@"21" forKey:@"ShowHits"];
            
            NSMutableDictionary *dicResponse;
            if (appDel.isTestMode) {
                
                dicResponse = [objWebServicesjson callJsonAPI:listSimilarRemovedAdvertisements_URL withDictionary:DictRequest];
                
            }
            else{
                
                dicResponse = [objWebServicesjson callJsonAPI:listSimilarRemovedAdvertisements_URL_LIVE withDictionary:DictRequest];
                
            }
            
            if (dicResponse) {
                
                if ([dicResponse count]> 0) {
                    
                    [Flurry endTimedEvent:@"WS-P-ListSimilarRemovedAdvertisements" withParameters:nil];
                    int errorCode = [[dicResponse objectForKey:@"errorCodeField"] intValue];
                    int vRMErrorCodeField = [[dicResponse objectForKey:@"vRMErrorCodeField"] intValue];
                    
                    
                    if (errorCode == 0 && vRMErrorCodeField == 0) {
                        
                        [Flurry endTimedEvent:@"WS-P-ListSimilarRemovedAdvertisements" withParameters:nil];
                        
                        NSMutableArray *arrAllData = [[NSMutableArray alloc] init];
                        arrAllData = [dicResponse objectForKey:@"advertisementsField"];
                        
                        [objSKDatabase deleteWhereAllRecord:@"tblOnSold"];
                        
                        [self grabAndStoreVehicleDetail:arrAllData forTable:@"tblOnSold"];
                        
                        [self setStatus:DoneOnSold];
                        
                    }
                    else{
                        
                        [Flurry endTimedEvent:@"WS-P-ListSimilarRemovedAdvertisements" withParameters:nil];
                        
                        [SVProgressHUD dismiss];
                        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                        
                        NSString *Str = [NSString stringWithFormat:@"GBvRMErrorCodeField%d",vRMErrorCodeField];
                        NSString *strErrorMsg = NSLocalizedString(Str,@"");
                        
                        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",strErrorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertError show];
                        alertError = nil;
                    }
                    
                }
                else{
                    
                    /*****No Result Found*****/
                    NSDictionary *flurryParams =
                    [NSDictionary dictionaryWithObjectsAndKeys:
                     @"WS-P-ListSimilarRemovedAdvertisements", @"ErrorLocation", 
                     @"No Result Found", @"Error",
                     nil];
                    if(appDel.isFlurryOn)
                    {
                        
                        NSError *error;
                        error = [NSError errorWithDomain:@"WS-P-ListSimilarRemovedAdvertisements - No Result Found" code:200 userInfo:flurryParams];
                        
                        [Flurry logError:@"WS-P-ListSimilarRemovedAdvertisements - No Result Found"   message:@"WS-P-ListSimilarRemovedAdvertisements - No Result Found"  error:error];//m2806
                    }
                    /*****No Result Found*****/
                    
                    [Flurry endTimedEvent:@"WS-P-ListSimilarRemovedAdvertisements" withParameters:nil];
                    
                    [SVProgressHUD dismiss];
                    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                    
                    UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message: [NSString stringWithFormat:@"%@ %@.",ErrorInResponse,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertError show];
                    alertError = nil;
                    
                }
            }
            
            else{
                
                /*****Server Error*****/
                NSDictionary *flurryParams =
                [NSDictionary dictionaryWithObjectsAndKeys:
                 @"WS-P-ListSimilarRemovedAdvertisements", @"ErrorLocation", 
                 @"Server Error", @"Error",
                 nil];
                if(appDel.isFlurryOn)
                {
                    NSError *error;
                    error = [NSError errorWithDomain:@"WS-P-ListSimilarRemovedAdvertisements - Server Error" code:200 userInfo:flurryParams];
                    [Flurry logError:@"WS-P-ListSimilarRemovedAdvertisements - Server Error"   message:@"WS-P-ListSimilarRemovedAdvertisements - Server Error"  error:error];
                }
                /*****Server Error*****/
                
                [Flurry endTimedEvent:@"WS-P-ListSimilarRemovedAdvertisements" withParameters:nil];
                
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
                UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message: [NSString stringWithFormat:@"%@ %@.",ErrorInResponse,customerServicesPhoneNo] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertError show];
                alertError = nil;
                
            }
            
        }
        
        @catch (NSException *exception) {
            
            /*****@catch*****/
            NSDictionary *flurryParams =
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"WS-P-ListSimilarRemovedAdvertisements", @"ErrorLocation", 
             exception.description, @"Error",
             nil];
            
            
            if(appDel.isFlurryOn)
            {
                //[Flurry logEvent:@"GetOwnVehicleSpotPrice" withParameters:flurryParams];
                NSError *error;
                error = [NSError errorWithDomain:@"WS-P-ListSimilarRemovedAdvertisements - Exception" code:200 userInfo:flurryParams];
                
                [Flurry logError:@"WS-P-ListSimilarRemovedAdvertisements - Exception"   message:@"WS-P-ListSimilarRemovedAdvertisements - Exception"  error:error];//m2806
            }
            
            /*****@catch*****/
            
            [Flurry endTimedEvent:@"WS-P-ListSimilarRemovedAdvertisements" withParameters:nil];
            [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
            
            NSLog(@"exception :- %@",exception);
        }
        @finally {
            
        }
        
        
    }
    
    else{
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
        
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Error" message:noInternet delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertError show];
        alertError = nil;
        return;
    }
    
    
}

-(void)showProgressWith:(NSString *)strMessage
{
    
    //Will called before each WS call to show Progress Indicator Status
    [SVProgressHUD setStatus:strMessage];
}

-(void)setStatus:(VRMStatus)status{
    
    @try {
        
        // This will get called after each WS call finish its execution.
        
        if (status == DoneVRMValuation)
        {
            
            
            // This will call after VRMValuation finish its execution.
            
            
            NSString *strTemp = [appDel.strRegistrationNo stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSArray *arrVehicleData = [objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblVehicle where RegistrationNo = '%@' AND OriginalMileage = '%@' OR RegistrationNoTemp = '%@' AND OriginalMileage = '%@' OR RegistrationNoTemp = '%@' AND OriginalMileage = '%@'",appDel.strRegistrationNo,appDel.strMileageLocal,appDel.strRegistrationNo,appDel.strMileageLocal,strTemp,appDel.strMileageLocal]];
            
            
            if ([arrVehicleData count] > 0) {
                
                if ([arrVehicleData count] > 1) {
                    
                    if (appDel.isFromHistory) {
                        
                        // if Call is made from history it will countinue to execute spot price
                        
                        NSDictionary *dicToInsert = [objSKDatabase lookupRowForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
                        
                        [self performSelector:@selector(getSpotPrice:) withObject:dicToInsert];
                        
                    }
                    else{
                        
                        // IF Multiple vehicle found it will redirect to the SelectVehicle screen.
                        
                        [SVProgressHUD dismiss];
                        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                            [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                        
                        appDel.isFromHistory = FALSE;
                        SelectCarViewController *objSelectCarViewController=[[SelectCarViewController alloc]initWithNibName:@"SelectCarViewController" bundle:nil];
                        [appDel.navigationeController pushViewController:objSelectCarViewController animated:TRUE];
                        
                        
                    }
                    
                }
                else{
                    
                    
                    // check for the Postcode
                    
                    
                    appDel.strVehicleID = [[arrVehicleData objectAtIndex:0] objectForKey:@"GlassCarCode"];

                    
                    appDel.isFromHistory = FALSE;
                    int rowsel = [[NSUserDefaults standardUserDefaults] integerForKey:@"UseGPS"];
                    
                    if (rowsel== 0) {
                        
                        //change here
                        
                        // Call Location Service
                        [appDel getNewLocaiton:self];
                        
                        
                        
                        //  appDel.strLastPostCode = @"KT16 9TU";
                        
                        return;
                        
                    }
                    else
                    {
                        
                        appDel.strLastPostCode = [[NSUserDefaults standardUserDefaults] valueForKey:@"Postcode"];
                        [self LocationCalledAndReturned];
                        
                    }
                    
                }
                
            }
            
            
        }
        else if (status == DoneSpotPrice) {
            
            // This will call after WS Spot Price finish its execution.
            
            
            NSArray *arr = [objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
            
            if ([arr count] > 0) {
                
                for (NSDictionary *dicToInsert in arr) {
                    
                    // WS Call to Average Selling time
                    
                    [self performSelector:@selector(getAverageSellingTime:) withObject:dicToInsert];
                }
                
                arr = nil;
            }
            
            else{
                
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
            }
            
        }
        else if (status == DoneAverageSellingTime) {
            
            // This will call after WS Average Selling time finish its execution.
            
            
            NSArray *arr = [objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
            
            if ([arr count] > 0) {
                
                for (NSDictionary *dicToInsert in arr) {
                    
                    
                    // WS Call for Similar Adverts
                    
                    [self performSelector:@selector(listSimilarAdvertisements:) withObject:dicToInsert];
                }
                
                arr = nil;
                
            }
            
            else{
                
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
                
            }
            
            
        }
        else if (status == DoneOnSale) {
            
            // This will call after WS Similar Adverts finish its execution.
            
            
            NSArray *arr = [objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
            
            if ([arr count] > 0) {
                
                for (NSDictionary *dicToInsert in arr) {
                    
                    // WS Call for Similar Removed Adverts
                    
                    [self performSelector:@selector(listSimilarRemoveAdvertisements:) withObject:dicToInsert];
                    
                }
                
                arr = nil;
                
                
            }
            
            else{
                
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
            }
        }
        else if (status == DoneOnSold) {
            
            // This will call after WS Similar Removed Adverts finish its execution.
            
            appDel.isFromHistory = FALSE;
            
            NSArray *arrVehicleData = (NSArray *)[objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
            
            UIViewController *viewController;
            NSArray *arr = [appDel.navigationeController viewControllers];
            if ([arr count] > 0) {
                
                viewController = [arr objectAtIndex:[arr count] -1];
            }
            
            
            if ([arrVehicleData count] > 0) {
                
                appDel.strVehicleID = [[arrVehicleData objectAtIndex:0] objectForKey:@"GlassCarCode"];
            }
            
            [objSKDatabase updateSQL:[NSString stringWithFormat:@"Update tblVehicle set SearchRadius = '%f' where GlassCarCode = '%@'",appDel.intValSlider,appDel.strVehicleID] forTable:@""];
            
            
            if ([viewController isKindOfClass:[SummaryViewController class]] || [viewController isKindOfClass:[OnSaleViewController class]] || [viewController isKindOfClass:[OnSoldViewController class]]) {
                
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                return;
            }
            
            /// Insert new record into History table
            
            NSDictionary * dicVehicleDetail = [[NSDictionary alloc] init];
            dicVehicleDetail = [objSKDatabase lookupRowForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
            
            
            NSArray *arrCount = [objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblHistory where CarID = '%@'",[dicVehicleDetail objectForKey:@"GlassCarCode"]]];
            
            if (arrCount.count > 0) {
                
                int days;
                NSString *strDate = [[arrCount objectAtIndex:0] objectForKey:@"DateTime"];
                NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
                [_formatter setDateFormat:@"dd-MM-YYYY HH:mm:ss"];
                
                
                NSString *str = [_formatter stringFromDate:[NSDate date]];
                
                NSArray *aryActiveRun = [strDate componentsSeparatedByString:@" "];
                NSArray *aryCurrentDate = [str componentsSeparatedByString:@" "];
                
                
                if([[aryActiveRun objectAtIndex:0] isEqualToString:[aryCurrentDate objectAtIndex:0]])
                    days = 0;
                else
                    days = -1;
                
                if (days == -1) {
                    
                    // Delete the 21th record from History.
                    
                    [objSKDatabase deleteWhere:[NSString stringWithFormat:@"CarID = '%@'",[dicVehicleDetail objectForKey:@"GlassCarCode"]] forTable:@"tblHistory"];
                    
                }
                
                
            }
            
            
            
            NSDateFormatter *formate1 = [[NSDateFormatter alloc] init];
            [formate1 setDateFormat:@"dd-MM-YYYY HH:mm:ss"];
            NSString *strDate1 = [formate1 stringFromDate:[NSDate date]];
            
            NSMutableDictionary *dicForHistory = [[NSMutableDictionary alloc] init];
            [dicForHistory setObject:strDate1 forKey:@"DateTime"];
            [dicForHistory setObject:[dicVehicleDetail objectForKey:@"RegistrationNo"] forKey:@"RegistrationNo"];
            [dicForHistory setObject:[dicVehicleDetail objectForKey:@"GlassCarCode"] forKey:@"CarID"];
            [dicForHistory setObject:[dicVehicleDetail objectForKey:@"Location"] forKey:@"Location"];
            
            NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
            [_formatter setDateFormat:@"YYYY-MM-dd"];
            NSDate *date = [_formatter dateFromString:[dicVehicleDetail objectForKey:@"RegistrationDate"]];
            
            NSDateFormatter *_formatter1=[[NSDateFormatter alloc]init];
            [_formatter1 setDateFormat:@"dd-MM-YYYY"];
            NSString *_date = [_formatter1 stringFromDate:date];
            
            
            [dicForHistory setObject:_date forKey:@"RegistrationDate"];
            [dicForHistory setObject:[dicVehicleDetail objectForKey:@"Mileage"] forKey:@"Mileage"];
            [dicForHistory setObject:[dicVehicleDetail objectForKey:@"SpotPrice"] forKey:@"SpotPrice"];
            [dicForHistory setObject:[dicVehicleDetail objectForKey:@"Currency"] forKey:@"Currency"];
            [dicForHistory setObject:[dicVehicleDetail objectForKey:@"OriginalMileage"] forKey:@"OriginalMileage"];
            
            //OriginalMileage
            
            
            NSMutableString *strVehicleDesc = [[NSMutableString alloc] init];
            //yearOfManufacture
            
            if ([[dicVehicleDetail objectForKey:@"yearOfManufacture"] length] > 0) {
                
                [strVehicleDesc appendString:[dicVehicleDetail objectForKey:@"yearOfManufacture"]];
            }
            
            if ([[dicVehicleDetail objectForKey:@"Make"] length] > 0) {
                
                [strVehicleDesc appendString:[NSString stringWithFormat:@", %@",[dicVehicleDetail objectForKey:@"Make"]]];
            }
            if ([[dicVehicleDetail objectForKey:@"Model"] length] > 0) {
                
                [strVehicleDesc appendString:[NSString stringWithFormat:@", %@",[dicVehicleDetail objectForKey:@"Model"]]];
            }
            
            if ([[dicVehicleDetail objectForKey:@"Description"] length] > 0) {
                
                [strVehicleDesc appendString:[NSString stringWithFormat:@", %@",[dicVehicleDetail objectForKey:@"Description"]]];
            }
            if ([[dicVehicleDetail objectForKey:@"BodyType"] length] > 0) {
                
                [strVehicleDesc appendString:[NSString stringWithFormat:@", %@",[dicVehicleDetail objectForKey:@"BodyType"]]];
            }
            
            NSString *strDesc;
            if ([[dicVehicleDetail objectForKey:@"RegistrationDate"] length] > 0) {
                
                strDesc = [NSString stringWithFormat:@"%@ \n%@",strVehicleDesc,[dicForHistory objectForKey:@"RegistrationDate"]];
                
                
                NSString *strMileage;
                
                if ([[dicVehicleDetail objectForKey:@"Mileage"] isEqualToString:@"0"]) {
                    
                    strMileage = [NSString stringWithFormat:@"%d",[[dicVehicleDetail objectForKey:@"AverageMileage"] intValue]];
                    
                }
                
                else{
                    
                    strMileage = [NSString stringWithFormat:@"%d",[[dicVehicleDetail objectForKey:@"Mileage"] intValue]];
                }
                
                
                if ([strMileage length] > 0) {
                    
                    float mileage = [strMileage floatValue]/(float)1000;
                    
                    if (mileage > 1) {
                        
                        mileage = roundf([strMileage floatValue]/(float)1000);
                    }
                    
                    if (mileage < 10 && mileage >= 1) {
                        
                        strMileage = [NSString stringWithFormat:@"%dK",(int)mileage];
                        
                    }
                    else if (mileage >= 10 && mileage < 100 && mileage >= 1){
                        
                        strMileage = [NSString stringWithFormat:@" %@%@K",[strMileage substringWithRange:NSMakeRange(0, 1)],[strMileage substringWithRange:NSMakeRange(1, 1)]];
                        
                    }
                    else if (mileage >= 100 && mileage < 1000 && mileage >= 1){
                        
                        strMileage = [NSString stringWithFormat:@" %@%@%@K",[strMileage substringWithRange:NSMakeRange(0, 1)],[strMileage substringWithRange:NSMakeRange(1, 1)],[strMileage substringWithRange:NSMakeRange(2, 1)]];
                        
                    }
                    
                    else if (mileage < 1 && mileage > 0){
                        
                        strMileage = [NSString stringWithFormat:@" 0.%@K",[strMileage substringWithRange:NSMakeRange(0, 1)]];
                        
                    }
                    else if (mileage == 0){
                        
                        strMileage = [NSString stringWithFormat:@"%@K",[strMileage substringWithRange:NSMakeRange(0, 1)]];
                    }
                    
                    // strMileage
                    
                    strMileage = [NSString stringWithFormat:@"%@ m",[dicVehicleDetail objectForKey:@"Mileage"]];
                    strDesc = [NSString stringWithFormat:@"%@ - %@",strDesc,strMileage];
                    
                    //strDesc = [NSString stringWithFormat:@"%@ , %@",strDesc,appDel.strLastPostCode];
                    
                    
                    
                }
                
                
            }
            
            [dicForHistory setObject:strDesc forKey:@"Description"];
            
            [dicForHistory setObject:appDel.strLastPostCode forKey:@"Postcode"];
            
            [objSKDatabase insertDictionary:dicForHistory forTable:@"tblHistory"];
            
            NSMutableArray *arrHistory = (NSMutableArray *)[objSKDatabase lookupAllForSQL:@"select * from tblHistory"];
            if ([arrHistory count] == 21) {
                
                if ([arrHistory count] > 0) {
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"dd-MM-YYYY HH:mm:ss"];
                    
                    NSComparator compareDates = ^(id string1, id string2) {
                        
                        NSDate *date1 = [formatter dateFromString:string1];
                        NSDate *date2 = [formatter dateFromString:string2];
                        
                        return [date1 compare:date2];
                    };
                    
                    
                    NSSortDescriptor * dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"DateTime" ascending:YES comparator:compareDates];
                    [arrHistory sortUsingDescriptors:[NSArray arrayWithObjects:dateDescriptor,nil]];
                    
                }
                
                NSDictionary *dicLast = [arrHistory objectAtIndex:0];
                if (dicLast) {
                    
                    [objSKDatabase deleteWhere:[NSString stringWithFormat:@"CarID = '%@' AND DateTime = '%@'",[dicLast objectForKey:@"CarID"],[dicLast objectForKey:@"DateTime"]] forTable:@"tblHistory"];
                    
                }
                
                
            }
            
            /// End inserting record
            
            int rowsel = [[NSUserDefaults standardUserDefaults] integerForKey:@"UseGPS"];
            
            NSString *strUpdate = [NSString stringWithFormat:@"Update tblVehicle set CustomPostCode = '%@',UseGps = '%@'where GlassCarCode = '%@'",appDel.strLastPostCode,[NSString stringWithFormat:@"%d",rowsel],appDel.strVehicleID];
            
            [objSKDatabase updateSQL:strUpdate forTable:@""];
            
            
            if ([viewController isKindOfClass:[HistoryViewController class]] || [viewController isKindOfClass:[LocationViewController class]]) {
                
                if ([viewController isKindOfClass:[HistoryViewController class]]) {
                    
                    appDel.isFromHistory = TRUE;
                    
                }
                CATransition *transition = [CATransition animation];
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromLeft;
                
                [appDel.navigationeController.view.layer addAnimation:transition forKey:nil];
                
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                // After Successfull execution of all WS call. Redirect to the Summary screen
                
                
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
            
            else{
                
                [SVProgressHUD dismiss];
                if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                if(appDel.isIphone5)
                {
                    
                    SummaryViewController *objSummaryViewController=[[SummaryViewController alloc]initWithNibName:@"SummaryViewController_i5" bundle:Nil];
                    [appDel.navigationeController pushViewController:objSummaryViewController animated:YES];
                }
                else
                {
                    SummaryViewController *objSummaryViewController=[[SummaryViewController alloc]initWithNibName:@"SummaryViewController" bundle:Nil];
                    [appDel.navigationeController pushViewController:objSummaryViewController animated:YES];
                    
                }
                
                
                
            }
            
            
        }
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exeption :- %@" , exception);
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
    @finally {
        
        
    }
    
    
}

-(void)LocationCalledAndReturned {
    
    int rowsel = [[NSUserDefaults standardUserDefaults] integerForKey:@"UseGPS"];

    if (rowsel == 0) {
    
        appDel.strLastPostCode = appDel.strDelPostCode;
    }
    
    if (appDel.strLastPostCode.length == 0 ) {
        
        alertNoPostcode = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry postcode could not be calculated, please enter your postcode manually." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertNoPostcode show];
        
    }
    
    else{
        
        // Call Spot Price if Postcode Found
        
        NSArray *arr = [objSKDatabase lookupAllForSQL:[NSString stringWithFormat:@"select * from tblVehicle where GlassCarCode = '%@'",appDel.strVehicleID]];
        
        if ([arr count] > 0) {
            
            for (NSDictionary *dicToInsert in arr) {
                
                [self performSelector:@selector(getSpotPrice:) withObject:dicToInsert];
            }
            
            arr = nil;
        }
        
        else{
            
            [SVProgressHUD dismiss];
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];;
            
            
        }
        
    }

}

#pragma mark-
#pragma mark AlertView Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView == alertNoPostcode) {
        
        // IF Postcode not found redirect to the Location screen
        
        [SVProgressHUD dismiss];
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        appDel.isWithoutPostCode = TRUE;
        LocationViewController *objLocationViewController=[[LocationViewController alloc]initWithNibName:@"LocationViewController" bundle:nil];
        [appDel.navigationeController pushViewController:objLocationViewController animated:YES];
        
        
    }
    
}




@end
