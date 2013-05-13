//
//  GameResult.m
//  GameSkelton
//
//  Created by Nobuhiro Kuroiwa on 12/08/01.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameResult.h"
#import "CommonUtility.h"

@implementation GameResult

@synthesize flags;
@synthesize gradeString;
@synthesize time;
@synthesize score;

- (id)initWithGradeString:(NSString*)str time:(float)theTime flags:(int)flagNum score:(float)theScore {
    self = [super init];
    [CommonUtility nilToFail:self reason:@"super of GameResult init failed"];

    flags = flagNum;
    gradeString = str;
    time = theTime;
    score = theScore;

    return self;
}

@end
