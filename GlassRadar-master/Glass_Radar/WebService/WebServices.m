//
//  WebServices.h
//  Glassradar
//
//  Created by Mina on 19/02/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//
#import "WebServices.h"


@implementation WebServices

@synthesize delegate;


#pragma mark - WS call

-(NSMutableDictionary *)Call_LoginWebService:(NSString *)url UserName:(NSString *)strUserName  Password: (NSString *)strPassword
{
    
    // This will make WS Call for Login Service and return response.
    
    @try {
        
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
        [DictRequest setObject:strUserName forKey:@"Username"];
        [DictRequest setObject:strPassword forKey:@"UserPassword"];
        [DictRequest setObject:@"Radar-App" forKey:@"ProductName"];
        
        
        isForLogin = TRUE;
        
        
        NSURL *url1=[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url1];
        // NSLog(@"url1:%@",url1);
        
        
        NSMutableString *strJSONString = [[NSMutableString alloc] initWithString:@""];
        if ([DictRequest count] > 0) {
            
            strJSONString = [NSMutableString stringWithString:[DictRequest JSONFragment]];
        }
        // NSLog(@"\n strJSONString:%@",strJSONString);
        
        NSData *requestData = [strJSONString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString* requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [requestData length]];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:requestData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];
        [request setTimeoutInterval:60];
        
        NSError *error;
        NSURLResponse *response;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        
        NSString *str=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *dicRes = [str JSONValue];
        return dicRes;
        
    }
    @catch (NSException *exception) {
        
        [SVProgressHUD dismiss];
        NSLog(@"exception :- %@",exception);
        
    }
    @finally {
        
    }
    
    return nil;
    
    
}


-(NSMutableDictionary *)Call_PwdResetWebService:(NSString *)url UserName :(NSString *)strUserName
{
    @try {
        
        // This will make WS Call for Password Reset Service and return response.
        
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
        [DictRequest setObject:strUserName forKey:@"Username"];
        [DictRequest setObject:@"Radar-App" forKey:@"ProductName"];
        
        
        isForLogin = TRUE;
        
        
        NSURL *url1=[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url1];
        // NSLog(@"url1:%@",url1);
        
        
        NSMutableString *strJSONString = [[NSMutableString alloc] initWithString:@""];
        if ([DictRequest count] > 0) {
            
            strJSONString = [NSMutableString stringWithString:[DictRequest JSONFragment]];
        }
        // NSLog(@"\n strJSONString:%@",strJSONString);
        
        NSData *requestData = [strJSONString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString* requestDataLengthString = [[NSString alloc] initWithFormat:@"%d", [requestData length]];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:requestData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:requestDataLengthString forHTTPHeaderField:@"Content-Length"];
        [request setTimeoutInterval:60];
        
        NSError *error;
        NSURLResponse *response;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        
        NSString *str=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
        NSMutableDictionary *dicRes = [str JSONValue];
        return dicRes;
        
    }
    @catch (NSException *exception) {
        
        [SVProgressHUD dismiss];
        NSLog(@"exception :- %@",exception);
        
    }
    @finally {
        
    }
    
    return nil;
}


@end
