// Copyright 2011-2012 Jason Whitehorn
// Released under the terms of the license found
// in the license.txt in the root of the project

// Based on works originally found @
// http://iphoneinaction.manning.com/iphone_in_action/2009/07/skdatabase-11-a-sqlite-library-for-the-iphone.html
// Unfortunantly that website is no longer around.
// If memory serves me correctly the original author
// released it into the public domain.

#import "SKDatabase.h"

@interface SKDatabase (Private)

- (sqlite3_stmt *)prepare:(NSString *)sql;

@end

@implementation SKDatabase

@synthesize delegate;
@synthesize dbh;
@synthesize dynamic;

- (id)initWithFile:(NSString *)dbFile {
    
	if (self = [super init]) {
		
		NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *docDir = [docPaths objectAtIndex:0];
		NSString *docPath = [docDir stringByAppendingPathComponent:dbFile];
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		if (![fileManager fileExistsAtPath:docPath]) {
			
			NSString *origPaths = [[NSBundle mainBundle] resourcePath];
			NSString *origPath = [origPaths stringByAppendingPathComponent:dbFile];
			
			NSError *error;
			int success = [fileManager copyItemAtPath:origPath toPath:docPath error:&error];
            if (success) {
                
            }
			NSAssert1(success,@"Failed to copy database into dynamic location",error);
		}
        
		int result = sqlite3_open([docPath UTF8String], &dbh);
        if (result) {
            
        }
        
		NSAssert1(SQLITE_OK == result, NSLocalizedStringFromTable(@"Unable to open the sqlite database (%@).", @"Database", @""), [NSString stringWithUTF8String:sqlite3_errmsg(dbh)]);	
		self.dynamic = YES;
	}
	
	return self;	
}

- (id)initWithData:(NSData *)data andFile:(NSString *)dbFile {
	if (self = [super init]) {
		
		NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *docDir = [docPaths objectAtIndex:0];
		NSString *docPath = [docDir stringByAppendingPathComponent:dbFile]; 
		bool success = [data writeToFile:docPath atomically:YES];
		if (success) {
            
        }
		NSAssert1(success,@"Failed to save database into documents path", nil);
		
		int result = sqlite3_open([docPath UTF8String], &dbh);
        if (result) {
            
        }
		NSAssert1(SQLITE_OK == result, NSLocalizedStringFromTable(@"Unable to open the sqlite database (%@).", @"Database", @""), [NSString stringWithUTF8String:sqlite3_errmsg(dbh)]);	
		self.dynamic = YES;
	}
	
	return self;	
}

// Three ways to lookup results: for a variable number of responses, for a full row
// of responses, or for a singular bit of data

- (NSArray *)lookupAllForSQL:(NSString *)sql {
    
    // NSLog(@"\n\n SQL :- %@",sql);
	sqlite3_stmt *statement;
	id result;
	NSMutableArray *thisArray = [NSMutableArray arrayWithCapacity:4];
    statement = [self prepare:sql];
	if (statement) {
		while (sqlite3_step(statement) == SQLITE_ROW) {	
			NSMutableDictionary *thisDict = [NSMutableDictionary dictionaryWithCapacity:4];
			for (int i = 0 ; i < sqlite3_column_count(statement) ; i++) {
				if(sqlite3_column_type(statement,i) == SQLITE_NULL){
					continue;
				}
				if (sqlite3_column_decltype(statement,i) != NULL &&
					strcasecmp(sqlite3_column_decltype(statement,i),"Boolean") == 0) {
					result = [NSNumber numberWithBool:(BOOL)sqlite3_column_int(statement,i)];
				} else if (sqlite3_column_type(statement,i) == SQLITE_INTEGER) {
					result = [NSNumber numberWithInt:(int)sqlite3_column_int(statement,i)];
				} else if (sqlite3_column_type(statement,i) == SQLITE_FLOAT) {
					result = [NSNumber numberWithFloat:(float)sqlite3_column_double(statement,i)];					
				} else {
					if((char *)sqlite3_column_text(statement,i) != NULL){
                        result = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement,i)];
                        [thisDict setObject:result
                                     forKey:[NSString stringWithUTF8String:sqlite3_column_name(statement,i)]];
                        result = nil;
					}
				}
				if (result) {
					[thisDict setObject:result
								 forKey:[NSString stringWithUTF8String:sqlite3_column_name(statement,i)]];
				}
			}
			[thisArray addObject:[NSDictionary dictionaryWithDictionary:thisDict]];
		}
	}
	sqlite3_finalize(statement);
	return thisArray;
}



- (NSDictionary *)lookupRowForSQL:(NSString *)sql {
    
   // NSLog(@"\n\n SQL :- %@",sql);
	sqlite3_stmt *statement;
	id result;
	NSMutableDictionary *thisDict = [NSMutableDictionary dictionaryWithCapacity:4];
    statement = [self prepare:sql];
	if (statement) {
		if (sqlite3_step(statement) == SQLITE_ROW) {	
			for (int i = 0 ; i < sqlite3_column_count(statement) ; i++) {
				if(sqlite3_column_type(statement,i) == SQLITE_NULL){
					continue;
				}
				if (sqlite3_column_decltype(statement,i) != NULL &&
					strcasecmp(sqlite3_column_decltype(statement,i),"Boolean") == 0) {
					result = [NSNumber numberWithBool:(BOOL)sqlite3_column_int(statement,i)];
				} else if (sqlite3_column_type(statement,i) == SQLITE_INTEGER) {
					result = [NSNumber numberWithInt:(int)sqlite3_column_int(statement,i)];
				} else if (sqlite3_column_type(statement,i) == SQLITE_FLOAT) {
					result = [NSNumber numberWithFloat:(float)sqlite3_column_double(statement,i)];					
				} else {
					if((char *)sqlite3_column_text(statement,i) != NULL){
                        result = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement,i)];
                        [thisDict setObject:result
                                     forKey:[NSString stringWithUTF8String:sqlite3_column_name(statement,i)]];
                        result = nil;
					}
				}
				if (result) {
					[thisDict setObject:result
								 forKey:[NSString stringWithUTF8String:sqlite3_column_name(statement,i)]];
				}
			}
		}
	}
	sqlite3_finalize(statement);
	return thisDict;
}

- (id)lookupColForSQL:(NSString *)sql {
	
	sqlite3_stmt *statement;
	id result;
	if ((statement = [self prepare:sql])) {
		if (sqlite3_step(statement) == SQLITE_ROW) {		
			if (strcasecmp(sqlite3_column_decltype(statement,0),"Boolean") == 0) {
				result = [NSNumber numberWithBool:(BOOL)sqlite3_column_int(statement,0)];
			} else if (sqlite3_column_type(statement, 0) == SQLITE_TEXT) {
				result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
			} else if (sqlite3_column_type(statement,0) == SQLITE_INTEGER) {
				result = [NSNumber numberWithInt:(int)sqlite3_column_int(statement,0)];
			} else if (sqlite3_column_type(statement,0) == SQLITE_FLOAT) {
				result = [NSNumber numberWithDouble:(double)sqlite3_column_double(statement,0)];					
			} else {
				result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
			}
		}
	}
	sqlite3_finalize(statement);
	return result;
	
}

- (void)insertArray:(NSArray *)dbData forTable:(NSString *)table {
    
	NSMutableString *sql = [NSMutableString stringWithCapacity:16];
	[sql appendFormat:@"INSERT INTO %@ (",table];
	
	for (int i = 0 ; i < [dbData count] ; i++) {
		[sql appendFormat:@"%@",[[dbData objectAtIndex:i] objectForKey:@"key"]];
		if (i + 1 < [dbData count]) {
			[sql appendFormat:@", "];
		}
	}
	[sql appendFormat:@") VALUES("];
	for (int i = 0 ; i < [dbData count] ; i++) {
		if ([[[dbData objectAtIndex:i] objectForKey:@"value"] intValue]) {
            
			[sql appendFormat:@"\"%d\"",[[[dbData objectAtIndex:i] objectForKey:@"value"] intValue]];
		} else {
			[sql appendFormat:@"\"%@\"",[[dbData objectAtIndex:i] objectForKey:@"value"]];
		}
		if (i + 1 < [dbData count]) {
			[sql appendFormat:@", "];
		}
	}
	[sql appendFormat:@")"];
	[self runDynamicSQL:sql forTable:table];
}
- (void)insertDictionary:(NSDictionary *)dbData forTable:(NSString *)table {
	
	
	
	NSString *Ssql = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT 1",table];
	
    sqlite3_stmt *statement = [self prepare:Ssql];
    NSMutableDictionary *dicColumns;
    
    if (statement) {
        
        int no_of_columns = sqlite3_column_count(statement);
        dicColumns = [[NSMutableDictionary alloc]initWithCapacity:no_of_columns];
		
        for (int i=0; i<no_of_columns;i++) {
            [dicColumns setObject:@"" forKey:[NSString stringWithUTF8String:sqlite3_column_name(statement,i)]];
        }
    }
    sqlite3_finalize(statement);
	
	
	/////////////////////////////////////////////////////////////////////////
	
	NSMutableString *sql = [NSMutableString stringWithCapacity:16];
	[sql appendFormat:@"INSERT INTO %@ (",table];
	if ([dbData isKindOfClass:[NSDictionary class]]) {
        
        NSArray *dataKeys = [dbData allKeys];
        for (int i = 0 ; i < [dataKeys count] ; i++) {
            [sql appendFormat:@"%@",[dataKeys objectAtIndex:i]];
            if (i + 1 < [dbData count]) {
                [sql appendFormat:@", "];
            }
        }
        
        [sql appendFormat:@") VALUES("];
        for (int i = 0 ; i < [dataKeys count] ; i++) {
            
            if ([[dbData objectForKey:[dataKeys objectAtIndex:i]] isKindOfClass:[NSString class]]) {
                NSString *strValue = [dbData objectForKey:[dataKeys objectAtIndex:i]];
                strValue = [strValue stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                strValue = [strValue stringByReplacingOccurrencesOfString:@"\"" withString:@"\"\""];
                
                [sql appendFormat:@"'%@'",strValue];
            }
            else if ([[dbData objectForKey:[dataKeys objectAtIndex:i]] isKindOfClass:[NSNumber class]])
            {
                [sql appendFormat:@"'%@'",[dbData objectForKey:[dataKeys objectAtIndex:i]]];
            }
            else if ([[dbData objectForKey:[dataKeys objectAtIndex:i]] isKindOfClass:[NSNull class]])
            {
                [sql appendFormat:@"\" \""];
            }
            else
            {
                [sql appendFormat:@"\" \""];
            }
            if (i + 1 < [dbData count]) {
                [sql appendFormat:@", "];
            }
        }
        
        [sql appendFormat:@")"];
       // NSLog(@"%@",sql);
        [self runDynamicSQL:sql forTable:table];
    }
    
    
}


- (void) performSQL:(NSString *)sql{
    [self lookupColForSQL:sql];
}

- (void)updateArray:(NSArray *)dbData forTable:(NSString *)table {
	[self updateArray:dbData forTable:table where:NULL];
}

- (void)updateArray:(NSArray *)dbData forTable:(NSString *)table where:(NSString *)where {
	
	NSMutableString *sql = [NSMutableString stringWithCapacity:16];
	[sql appendFormat:@"UPDATE %@ SET ",table];
	
	for (int i = 0 ; i < [dbData count] ; i++) {
		if ([[[dbData objectAtIndex:i] objectForKey:@"value"] intValue]) {
			[sql appendFormat:@"%@=%@",
			 [[dbData objectAtIndex:i] objectForKey:@"key"],
			 [[dbData objectAtIndex:i] objectForKey:@"value"]];
		} else {
			[sql appendFormat:@"%@='%@'",
			 [[dbData objectAtIndex:i] objectForKey:@"key"],
			 [[dbData objectAtIndex:i] objectForKey:@"value"]];
		}
		if (i + 1 < [dbData count]) {
			[sql appendFormat:@", "];
		}
	}
	if (where != NULL) {
		[sql appendFormat:@" WHERE %@",where];
	} else {
		[sql appendFormat:@" WHERE 1"];
	}
	[self runDynamicSQL:sql forTable:table];
}


- (void)updateDictionary:(NSDictionary *)dbData forTable:(NSString *)table where:(NSString *)where {
    @try {
        
        NSMutableString *sql = [NSMutableString stringWithCapacity:16];
        [sql appendFormat:@"UPDATE %@ SET ",table];
        if ([dbData isKindOfClass:[NSDictionary class]]) {
            
            
            NSArray *dataKeys = [dbData allKeys];
            for (int i = 0 ; i < [dataKeys count] ; i++) {
                if ([[dbData objectForKey:[dataKeys objectAtIndex:i]] isKindOfClass:[NSString class]]) {
                    [sql appendFormat:@"%@ = '%@'",[dataKeys objectAtIndex:i],[dbData objectForKey:[dataKeys objectAtIndex:i]]];
                }
                else if ([[dbData objectForKey:[dataKeys objectAtIndex:i]] isKindOfClass:[NSNumber class]])
                {
                    [sql appendFormat:@"%@ = '%@'",[dataKeys objectAtIndex:i],[dbData objectForKey:[dataKeys objectAtIndex:i]]];
                }
                else if ([[dbData objectForKey:[dataKeys objectAtIndex:i]] isKindOfClass:[NSNull class]])
                {
                    [sql appendFormat:@"%@ = ''",[dataKeys objectAtIndex:i]];
                }
                else
                {
                    [sql appendFormat:@"\"\""];
                }
                
                if (i + 1 < [dbData count]) {
                    [sql appendFormat:@", "];
                }
            }
            if (where != NULL) {
                [sql appendFormat:@" WHERE %@",where];
            }
           // NSLog(@"UPDATE ****************** %@",sql);
            //Debug(@"UPDATE ****************** %@",sql);
            [self runDynamicSQL:sql forTable:table];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception%@",exception);
    }
    
}

- (void)updateSQL:(NSString *)sql forTable:(NSString *)table {
    
   // NSLog(@"\n\n\n sql :- %@ \n\n\n",sql);
	[self runDynamicSQL:sql forTable:table];
}

- (void)deleteWhere:(NSString *)where forTable:(NSString *)table {
    
	NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ where %@",
					 table,where];
    
	[self runDynamicSQL:sql forTable:table];
}

- (void)deleteWhereAllRecord:(NSString *)table {
    
	NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",
					 table];
    
	[self runDynamicSQL:sql forTable:table];
}

- (void)insertSQL:(NSString *)sql forTable:(NSString *)table {
	[self runDynamicSQL:sql forTable:table];
}
// INSERT/UPDATE/DELETE Subroutines

- (BOOL)runDynamicSQL:(NSString *)sql forTable:(NSString *)table {
    @synchronized(self){
        //       [self checkLock];
        //      self.isWorking = TRUE;
        int result = 0;
        NSAssert1(self.dynamic == 1,@"Tried to use a dynamic function on a static database",NULL);
        sqlite3_stmt *statement;
        if ((statement = [self prepare:sql])) {
            result = sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
        if (result) {
            if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(databaseTableWasUpdated:)]) {
                [delegate databaseTableWasUpdated:table];
            }
            

            return YES;

        } else {


            return NO;
        }
    }
}

- (NSString *)escapeString:(NSString *)dirtyString{
	NSString *cleanString = [dirtyString stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
	return cleanString;
}

// requirements for closing things down

- (void)dealloc {
	
	[self close];
}

- (void)close {
	
	if (dbh) {
		sqlite3_close(dbh);
	}
}

//----private----
- (sqlite3_stmt *)prepare:(NSString *)sql {
	
	const char *utfsql = [sql UTF8String];
	
	sqlite3_stmt *statement;
	
	if (sqlite3_prepare([self dbh],utfsql,-1,&statement,NULL) == SQLITE_OK) {
		return statement;
	} else {
		return 0;
	}
}

@end
