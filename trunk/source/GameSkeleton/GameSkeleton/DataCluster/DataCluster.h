//
//  DataCluster.h
//  GameSkeleton
//
//  Created by Nobuhiro Kuroiwa on 10/09/04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonUtility.h"
#import "DiagnosticTool.h"

#define DB_FILE_NAME_NOEXT			@"data"
#define DB_FILE_NAME				@"data.plist"
#define DB_FILE_NAME_EXT			@"plist"

#define DBKEY_DBVERSION				@"Ver"

#define DBKEY_STAGE_GRADES          @"StageGrades"
#define DBVAL_SPECIAL               @"S"
#define DBVAL_EXCELLENT             @"A"
#define DBVAL_GOOD                  @"B"
#define DBVAL_OK                    @"C"
#define DBVAL_FAIL                  @"F"
#define DBVAL_NOGRADE               @""

#define LOADED(TYPE,VAL)	(VAL != nil && [VAL isKindOfClass:[VAL class]])


@interface DataCluster : NSObject {
	int dbver;
}

@property (nonatomic, readonly) int dbver;
@property (nonatomic, retain) NSMutableArray* grades;

+ (id)sharedData;
- (NSString *)plistPathInDocument;
- (NSString *)plistPathInResource;
- (BOOL)saveDB;
- (BOOL)loadDB;

@end
