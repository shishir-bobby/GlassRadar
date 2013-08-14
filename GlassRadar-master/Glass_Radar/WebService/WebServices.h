//
//  WebServices.h
//  Glassradar
//
//  Created by Mina on 19/02/13.
//  Copyright (c) 2013 Bamboo Rocket Apps. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>




@interface WebServices : NSObject<NSXMLParserDelegate>
{
    
    BOOL isForLogin;

}

@property (retain) id delegate;

-(NSMutableDictionary *)Call_LoginWebService:(NSString *)url UserName:(NSString *)strUserName  Password: (NSString *)strPassword;
-(NSMutableDictionary *)Call_PwdResetWebService:(NSString *)url UserName :(NSString *)strUserName;

@end
