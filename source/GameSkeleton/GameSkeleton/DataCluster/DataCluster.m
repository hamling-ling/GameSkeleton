//
//  DataCluster.m
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 10/09/04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataCluster.h"

static DataCluster* dataCluster = nil;

@implementation DataCluster

@synthesize dbver;
@synthesize grades;

#pragma mark Singleton Methods
+ (id) sharedData {
	@synchronized(self) {
		if(dataCluster == nil) {
			dataCluster = [[DataCluster alloc] init];
			
			[dataCluster loadDB];
		}
	}
	return dataCluster;
}

- (id)copyWithZone:(NSZone *) zone {
	return self;
}

- (id)init {
	if(self = [super init]) {
	}
	return self;
}


- (NSString *)plistPathInDocument {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentDir = [paths objectAtIndex:0];
	
	return [documentDir stringByAppendingPathComponent:DB_FILE_NAME];
}

- (NSString *)plistPathInResource {
	NSString* path = [[NSBundle mainBundle] pathForResource:DB_FILE_NAME_NOEXT ofType:DB_FILE_NAME_EXT];
	return path;
}

- (BOOL)loadDB {
	
	NSString* docFilePath = [self plistPathInDocument];
	NSString* resFilePath = [self plistPathInResource];
	
	// read root dictionary
	NSMutableDictionary* rootDic1st = [NSMutableDictionary dictionaryWithContentsOfFile:resFilePath];
	NSMutableDictionary* rootDic2nd = rootDic1st;

	// clean installed boot
	if ([[NSFileManager defaultManager] fileExistsAtPath:docFilePath]) {
		LOG(@"plist found in document folder. using document plist");
		rootDic1st = [NSMutableDictionary dictionaryWithContentsOfFile:docFilePath];
	}
	
	// read version
	NSNumber* numVer = [rootDic1st objectForKey:DBKEY_DBVERSION];
	if (!LOADED(NSNumber, numVer)) {
		numVer = [rootDic2nd objectForKey:DBKEY_DBVERSION];
		NSAssert(LOADED(NSNumber, numVer), @"loading dbver");
	}
	dbver = [numVer intValue];
	NSLog(@"dbver loaded : %d", [numVer intValue]);
	
	// read grades
	NSArray* ar = [rootDic1st objectForKey:DBKEY_STAGE_GRADES];
	if (!LOADED(NSArray, ar)) {
		ar = [rootDic2nd objectForKey:DBKEY_STAGE_GRADES];
		NSAssert(LOADED(NSNumber, ar), @"loading grades");
	}
	grades = [ar mutableCopy];
	LOG(@"grades loaded");
	
	return YES;
}

- (BOOL)saveDB {
	NSMutableDictionary* rootDic = [[NSMutableDictionary alloc]init];
	
	// add version
	NSNumber* numVer = [NSNumber numberWithInt:self.dbver];
	[rootDic setObject:numVer forKey:DBKEY_DBVERSION];
	
	// add whistleType
	[rootDic setObject:self.grades forKey:DBKEY_STAGE_GRADES];
	
	// write file
	NSString* path = [self plistPathInDocument];
	BOOL isSuccess = [rootDic writeToFile:path atomically:YES];
	NSAssert(isSuccess, @"failed to save DB");
	
	return isSuccess;
}

@end
