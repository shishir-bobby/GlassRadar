//
//  WebServices.m
//  winkflash
//
//  Created by Nandpal on 01/10/12.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//

#import "WebServicesjson.h"
#import "JSON.h"


@implementation WebServicesjson



#pragma mark -
#pragma mark Login Web Service

-(NSMutableDictionary *)callJsonAPI:(NSString *)url withDictionary : (NSMutableDictionary *)dicAPIData
{
    
    @try {
        
        // This will called when all WS call Made and return Response.
        
        NSURL *url1=[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url1];
        // NSLog(@"url1:%@",url1);
        
        
        NSMutableString *strJSONString = [[NSMutableString alloc] initWithString:@""];
        if ([dicAPIData count] > 0) {
            
            strJSONString = [NSMutableString stringWithString:[dicAPIData JSONFragment]];
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
        
        if ([url isEqualToString:VRM_URL] || [url isEqualToString:VRM_URL_LIVE] || [url isEqualToString:GetValuation_URL] || [url isEqualToString:GetValuation_URL_LIVE]) {
            
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            int responseStatusCode = [httpResponse statusCode];
            
            if (responseStatusCode == 500) {
                
            }
            else if (responseStatusCode == 400){
                
                NSMutableDictionary *dicResponse = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"No record found in SAE table",@"ErrorMsg",@"400",@"ErrorCode", nil];
                return dicResponse;
                
            }
            else {
                
                NSString *str=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                NSMutableDictionary *dicRes = [str JSONValue];
                return dicRes;
                
            }
            
        }
        else{
            
            NSString *str=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
            NSMutableDictionary *dicRes = [str JSONValue];
            return dicRes;
            
        }
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"exception :- %@",exception);
        
    }
    @finally {
        
    }
    
    return nil;
    
}

-(NSArray *)callJsonAPIForAryReponse:(NSString *)url withDictionary : (NSMutableDictionary *)dicAPIData
{
    
    @try {
        
        // This will called when all WS call Made and return Response in array.
        
        NSURL *url1=[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url1];
        
        NSMutableString *strJSONString = [[NSMutableString alloc] initWithString:@""];
        if ([dicAPIData count] > 0) {
            
            strJSONString = [NSMutableString stringWithString:[dicAPIData JSONFragment]];
        }
        
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
        
        if ([url isEqualToString:VRM_URL] || [url isEqualToString:VRM_URL_LIVE] || [url isEqualToString:GetValuation_URL] || [url isEqualToString:GetValuation_URL_LIVE]) {
            
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            int responseStatusCode = [httpResponse statusCode];
            
            if (responseStatusCode == 500) {
                
                
            }
            else if (responseStatusCode == 400){
                
                NSDictionary *dicResponse = [[NSDictionary alloc] initWithObjectsAndKeys:@"No record found in SAE table",@"ErrorMsg",@"400",@"ErrorCode",nil];
                NSArray *arr = [[NSArray alloc] initWithObjects:dicResponse, nil];
                return arr;
                
            }
            
            else {
                
                NSString *str = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
                NSArray *arrRes = [str JSONValue];
                return arrRes;
                
            }
        }
        
        else{
            
            NSString *str = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
            NSArray *arrRes = [str JSONValue];
            return arrRes;
            
        }
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"exception :- %@",exception);
        
    }
    @finally {
        
    }
    
    return nil;
    
}


@end
